#!/usr/bin/env python
# encoding: utf-8
# 计算0-100之间所有数字的累计求和结果
# 0.定义最终结果的变量
result = 0
i = 0
# 2.开始循环
while  i<=100:
       print(i)
       # 处理计数器
       result += i
       i += 1
print("0-100之间的数字求和的结果=%d" % result)


