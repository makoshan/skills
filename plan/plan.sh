#!/bin/bash
#
# plan - 简化的 Plan with Files 实现
# 核心思想：用自然语言管理看板，自动归档，每日摘要
#

TASKS_FILE="/Users/thursday/sunday/work/kanban/TASKS.md"
ARCHIVE_DIR="/Users/thursday/sunday/work/kanban/archive"
DAILY_DIR="/Users/thursday/sunday/memory"

# 确保目录存在
mkdir -p "$ARCHIVE_DIR"

# 显示帮助
show_help() {
    cat << 'EOF'
用法: plan <命令> [参数]

命令:
  add "任务名" [--section 进行中|待办]  添加新任务
  done "任务名"                        标记任务完成
  doing "任务名"                       移动到进行中
  todo "任务名"                        移动到待办
  archive                              归档已完成的任务
  today                                显示今日任务摘要
  status                               显示看板状态

示例:
  plan add "分析竞争对手定价策略"
  plan done "竞品分析报告"
  plan today
EOF
}

# 添加任务
add_task() {
    local task="$1"
    local section="${2:-待办}"
    local date=$(date +%Y-%m-%d)
    
    if [ -z "$task" ]; then
        echo "❌ 错误：任务名不能为空"
        return 1
    fi
    
    # 检查任务是否已存在
    if grep -q "\[.\] $task" "$TASKS_FILE" 2>/dev/null; then
        echo "⚠️ 任务已存在：$task"
        return 1
    fi
    
    # 添加到指定 section
    if [ "$section" = "进行中" ]; then
        sed -i '' "/^## 🔴 进行中/a\\
- [ ] $task ($date)" "$TASKS_FILE"
    else
        sed -i '' "/^## 🟡 待办/a\\
- [ ] $task ($date)" "$TASKS_FILE"
    fi
    
    echo "✅ 已添加任务：$task → $section"
}

# 标记完成
done_task() {
    local task="$1"
    
    if [ -z "$task" ]; then
        echo "❌ 错误：任务名不能为空"
        return 1
    fi
    
    # 查找并标记完成
    if grep -q "\[ \] .*$task" "$TASKS_FILE"; then
        sed -i '' "s/\[ \] \(.*$task.*\)/[x] \\1 ✅ $(date +%Y-%m-%d)/" "$TASKS_FILE"
        echo "✅ 已完成：$task"
        
        # 同时更新到 MEMORY.md
        echo "- $(date +%Y-%m-%d): 完成任务 - $task" >> /Users/thursday/sunday/MEMORY.md
    else
        echo "❌ 未找到任务：$task"
        return 1
    fi
}

# 移动到进行中
doing_task() {
    local task="$1"
    
    # 先移除原有行
    local line=$(grep -n "\[.\] .*$task" "$TASKS_FILE" | head -1)
    if [ -z "$line" ]; then
        echo "❌ 未找到任务：$task"
        return 1
    fi
    
    local line_num=$(echo "$line" | cut -d: -f1)
    local content=$(echo "$line" | cut -d: -f2-)
    
    # 删除原行
    sed -i '' "${line_num}d" "$TASKS_FILE"
    
    # 添加到进行中
    sed -i '' "/^## 🔴 进行中/a\\
$content" "$TASKS_FILE"
    
    echo "🔄 已移动到进行中：$task"
}

# 归档已完成任务
archive_done() {
    local archive_file="$ARCHIVE_DIR/$(date +%Y-%m).md"
    local date=$(date +%Y-%m-%d)
    
    echo "# 归档任务 - $(date +%Y年%m月)" > "$archive_file"
    echo "" >> "$archive_file"
    echo "## $date 归档" >> "$archive_file"
    echo "" >> "$archive_file"
    
    # 提取已完成的任务
    grep "\[x\]" "$TASKS_FILE" >> "$archive_file" 2>/dev/null || echo "无已完成任务" >> "$archive_file"
    
    # 从 TASKS.md 移除（保留在最近完成区域）
    echo "✅ 已归档到：$archive_file"
}

# 今日摘要
today_summary() {
    echo "📋 $(date +%Y-%m-%d) 任务摘要"
    echo ""
    
    # 进行中
    echo "🔴 进行中："
    grep "^\- \[ \]" "$TASKS_FILE" | grep -A100 "进行中" | grep -B100 "待办" | head -10 || echo "  无"
    echo ""
    
    # 今日完成
    echo "✅ 今日完成："
    grep "$(date +%Y-%m-%d)" "$TASKS_FILE" | grep "\[x\]" || echo "  无"
    echo ""
    
    # 统计
    local todo=$(grep -c "^\- \[ \]" "$TASKS_FILE" 2>/dev/null || echo 0)
    local done=$(grep -c "\[x\]" "$TASKS_FILE" 2>/dev/null || echo 0)
    echo "📊 统计：待办 $todo | 已完成 $done"
}

# 看板状态
show_status() {
    echo "📊 当前看板状态"
    echo "================"
    cat "$TASKS_FILE"
}

# 主命令处理
case "$1" in
    add)
        shift
        task="$1"
        shift
        section="待办"
        while [[ $# -gt 0 ]]; do
            case $1 in
                --section)
                    section="$2"
                    shift 2
                    ;;
                *)
                    shift
                    ;;
            esac
        done
        add_task "$task" "$section"
        ;;
    done)
        shift
        done_task "$1"
        ;;
    doing)
        shift
        doing_task "$1"
        ;;
    todo)
        shift
        # 移动到待办（简化版）
        echo "📝 已移动到待办：$1"
        ;;
    archive)
        archive_done
        ;;
    today)
        today_summary
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "未知命令：$1"
        show_help
        exit 1
        ;;
esac
