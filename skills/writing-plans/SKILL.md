---
name: writing-plans
description: 当你有一个 spec 或一组多步骤任务的需求时使用——在动代码之前
---

# 编写计划

## 概述

按"工程师对我们代码库零上下文且品味可疑"来写一份完整的实施计划。把他们需要知道的一切都写明白：每个任务要碰哪些文件、代码、要看的测试和文档、怎么测。把整份计划拆成细粒度任务交给他们。DRY。YAGNI。TDD。频繁提交。

假设他们是熟练开发者，但对我们的工具链或问题域几乎一无所知。假设他们不太懂好的测试设计。

**开始时声明：** "我正在使用 writing-plans skill 来创建实施计划。"

**计划保存到：** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- （用户对计划位置的偏好覆盖此默认值）

## 范围检查

如果 spec 涉及多个独立子系统，它本应在 brainstorming 阶段就被拆成各个子项目 spec。如果没拆，建议把它拆成多个独立计划——每个子系统一个。每个计划应该独立产生可工作、可测试的软件。

## 文件结构

定义任务之前，先规划要创建或修改哪些文件，每个文件负责什么。这是分解决策落地的地方。

- 设计具有清晰边界和良好接口的单元。每个文件应有一个明确职责。
- 你对能一次性容纳进上下文的代码理解得最好，文件聚焦时编辑也更可靠。优先选择更小、聚焦的文件，而非做太多事的大文件。
- 一起变化的文件应该放在一起。按职责拆分，而不是按技术层。
- 在已有代码库中，遵循既有模式。如果代码库使用大文件，不要单方面重构——但如果你要修改的文件已经臃肿，在计划中包含拆分是合理的。

这个结构决定了任务的分解方式。每个任务应产出独立可理解的自包含变更。

## 细粒度任务粒度

**每个步骤是一个动作（2-5 分钟）：**
- "写失败的测试" - 一个步骤
- "运行它确保它失败" - 一个步骤
- "编写让测试通过的最小实现" - 一个步骤
- "跑测试确保通过" - 一个步骤
- "提交" - 一个步骤

## 计划文档头部

**每份计划必须以这个头部开始：**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** Use the subagent-driven-development skill (recommended) or executing-plans skill to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## 任务结构

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## 不要有占位符

每一步都必须包含工程师真正需要的内容。这些是**计划级别的失败**——绝不要写：
- "TBD"、"TODO"、"implement later"、"fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above"（没有真正的测试代码）
- "Similar to Task N"（重复代码——工程师可能乱序读任务）
- 描述要做什么却不展示怎么做的步骤（涉及代码的步骤必须有代码块）
- 引用了任何任务中都未定义的类型、函数或方法

## 记住
- 永远是精确的文件路径
- 每一步都给出完整代码——如果步骤改代码，就展示代码
- 精确的命令和预期输出
- DRY、YAGNI、TDD、频繁提交

## 自审

写完完整计划后，带着新鲜的眼光看 spec，并对照检查计划。这是你自己跑的检查清单——不是分派子代理。

**1. Spec 覆盖：** 浏览 spec 的每个章节/需求。你能指出哪个任务实现了它吗？列出任何缺口。

**2. 占位符扫描：** 在你的计划中搜索红色信号——前文 "不要有占位符" 部分列出的任意模式。修掉它们。

**3. 类型一致性：** 你在后续任务中使用的类型、方法签名、属性名是否与早期任务中定义的一致？Task 3 中叫 `clearLayers()`、Task 7 中却叫 `clearFullLayers()` 就是一个 bug。

如果发现问题，就地修复。无需重审——修完继续。如果发现 spec 的某个需求没有对应任务，就加一个任务。

## 移交执行

保存计划后，提供执行选项：

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`。两种执行选择：**

**1. Subagent-Driven（推荐）** - 我为每个任务调度一个全新子代理，任务之间评审，快速迭代

**2. Inline Execution** - 在本会话中使用 executing-plans 执行任务，批量执行加检查点

**选哪种？"**

**如果选 Subagent-Driven：**
- 使用 **subagent-driven-development** skill
- 每个任务一个全新子代理 + 两阶段评审

**如果选 Inline Execution：**
- 使用 **executing-plans** skill
- 批量执行，含评审检查点
