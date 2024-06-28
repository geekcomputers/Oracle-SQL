#!/bin/bash

# 名称					: kill_oracle.sh

# 作者				: Craig Richards
# 创建				: 2012年5月31日
# 最后修改		:
# 版本				: 1.0
# 修改记录		:

# 描述			: 这将杀死与给定sid相关的所有oracle进程

# 使用说明		: kill_oracle.sh $ORACLE_SID

#################################
# 开始的过程/函数 #
#################################

funct_check_params()																									# 函数名称
{																																	# 函数开始
  if [ ${NARG} -ne 1 ]; then																								# 如果参数数量不是一个，则输出一条消息
    echo "$0 : 参数不足，需要提供一个ORACLE_SID"
    exit 1																														# 退出程序
  elif																																# 否则

  # 如果传递的参数是-h或--h，则显示以下消息

  [[ ${SID} = "-h" ]] || [[ ${SID} = "--h" ]]; then
    echo "使用方法: 需要添加一个ORACLE_SID，例如 $0 BOSSLIVE"
    exit 1																														# 退出程序
  fi																																# 结束if语句
}																																	# 结束函数

funct_check_user()																										# 函数名称
{																																	# 函数开始
  if [ `/usr/ucb/whoami` != 'oracle' ]; then																			# 检查用户是否是Oracle
    echo "错误: 必须以oracle用户身份运行"																		# 如果是其他用户，则显示一条消息
    exit 99																														# 退出程序
  fi																																	
}																																	# 结束函数

funct_kill_oracle()																											# 函数名称
{																																	# 函数开始
  get_processes=`ps -ef | grep "ora_" | grep ${SID} | grep -v grep` ; export get_processes		# 设置变量get_processes以显示将被杀死的进程
  echo -e "\n将被杀死的进程是 \n\n ${get_processes}"
  ps -ef | grep "ora_" | grep ${SID} | grep -v grep | awk '{print $2}' | xargs kill -9						# 杀死与给定sid相关的所有进程
}																																	# 结束函数

################
# 主程序 #
################

# 变量设置

SID=$1																															# 将变量SID设置为传递的第一个参数
NARG=$# 																													# 将变量NARG设置为命令行上的参数数量

{																																	# 主程序开始
  funct_check_params																									# 调用函数funct_check_params
  funct_check_user																										# 调用函数funct_check_user
  funct_kill_oracle																											# 调用函数funct_kill_oracle
}																																	# 主程序结束

## 脚本结束

