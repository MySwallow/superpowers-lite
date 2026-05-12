# 代码质量审阅者 Prompt 模板

调度代码质量审阅者子代理时使用本模板。

**目的：** 验证实现做工扎实（整洁、有测试、可维护）

**只有当 spec 合规性评审通过后才调度。**

```
Task tool (general-purpose):
  使用本 skill 文件夹下的 ./code-reviewer.md 模板

  DESCRIPTION: [任务摘要，来自 implementer 的报告]
  PLAN_OR_REQUIREMENTS: 来自 [plan-file] 的 Task N
  CHANGES_TO_REVIEW: 本任务的暂存 diff（`git diff --staged`）—— implementer 已 stage 但未 commit
```

**除常规代码质量关注外，审阅者还应检查：**
- 每个文件是否拥有一个明确职责和良好接口？
- 单元是否拆分到可以被独立理解和测试？
- 实现是否遵循了计划中的文件结构？
- 本次实现是否新建了已经很大的文件，或让现有文件显著膨胀？（不要标记预先存在的文件大小——只关注本次变更新增的部分。）

**Code reviewer 返回：** Strengths、Issues（Critical/Important/Minor）、Assessment
