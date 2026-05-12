#!/usr/bin/env bash
# 二分查找脚本：找出哪个测试创建了不该有的文件/状态
# 用法：./find-polluter.sh <要检查的文件或目录> <测试 pattern>
# 示例：./find-polluter.sh '.git' 'src/**/*.test.ts'

set -e

if [ $# -ne 2 ]; then
  echo "Usage: $0 <file_to_check> <test_pattern>"
  echo "Example: $0 '.git' 'src/**/*.test.ts'"
  exit 1
fi

POLLUTION_CHECK="$1"
TEST_PATTERN="$2"

echo "🔍 查找创建以下内容的测试：$POLLUTION_CHECK"
echo "测试 pattern：$TEST_PATTERN"
echo ""

# 获取测试文件列表
TEST_FILES=$(find . -path "$TEST_PATTERN" | sort)
TOTAL=$(echo "$TEST_FILES" | wc -l | tr -d ' ')

echo "找到 $TOTAL 个测试文件"
echo ""

COUNT=0
for TEST_FILE in $TEST_FILES; do
  COUNT=$((COUNT + 1))

  # 如果污染已经存在则跳过
  if [ -e "$POLLUTION_CHECK" ]; then
    echo "⚠️  在测试 $COUNT/$TOTAL 之前污染已存在"
    echo "   跳过：$TEST_FILE"
    continue
  fi

  echo "[$COUNT/$TOTAL] 测试中：$TEST_FILE"

  # 跑该测试
  npm test "$TEST_FILE" > /dev/null 2>&1 || true

  # 检查污染是否出现
  if [ -e "$POLLUTION_CHECK" ]; then
    echo ""
    echo "🎯 找到污染者！"
    echo "   测试：$TEST_FILE"
    echo "   创建了：$POLLUTION_CHECK"
    echo ""
    echo "污染详情："
    ls -la "$POLLUTION_CHECK"
    echo ""
    echo "调查命令："
    echo "  npm test $TEST_FILE    # 只跑这个测试"
    echo "  cat $TEST_FILE         # 看测试代码"
    exit 1
  fi
done

echo ""
echo "✅ 未发现污染者——所有测试都干净！"
exit 0
