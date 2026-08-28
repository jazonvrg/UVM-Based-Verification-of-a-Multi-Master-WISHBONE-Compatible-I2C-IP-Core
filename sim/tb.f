+incdir+${I2C_IP_VERIF_PATH}/sequences
+incdir+${I2C_IP_VERIF_PATH}/testcases
+incdir+${I2C_IP_VERIF_PATH}/tb
+incdir+${I2C_IP_VERIF_PATH}/regmodel
+incdir+${I2C_IP_VERIF_PATH}/regmodel/register

// Compilation VIP design (agent) list
-f ${I2C_VIP_ROOT}/i2c_vip.f
-f ${WIS_VIP_ROOT}/wishbone_vip.f

// Compilation Environment
${I2C_IP_VERIF_PATH}/regmodel/register/i2c_register_pkg.sv
${I2C_IP_VERIF_PATH}/regmodel/i2c_regmodel_pkg.sv
${I2C_IP_VERIF_PATH}/tb/env_pkg.sv
${I2C_IP_VERIF_PATH}/sequences/seq_pkg.sv
${I2C_IP_VERIF_PATH}/testcases/test_pkg.sv
${I2C_IP_VERIF_PATH}/tb/testbench.sv

