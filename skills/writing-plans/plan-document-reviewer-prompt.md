# 计划文档审阅者 Prompt 模板

调度计划文档审阅者子代理时使用本模板。

**目的：** 验证计划完整、与 spec 匹配，且任务分解合理。

**调度时机：** 完整计划写完之后。

```
Task tool (general-purpose):
  description: "Review plan document"
  prompt: |
    你是一名计划文档审阅者。验证这份计划完整且可以付诸实施。

    **要审阅的计划：** [PLAN_FILE_PATH]
    **作为参照的 spec：** [SPEC_FILE_PATH]

    ## 检查什么

    | 类别 | 看什么 |
    |----------|------------------|
    | 完整性 | TODOs、占位符、不完整的任务、缺失步骤 |
    | Spec 对齐 | 计划覆盖了 spec 需求，没有重大范围蔓延 |
    | 任务分解 | 任务边界清晰，步骤可操作 |
    | 可建造性 | 工程师能照这份计划走下去而不卡住吗？ |

    ## 标定

    **只标记会在实施中造成真正问题的事项。**
    实施者建错东西或卡住——这是问题。
    措辞细节、风格偏好和"nice to have"建议——不是。

    除非存在严重缺口——遗漏 spec 中的需求、步骤相互矛盾、
    占位符内容、或任务模糊到无法执行——否则就 approve。

    ## 输出格式

    ## Plan Review

    **Status:** Approved | Issues Found

    **Issues (if any):**
    - [Task X, Step Y]：[具体问题] - [为什么这对实施重要]

    **Recommendations (advisory, do not block approval):**
    - [改进建议]
```

**审阅者返回：** Status、Issues（若有）、Recommendations
