; SMT-LIBv2 description generated by Yosys 0.37 (git sha1 a5c7f69ed8f, clang 14.0.6 -fPIC -Os)
; yosys-smt2-module robot
(declare-sort |robot_s| 0)
(declare-fun |robot_is| (|robot_s|) Bool)
(declare-fun |robot#0| (|robot_s|) Bool) ; \rstn
; yosys-smt2-input rstn 1
; yosys-smt2-wire rstn 1
; yosys-smt2-witness {"offset": 0, "path": ["\\rstn"], "smtname": "rstn", "smtoffset": 0, "type": "input", "width": 1}
(define-fun |robot_n rstn| ((state |robot_s|)) Bool (|robot#0| state))
; yosys-smt2-anyinit robot#1 1 robot.sv:37.2-43.5
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyinit_procdff_136"], "smtname": 1, "smtoffset": 0, "type": "init", "width": 1}
(declare-fun |robot#1| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyinit_procdff_136
(define-fun |robot#2| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#1| state) #b0)) ; \out_alarm_flag
; yosys-smt2-wire out_alarm_flag 1
(define-fun |robot_n out_alarm_flag| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#2| state)) #b1))
; yosys-smt2-anyinit robot#3 1 robot.sv:26.2-32.5
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyinit_procdff_137"], "smtname": 3, "smtoffset": 0, "type": "init", "width": 1}
(declare-fun |robot#3| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyinit_procdff_137
(define-fun |robot#4| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#3| state) #b0)) ; \obs_detected
; yosys-smt2-output obs_detected_out 1
; yosys-smt2-wire obs_detected_out 1
(define-fun |robot_n obs_detected_out| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#4| state)) #b1))
(declare-fun |robot#5| (|robot_s|) (_ BitVec 16)) ; \dist_v
(define-fun |robot#6| ((state |robot_s|)) Bool (bvult (|robot#5| state) #b0000000000110010)) ; $lt$robot.sv:24$11_Y
(define-fun |robot#7| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#6| state) #b1 #b0)) ; \f_obs
; yosys-smt2-wire obs_detected_next 1
(define-fun |robot_n obs_detected_next| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#7| state)) #b1))
; yosys-smt2-wire obs_detected 1
(define-fun |robot_n obs_detected| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#4| state)) #b1))
; yosys-smt2-witness {"offset": 0, "path": ["$auto$async2sync.cc:171:execute$142"], "smtname": 8, "smtoffset": 0, "type": "reg", "width": 1}
(declare-fun |robot#8| (|robot_s|) (_ BitVec 1)) ; $auto$async2sync.cc:171:execute$142
(define-fun |robot#9| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#8| state) #b0)) ; \f_past_valid
; yosys-smt2-wire f_past_valid 1
(define-fun |robot_n f_past_valid| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#9| state)) #b1))
; yosys-smt2-witness {"offset": 0, "path": ["\\f_past_past_valid"], "smtname": 10, "smtoffset": 0, "type": "reg", "width": 1}
(declare-fun |robot#10| (|robot_s|) (_ BitVec 1)) ; \f_past_past_valid
; yosys-smt2-register f_past_past_valid 1
; yosys-smt2-wire f_past_past_valid 1
(define-fun |robot_n f_past_past_valid| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#10| state)) #b1))
; yosys-smt2-anyinit robot#11 1 robot.sv:64.3-77.6
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyinit_procdff_130"], "smtname": 11, "smtoffset": 0, "type": "init", "width": 1}
(declare-fun |robot#11| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyinit_procdff_130
(define-fun |robot#12| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#11| state) #b0)) ; \f_obs_past
(define-fun |robot#13| ((state |robot_s|)) (_ BitVec 1) (bvxor (|robot#12| state) (|robot#4| state))) ; \f_obs_res
; yosys-smt2-wire f_obs_res 1
(define-fun |robot_n f_obs_res| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#13| state)) #b1))
; yosys-smt2-anyinit robot#14 1 robot.sv:64.3-77.6
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyinit_procdff_131"], "smtname": 14, "smtoffset": 0, "type": "init", "width": 1}
(declare-fun |robot#14| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyinit_procdff_131
(define-fun |robot#15| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#14| state) #b0)) ; \f_obs_past_past
; yosys-smt2-wire f_obs_past_past 1
(define-fun |robot_n f_obs_past_past| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#15| state)) #b1))
; yosys-smt2-wire f_obs_past 1
(define-fun |robot_n f_obs_past| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#12| state)) #b1))
; yosys-smt2-wire f_obs 1
(define-fun |robot_n f_obs| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#7| state)) #b1))
(define-fun |robot#16| ((state |robot_s|)) (_ BitVec 1) (bvxor (|robot#15| state) (|robot#2| state))) ; \f_alarm_res
; yosys-smt2-wire f_alarm_res 1
(define-fun |robot_n f_alarm_res| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#16| state)) #b1))
; yosys-smt2-input dist_v 16
; yosys-smt2-wire dist_v 16
; yosys-smt2-witness {"offset": 0, "path": ["\\dist_v"], "smtname": "dist_v", "smtoffset": 0, "type": "input", "width": 16}
(define-fun |robot_n dist_v| ((state |robot_s|)) (_ BitVec 16) (|robot#5| state))
(declare-fun |robot#17| (|robot_s|) Bool) ; \clk
; yosys-smt2-input clk 1
; yosys-smt2-wire clk 1
; yosys-smt2-clock clk posedge
; yosys-smt2-witness {"offset": 0, "path": ["\\clk"], "smtname": "clk", "smtoffset": 0, "type": "posedge", "width": 1}
; yosys-smt2-witness {"offset": 0, "path": ["\\clk"], "smtname": "clk", "smtoffset": 0, "type": "input", "width": 1}
(define-fun |robot_n clk| ((state |robot_s|)) Bool (|robot#17| state))
; yosys-smt2-wire buff_dist_v 16
(define-fun |robot_n buff_dist_v| ((state |robot_s|)) (_ BitVec 16) (|robot#5| state))
(define-fun |robot#18| ((state |robot_s|)) (_ BitVec 1) (ite (= ((_ extract 0 0) (|robot#4| state)) #b1) #b1 #b0)) ; \alarm_flag_next
; yosys-smt2-wire alarm_flag_next 1
(define-fun |robot_n alarm_flag_next| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#18| state)) #b1))
; yosys-smt2-output alarm_flag 1
; yosys-smt2-wire alarm_flag 1
(define-fun |robot_n alarm_flag| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#2| state)) #b1))
; yosys-smt2-anyseq robot#19 1 $auto$setundef.cc:533:execute$170
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyseq_auto_setundef_cc_533_execute_170"], "smtname": 19, "smtoffset": 0, "type": "seq", "width": 1}
(declare-fun |robot#19| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyseq_auto_setundef_cc_533_execute_170
; yosys-smt2-wire _witness_.anyseq_auto_setundef_cc_533_execute_170 1
(define-fun |robot_n _witness_.anyseq_auto_setundef_cc_533_execute_170| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#19| state)) #b1))
; yosys-smt2-anyseq robot#20 1 $auto$setundef.cc:533:execute$168
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyseq_auto_setundef_cc_533_execute_168"], "smtname": 20, "smtoffset": 0, "type": "seq", "width": 1}
(declare-fun |robot#20| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyseq_auto_setundef_cc_533_execute_168
; yosys-smt2-wire _witness_.anyseq_auto_setundef_cc_533_execute_168 1
(define-fun |robot_n _witness_.anyseq_auto_setundef_cc_533_execute_168| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#20| state)) #b1))
; yosys-smt2-anyseq robot#21 1 $auto$setundef.cc:533:execute$166
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyseq_auto_setundef_cc_533_execute_166"], "smtname": 21, "smtoffset": 0, "type": "seq", "width": 1}
(declare-fun |robot#21| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyseq_auto_setundef_cc_533_execute_166
; yosys-smt2-wire _witness_.anyseq_auto_setundef_cc_533_execute_166 1
(define-fun |robot_n _witness_.anyseq_auto_setundef_cc_533_execute_166| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#21| state)) #b1))
; yosys-smt2-anyseq robot#22 1 $auto$setundef.cc:533:execute$164
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyseq_auto_setundef_cc_533_execute_164"], "smtname": 22, "smtoffset": 0, "type": "seq", "width": 1}
(declare-fun |robot#22| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyseq_auto_setundef_cc_533_execute_164
; yosys-smt2-wire _witness_.anyseq_auto_setundef_cc_533_execute_164 1
(define-fun |robot_n _witness_.anyseq_auto_setundef_cc_533_execute_164| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#22| state)) #b1))
; yosys-smt2-anyseq robot#23 1 $auto$setundef.cc:533:execute$162
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyseq_auto_setundef_cc_533_execute_162"], "smtname": 23, "smtoffset": 0, "type": "seq", "width": 1}
(declare-fun |robot#23| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyseq_auto_setundef_cc_533_execute_162
; yosys-smt2-wire _witness_.anyseq_auto_setundef_cc_533_execute_162 1
(define-fun |robot_n _witness_.anyseq_auto_setundef_cc_533_execute_162| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#23| state)) #b1))
; yosys-smt2-anyseq robot#24 1 $auto$setundef.cc:533:execute$160
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyseq_auto_setundef_cc_533_execute_160"], "smtname": 24, "smtoffset": 0, "type": "seq", "width": 1}
(declare-fun |robot#24| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyseq_auto_setundef_cc_533_execute_160
; yosys-smt2-wire _witness_.anyseq_auto_setundef_cc_533_execute_160 1
(define-fun |robot_n _witness_.anyseq_auto_setundef_cc_533_execute_160| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#24| state)) #b1))
; yosys-smt2-register _witness_.anyinit_procdff_137 1
; yosys-smt2-wire _witness_.anyinit_procdff_137 1
(define-fun |robot_n _witness_.anyinit_procdff_137| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#3| state)) #b1))
; yosys-smt2-register _witness_.anyinit_procdff_136 1
; yosys-smt2-wire _witness_.anyinit_procdff_136 1
(define-fun |robot_n _witness_.anyinit_procdff_136| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#1| state)) #b1))
; yosys-smt2-register _witness_.anyinit_procdff_131 1
; yosys-smt2-wire _witness_.anyinit_procdff_131 1
(define-fun |robot_n _witness_.anyinit_procdff_131| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#14| state)) #b1))
; yosys-smt2-register _witness_.anyinit_procdff_130 1
; yosys-smt2-wire _witness_.anyinit_procdff_130 1
(define-fun |robot_n _witness_.anyinit_procdff_130| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#11| state)) #b1))
; yosys-smt2-anyinit robot#25 1 robot.sv:80.9-102.12
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyinit_procdff_116"], "smtname": 25, "smtoffset": 0, "type": "init", "width": 1}
(declare-fun |robot#25| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyinit_procdff_116
; yosys-smt2-register _witness_.anyinit_procdff_116 1
; yosys-smt2-wire _witness_.anyinit_procdff_116 1
(define-fun |robot_n _witness_.anyinit_procdff_116| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#25| state)) #b1))
; yosys-smt2-anyinit robot#26 1 robot.sv:80.9-102.12
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyinit_procdff_114"], "smtname": 26, "smtoffset": 0, "type": "init", "width": 1}
(declare-fun |robot#26| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyinit_procdff_114
; yosys-smt2-register _witness_.anyinit_procdff_114 1
; yosys-smt2-wire _witness_.anyinit_procdff_114 1
(define-fun |robot_n _witness_.anyinit_procdff_114| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#26| state)) #b1))
; yosys-smt2-anyinit robot#27 1 robot.sv:80.9-102.12
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyinit_procdff_112"], "smtname": 27, "smtoffset": 0, "type": "init", "width": 1}
(declare-fun |robot#27| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyinit_procdff_112
; yosys-smt2-register _witness_.anyinit_procdff_112 1
; yosys-smt2-wire _witness_.anyinit_procdff_112 1
(define-fun |robot_n _witness_.anyinit_procdff_112| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#27| state)) #b1))
; yosys-smt2-anyinit robot#28 1 robot.sv:80.9-102.12
; yosys-smt2-witness {"offset": 0, "path": ["\\_witness_", "\\anyinit_procdff_110"], "smtname": 28, "smtoffset": 0, "type": "init", "width": 1}
(declare-fun |robot#28| (|robot_s|) (_ BitVec 1)) ; \_witness_.anyinit_procdff_110
; yosys-smt2-register _witness_.anyinit_procdff_110 1
; yosys-smt2-wire _witness_.anyinit_procdff_110 1
(define-fun |robot_n _witness_.anyinit_procdff_110| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#28| state)) #b1))
; yosys-smt2-witness {"offset": 0, "path": ["$formal$robot.sv:89$4_EN"], "smtname": 29, "smtoffset": 0, "type": "reg", "width": 1}
(declare-fun |robot#29| (|robot_s|) (_ BitVec 1)) ; $formal$robot.sv:89$4_EN
; yosys-smt2-register $formal$robot.sv:89$4_EN 1
(define-fun |robot_n $formal$robot.sv:89$4_EN| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#29| state)) #b1))
; yosys-smt2-witness {"offset": 0, "path": ["$formal$robot.sv:86$3_EN"], "smtname": 30, "smtoffset": 0, "type": "reg", "width": 1}
(declare-fun |robot#30| (|robot_s|) (_ BitVec 1)) ; $formal$robot.sv:86$3_EN
; yosys-smt2-register $formal$robot.sv:86$3_EN 1
(define-fun |robot_n $formal$robot.sv:86$3_EN| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#30| state)) #b1))
; yosys-smt2-witness {"offset": 0, "path": ["$formal$robot.sv:82$1_EN"], "smtname": 31, "smtoffset": 0, "type": "reg", "width": 1}
(declare-fun |robot#31| (|robot_s|) (_ BitVec 1)) ; $formal$robot.sv:82$1_EN
; yosys-smt2-register $formal$robot.sv:82$1_EN 1
(define-fun |robot_n $formal$robot.sv:82$1_EN| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#31| state)) #b1))
; yosys-smt2-register $auto$async2sync.cc:171:execute$142 1
(define-fun |robot_n $auto$async2sync.cc:171:execute$142| ((state |robot_s|)) Bool (= ((_ extract 0 0) (|robot#8| state)) #b1))
(define-fun |robot#32| ((state |robot_s|)) (_ BitVec 1) (bvnot (ite (|robot#17| state) #b1 #b0))) ; $auto$rtlil.cc:2461:Not$173
; yosys-smt2-assume 0 $auto$formalff.cc:758:execute$174
(define-fun |robot_u 0| ((state |robot_s|)) Bool (or (= ((_ extract 0 0) (|robot#32| state)) #b1) (not true))) ; $auto$formalff.cc:758:execute$174
; yosys-smt2-assert 0 assert_obs_detected_reset
(define-fun |robot_a 0| ((state |robot_s|)) Bool (or (= ((_ extract 0 0) (|robot#28| state)) #b1) (not (= ((_ extract 0 0) (|robot#31| state)) #b1)))) ; assert_obs_detected_reset
; yosys-smt2-assert 1 assert_obs_detected
(define-fun |robot_a 1| ((state |robot_s|)) Bool (or (= ((_ extract 0 0) (|robot#26| state)) #b1) (not (= ((_ extract 0 0) (|robot#30| state)) #b1)))) ; assert_obs_detected
; yosys-smt2-assert 2 assert_alarm_false_reset
(define-fun |robot_a 2| ((state |robot_s|)) Bool (or (= ((_ extract 0 0) (|robot#27| state)) #b1) (not (= ((_ extract 0 0) (|robot#31| state)) #b1)))) ; assert_alarm_false_reset
; yosys-smt2-assert 3 assert_alarm
(define-fun |robot_a 3| ((state |robot_s|)) Bool (or (= ((_ extract 0 0) (|robot#25| state)) #b1) (not (= ((_ extract 0 0) (|robot#29| state)) #b1)))) ; assert_alarm
(define-fun |robot#33| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) #b0 #b1)) ; $0$formal$robot.sv:82$1_EN[0:0]$26
(define-fun |robot#34| ((state |robot_s|)) (_ BitVec 1) (ite (= ((_ extract 0 0) (|robot#9| state)) #b1) #b1 #b0)) ; $procmux$88_Y
(define-fun |robot#35| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#34| state) #b0)) ; $0$formal$robot.sv:86$3_EN[0:0]$30
(define-fun |robot#36| ((state |robot_s|)) (_ BitVec 1) (ite (= ((_ extract 0 0) (|robot#10| state)) #b1) #b1 #b0)) ; $procmux$98_Y
(define-fun |robot#37| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#36| state) #b0)) ; $0$formal$robot.sv:89$4_EN[0:0]$32
(define-fun |robot#38| ((state |robot_s|)) Bool (not (or  (= ((_ extract 0 0) (|robot#4| state)) #b1) false))) ; $0$formal$robot.sv:97$8_CHECK[0:0]$39
(define-fun |robot#39| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#22| state) (ite (|robot#38| state) #b1 #b0))) ; $0$formal$robot.sv:82$1_CHECK[0:0]$25
(define-fun |robot#40| ((state |robot_s|)) Bool (not (or  (= ((_ extract 0 0) (|robot#2| state)) #b1) false))) ; $0$formal$robot.sv:100$10_CHECK[0:0]$43
(define-fun |robot#41| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#21| state) (ite (|robot#40| state) #b1 #b0))) ; $0$formal$robot.sv:83$2_CHECK[0:0]$27
(define-fun |robot#42| ((state |robot_s|)) Bool (not (or  (= ((_ extract 0 0) (|robot#13| state)) #b1) false))) ; $logic_not$robot.sv:86$48_Y
(define-fun |robot#43| ((state |robot_s|)) (_ BitVec 1) (ite (= ((_ extract 0 0) (|robot#9| state)) #b1) (ite (|robot#42| state) #b1 #b0) (|robot#20| state))) ; $procmux$93_Y
(define-fun |robot#44| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#43| state) (|robot#19| state))) ; $0$formal$robot.sv:86$3_CHECK[0:0]$29
(define-fun |robot#45| ((state |robot_s|)) Bool (not (or  (= ((_ extract 0 0) (|robot#16| state)) #b1) false))) ; $logic_not$robot.sv:89$49_Y
(define-fun |robot#46| ((state |robot_s|)) (_ BitVec 1) (ite (= ((_ extract 0 0) (|robot#10| state)) #b1) (ite (|robot#45| state) #b1 #b0) (|robot#24| state))) ; $procmux$103_Y
(define-fun |robot#47| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#46| state) (|robot#23| state))) ; $0$formal$robot.sv:89$4_CHECK[0:0]$31
(define-fun |robot#48| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#12| state) #b0)) ; $auto$rtlil.cc:2558:Mux$151
(define-fun |robot#49| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#7| state) #b0)) ; $auto$rtlil.cc:2558:Mux$149
(define-fun |robot#50| ((state |robot_s|)) (_ BitVec 1) (ite (= ((_ extract 0 0) (|robot#9| state)) #b1) #b1 (|robot#10| state))) ; $0\f_past_past_valid[0:0]
(define-fun |robot#51| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#50| state) (|robot#10| state))) ; $auto$rtlil.cc:2558:Mux$134
(define-fun |robot#52| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) #b1 #b0)) ; $auto$rtlil.cc:2558:Mux$153
(define-fun |robot#53| ((state |robot_s|)) (_ BitVec 1) (ite (|robot#0| state) (|robot#18| state) #b0)) ; $auto$rtlil.cc:2558:Mux$155
(define-fun |robot_a| ((state |robot_s|)) Bool (and
  (|robot_a 0| state)
  (|robot_a 1| state)
  (|robot_a 2| state)
  (|robot_a 3| state)
))
(define-fun |robot_u| ((state |robot_s|)) Bool 
  (|robot_u 0| state)
)
(define-fun |robot_i| ((state |robot_s|)) Bool (and
  (= (= ((_ extract 0 0) (|robot#10| state)) #b1) false) ; f_past_past_valid
  (= (= ((_ extract 0 0) (|robot#29| state)) #b1) false) ; $formal$robot.sv:89$4_EN
  (= (= ((_ extract 0 0) (|robot#30| state)) #b1) false) ; $formal$robot.sv:86$3_EN
  (= (= ((_ extract 0 0) (|robot#31| state)) #b1) false) ; $formal$robot.sv:82$1_EN
  (= (= ((_ extract 0 0) (|robot#8| state)) #b1) false) ; $auto$async2sync.cc:171:execute$142
))
(define-fun |robot_h| ((state |robot_s|)) Bool true)
(define-fun |robot_t| ((state |robot_s|) (next_state |robot_s|)) Bool (and
  (= (|robot#33| state) (|robot#31| next_state)) ; $procdff$111 $formal$robot.sv:82$1_EN
  (= (|robot#35| state) (|robot#30| next_state)) ; $procdff$115 $formal$robot.sv:86$3_EN
  (= (|robot#37| state) (|robot#29| next_state)) ; $procdff$117 $formal$robot.sv:89$4_EN
  (= (|robot#39| state) (|robot#28| next_state)) ; $procdff$110 \_witness_.anyinit_procdff_110
  (= (|robot#41| state) (|robot#27| next_state)) ; $procdff$112 \_witness_.anyinit_procdff_112
  (= (|robot#44| state) (|robot#26| next_state)) ; $procdff$114 \_witness_.anyinit_procdff_114
  (= (|robot#47| state) (|robot#25| next_state)) ; $procdff$116 \_witness_.anyinit_procdff_116
  (= (|robot#48| state) (|robot#14| next_state)) ; $procdff$131 \_witness_.anyinit_procdff_131
  (= (|robot#49| state) (|robot#11| next_state)) ; $procdff$130 \_witness_.anyinit_procdff_130
  (= (|robot#51| state) (|robot#10| next_state)) ; $procdff$135 \f_past_past_valid
  (= (|robot#52| state) (|robot#8| next_state)) ; $procdff$132 $auto$async2sync.cc:171:execute$142
  (= (|robot#49| state) (|robot#3| next_state)) ; $procdff$137 \_witness_.anyinit_procdff_137
  (= (|robot#53| state) (|robot#1| next_state)) ; $procdff$136 \_witness_.anyinit_procdff_136
)) ; end of module robot
; yosys-smt2-topmod robot
; end of yosys output
