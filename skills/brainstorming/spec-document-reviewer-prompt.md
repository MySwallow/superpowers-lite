# Spec 文档审阅者 Prompt 模板

调度 spec 文档审阅者子代理时使用本模板。

**目的：** 验证 spec 完整、一致，且可用于实施规划。

**调度时机：** Spec 文档已写到 docs/superpowers/specs/

```
Task tool (general-purpose):
  description: "Review spec document"
  prompt: |
    你是一名 spec 文档审阅者。验证这份 spec 完整且可用于规划。

    **要审阅的 spec：** [SPEC_FILE_PATH]

    ## 检查什么

    | 类别 | 看什么 |
    |----------|------------------|
    | 完整性 | TODOs、占位符、"TBD"、未完成章节 |
    | 一致性 | 内部矛盾、互相冲突的需求 |
    | 清晰度 | 需求是否模糊到会让人建错东西 |
    | 范围 | 聚焦到能用一个 plan 做完——而非覆盖多个独立子系统 |
    | YAGNI | 未请求的功能、过度工程 |

    ## 标定

    **只标记会在实施规划中造成真正问题的事项。**
    缺失的章节、矛盾、模糊到可以两种解读的需求——这些是问题。
    措辞细节、风格偏好和"某些章节没其他细致"——不是。

    除非存在会导致计划有缺陷的严重缺口，否则就 approve。

    ## 输出格式

    ## Spec Review

    **Status:** Approved | Issues Found

    **Issues (if any):**
    - [Section X]：[具体问题] - [为什么这对规划重要]

    **Recommendations (advisory, do not block approval):**
    - [改进建议]
```

**审阅者返回：** Status、Issues（若有）、Recommendations
