# VyZX / Rocq 形式化 demo

这两个 `.v` 文件使用 Coq 8.20.1（现名 Rocq）检查数学证明，与根目录中的 PyZX 数值实验分开。

| 文件 | 证明内容 | 范围 |
| --- | --- | --- |
| [SpiderFusionRepro.v](SpiderFusionRepro.v) | Z 单线融合、由颜色交换推导的 X 融合、两个 π/4 实例 | 任意输入输出数和实数相位；两个 spider 之间一条线 |
| [Supplementarity3.v](Supplementarity3.v) | 三阶 cyclotomic supplementarity（SUP₃） | 任意实数相位 α；固定的 0→1 状态图 |

两份文件都以 `Qed` 完成证明，没有 `Admitted`、`Abort` 或新增公理。`∝=` 表示完整矩阵语义相等，包括标量。

## 1. 环境与依赖

本次验证版本：

- Coq 8.20.1、OCaml 4.14.1、Dune 3.23.1
- QuantumLib 1.8.0、SQIR 1.3.2、VOQC 1.3.2
- [官方 VyZX](https://github.com/inQWIRE/VyZX) 提交 `10f8c16741952dbaa2bb7a73e13767945e696b8f`

在 Linux 或 WSL 中使用已经安装上述依赖的 opam 环境：

```bash
eval "$(opam env)"
```

如需从零配置依赖，参考固定版本的 [VyZX 构建说明](https://github.com/inQWIRE/VyZX/tree/10f8c16741952dbaa2bb7a73e13767945e696b8f#building-vyzx)。这里记录了已验证版本，但未提供完整的传递依赖锁文件。

## 2. 获取 VyZX

在本仓库根目录执行；若已有对应提交的 VyZX checkout，可跳过这一步。

```bash
mkdir -p formal/.deps
git clone https://github.com/inQWIRE/VyZX.git formal/.deps/VyZX
git -C formal/.deps/VyZX checkout --detach 10f8c16741952dbaa2bb7a73e13767945e696b8f
```

## 3. 编译并检查证明对象

```bash
bash formal/verify.sh
```

或传入已有 VyZX 的路径：

```bash
bash formal/verify.sh /path/to/VyZX
```

脚本先构建 VyZX，再将两个文件编译为 `FormalDemos` 命名空间下的模块，最后用 `coqchk` 复核两个证明对象及依赖。它不会把 demo 复制进或修改 VyZX 的源文件。

Windows 用户先在 PowerShell 中运行 `wsl -d Ubuntu-24.04`，在 Ubuntu 中进入本仓库的 `/mnt/c/...` 路径，再执行上述 Bash 命令。

成功时最后显示 `PASS`。完整日志位于 `formal/.build/`，包括文件末尾 `Print Assumptions` 的输出。非零退出码表示某个检查失败；已有编译缓存时 Dune 可以没有输出。

本机验证时，两个文件报告的基础公理依赖均为：

- `ClassicalDedekindReals.sig_not_dec`
- `ClassicalDedekindReals.sig_forall_dec`
- `functional_extensionality_dep`

因此，这些证明依赖实数与矩阵语义的基础公理，并非无公理证明。

验证记录（2026-10-25）：已实际运行 `bash formal/verify.sh`（传入上述版本的现有 VyZX checkout），两个文件编译和同一次 `coqchk` 复核均通过，脚本退出码为 0。

## 4. 数学内容与来源

### Spider fusion

`repro_Z_single_wire_fusion` 证明：

```coq
forall (n m : nat) (alpha beta : R),
  (Z n 1 alpha ⟷ Z 1 m beta) ∝= Z n m (alpha + beta).
```

该证明依照作者 `CoreData/ZXCore.v` 中 `Z_spider_1_1_fusion_eq` 的语义证明重新展开，使用基态正交性消去交叉项，再合并复指数。它没有直接套用已有的融合定理，但仍使用库的基础定理及 tactic。

来源：[VyZX 论文第 5 节](https://arxiv.org/html/2311.11571v4#S5)。改编的上游代码版权与 MIT 许可保留于 [LICENSE-VyZX](LICENSE-VyZX)。

### SUP₃

三个 Z 状态的相位为 α、α+2π/3、α+4π/3，分别连接同一个零相位 X spider。它们等价于一个相位 3α+2π 的 Z spider，通过三条线接到该 X spider：

```coq
((Z 0 1 alpha ↕ Z 0 1 (alpha + 2 * PI / 3))
     ↕ Z 0 1 (alpha + 4 * PI / 3)) ⟷ X 3 1 0
∝= Z 0 3 (3 * alpha + 2 * PI) ⟷ X 3 1 0.
```

证明按以下顺序组织：单位根求和、单位根乘积、多项式恒等式、复指数乘积、图的两个输出分量相等。

来源：Jeandel、Perdrix、Vilmart、Wang，[*ZX-Calculus: Cyclotomic Supplementarity and Incompleteness for Clifford+T quantum mechanics*](https://arxiv.org/pdf/1702.01945)，第 4 节 Proposition 5、附录 A.2。

这里仅证明固定结构的最小状态版本，没有声称覆盖任意公共邻域、任意外接线数量或一般 SUPₙ，也不声称是该规则首次被形式化。
