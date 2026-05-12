# 纵深防御校验

## 概述

当你修复一个因数据无效引起的 bug 时，在一处加校验感觉够了。但单个检查可以被不同代码路径、重构或 mock 绕过。

**核心原则：** 在数据流经的**每一层**都校验。让 bug 在结构上不可能发生。

## 为什么要多层

单层校验："我们修了这个 bug"
多层校验："我们让这个 bug 不可能发生"

不同层抓不同情况：
- 入口校验抓大多数 bug
- 业务逻辑抓边界情况
- 环境守卫防上下文相关的危险
- 调试日志在其他层失效时帮上忙

## 四层

### 层 1：入口校验
**目的：** 在 API 边界拒绝明显无效的输入

```typescript
function createProject(name: string, workingDirectory: string) {
  if (!workingDirectory || workingDirectory.trim() === '') {
    throw new Error('workingDirectory cannot be empty');
  }
  if (!existsSync(workingDirectory)) {
    throw new Error(`workingDirectory does not exist: ${workingDirectory}`);
  }
  if (!statSync(workingDirectory).isDirectory()) {
    throw new Error(`workingDirectory is not a directory: ${workingDirectory}`);
  }
  // ... 继续
}
```

### 层 2：业务逻辑校验
**目的：** 确保数据对本操作有意义

```typescript
function initializeWorkspace(projectDir: string, sessionId: string) {
  if (!projectDir) {
    throw new Error('projectDir required for workspace initialization');
  }
  // ... 继续
}
```

### 层 3：环境守卫
**目的：** 在特定上下文中防止危险操作

```typescript
async function gitInit(directory: string) {
  // 测试中，拒绝在临时目录外做 git init
  if (process.env.NODE_ENV === 'test') {
    const normalized = normalize(resolve(directory));
    const tmpDir = normalize(resolve(tmpdir()));

    if (!normalized.startsWith(tmpDir)) {
      throw new Error(
        `Refusing git init outside temp dir during tests: ${directory}`
      );
    }
  }
  // ... 继续
}
```

### 层 4：调试埋点
**目的：** 捕获上下文用于事后分析

```typescript
async function gitInit(directory: string) {
  const stack = new Error().stack;
  logger.debug('About to git init', {
    directory,
    cwd: process.cwd(),
    stack,
  });
  // ... 继续
}
```

## 应用范式

发现 bug 时：

1. **追踪数据流** - 坏值从哪儿来？在哪儿用？
2. **画出所有检查点** - 列出数据经过的每个点
3. **在每层加校验** - 入口、业务、环境、调试
4. **测试每层** - 试着绕过层 1，验证层 2 抓住

## 来自会话的例子

Bug：空 `projectDir` 在源码目录里跑了 `git init`

**数据流：**
1. 测试 setup → 空字符串
2. `Project.create(name, '')`
3. `WorkspaceManager.createWorkspace('')`
4. `git init` 跑在 `process.cwd()`

**加了四层：**
- 层 1：`Project.create()` 校验非空/存在/可写
- 层 2：`WorkspaceManager` 校验 projectDir 非空
- 层 3：`WorktreeManager` 在测试中拒绝 tmpdir 外的 git init
- 层 4：git init 之前的 stack trace 日志

**结果：** 全部 1847 个测试通过，bug 不可能复现

## 关键见解

这四层都必要。测试期间，每一层都抓到了其他层漏掉的 bug：
- 不同代码路径绕过入口校验
- Mock 绕过业务逻辑检查
- 不同平台的边界情况需要环境守卫
- 调试日志识别出结构性误用

**不要在单点校验就停下。** 在每一层都加检查。
