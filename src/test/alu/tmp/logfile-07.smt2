(get-info :version)
; (:version "4.8.6")
; Started: 2024-07-15 15:44:38
; Silicon.version: 1.1-SNAPSHOT (4dbb81fc@(detached))
; Input file: -
; Verifier id: 00
; ------------------------------------------------------------
; Begin preamble
; ////////// Static preamble
; 
; ; /z3config.smt2
(set-option :print-success true) ; Boogie: false
(set-option :global-decls true) ; Boogie: default
(set-option :auto_config false) ; Usually a good idea
(set-option :smt.restart_strategy 0)
(set-option :smt.restart_factor |1.5|)
(set-option :smt.case_split 3)
(set-option :smt.delay_units true)
(set-option :smt.delay_units_threshold 16)
(set-option :nnf.sk_hack true)
(set-option :type_check true)
(set-option :smt.bv.reflect true)
(set-option :smt.mbqi false)
(set-option :smt.qi.eager_threshold 100)
(set-option :smt.qi.cost "(+ weight generation)")
(set-option :smt.qi.max_multi_patterns 1000)
(set-option :smt.phase_selection 0) ; default: 3, Boogie: 0
(set-option :sat.phase caching)
(set-option :sat.random_seed 0)
(set-option :nlsat.randomize true)
(set-option :nlsat.seed 0)
(set-option :nlsat.shuffle_vars false)
(set-option :fp.spacer.order_children 0) ; Not available with Z3 4.5
(set-option :fp.spacer.random_seed 0) ; Not available with Z3 4.5
(set-option :smt.arith.random_initial_value true) ; Boogie: true
(set-option :smt.random_seed 0)
(set-option :sls.random_offset true)
(set-option :sls.random_seed 0)
(set-option :sls.restart_init false)
(set-option :sls.walksat_ucb true)
(set-option :model.v2 true)
; 
; ; /preamble.smt2
(declare-datatypes () ((
    $Snap ($Snap.unit)
    ($Snap.combine ($Snap.first $Snap) ($Snap.second $Snap)))))
(declare-sort $Ref 0)
(declare-const $Ref.null $Ref)
(declare-sort $FPM)
(declare-sort $PPM)
(define-sort $Perm () Real)
(define-const $Perm.Write $Perm 1.0)
(define-const $Perm.No $Perm 0.0)
(define-fun $Perm.isValidVar ((p $Perm)) Bool
	(<= $Perm.No p))
(define-fun $Perm.isReadVar ((p $Perm) (ub $Perm)) Bool
    (and ($Perm.isValidVar p)
         (not (= p $Perm.No))
         (< p $Perm.Write)))
(define-fun $Perm.min ((p1 $Perm) (p2 $Perm)) Real
    (ite (<= p1 p2) p1 p2))
(define-fun $Math.min ((a Int) (b Int)) Int
    (ite (<= a b) a b))
(define-fun $Math.clip ((a Int)) Int
    (ite (< a 0) 0 a))
; ////////// Sorts
(declare-sort Seq<Int>)
(declare-sort Set<$Ref>)
(declare-sort Set<Bool>)
(declare-sort Set<Int>)
(declare-sort Set<Seq<Int>>)
(declare-sort Set<$Snap>)
(declare-sort frac)
(declare-sort TYPE)
(declare-sort zfrac)
(declare-sort $FVF<Seq<Int>>)
(declare-sort $FVF<$Ref>)
; ////////// Sort wrappers
; Declaring additional sort wrappers
(declare-fun $SortWrappers.IntTo$Snap (Int) $Snap)
(declare-fun $SortWrappers.$SnapToInt ($Snap) Int)
(assert (forall ((x Int)) (!
    (= x ($SortWrappers.$SnapToInt($SortWrappers.IntTo$Snap x)))
    :pattern (($SortWrappers.IntTo$Snap x))
    :qid |$Snap.$SnapToIntTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.IntTo$Snap($SortWrappers.$SnapToInt x)))
    :pattern (($SortWrappers.$SnapToInt x))
    :qid |$Snap.IntTo$SnapToInt|
    )))
(declare-fun $SortWrappers.BoolTo$Snap (Bool) $Snap)
(declare-fun $SortWrappers.$SnapToBool ($Snap) Bool)
(assert (forall ((x Bool)) (!
    (= x ($SortWrappers.$SnapToBool($SortWrappers.BoolTo$Snap x)))
    :pattern (($SortWrappers.BoolTo$Snap x))
    :qid |$Snap.$SnapToBoolTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.BoolTo$Snap($SortWrappers.$SnapToBool x)))
    :pattern (($SortWrappers.$SnapToBool x))
    :qid |$Snap.BoolTo$SnapToBool|
    )))
(declare-fun $SortWrappers.$RefTo$Snap ($Ref) $Snap)
(declare-fun $SortWrappers.$SnapTo$Ref ($Snap) $Ref)
(assert (forall ((x $Ref)) (!
    (= x ($SortWrappers.$SnapTo$Ref($SortWrappers.$RefTo$Snap x)))
    :pattern (($SortWrappers.$RefTo$Snap x))
    :qid |$Snap.$SnapTo$RefTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$RefTo$Snap($SortWrappers.$SnapTo$Ref x)))
    :pattern (($SortWrappers.$SnapTo$Ref x))
    :qid |$Snap.$RefTo$SnapTo$Ref|
    )))
(declare-fun $SortWrappers.$PermTo$Snap ($Perm) $Snap)
(declare-fun $SortWrappers.$SnapTo$Perm ($Snap) $Perm)
(assert (forall ((x $Perm)) (!
    (= x ($SortWrappers.$SnapTo$Perm($SortWrappers.$PermTo$Snap x)))
    :pattern (($SortWrappers.$PermTo$Snap x))
    :qid |$Snap.$SnapTo$PermTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$PermTo$Snap($SortWrappers.$SnapTo$Perm x)))
    :pattern (($SortWrappers.$SnapTo$Perm x))
    :qid |$Snap.$PermTo$SnapTo$Perm|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.Seq<Int>To$Snap (Seq<Int>) $Snap)
(declare-fun $SortWrappers.$SnapToSeq<Int> ($Snap) Seq<Int>)
(assert (forall ((x Seq<Int>)) (!
    (= x ($SortWrappers.$SnapToSeq<Int>($SortWrappers.Seq<Int>To$Snap x)))
    :pattern (($SortWrappers.Seq<Int>To$Snap x))
    :qid |$Snap.$SnapToSeq<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Seq<Int>To$Snap($SortWrappers.$SnapToSeq<Int> x)))
    :pattern (($SortWrappers.$SnapToSeq<Int> x))
    :qid |$Snap.Seq<Int>To$SnapToSeq<Int>|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.Set<$Ref>To$Snap (Set<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Ref> ($Snap) Set<$Ref>)
(assert (forall ((x Set<$Ref>)) (!
    (= x ($SortWrappers.$SnapToSet<$Ref>($SortWrappers.Set<$Ref>To$Snap x)))
    :pattern (($SortWrappers.Set<$Ref>To$Snap x))
    :qid |$Snap.$SnapToSet<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Ref>To$Snap($SortWrappers.$SnapToSet<$Ref> x)))
    :pattern (($SortWrappers.$SnapToSet<$Ref> x))
    :qid |$Snap.Set<$Ref>To$SnapToSet<$Ref>|
    )))
(declare-fun $SortWrappers.Set<Bool>To$Snap (Set<Bool>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Bool> ($Snap) Set<Bool>)
(assert (forall ((x Set<Bool>)) (!
    (= x ($SortWrappers.$SnapToSet<Bool>($SortWrappers.Set<Bool>To$Snap x)))
    :pattern (($SortWrappers.Set<Bool>To$Snap x))
    :qid |$Snap.$SnapToSet<Bool>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Bool>To$Snap($SortWrappers.$SnapToSet<Bool> x)))
    :pattern (($SortWrappers.$SnapToSet<Bool> x))
    :qid |$Snap.Set<Bool>To$SnapToSet<Bool>|
    )))
(declare-fun $SortWrappers.Set<Int>To$Snap (Set<Int>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Int> ($Snap) Set<Int>)
(assert (forall ((x Set<Int>)) (!
    (= x ($SortWrappers.$SnapToSet<Int>($SortWrappers.Set<Int>To$Snap x)))
    :pattern (($SortWrappers.Set<Int>To$Snap x))
    :qid |$Snap.$SnapToSet<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Int>To$Snap($SortWrappers.$SnapToSet<Int> x)))
    :pattern (($SortWrappers.$SnapToSet<Int> x))
    :qid |$Snap.Set<Int>To$SnapToSet<Int>|
    )))
(declare-fun $SortWrappers.Set<Seq<Int>>To$Snap (Set<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Seq<Int>> ($Snap) Set<Seq<Int>>)
(assert (forall ((x Set<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapToSet<Seq<Int>>($SortWrappers.Set<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.Set<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapToSet<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Seq<Int>>To$Snap($SortWrappers.$SnapToSet<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapToSet<Seq<Int>> x))
    :qid |$Snap.Set<Seq<Int>>To$SnapToSet<Seq<Int>>|
    )))
(declare-fun $SortWrappers.Set<$Snap>To$Snap (Set<$Snap>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Snap> ($Snap) Set<$Snap>)
(assert (forall ((x Set<$Snap>)) (!
    (= x ($SortWrappers.$SnapToSet<$Snap>($SortWrappers.Set<$Snap>To$Snap x)))
    :pattern (($SortWrappers.Set<$Snap>To$Snap x))
    :qid |$Snap.$SnapToSet<$Snap>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Snap>To$Snap($SortWrappers.$SnapToSet<$Snap> x)))
    :pattern (($SortWrappers.$SnapToSet<$Snap> x))
    :qid |$Snap.Set<$Snap>To$SnapToSet<$Snap>|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.fracTo$Snap (frac) $Snap)
(declare-fun $SortWrappers.$SnapTofrac ($Snap) frac)
(assert (forall ((x frac)) (!
    (= x ($SortWrappers.$SnapTofrac($SortWrappers.fracTo$Snap x)))
    :pattern (($SortWrappers.fracTo$Snap x))
    :qid |$Snap.$SnapTofracTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.fracTo$Snap($SortWrappers.$SnapTofrac x)))
    :pattern (($SortWrappers.$SnapTofrac x))
    :qid |$Snap.fracTo$SnapTofrac|
    )))
(declare-fun $SortWrappers.TYPETo$Snap (TYPE) $Snap)
(declare-fun $SortWrappers.$SnapToTYPE ($Snap) TYPE)
(assert (forall ((x TYPE)) (!
    (= x ($SortWrappers.$SnapToTYPE($SortWrappers.TYPETo$Snap x)))
    :pattern (($SortWrappers.TYPETo$Snap x))
    :qid |$Snap.$SnapToTYPETo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.TYPETo$Snap($SortWrappers.$SnapToTYPE x)))
    :pattern (($SortWrappers.$SnapToTYPE x))
    :qid |$Snap.TYPETo$SnapToTYPE|
    )))
(declare-fun $SortWrappers.zfracTo$Snap (zfrac) $Snap)
(declare-fun $SortWrappers.$SnapTozfrac ($Snap) zfrac)
(assert (forall ((x zfrac)) (!
    (= x ($SortWrappers.$SnapTozfrac($SortWrappers.zfracTo$Snap x)))
    :pattern (($SortWrappers.zfracTo$Snap x))
    :qid |$Snap.$SnapTozfracTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.zfracTo$Snap($SortWrappers.$SnapTozfrac x)))
    :pattern (($SortWrappers.$SnapTozfrac x))
    :qid |$Snap.zfracTo$SnapTozfrac|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.$FVF<Seq<Int>>To$Snap ($FVF<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<Seq<Int>> ($Snap) $FVF<Seq<Int>>)
(assert (forall ((x $FVF<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<Seq<Int>>($SortWrappers.$FVF<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<Seq<Int>>To$Snap($SortWrappers.$SnapTo$FVF<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<Seq<Int>> x))
    :qid |$Snap.$FVF<Seq<Int>>To$SnapTo$FVF<Seq<Int>>|
    )))
(declare-fun $SortWrappers.$FVF<$Ref>To$Snap ($FVF<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<$Ref> ($Snap) $FVF<$Ref>)
(assert (forall ((x $FVF<$Ref>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<$Ref>($SortWrappers.$FVF<$Ref>To$Snap x)))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<$Ref>To$Snap($SortWrappers.$SnapTo$FVF<$Ref> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<$Ref> x))
    :qid |$Snap.$FVF<$Ref>To$SnapTo$FVF<$Ref>|
    )))
; ////////// Symbols
(declare-fun Set_in ($Ref Set<$Ref>) Bool)
(declare-fun Set_card (Set<$Ref>) Int)
(declare-const Set_empty Set<$Ref>)
(declare-fun Set_singleton ($Ref) Set<$Ref>)
(declare-fun Set_unionone (Set<$Ref> $Ref) Set<$Ref>)
(declare-fun Set_union (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_disjoint (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_difference (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_intersection (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_subset (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_equal (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_in (Bool Set<Bool>) Bool)
(declare-fun Set_card (Set<Bool>) Int)
(declare-const Set_empty Set<Bool>)
(declare-fun Set_singleton (Bool) Set<Bool>)
(declare-fun Set_unionone (Set<Bool> Bool) Set<Bool>)
(declare-fun Set_union (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_disjoint (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_difference (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_intersection (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_subset (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_equal (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_in (Int Set<Int>) Bool)
(declare-fun Set_card (Set<Int>) Int)
(declare-const Set_empty Set<Int>)
(declare-fun Set_singleton (Int) Set<Int>)
(declare-fun Set_unionone (Set<Int> Int) Set<Int>)
(declare-fun Set_union (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_disjoint (Set<Int> Set<Int>) Bool)
(declare-fun Set_difference (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_intersection (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_subset (Set<Int> Set<Int>) Bool)
(declare-fun Set_equal (Set<Int> Set<Int>) Bool)
(declare-fun Set_in (Seq<Int> Set<Seq<Int>>) Bool)
(declare-fun Set_card (Set<Seq<Int>>) Int)
(declare-const Set_empty Set<Seq<Int>>)
(declare-fun Set_singleton (Seq<Int>) Set<Seq<Int>>)
(declare-fun Set_unionone (Set<Seq<Int>> Seq<Int>) Set<Seq<Int>>)
(declare-fun Set_union (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_disjoint (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_difference (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_intersection (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_subset (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_equal (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_in ($Snap Set<$Snap>) Bool)
(declare-fun Set_card (Set<$Snap>) Int)
(declare-const Set_empty Set<$Snap>)
(declare-fun Set_singleton ($Snap) Set<$Snap>)
(declare-fun Set_unionone (Set<$Snap> $Snap) Set<$Snap>)
(declare-fun Set_union (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_disjoint (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_difference (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_intersection (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_subset (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_equal (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Seq_length (Seq<Int>) Int)
(declare-const Seq_empty Seq<Int>)
(declare-fun Seq_singleton (Int) Seq<Int>)
(declare-fun Seq_build (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_index (Seq<Int> Int) Int)
(declare-fun Seq_append (Seq<Int> Seq<Int>) Seq<Int>)
(declare-fun Seq_update (Seq<Int> Int Int) Seq<Int>)
(declare-fun Seq_contains (Seq<Int> Int) Bool)
(declare-fun Seq_take (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_drop (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_equal (Seq<Int> Seq<Int>) Bool)
(declare-fun Seq_sameuntil (Seq<Int> Seq<Int> Int) Bool)
(declare-fun Seq_range (Int Int) Seq<Int>)
(declare-fun frac_val<Perm> (frac) $Perm)
(declare-const class_ALU<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class_Driver<TYPE> TYPE)
(declare-const class_Monitor<TYPE> TYPE)
(declare-const class_Main<TYPE> TYPE)
(declare-const class_EncodedGlobalVariables<TYPE> TYPE)
(declare-fun directSuperclass<TYPE> (TYPE) TYPE)
(declare-fun type_of<TYPE> ($Ref) TYPE)
(declare-fun zfrac_val<Perm> (zfrac) $Perm)
; /field_value_functions_declarations.smt2 [Main_process_state: Seq[Int]]
(declare-fun $FVF.domain_Main_process_state ($FVF<Seq<Int>>) Set<$Ref>)
(declare-fun $FVF.lookup_Main_process_state ($FVF<Seq<Int>> $Ref) Seq<Int>)
(declare-fun $FVF.after_Main_process_state ($FVF<Seq<Int>> $FVF<Seq<Int>>) Bool)
(declare-fun $FVF.loc_Main_process_state (Seq<Int> $Ref) Bool)
(declare-fun $FVF.perm_Main_process_state ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Main_process_state $FVF<Seq<Int>>)
; /field_value_functions_declarations.smt2 [ALU_m: Ref]
(declare-fun $FVF.domain_ALU_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_ALU_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_ALU_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_ALU_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_ALU_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_ALU_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Driver_m: Ref]
(declare-fun $FVF.domain_Driver_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Driver_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Driver_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Driver_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Driver_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Driver_m $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [Monitor_m: Ref]
(declare-fun $FVF.domain_Monitor_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Monitor_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Monitor_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Monitor_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Monitor_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Monitor_m $FVF<$Ref>)
; Declaring symbols related to program functions (from program analysis)
(declare-fun instanceof_TYPE_TYPE ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%limited ($Snap TYPE TYPE) Bool)
(declare-fun instanceof_TYPE_TYPE%stateless (TYPE TYPE) Bool)
(declare-fun new_frac ($Snap $Perm) frac)
(declare-fun new_frac%limited ($Snap $Perm) frac)
(declare-fun new_frac%stateless ($Perm) Bool)
(declare-fun new_zfrac ($Snap $Perm) zfrac)
(declare-fun new_zfrac%limited ($Snap $Perm) zfrac)
(declare-fun new_zfrac%stateless ($Perm) Bool)
(declare-fun Main_find_minimum_advance_Sequence$Integer$ ($Snap $Ref Seq<Int>) Int)
(declare-fun Main_find_minimum_advance_Sequence$Integer$%limited ($Snap $Ref Seq<Int>) Int)
(declare-fun Main_find_minimum_advance_Sequence$Integer$%stateless ($Ref Seq<Int>) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
(declare-fun Driver_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Driver_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Monitor_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Monitor_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_ALU<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_Driver<TYPE> class_Monitor<TYPE> class_Main<TYPE> class_EncodedGlobalVariables<TYPE>))
; ////////// Axioms
(assert (forall ((s Seq<Int>)) (!
  (<= 0 (Seq_length s))
  :pattern ((Seq_length s))
  :qid |$Seq[Int]_prog.seq_length_non_negative|)))
(assert (= (Seq_length (as Seq_empty  Seq<Int>)) 0))
(assert (forall ((s Seq<Int>)) (!
  (implies (= (Seq_length s) 0) (= s (as Seq_empty  Seq<Int>)))
  :pattern ((Seq_length s))
  :qid |$Seq[Int]_prog.only_empty_seq_length_zero|)))
(assert (forall ((e Int)) (!
  (= (Seq_length (Seq_singleton e)) 1)
  :pattern ((Seq_length (Seq_singleton e)))
  :qid |$Seq[Int]_prog.length_singleton_seq|)))
(assert (forall ((s Seq<Int>) (e Int)) (!
  (= (Seq_length (Seq_build s e)) (+ 1 (Seq_length s)))
  :pattern ((Seq_length (Seq_build s e)))
  :qid |$Seq[Int]_prog.length_seq_build_inc_by_one|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int)) (!
  (ite
    (= i (Seq_length s))
    (= (Seq_index (Seq_build s e) i) e)
    (= (Seq_index (Seq_build s e) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_build s e) i))
  :qid |$Seq[Int]_prog.seq_index_over_build|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Int>)))
      (not (= s2 (as Seq_empty  Seq<Int>))))
    (= (Seq_length (Seq_append s1 s2)) (+ (Seq_length s1) (Seq_length s2))))
  :pattern ((Seq_length (Seq_append s1 s2)))
  :qid |$Seq[Int]_prog.seq_length_over_append|)))
(assert (forall ((e Int)) (!
  (= (Seq_index (Seq_singleton e) 0) e)
  :pattern ((Seq_index (Seq_singleton e) 0))
  :qid |$Seq[Int]_prog.seq_index_over_singleton|)))
(assert (forall ((e1 Int) (e2 Int)) (!
  (= (Seq_contains (Seq_singleton e1) e2) (= e1 e2))
  :pattern ((Seq_contains (Seq_singleton e1) e2))
  :qid |$Seq[Int]_prog.seq_contains_over_singleton|)))
(assert (forall ((s Seq<Int>)) (!
  (= (Seq_append (as Seq_empty  Seq<Int>) s) s)
  :pattern ((Seq_append (as Seq_empty  Seq<Int>) s))
  :qid |$Seq[Int]_prog.seq_append_empty_left|)))
(assert (forall ((s Seq<Int>)) (!
  (= (Seq_append s (as Seq_empty  Seq<Int>)) s)
  :pattern ((Seq_append s (as Seq_empty  Seq<Int>)))
  :qid |$Seq[Int]_prog.seq_append_empty_right|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (i Int)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Int>)))
      (not (= s2 (as Seq_empty  Seq<Int>))))
    (ite
      (< i (Seq_length s1))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s1 i))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s2 (- i (Seq_length s1))))))
  :pattern ((Seq_index (Seq_append s1 s2) i))
  :pattern ((Seq_index s1 i) (Seq_append s1 s2))
  :qid |$Seq[Int]_prog.seq_index_over_append|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int)) (!
  (implies
    (and (<= 0 i) (< i (Seq_length s)))
    (= (Seq_length (Seq_update s i e)) (Seq_length s)))
  :pattern ((Seq_length (Seq_update s i e)))
  :qid |$Seq[Int]_prog.seq_length_invariant_over_update|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (j Int)) (!
  (ite
    (implies (and (<= 0 i) (< i (Seq_length s))) (= i j))
    (= (Seq_index (Seq_update s i e) j) e)
    (= (Seq_index (Seq_update s i e) j) (Seq_index s j)))
  :pattern ((Seq_index (Seq_update s i e) j))
  :qid |$Seq[Int]_prog.seq_index_over_update|)))
(assert (forall ((s Seq<Int>) (e Int)) (!
  (=
    (Seq_contains s e)
    (exists ((i Int)) (!
      (and (<= 0 i) (and (< i (Seq_length s)) (= (Seq_index s i) e)))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains s e))
  :qid |$Seq[Int]_prog.seq_element_contains_index_exists|)))
(assert (forall ((e Int)) (!
  (not (Seq_contains (as Seq_empty  Seq<Int>) e))
  :pattern ((Seq_contains (as Seq_empty  Seq<Int>) e))
  :qid |$Seq[Int]_prog.empty_seq_contains_nothing|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (e Int)) (!
  (=
    (Seq_contains (Seq_append s1 s2) e)
    (or (Seq_contains s1 e) (Seq_contains s2 e)))
  :pattern ((Seq_contains (Seq_append s1 s2) e))
  :qid |$Seq[Int]_prog.seq_contains_over_append|)))
(assert (forall ((s Seq<Int>) (e1 Int) (e2 Int)) (!
  (= (Seq_contains (Seq_build s e1) e2) (or (= e1 e2) (Seq_contains s e2)))
  :pattern ((Seq_contains (Seq_build s e1) e2))
  :qid |$Seq[Int]_prog.seq_contains_over_build|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies (<= n 0) (= (Seq_take s n) (as Seq_empty  Seq<Int>)))
  :pattern ((Seq_take s n))
  :qid |$Seq[Int]_prog.seq_take_negative_length|)))
(assert (forall ((s Seq<Int>) (n Int) (e Int)) (!
  (=
    (Seq_contains (Seq_take s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (< i n) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_take s n) e))
  :qid |$Seq[Int]_prog.seq_contains_over_take_index_exists|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies (<= n 0) (= (Seq_drop s n) s))
  :pattern ((Seq_drop s n))
  :qid |$Seq[Int]_prog.seq_drop_negative_length|)))
(assert (forall ((s Seq<Int>) (n Int) (e Int)) (!
  (=
    (Seq_contains (Seq_drop s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (<= n i) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_drop s n) e))
  :qid |$Seq[Int]_prog.seq_contains_over_drop_index_exists|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (=
    (Seq_equal s1 s2)
    (and
      (= (Seq_length s1) (Seq_length s2))
      (forall ((i Int)) (!
        (implies
          (and (<= 0 i) (< i (Seq_length s1)))
          (= (Seq_index s1 i) (Seq_index s2 i)))
        :pattern ((Seq_index s1 i))
        :pattern ((Seq_index s2 i))
        ))))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Int]_prog.extensional_seq_equality|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (implies (Seq_equal s1 s2) (= s1 s2))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Int]_prog.seq_equality_identity|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (n Int)) (!
  (=
    (Seq_sameuntil s1 s2 n)
    (forall ((i Int)) (!
      (implies (and (<= 0 i) (< i n)) (= (Seq_index s1 i) (Seq_index s2 i)))
      :pattern ((Seq_index s1 i))
      :pattern ((Seq_index s2 i))
      )))
  :pattern ((Seq_sameuntil s1 s2 n))
  :qid |$Seq[Int]_prog.extensional_seq_equality_prefix|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_take s n)) n)
      (= (Seq_length (Seq_take s n)) (Seq_length s))))
  :pattern ((Seq_length (Seq_take s n)))
  :qid |$Seq[Int]_prog.seq_length_over_take|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< i (Seq_length s))))
    (= (Seq_index (Seq_take s n) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_take s n) i))
  :pattern ((Seq_index s i) (Seq_take s n))
  :qid |$Seq[Int]_prog.seq_index_over_take|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_drop s n)) (- (Seq_length s) n))
      (= (Seq_length (Seq_drop s n)) 0)))
  :pattern ((Seq_length (Seq_drop s n)))
  :qid |$Seq[Int]_prog.seq_length_over_drop|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= 0 i) (< i (- (Seq_length s) n))))
    (= (Seq_index (Seq_drop s n) i) (Seq_index s (+ i n))))
  :pattern ((Seq_index (Seq_drop s n) i))
  :qid |$Seq[Int]_prog.seq_index_over_drop_1|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_index (Seq_drop s n) (- i n)) (Seq_index s i)))
  :pattern ((Seq_index s i) (Seq_drop s n))
  :qid |$Seq[Int]_prog.seq_index_over_drop_2|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_take (Seq_update s i e) n) (Seq_update (Seq_take s n) i e)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_take_over_update_1|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= n i) (< i (Seq_length s)))
    (= (Seq_take (Seq_update s i e) n) (Seq_take s n)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_take_over_update_2|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_update (Seq_drop s n) (- i n) e)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_update_1|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_drop s n)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_update_2|)))
(assert (forall ((s Seq<Int>) (e Int) (n Int)) (!
  (implies
    (and (<= 0 n) (<= n (Seq_length s)))
    (= (Seq_drop (Seq_build s e) n) (Seq_build (Seq_drop s n) e)))
  :pattern ((Seq_drop (Seq_build s e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_build|)))
(assert (forall ((min_ Int) (max Int)) (!
  (ite
    (< min_ max)
    (= (Seq_length (Seq_range min_ max)) (- max min_))
    (= (Seq_length (Seq_range min_ max)) 0))
  :pattern ((Seq_length (Seq_range min_ max)))
  :qid |$Seq[Int]_prog.ranged_seq_length|)))
(assert (forall ((min_ Int) (max Int) (i Int)) (!
  (implies
    (and (<= 0 i) (< i (- max min_)))
    (= (Seq_index (Seq_range min_ max) i) (+ min_ i)))
  :pattern ((Seq_index (Seq_range min_ max) i))
  :qid |$Seq[Int]_prog.ranged_seq_index|)))
(assert (forall ((min_ Int) (max Int) (e Int)) (!
  (= (Seq_contains (Seq_range min_ max) e) (and (<= min_ e) (< e max)))
  :pattern ((Seq_contains (Seq_range min_ max) e))
  :qid |$Seq[Int]_prog.ranged_seq_contains|)))
(assert (forall ((s Set<$Ref>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.card_non_negative|)))
(assert (forall ((e $Ref)) (!
  (not (Set_in e (as Set_empty  Set<$Ref>)))
  :pattern ((Set_in e (as Set_empty  Set<$Ref>)))
  :qid |$Set[Ref]_prog.in_empty_set|)))
(assert (forall ((s Set<$Ref>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Ref>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e $Ref)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.empty_set_cardinality|)))
(assert (forall ((e $Ref)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Ref]_prog.in_singleton_set|)))
(assert (forall ((e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Ref]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Ref)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Ref]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Ref]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Ref]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Ref]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Ref]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Ref]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Ref)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Ref]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Ref)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.native_equality|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Ref)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Ref]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_difference|)))
(assert (forall ((s Set<Bool>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Bool]_prog.card_non_negative|)))
(assert (forall ((e Bool)) (!
  (not (Set_in e (as Set_empty  Set<Bool>)))
  :pattern ((Set_in e (as Set_empty  Set<Bool>)))
  :qid |$Set[Bool]_prog.in_empty_set|)))
(assert (forall ((s Set<Bool>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Bool>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Bool)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Bool]_prog.empty_set_cardinality|)))
(assert (forall ((e Bool)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Bool]_prog.in_singleton_set|)))
(assert (forall ((e1 Bool) (e2 Bool)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Bool]_prog.in_singleton_set_equality|)))
(assert (forall ((e Bool)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Bool]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Bool]_prog.in_unionone_same|)))
(assert (forall ((s Set<Bool>) (e1 Bool) (e2 Bool)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Bool]_prog.in_unionone_other|)))
(assert (forall ((s Set<Bool>) (e1 Bool) (e2 Bool)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Bool]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Bool]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Bool]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Bool]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Bool]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Bool]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Bool]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Bool]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Bool]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Bool]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Bool]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Bool]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Bool]_prog.in_difference|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Bool]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Bool)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Bool]_prog.subset_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Bool)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Bool]_prog.equality_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Bool]_prog.native_equality|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Bool)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Bool]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Bool]_prog.cardinality_difference|)))
(assert (forall ((s Set<Int>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.card_non_negative|)))
(assert (forall ((e Int)) (!
  (not (Set_in e (as Set_empty  Set<Int>)))
  :pattern ((Set_in e (as Set_empty  Set<Int>)))
  :qid |$Set[Int]_prog.in_empty_set|)))
(assert (forall ((s Set<Int>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Int>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Int)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.empty_set_cardinality|)))
(assert (forall ((e Int)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Int]_prog.in_singleton_set|)))
(assert (forall ((e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Int]_prog.in_singleton_set_equality|)))
(assert (forall ((e Int)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Int]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Int]_prog.in_unionone_same|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Int]_prog.in_unionone_other|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Int]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Int]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Int]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Int]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Int]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Int)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Int]_prog.subset_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Int)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.equality_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.native_equality|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Int)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Int]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.cardinality_difference|)))
(assert (forall ((s Set<Seq<Int>>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Int]]_prog.card_non_negative|)))
(assert (forall ((e Seq<Int>)) (!
  (not (Set_in e (as Set_empty  Set<Seq<Int>>)))
  :pattern ((Set_in e (as Set_empty  Set<Seq<Int>>)))
  :qid |$Set[Seq[Int]]_prog.in_empty_set|)))
(assert (forall ((s Set<Seq<Int>>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Seq<Int>>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Seq<Int>)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Int]]_prog.empty_set_cardinality|)))
(assert (forall ((e Seq<Int>)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Seq[Int]]_prog.in_singleton_set|)))
(assert (forall ((e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Seq[Int]]_prog.in_singleton_set_equality|)))
(assert (forall ((e Seq<Int>)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Seq[Int]]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Seq[Int]]_prog.in_unionone_same|)))
(assert (forall ((s Set<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Seq[Int]]_prog.in_unionone_other|)))
(assert (forall ((s Set<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Seq[Int]]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Int]]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Int]]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Seq[Int]]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Seq[Int]]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Seq[Int]]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Int]]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Seq[Int]]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Seq[Int]]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Seq[Int]]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Seq[Int]]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Seq[Int]]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Seq[Int]]_prog.in_difference|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Int]]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Seq<Int>)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Seq[Int]]_prog.subset_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Seq<Int>)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Int]]_prog.equality_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Int]]_prog.native_equality|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Seq<Int>)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Seq[Int]]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Seq[Int]]_prog.cardinality_difference|)))
(assert (forall ((s Set<$Snap>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.card_non_negative|)))
(assert (forall ((e $Snap)) (!
  (not (Set_in e (as Set_empty  Set<$Snap>)))
  :pattern ((Set_in e (as Set_empty  Set<$Snap>)))
  :qid |$Set[Snap]_prog.in_empty_set|)))
(assert (forall ((s Set<$Snap>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Snap>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e $Snap)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.empty_set_cardinality|)))
(assert (forall ((e $Snap)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Snap]_prog.in_singleton_set|)))
(assert (forall ((e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Snap]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Snap)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Snap]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Snap]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Snap]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Snap]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Snap]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Snap]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Snap)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Snap]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Snap)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.native_equality|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Snap)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Snap]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_difference|)))
(assert (forall ((a frac) (b frac)) (!
  (= (= (frac_val<Perm> a) (frac_val<Perm> b)) (= a b))
  :pattern ((frac_val<Perm> a) (frac_val<Perm> b))
  :qid |prog.frac_eq|)))
(assert (forall ((a frac)) (!
  (and (< $Perm.No (frac_val<Perm> a)) (<= (frac_val<Perm> a) $Perm.Write))
  :pattern ((frac_val<Perm> a))
  :qid |prog.frac_bound|)))
(assert (=
  (directSuperclass<TYPE> (as class_ALU<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Driver<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Monitor<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Main<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_EncodedGlobalVariables<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (forall ((a zfrac) (b zfrac)) (!
  (= (= (zfrac_val<Perm> a) (zfrac_val<Perm> b)) (= a b))
  :pattern ((zfrac_val<Perm> a) (zfrac_val<Perm> b))
  :qid |prog.zfrac_eq|)))
(assert (forall ((a zfrac)) (!
  (and (<= $Perm.No (zfrac_val<Perm> a)) (<= (zfrac_val<Perm> a) $Perm.Write))
  :pattern ((zfrac_val<Perm> a))
  :qid |prog.zfrac_bound|)))
; /field_value_functions_axioms.smt2 [Main_process_state: Seq[Int]]
(assert (forall ((vs $FVF<Seq<Int>>) (ws $FVF<Seq<Int>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Main_process_state vs) ($FVF.domain_Main_process_state ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Main_process_state vs))
            (= ($FVF.lookup_Main_process_state vs x) ($FVF.lookup_Main_process_state ws x)))
          :pattern (($FVF.lookup_Main_process_state vs x) ($FVF.lookup_Main_process_state ws x))
          :qid |qp.$FVF<Seq<Int>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap vs)
              ($SortWrappers.$FVF<Seq<Int>>To$Snap ws)
              )
    :qid |qp.$FVF<Seq<Int>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Main_process_state pm r))
    :pattern ($FVF.perm_Main_process_state pm r))))
(assert (forall ((r $Ref) (f Seq<Int>)) (!
    (= ($FVF.loc_Main_process_state f r) true)
    :pattern ($FVF.loc_Main_process_state f r))))
; /field_value_functions_axioms.smt2 [ALU_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_ALU_m vs) ($FVF.domain_ALU_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_ALU_m vs))
            (= ($FVF.lookup_ALU_m vs x) ($FVF.lookup_ALU_m ws x)))
          :pattern (($FVF.lookup_ALU_m vs x) ($FVF.lookup_ALU_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_ALU_m pm r))
    :pattern ($FVF.perm_ALU_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_ALU_m f r) true)
    :pattern ($FVF.loc_ALU_m f r))))
; /field_value_functions_axioms.smt2 [Driver_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Driver_m vs) ($FVF.domain_Driver_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Driver_m vs))
            (= ($FVF.lookup_Driver_m vs x) ($FVF.lookup_Driver_m ws x)))
          :pattern (($FVF.lookup_Driver_m vs x) ($FVF.lookup_Driver_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Driver_m pm r))
    :pattern ($FVF.perm_Driver_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Driver_m f r) true)
    :pattern ($FVF.loc_Driver_m f r))))
; /field_value_functions_axioms.smt2 [Monitor_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Monitor_m vs) ($FVF.domain_Monitor_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Monitor_m vs))
            (= ($FVF.lookup_Monitor_m vs x) ($FVF.lookup_Monitor_m ws x)))
          :pattern (($FVF.lookup_Monitor_m vs x) ($FVF.lookup_Monitor_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Monitor_m pm r))
    :pattern ($FVF.perm_Monitor_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Monitor_m f r) true)
    :pattern ($FVF.loc_Monitor_m f r))))
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ------------------------------------------------------------
; Begin function- and predicate-related preamble
; Declaring symbols related to program functions (from verification)
(assert (forall ((s@$ $Snap) (t@0@00 TYPE) (u@1@00 TYPE)) (!
  (=
    (instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00)
    (instanceof_TYPE_TYPE s@$ t@0@00 u@1@00))
  :pattern ((instanceof_TYPE_TYPE s@$ t@0@00 u@1@00))
  )))
(assert (forall ((s@$ $Snap) (t@0@00 TYPE) (u@1@00 TYPE)) (!
  (instanceof_TYPE_TYPE%stateless t@0@00 u@1@00)
  :pattern ((instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00))
  )))
(assert (forall ((s@$ $Snap) (t@0@00 TYPE) (u@1@00 TYPE)) (!
  (let ((result@2@00 (instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00))) (=
    result@2@00
    (or (= t@0@00 u@1@00) (= (directSuperclass<TYPE> t@0@00) u@1@00))))
  :pattern ((instanceof_TYPE_TYPE%limited s@$ t@0@00 u@1@00))
  )))
(assert (forall ((s@$ $Snap) (x@3@00 $Perm)) (!
  (= (new_frac%limited s@$ x@3@00) (new_frac s@$ x@3@00))
  :pattern ((new_frac s@$ x@3@00))
  )))
(assert (forall ((s@$ $Snap) (x@3@00 $Perm)) (!
  (new_frac%stateless x@3@00)
  :pattern ((new_frac%limited s@$ x@3@00))
  )))
(assert (forall ((s@$ $Snap) (x@3@00 $Perm)) (!
  (let ((result@4@00 (new_frac%limited s@$ x@3@00))) (implies
    (and (< $Perm.No x@3@00) (<= x@3@00 $Perm.Write))
    (= (frac_val<Perm> result@4@00) x@3@00)))
  :pattern ((new_frac%limited s@$ x@3@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 $Perm)) (!
  (= (new_zfrac%limited s@$ x@5@00) (new_zfrac s@$ x@5@00))
  :pattern ((new_zfrac s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 $Perm)) (!
  (new_zfrac%stateless x@5@00)
  :pattern ((new_zfrac%limited s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (x@5@00 $Perm)) (!
  (let ((result@6@00 (new_zfrac%limited s@$ x@5@00))) (implies
    (and (<= $Perm.No x@5@00) (<= x@5@00 $Perm.Write))
    (= (zfrac_val<Perm> result@6@00) x@5@00)))
  :pattern ((new_zfrac%limited s@$ x@5@00))
  )))
(assert (forall ((s@$ $Snap) (diz@7@00 $Ref) (vals@8@00 Seq<Int>)) (!
  (=
    (Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00)
    (Main_find_minimum_advance_Sequence$Integer$ s@$ diz@7@00 vals@8@00))
  :pattern ((Main_find_minimum_advance_Sequence$Integer$ s@$ diz@7@00 vals@8@00))
  )))
(assert (forall ((s@$ $Snap) (diz@7@00 $Ref) (vals@8@00 Seq<Int>)) (!
  (Main_find_minimum_advance_Sequence$Integer$%stateless diz@7@00 vals@8@00)
  :pattern ((Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00))
  )))
(assert (forall ((s@$ $Snap) (diz@7@00 $Ref) (vals@8@00 Seq<Int>)) (!
  (let ((result@9@00 (Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00))) (implies
    (and (not (= diz@7@00 $Ref.null)) (= (Seq_length vals@8@00) 2))
    (and
      (and
        (or
          (< (Seq_index vals@8@00 0) (- 0 1))
          (<= result@9@00 (Seq_index vals@8@00 0)))
        (or
          (< (Seq_index vals@8@00 1) (- 0 1))
          (<= result@9@00 (Seq_index vals@8@00 1))))
      (and
        (implies
          (and
            (< (Seq_index vals@8@00 0) (- 0 1))
            (< (Seq_index vals@8@00 1) (- 0 1)))
          (= result@9@00 0))
        (implies
          (or
            (<= (- 0 1) (Seq_index vals@8@00 0))
            (<= (- 0 1) (Seq_index vals@8@00 1)))
          (or
            (and
              (<= (- 0 1) (Seq_index vals@8@00 0))
              (= result@9@00 (Seq_index vals@8@00 0)))
            (and
              (<= (- 0 1) (Seq_index vals@8@00 1))
              (= result@9@00 (Seq_index vals@8@00 1)))))))))
  :pattern ((Main_find_minimum_advance_Sequence$Integer$%limited s@$ diz@7@00 vals@8@00))
  )))
; End function- and predicate-related preamble
; ------------------------------------------------------------
; ---------- ALU_ALU_EncodedGlobalVariables_Main ----------
(declare-const globals@0@07 $Ref)
(declare-const m_param@1@07 $Ref)
(declare-const sys__result@2@07 $Ref)
(declare-const globals@3@07 $Ref)
(declare-const m_param@4@07 $Ref)
(declare-const sys__result@5@07 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@6@07 $Snap)
(assert (= $t@6@07 ($Snap.combine ($Snap.first $t@6@07) ($Snap.second $t@6@07))))
(assert (= ($Snap.first $t@6@07) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@5@07 $Ref.null)))
(assert (=
  ($Snap.second $t@6@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@6@07))
    ($Snap.second ($Snap.second $t@6@07)))))
(assert (= ($Snap.first ($Snap.second $t@6@07)) $Snap.unit))
; [eval] type_of(sys__result) == class_ALU()
; [eval] type_of(sys__result)
; [eval] class_ALU()
(assert (= (type_of<TYPE> sys__result@5@07) (as class_ALU<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@6@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@6@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@6@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@6@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))
  $Snap.unit))
; [eval] sys__result.ALU_OP1 == 0
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))
  0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
  $Snap.unit))
; [eval] sys__result.ALU_OP2 == 0
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
  0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))
  $Snap.unit))
; [eval] !sys__result.ALU_CARRY
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))
  $Snap.unit))
; [eval] !sys__result.ALU_ZERO
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))
  $Snap.unit))
; [eval] sys__result.ALU_RESULT == 0
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))
  0))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))
  $Snap.unit))
; [eval] sys__result.ALU_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@6@07))))
  m_param@4@07))
(pop) ; 2
(push) ; 2
; [exec]
; var diz__1: Ref
(declare-const diz__1@7@07 $Ref)
; [exec]
; diz__1 := new(ALU_m, ALU_init, ALU_OPCODE, ALU_OP1, ALU_OP2, ALU_CARRY, ALU_ZERO, ALU_RESULT)
(declare-const diz__1@8@07 $Ref)
(assert (not (= diz__1@8@07 $Ref.null)))
(declare-const ALU_m@9@07 $Ref)
(declare-const ALU_init@10@07 Bool)
(declare-const ALU_OPCODE@11@07 Int)
(declare-const ALU_OP1@12@07 Int)
(declare-const ALU_OP2@13@07 Int)
(declare-const ALU_CARRY@14@07 Bool)
(declare-const ALU_ZERO@15@07 Bool)
(declare-const ALU_RESULT@16@07 Int)
(assert (not (= diz__1@8@07 diz__1@7@07)))
(assert (not (= diz__1@8@07 m_param@4@07)))
(assert (not (= diz__1@8@07 sys__result@5@07)))
(assert (not (= diz__1@8@07 globals@3@07)))
; [exec]
; inhale type_of(diz__1) == class_ALU()
(declare-const $t@17@07 $Snap)
(assert (= $t@17@07 $Snap.unit))
; [eval] type_of(diz__1) == class_ALU()
; [eval] type_of(diz__1)
; [eval] class_ALU()
(assert (= (type_of<TYPE> diz__1@8@07) (as class_ALU<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz__1.ALU_m := m_param
; [exec]
; diz__1.ALU_OPCODE := 0
; [exec]
; diz__1.ALU_OP1 := 0
; [exec]
; diz__1.ALU_OP2 := 0
; [exec]
; diz__1.ALU_CARRY := false
; [exec]
; diz__1.ALU_ZERO := false
; [exec]
; diz__1.ALU_RESULT := 0
; [exec]
; sys__result := diz__1
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_ALU() && acc(sys__result.ALU_m, write) && acc(sys__result.ALU_OPCODE, write) && acc(sys__result.ALU_OP1, write) && sys__result.ALU_OP1 == 0 && acc(sys__result.ALU_OP2, write) && sys__result.ALU_OP2 == 0 && acc(sys__result.ALU_CARRY, write) && !sys__result.ALU_CARRY && acc(sys__result.ALU_ZERO, write) && !sys__result.ALU_ZERO && acc(sys__result.ALU_RESULT, write) && sys__result.ALU_RESULT == 0 && sys__result.ALU_m == m_param
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_ALU()
; [eval] type_of(sys__result)
; [eval] class_ALU()
; [eval] sys__result.ALU_OP1 == 0
; [eval] sys__result.ALU_OP2 == 0
; [eval] !sys__result.ALU_CARRY
; [eval] !sys__result.ALU_ZERO
; [eval] sys__result.ALU_RESULT == 0
; [eval] sys__result.ALU_m == m_param
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Driver_forkOperator_EncodedGlobalVariables ----------
(declare-const diz@18@07 $Ref)
(declare-const globals@19@07 $Ref)
(declare-const diz@20@07 $Ref)
(declare-const globals@21@07 $Ref)
(push) ; 1
(declare-const $t@22@07 $Snap)
(assert (= $t@22@07 ($Snap.combine ($Snap.first $t@22@07) ($Snap.second $t@22@07))))
(assert (= ($Snap.first $t@22@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@20@07 $Ref.null)))
(assert (=
  ($Snap.second $t@22@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@22@07))
    ($Snap.second ($Snap.second $t@22@07)))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             19
;  :arith-assert-lower    1
;  :arith-assert-upper    1
;  :arith-eq-adapter      1
;  :binary-propagations   16
;  :datatype-accessor-ax  4
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           267
;  :mk-clause             1
;  :num-allocs            3508183
;  :num-checks            3
;  :propagations          16
;  :quant-instantiations  1
;  :rlimit-count          112662)
(assert (=
  ($Snap.second ($Snap.second $t@22@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@22@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@22@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@22@07))) $Snap.unit))
; [eval] diz.Driver_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@22@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@22@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@22@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07)))))))
(declare-const $k@23@07 $Perm)
(assert ($Perm.isReadVar $k@23@07 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@23@07 $Perm.No) (< $Perm.No $k@23@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             31
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             1
;  :datatype-accessor-ax  6
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           276
;  :mk-clause             3
;  :num-allocs            3508183
;  :num-checks            4
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113234)
(assert (<= $Perm.No $k@23@07))
(assert (<= $k@23@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@23@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@22@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07)))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@23@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             37
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             2
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           279
;  :mk-clause             3
;  :num-allocs            3508183
;  :num-checks            5
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113507)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@22@07)))))
  diz@20@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07)))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             44
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             2
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           282
;  :mk-clause             3
;  :num-allocs            3508183
;  :num-checks            6
;  :propagations          17
;  :quant-instantiations  3
;  :rlimit-count          113758)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07)))))))
  $Snap.unit))
; [eval] !diz.Driver_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@22@07)))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@24@07 $Snap)
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Driver___contract_unsatisfiable__run_EncodedGlobalVariables ----------
(declare-const diz@25@07 $Ref)
(declare-const globals@26@07 $Ref)
(declare-const diz@27@07 $Ref)
(declare-const globals@28@07 $Ref)
(push) ; 1
(declare-const $t@29@07 $Snap)
(assert (= $t@29@07 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@27@07 $Ref.null)))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Driver_m, 1 / 2) && diz.Driver_m != null && acc(diz.Driver_m.Main_dr, wildcard) && diz.Driver_m.Main_dr == diz && acc(diz.Driver_init, 1 / 2) && !diz.Driver_init)
(declare-const $t@30@07 $Snap)
(assert (= $t@30@07 ($Snap.combine ($Snap.first $t@30@07) ($Snap.second $t@30@07))))
(assert (= ($Snap.first $t@30@07) $Snap.unit))
(assert (=
  ($Snap.second $t@30@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@30@07))
    ($Snap.second ($Snap.second $t@30@07)))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               76
;  :arith-assert-diseq      1
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :binary-propagations     16
;  :conflicts               2
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   4
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             296
;  :mk-clause               3
;  :num-allocs              3626523
;  :num-checks              9
;  :propagations            17
;  :quant-instantiations    5
;  :rlimit-count            115010)
(assert (=
  ($Snap.second ($Snap.second $t@30@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@30@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@30@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@30@07))) $Snap.unit))
; [eval] diz.Driver_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@30@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@30@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@30@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07)))))))
(declare-const $k@31@07 $Perm)
(assert ($Perm.isReadVar $k@31@07 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@31@07 $Perm.No) (< $Perm.No $k@31@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               88
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :binary-propagations     16
;  :conflicts               3
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   4
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             305
;  :mk-clause               5
;  :num-allocs              3626523
;  :num-checks              10
;  :propagations            18
;  :quant-instantiations    6
;  :rlimit-count            115583)
(assert (<= $Perm.No $k@31@07))
(assert (<= $k@31@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@31@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@30@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07)))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               94
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     16
;  :conflicts               4
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   4
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             308
;  :mk-clause               5
;  :num-allocs              3626523
;  :num-checks              11
;  :propagations            18
;  :quant-instantiations    6
;  :rlimit-count            115856)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@30@07)))))
  diz@27@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07)))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               101
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     16
;  :conflicts               4
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 4
;  :datatype-occurs-check   4
;  :datatype-splits         4
;  :decisions               4
;  :del-clause              2
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             311
;  :mk-clause               5
;  :num-allocs              3626523
;  :num-checks              12
;  :propagations            18
;  :quant-instantiations    7
;  :rlimit-count            116107)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07))))))
  $Snap.unit))
; [eval] !diz.Driver_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@30@07)))))))))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; // assert
; assert false
(set-option :timeout 10)
(check-sat)
; unknown
; [state consolidation]
; State saturation: before repetition
(check-sat)
; unknown
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Monitor___contract_unsatisfiable__Monitor_EncodedGlobalVariables_Main ----------
(declare-const diz@32@07 $Ref)
(declare-const globals@33@07 $Ref)
(declare-const m_param@34@07 $Ref)
(declare-const diz@35@07 $Ref)
(declare-const globals@36@07 $Ref)
(declare-const m_param@37@07 $Ref)
(push) ; 1
(declare-const $t@38@07 $Snap)
(assert (= $t@38@07 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@35@07 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@39@07 $Snap)
(assert (= $t@39@07 ($Snap.combine ($Snap.first $t@39@07) ($Snap.second $t@39@07))))
(assert (= ($Snap.first $t@39@07) $Snap.unit))
(assert (= ($Snap.second $t@39@07) $Snap.unit))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; // assert
; assert false
(set-option :timeout 10)
(check-sat)
; unknown
; [state consolidation]
; State saturation: before repetition
(check-sat)
; unknown
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Monitor_Monitor_EncodedGlobalVariables_Main ----------
(declare-const globals@40@07 $Ref)
(declare-const m_param@41@07 $Ref)
(declare-const sys__result@42@07 $Ref)
(declare-const globals@43@07 $Ref)
(declare-const m_param@44@07 $Ref)
(declare-const sys__result@45@07 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@46@07 $Snap)
(assert (= $t@46@07 ($Snap.combine ($Snap.first $t@46@07) ($Snap.second $t@46@07))))
(assert (= ($Snap.first $t@46@07) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@45@07 $Ref.null)))
(assert (=
  ($Snap.second $t@46@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@46@07))
    ($Snap.second ($Snap.second $t@46@07)))))
(assert (= ($Snap.first ($Snap.second $t@46@07)) $Snap.unit))
; [eval] type_of(sys__result) == class_Monitor()
; [eval] type_of(sys__result)
; [eval] class_Monitor()
(assert (= (type_of<TYPE> sys__result@45@07) (as class_Monitor<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@46@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@46@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@46@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@46@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07))))))
  $Snap.unit))
; [eval] !sys__result.Monitor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@07))))))
  $Snap.unit))
; [eval] sys__result.Monitor_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@07)))))
  m_param@44@07))
(pop) ; 2
(push) ; 2
; [exec]
; var diz__74: Ref
(declare-const diz__74@47@07 $Ref)
; [exec]
; diz__74 := new(Monitor_m, Monitor_init)
(declare-const diz__74@48@07 $Ref)
(assert (not (= diz__74@48@07 $Ref.null)))
(declare-const Monitor_m@49@07 $Ref)
(declare-const Monitor_init@50@07 Bool)
(assert (not (= diz__74@48@07 diz__74@47@07)))
(assert (not (= diz__74@48@07 globals@43@07)))
(assert (not (= diz__74@48@07 sys__result@45@07)))
(assert (not (= diz__74@48@07 m_param@44@07)))
; [exec]
; inhale type_of(diz__74) == class_Monitor()
(declare-const $t@51@07 $Snap)
(assert (= $t@51@07 $Snap.unit))
; [eval] type_of(diz__74) == class_Monitor()
; [eval] type_of(diz__74)
; [eval] class_Monitor()
(assert (= (type_of<TYPE> diz__74@48@07) (as class_Monitor<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz__74.Monitor_m := m_param
; [exec]
; diz__74.Monitor_init := false
; [exec]
; inhale acc(Monitor_idleToken_EncodedGlobalVariables(diz__74, globals), write)
(declare-const $t@52@07 $Snap)
; State saturation: after inhale
(check-sat)
; unknown
; [exec]
; sys__result := diz__74
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Monitor() && acc(Monitor_idleToken_EncodedGlobalVariables(sys__result, globals), write) && acc(sys__result.Monitor_m, write) && acc(sys__result.Monitor_init, write) && !sys__result.Monitor_init && sys__result.Monitor_m == m_param
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Monitor()
; [eval] type_of(sys__result)
; [eval] class_Monitor()
; [eval] !sys__result.Monitor_init
; [eval] sys__result.Monitor_m == m_param
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Monitor_forkOperator_EncodedGlobalVariables ----------
(declare-const diz@53@07 $Ref)
(declare-const globals@54@07 $Ref)
(declare-const diz@55@07 $Ref)
(declare-const globals@56@07 $Ref)
(push) ; 1
(declare-const $t@57@07 $Snap)
(assert (= $t@57@07 ($Snap.combine ($Snap.first $t@57@07) ($Snap.second $t@57@07))))
(assert (= ($Snap.first $t@57@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@55@07 $Ref.null)))
(assert (=
  ($Snap.second $t@57@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@57@07))
    ($Snap.second ($Snap.second $t@57@07)))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               159
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     16
;  :conflicts               4
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   25
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             334
;  :mk-clause               5
;  :num-allocs              3626523
;  :num-checks              25
;  :propagations            18
;  :quant-instantiations    9
;  :rlimit-count            120643)
(assert (=
  ($Snap.second ($Snap.second $t@57@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@57@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@57@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@57@07))) $Snap.unit))
; [eval] diz.Monitor_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@57@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@57@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07)))))))
(declare-const $k@58@07 $Perm)
(assert ($Perm.isReadVar $k@58@07 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@58@07 $Perm.No) (< $Perm.No $k@58@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               171
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      6
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :conflicts               5
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   25
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             343
;  :mk-clause               7
;  :num-allocs              3626523
;  :num-checks              26
;  :propagations            19
;  :quant-instantiations    10
;  :rlimit-count            121216)
(assert (<= $Perm.No $k@58@07))
(assert (<= $k@58@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@58@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@57@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07)))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@58@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               177
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :conflicts               6
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   25
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             346
;  :mk-clause               7
;  :num-allocs              3626523
;  :num-checks              27
;  :propagations            19
;  :quant-instantiations    10
;  :rlimit-count            121489)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@07)))))
  diz@55@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07)))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               184
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :conflicts               6
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   25
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             349
;  :mk-clause               7
;  :num-allocs              3626523
;  :num-checks              28
;  :propagations            19
;  :quant-instantiations    11
;  :rlimit-count            121740)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07)))))))
  $Snap.unit))
; [eval] !diz.Monitor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@07)))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@59@07 $Snap)
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Monitor_joinOperator_EncodedGlobalVariables ----------
(declare-const diz@60@07 $Ref)
(declare-const globals@61@07 $Ref)
(declare-const diz@62@07 $Ref)
(declare-const globals@63@07 $Ref)
(push) ; 1
(declare-const $t@64@07 $Snap)
(assert (= $t@64@07 ($Snap.combine ($Snap.first $t@64@07) ($Snap.second $t@64@07))))
(assert (= ($Snap.first $t@64@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@62@07 $Ref.null)))
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(declare-const $t@65@07 $Snap)
(assert (= $t@65@07 ($Snap.combine ($Snap.first $t@65@07) ($Snap.second $t@65@07))))
(assert (=
  ($Snap.second $t@65@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@65@07))
    ($Snap.second ($Snap.second $t@65@07)))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               222
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     16
;  :conflicts               6
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   29
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              6
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             364
;  :mk-clause               7
;  :num-allocs              3626523
;  :num-checks              31
;  :propagations            19
;  :quant-instantiations    13
;  :rlimit-count            123061)
(assert (=
  ($Snap.second ($Snap.second $t@65@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@65@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@65@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@65@07))) $Snap.unit))
; [eval] diz.Monitor_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@65@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@65@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@65@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07)))))))
(declare-const $k@66@07 $Perm)
(assert ($Perm.isReadVar $k@66@07 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@66@07 $Perm.No) (< $Perm.No $k@66@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               234
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      8
;  :arith-eq-adapter        5
;  :binary-propagations     16
;  :conflicts               7
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   29
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              6
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             373
;  :mk-clause               9
;  :num-allocs              3626523
;  :num-checks              32
;  :propagations            20
;  :quant-instantiations    14
;  :rlimit-count            123634)
(assert (<= $Perm.No $k@66@07))
(assert (<= $k@66@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@66@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@65@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07)))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@66@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               240
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     16
;  :conflicts               8
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   29
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              6
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             376
;  :mk-clause               9
;  :num-allocs              3626523
;  :num-checks              33
;  :propagations            20
;  :quant-instantiations    14
;  :rlimit-count            123907)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@65@07)))))
  diz@62@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07)))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               247
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     16
;  :conflicts               8
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   29
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              6
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             379
;  :mk-clause               9
;  :num-allocs              3626523
;  :num-checks              34
;  :propagations            20
;  :quant-instantiations    15
;  :rlimit-count            124158)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07))))))
  $Snap.unit))
; [eval] !diz.Monitor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@65@07)))))))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Monitor___contract_unsatisfiable__run_EncodedGlobalVariables ----------
(declare-const diz@67@07 $Ref)
(declare-const globals@68@07 $Ref)
(declare-const diz@69@07 $Ref)
(declare-const globals@70@07 $Ref)
(push) ; 1
(declare-const $t@71@07 $Snap)
(assert (= $t@71@07 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@69@07 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Monitor_m, 1 / 2) && diz.Monitor_m != null && acc(diz.Monitor_m.Main_mon, wildcard) && diz.Monitor_m.Main_mon == diz && acc(diz.Monitor_init, 1 / 2) && !diz.Monitor_init)
(declare-const $t@72@07 $Snap)
(assert (= $t@72@07 ($Snap.combine ($Snap.first $t@72@07) ($Snap.second $t@72@07))))
(assert (= ($Snap.first $t@72@07) $Snap.unit))
(assert (=
  ($Snap.second $t@72@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@72@07))
    ($Snap.second ($Snap.second $t@72@07)))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               259
;  :arith-assert-diseq      4
;  :arith-assert-lower      9
;  :arith-assert-upper      9
;  :arith-eq-adapter        5
;  :binary-propagations     16
;  :conflicts               8
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   30
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              8
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             384
;  :mk-clause               9
;  :num-allocs              3626523
;  :num-checks              36
;  :propagations            20
;  :quant-instantiations    15
;  :rlimit-count            124779)
(assert (=
  ($Snap.second ($Snap.second $t@72@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@72@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@72@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@72@07))) $Snap.unit))
; [eval] diz.Monitor_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@72@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@72@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07)))))))
(declare-const $k@73@07 $Perm)
(assert ($Perm.isReadVar $k@73@07 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@73@07 $Perm.No) (< $Perm.No $k@73@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               271
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      10
;  :arith-eq-adapter        6
;  :binary-propagations     16
;  :conflicts               9
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   30
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              8
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             393
;  :mk-clause               11
;  :num-allocs              3626523
;  :num-checks              37
;  :propagations            21
;  :quant-instantiations    16
;  :rlimit-count            125351)
(assert (<= $Perm.No $k@73@07))
(assert (<= $k@73@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@73@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@72@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07)))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@73@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               277
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     16
;  :conflicts               10
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   30
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              8
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             396
;  :mk-clause               11
;  :num-allocs              3626523
;  :num-checks              38
;  :propagations            21
;  :quant-instantiations    16
;  :rlimit-count            125624)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@07)))))
  diz@69@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07)))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               284
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     16
;  :conflicts               10
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 21
;  :datatype-occurs-check   30
;  :datatype-splits         12
;  :decisions               21
;  :del-clause              8
;  :final-checks            23
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             399
;  :mk-clause               11
;  :num-allocs              3626523
;  :num-checks              39
;  :propagations            21
;  :quant-instantiations    17
;  :rlimit-count            125875)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07))))))
  $Snap.unit))
; [eval] !diz.Monitor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@07)))))))))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; // assert
; assert false
(set-option :timeout 10)
(check-sat)
; unknown
; [state consolidation]
; State saturation: before repetition
(check-sat)
; unknown
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Monitor_run_EncodedGlobalVariables ----------
(declare-const diz@74@07 $Ref)
(declare-const globals@75@07 $Ref)
(declare-const diz@76@07 $Ref)
(declare-const globals@77@07 $Ref)
(push) ; 1
(declare-const $t@78@07 $Snap)
(assert (= $t@78@07 ($Snap.combine ($Snap.first $t@78@07) ($Snap.second $t@78@07))))
(assert (= ($Snap.first $t@78@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@76@07 $Ref.null)))
(assert (=
  ($Snap.second $t@78@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@78@07))
    ($Snap.second ($Snap.second $t@78@07)))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               332
;  :arith-assert-diseq      5
;  :arith-assert-lower      11
;  :arith-assert-upper      11
;  :arith-eq-adapter        6
;  :binary-propagations     16
;  :conflicts               10
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   40
;  :datatype-splits         15
;  :decisions               33
;  :del-clause              10
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             410
;  :mk-clause               11
;  :num-allocs              3626523
;  :num-checks              44
;  :propagations            21
;  :quant-instantiations    19
;  :rlimit-count            127641)
(assert (=
  ($Snap.second ($Snap.second $t@78@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@78@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@78@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@78@07))) $Snap.unit))
; [eval] diz.Monitor_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@78@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07)))))))
(declare-const $k@79@07 $Perm)
(assert ($Perm.isReadVar $k@79@07 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@79@07 $Perm.No) (< $Perm.No $k@79@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               344
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      12
;  :arith-eq-adapter        7
;  :binary-propagations     16
;  :conflicts               11
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   40
;  :datatype-splits         15
;  :decisions               33
;  :del-clause              10
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             419
;  :mk-clause               13
;  :num-allocs              3626523
;  :num-checks              45
;  :propagations            22
;  :quant-instantiations    20
;  :rlimit-count            128213)
(assert (<= $Perm.No $k@79@07))
(assert (<= $k@79@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@79@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07)))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@79@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               350
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     16
;  :conflicts               12
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   40
;  :datatype-splits         15
;  :decisions               33
;  :del-clause              10
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             422
;  :mk-clause               13
;  :num-allocs              3626523
;  :num-checks              46
;  :propagations            22
;  :quant-instantiations    20
;  :rlimit-count            128486)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@07)))))
  diz@76@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07)))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               357
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     16
;  :conflicts               12
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 33
;  :datatype-occurs-check   40
;  :datatype-splits         15
;  :decisions               33
;  :del-clause              10
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             425
;  :mk-clause               13
;  :num-allocs              3626523
;  :num-checks              47
;  :propagations            22
;  :quant-instantiations    21
;  :rlimit-count            128737)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07))))))
  $Snap.unit))
; [eval] !diz.Monitor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07)))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@80@07 $Snap)
(assert (= $t@80@07 ($Snap.combine ($Snap.first $t@80@07) ($Snap.second $t@80@07))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               375
;  :arith-assert-diseq      6
;  :arith-assert-lower      13
;  :arith-assert-upper      13
;  :arith-eq-adapter        7
;  :binary-propagations     16
;  :conflicts               12
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   42
;  :datatype-splits         18
;  :decisions               36
;  :del-clause              12
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             433
;  :mk-clause               13
;  :num-allocs              3626523
;  :num-checks              49
;  :propagations            22
;  :quant-instantiations    23
;  :rlimit-count            129388)
(assert (=
  ($Snap.second $t@80@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@80@07))
    ($Snap.second ($Snap.second $t@80@07)))))
(assert (= ($Snap.first ($Snap.second $t@80@07)) $Snap.unit))
; [eval] diz.Monitor_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@80@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@80@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@80@07))))))
(declare-const $k@81@07 $Perm)
(assert ($Perm.isReadVar $k@81@07 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@81@07 $Perm.No) (< $Perm.No $k@81@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               387
;  :arith-assert-diseq      7
;  :arith-assert-lower      15
;  :arith-assert-upper      14
;  :arith-eq-adapter        8
;  :binary-propagations     16
;  :conflicts               13
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   42
;  :datatype-splits         18
;  :decisions               36
;  :del-clause              12
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             442
;  :mk-clause               15
;  :num-allocs              3626523
;  :num-checks              50
;  :propagations            23
;  :quant-instantiations    24
;  :rlimit-count            129949)
(assert (<= $Perm.No $k@81@07))
(assert (<= $k@81@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@81@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@80@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@07)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@07))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@81@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               393
;  :arith-assert-diseq      7
;  :arith-assert-lower      15
;  :arith-assert-upper      15
;  :arith-eq-adapter        8
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   42
;  :datatype-splits         18
;  :decisions               36
;  :del-clause              12
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             445
;  :mk-clause               15
;  :num-allocs              3626523
;  :num-checks              51
;  :propagations            23
;  :quant-instantiations    24
;  :rlimit-count            130212)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@80@07))))
  diz@76@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@07))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               401
;  :arith-assert-diseq      7
;  :arith-assert-lower      15
;  :arith-assert-upper      15
;  :arith-eq-adapter        8
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 36
;  :datatype-occurs-check   42
;  :datatype-splits         18
;  :decisions               36
;  :del-clause              12
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             448
;  :mk-clause               15
;  :num-allocs              3626523
;  :num-checks              52
;  :propagations            23
;  :quant-instantiations    25
;  :rlimit-count            130452)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@07)))))
  $Snap.unit))
; [eval] !diz.Monitor_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@07))))))))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_45__75: Ref
(declare-const __flatten_45__75@82@07 $Ref)
; [exec]
; var __flatten_46__76: Seq[Int]
(declare-const __flatten_46__76@83@07 Seq<Int>)
; [exec]
; var __flatten_47__77: Ref
(declare-const __flatten_47__77@84@07 $Ref)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Monitor_m, globals), write)
(declare-const $t@85@07 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Monitor_m, globals), write)
(assert (= $t@85@07 ($Snap.combine ($Snap.first $t@85@07) ($Snap.second $t@85@07))))
(assert (= ($Snap.first $t@85@07) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@85@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@85@07))
    ($Snap.second ($Snap.second $t@85@07)))))
(assert (= ($Snap.first ($Snap.second $t@85@07)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@85@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@85@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@85@07))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@85@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@86@07 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@86@07 | live]
; [else-branch: 0 | !(0 <= i@86@07) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@86@07]
(assert (<= 0 i@86@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@86@07)]
(assert (not (<= 0 i@86@07)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@86@07 < |First:(Second:(Second:(Second:($t@85@07))))| && 0 <= i@86@07 | live]
; [else-branch: 1 | !(i@86@07 < |First:(Second:(Second:(Second:($t@85@07))))| && 0 <= i@86@07) | live]
(push) ; 5
; [then-branch: 1 | i@86@07 < |First:(Second:(Second:(Second:($t@85@07))))| && 0 <= i@86@07]
(assert (and
  (<
    i@86@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
  (<= 0 i@86@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@86@07 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               460
;  :arith-assert-diseq      9
;  :arith-assert-lower      22
;  :arith-assert-upper      18
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              14
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             480
;  :mk-clause               21
;  :num-allocs              3626523
;  :num-checks              54
;  :propagations            25
;  :quant-instantiations    31
;  :rlimit-count            132139)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:($t@85@07))))[i@86@07] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:($t@85@07))))[i@86@07] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:($t@85@07))))[i@86@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
    i@86@07)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:($t@85@07))))[i@86@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
      i@86@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@86@07 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               460
;  :arith-assert-diseq      9
;  :arith-assert-lower      22
;  :arith-assert-upper      18
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              14
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.87
;  :mk-bool-var             481
;  :mk-clause               21
;  :num-allocs              3626523
;  :num-checks              55
;  :propagations            25
;  :quant-instantiations    31
;  :rlimit-count            132314)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@85@07))))[i@86@07] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@85@07))))[i@86@07]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@85@07))))[i@86@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
    i@86@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@86@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               460
;  :arith-assert-diseq      10
;  :arith-assert-lower      25
;  :arith-assert-upper      18
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               14
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              14
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             484
;  :mk-clause               22
;  :num-allocs              3761498
;  :num-checks              56
;  :propagations            25
;  :quant-instantiations    31
;  :rlimit-count            132437)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@85@07))))[i@86@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
      i@86@07))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(pop) ; 5
(push) ; 5
; [else-branch: 1 | !(i@86@07 < |First:(Second:(Second:(Second:($t@85@07))))| && 0 <= i@86@07)]
(assert (not
  (and
    (<
      i@86@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
    (<= 0 i@86@07))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@86@07 Int)) (!
  (implies
    (and
      (<
        i@86@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
      (<= 0 i@86@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
          i@86@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
            i@86@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
            i@86@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
    i@86@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))
(declare-const $k@87@07 $Perm)
(assert ($Perm.isReadVar $k@87@07 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@87@07 $Perm.No) (< $Perm.No $k@87@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               465
;  :arith-assert-diseq      11
;  :arith-assert-lower      27
;  :arith-assert-upper      19
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               15
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             490
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              57
;  :propagations            26
;  :quant-instantiations    31
;  :rlimit-count            133205)
(assert (<= $Perm.No $k@87@07))
(assert (<= $k@87@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@87@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))
  $Snap.unit))
; [eval] diz.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               471
;  :arith-assert-diseq      11
;  :arith-assert-lower      27
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               16
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             493
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              58
;  :propagations            26
;  :quant-instantiations    31
;  :rlimit-count            133528)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      11
;  :arith-assert-lower      27
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               17
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             496
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              59
;  :propagations            26
;  :quant-instantiations    32
;  :rlimit-count            133884)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               482
;  :arith-assert-diseq      11
;  :arith-assert-lower      27
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               18
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             497
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              60
;  :propagations            26
;  :quant-instantiations    32
;  :rlimit-count            134141)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               487
;  :arith-assert-diseq      11
;  :arith-assert-lower      27
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               19
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             498
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              61
;  :propagations            26
;  :quant-instantiations    32
;  :rlimit-count            134408)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               492
;  :arith-assert-diseq      11
;  :arith-assert-lower      27
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               20
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             499
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              62
;  :propagations            26
;  :quant-instantiations    32
;  :rlimit-count            134685)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               497
;  :arith-assert-diseq      11
;  :arith-assert-lower      27
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               21
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             500
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              63
;  :propagations            26
;  :quant-instantiations    32
;  :rlimit-count            134972)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               502
;  :arith-assert-diseq      11
;  :arith-assert-lower      27
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               22
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             501
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              64
;  :propagations            26
;  :quant-instantiations    32
;  :rlimit-count            135269)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               508
;  :arith-assert-diseq      11
;  :arith-assert-lower      27
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               23
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             503
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              65
;  :propagations            26
;  :quant-instantiations    32
;  :rlimit-count            135608)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               515
;  :arith-assert-diseq      11
;  :arith-assert-lower      28
;  :arith-assert-upper      20
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               24
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             507
;  :mk-clause               24
;  :num-allocs              3761498
;  :num-checks              66
;  :propagations            26
;  :quant-instantiations    33
;  :rlimit-count            136055)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))
(declare-const $k@88@07 $Perm)
(assert ($Perm.isReadVar $k@88@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@88@07 $Perm.No) (< $Perm.No $k@88@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               520
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      22
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               25
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             513
;  :mk-clause               26
;  :num-allocs              3761498
;  :num-checks              67
;  :propagations            27
;  :quant-instantiations    33
;  :rlimit-count            136573)
(assert (<= $Perm.No $k@88@07))
(assert (<= $k@88@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@88@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               526
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      23
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               26
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             516
;  :mk-clause               26
;  :num-allocs              3761498
;  :num-checks              68
;  :propagations            27
;  :quant-instantiations    33
;  :rlimit-count            136996)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               532
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      23
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               27
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             519
;  :mk-clause               26
;  :num-allocs              3761498
;  :num-checks              69
;  :propagations            27
;  :quant-instantiations    34
;  :rlimit-count            137452)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               532
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      23
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               27
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             519
;  :mk-clause               26
;  :num-allocs              3761498
;  :num-checks              70
;  :propagations            27
;  :quant-instantiations    34
;  :rlimit-count            137465)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               537
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      23
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               28
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             520
;  :mk-clause               26
;  :num-allocs              3761498
;  :num-checks              71
;  :propagations            27
;  :quant-instantiations    34
;  :rlimit-count            137822)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               542
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      23
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               29
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             521
;  :mk-clause               26
;  :num-allocs              3761498
;  :num-checks              72
;  :propagations            27
;  :quant-instantiations    34
;  :rlimit-count            138189)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               547
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      23
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               30
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             522
;  :mk-clause               26
;  :num-allocs              3761498
;  :num-checks              73
;  :propagations            27
;  :quant-instantiations    34
;  :rlimit-count            138566)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               552
;  :arith-assert-diseq      12
;  :arith-assert-lower      30
;  :arith-assert-upper      23
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               31
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             523
;  :mk-clause               26
;  :num-allocs              3761498
;  :num-checks              74
;  :propagations            27
;  :quant-instantiations    34
;  :rlimit-count            138953)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))))
(declare-const $k@89@07 $Perm)
(assert ($Perm.isReadVar $k@89@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@89@07 $Perm.No) (< $Perm.No $k@89@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               557
;  :arith-assert-diseq      13
;  :arith-assert-lower      32
;  :arith-assert-upper      24
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               32
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  3.97
;  :mk-bool-var             528
;  :mk-clause               28
;  :num-allocs              3761498
;  :num-checks              75
;  :propagations            28
;  :quant-instantiations    34
;  :rlimit-count            139493)
(declare-const $t@90@07 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@79@07)
    (=
      $t@90@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@78@07)))))))
  (implies
    (< $Perm.No $k@89@07)
    (=
      $t@90@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@79@07 $k@89@07)))
(assert (<= (+ $k@79@07 $k@89@07) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@79@07 $k@89@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@79@07 $k@89@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               567
;  :arith-assert-diseq      13
;  :arith-assert-lower      33
;  :arith-assert-upper      26
;  :arith-conflicts         1
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               33
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             536
;  :mk-clause               28
;  :num-allocs              3900966
;  :num-checks              76
;  :propagations            28
;  :quant-instantiations    35
;  :rlimit-count            140256)
(assert (not (= $t@90@07 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@79@07 $k@89@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-assert-diseq      13
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               34
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             539
;  :mk-clause               28
;  :num-allocs              3900966
;  :num-checks              77
;  :propagations            28
;  :quant-instantiations    35
;  :rlimit-count            140732)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-assert-diseq      13
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               34
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             539
;  :mk-clause               28
;  :num-allocs              3900966
;  :num-checks              78
;  :propagations            28
;  :quant-instantiations    35
;  :rlimit-count            140745)
(set-option :timeout 10)
(push) ; 3
(assert (not (= diz@76@07 $t@90@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               573
;  :arith-assert-diseq      13
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               35
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             540
;  :mk-clause               28
;  :num-allocs              3900966
;  :num-checks              79
;  :propagations            28
;  :quant-instantiations    35
;  :rlimit-count            140805)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@78@07)))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               581
;  :arith-assert-diseq      13
;  :arith-assert-lower      33
;  :arith-assert-upper      27
;  :arith-conflicts         2
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               36
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             543
;  :mk-clause               28
;  :num-allocs              3900966
;  :num-checks              80
;  :propagations            28
;  :quant-instantiations    36
;  :rlimit-count            141321)
(declare-const $k@91@07 $Perm)
(assert ($Perm.isReadVar $k@91@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@91@07 $Perm.No) (< $Perm.No $k@91@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               581
;  :arith-assert-diseq      14
;  :arith-assert-lower      35
;  :arith-assert-upper      28
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               37
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             547
;  :mk-clause               30
;  :num-allocs              3900966
;  :num-checks              81
;  :propagations            29
;  :quant-instantiations    36
;  :rlimit-count            141519)
(assert (<= $Perm.No $k@91@07))
(assert (<= $k@91@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@91@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               582
;  :arith-assert-diseq      14
;  :arith-assert-lower      35
;  :arith-assert-upper      29
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               38
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             549
;  :mk-clause               30
;  :num-allocs              3900966
;  :num-checks              82
;  :propagations            29
;  :quant-instantiations    36
;  :rlimit-count            141955)
(push) ; 3
(assert (not (< $Perm.No $k@91@07)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               582
;  :arith-assert-diseq      14
;  :arith-assert-lower      35
;  :arith-assert-upper      29
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               39
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 39
;  :datatype-occurs-check   43
;  :datatype-splits         18
;  :decisions               39
;  :del-clause              15
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             549
;  :mk-clause               30
;  :num-allocs              3900966
;  :num-checks              83
;  :propagations            29
;  :quant-instantiations    36
;  :rlimit-count            142003)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07)))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@85@07 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07))) globals@77@07))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Monitor_m, globals), write)
(declare-const $t@92@07 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz.Monitor_init := true
(declare-const __flatten_45__75@93@07 $Ref)
(declare-const __flatten_47__77@94@07 $Ref)
(declare-const __flatten_46__76@95@07 Seq<Int>)
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@96@07 $Snap)
(assert (= $t@96@07 ($Snap.combine ($Snap.first $t@96@07) ($Snap.second $t@96@07))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               706
;  :arith-assert-diseq      14
;  :arith-assert-lower      35
;  :arith-assert-upper      29
;  :arith-conflicts         2
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               40
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              29
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             589
;  :mk-clause               31
;  :num-allocs              3900966
;  :num-checks              86
;  :propagations            30
;  :quant-instantiations    37
;  :rlimit-count            143854)
(assert (=
  ($Snap.second $t@96@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@96@07))
    ($Snap.second ($Snap.second $t@96@07)))))
(assert (= ($Snap.first ($Snap.second $t@96@07)) $Snap.unit))
; [eval] diz.Monitor_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@96@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@96@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@96@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
  $Snap.unit))
; [eval] |diz.Monitor_m.Main_process_state| == 1
; [eval] |diz.Monitor_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
  $Snap.unit))
; [eval] |diz.Monitor_m.Main_event_state| == 2
; [eval] |diz.Monitor_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
  $Snap.unit))
; [eval] (forall i__78: Int :: { diz.Monitor_m.Main_process_state[i__78] } 0 <= i__78 && i__78 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__78] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|)
(declare-const i__78@97@07 Int)
(push) ; 4
; [eval] 0 <= i__78 && i__78 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__78] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= i__78 && i__78 < |diz.Monitor_m.Main_process_state|
; [eval] 0 <= i__78
(push) ; 5
; [then-branch: 4 | 0 <= i__78@97@07 | live]
; [else-branch: 4 | !(0 <= i__78@97@07) | live]
(push) ; 6
; [then-branch: 4 | 0 <= i__78@97@07]
(assert (<= 0 i__78@97@07))
; [eval] i__78 < |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 4 | !(0 <= i__78@97@07)]
(assert (not (<= 0 i__78@97@07)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 5 | i__78@97@07 < |First:(Second:(Second:(Second:($t@96@07))))| && 0 <= i__78@97@07 | live]
; [else-branch: 5 | !(i__78@97@07 < |First:(Second:(Second:(Second:($t@96@07))))| && 0 <= i__78@97@07) | live]
(push) ; 6
; [then-branch: 5 | i__78@97@07 < |First:(Second:(Second:(Second:($t@96@07))))| && 0 <= i__78@97@07]
(assert (and
  (<
    i__78@97@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
  (<= 0 i__78@97@07)))
; [eval] diz.Monitor_m.Main_process_state[i__78] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__78] == -1
; [eval] diz.Monitor_m.Main_process_state[i__78]
(push) ; 7
(assert (not (>= i__78@97@07 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               751
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      32
;  :arith-conflicts         2
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               40
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              29
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             614
;  :mk-clause               31
;  :num-allocs              3900966
;  :num-checks              87
;  :propagations            30
;  :quant-instantiations    42
;  :rlimit-count            145137)
; [eval] -1
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@96@07))))[i__78@97@07] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@96@07))))[i__78@97@07] != -1 | live]
(push) ; 8
; [then-branch: 6 | First:(Second:(Second:(Second:($t@96@07))))[i__78@97@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
    i__78@97@07)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 6 | First:(Second:(Second:(Second:($t@96@07))))[i__78@97@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
      i__78@97@07)
    (- 0 1))))
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__78]
; [eval] diz.Monitor_m.Main_process_state[i__78]
(push) ; 9
(assert (not (>= i__78@97@07 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               751
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      32
;  :arith-conflicts         2
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               40
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              29
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             615
;  :mk-clause               31
;  :num-allocs              3900966
;  :num-checks              88
;  :propagations            30
;  :quant-instantiations    42
;  :rlimit-count            145312)
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@96@07))))[i__78@97@07] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@96@07))))[i__78@97@07]) | live]
(push) ; 10
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@96@07))))[i__78@97@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
    i__78@97@07)))
; [eval] diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__78]
(push) ; 11
(assert (not (>= i__78@97@07 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               751
;  :arith-assert-diseq      15
;  :arith-assert-lower      43
;  :arith-assert-upper      32
;  :arith-conflicts         2
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               40
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              29
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             618
;  :mk-clause               32
;  :num-allocs              3900966
;  :num-checks              89
;  :propagations            30
;  :quant-instantiations    42
;  :rlimit-count            145436)
; [eval] |diz.Monitor_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@96@07))))[i__78@97@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
      i__78@97@07))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 5 | !(i__78@97@07 < |First:(Second:(Second:(Second:($t@96@07))))| && 0 <= i__78@97@07)]
(assert (not
  (and
    (<
      i__78@97@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
    (<= 0 i__78@97@07))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__78@97@07 Int)) (!
  (implies
    (and
      (<
        i__78@97@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
      (<= 0 i__78@97@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
          i__78@97@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
            i__78@97@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
            i__78@97@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
    i__78@97@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))
(declare-const $k@98@07 $Perm)
(assert ($Perm.isReadVar $k@98@07 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@98@07 $Perm.No) (< $Perm.No $k@98@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               756
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      33
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               41
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             624
;  :mk-clause               34
;  :num-allocs              3900966
;  :num-checks              90
;  :propagations            31
;  :quant-instantiations    42
;  :rlimit-count            146205)
(assert (<= $Perm.No $k@98@07))
(assert (<= $k@98@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@98@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_alu != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               42
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             627
;  :mk-clause               34
;  :num-allocs              3900966
;  :num-checks              91
;  :propagations            31
;  :quant-instantiations    42
;  :rlimit-count            146528)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               768
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               43
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             630
;  :mk-clause               34
;  :num-allocs              4044844
;  :num-checks              92
;  :propagations            31
;  :quant-instantiations    43
;  :rlimit-count            146884)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               773
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               44
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             631
;  :mk-clause               34
;  :num-allocs              4044844
;  :num-checks              93
;  :propagations            31
;  :quant-instantiations    43
;  :rlimit-count            147141)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               778
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               45
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             632
;  :mk-clause               34
;  :num-allocs              4044844
;  :num-checks              94
;  :propagations            31
;  :quant-instantiations    43
;  :rlimit-count            147408)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               783
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               46
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             633
;  :mk-clause               34
;  :num-allocs              4044844
;  :num-checks              95
;  :propagations            31
;  :quant-instantiations    43
;  :rlimit-count            147685)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               788
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               47
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             634
;  :mk-clause               34
;  :num-allocs              4044844
;  :num-checks              96
;  :propagations            31
;  :quant-instantiations    43
;  :rlimit-count            147972)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               793
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               48
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             635
;  :mk-clause               34
;  :num-allocs              4044844
;  :num-checks              97
;  :propagations            31
;  :quant-instantiations    43
;  :rlimit-count            148269)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.Monitor_m.Main_alu.ALU_RESULT
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               799
;  :arith-assert-diseq      16
;  :arith-assert-lower      45
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               49
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             637
;  :mk-clause               34
;  :num-allocs              4044844
;  :num-checks              98
;  :propagations            31
;  :quant-instantiations    43
;  :rlimit-count            148608)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_alu.ALU_RESULT <= 16
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               806
;  :arith-assert-diseq      16
;  :arith-assert-lower      46
;  :arith-assert-upper      34
;  :arith-conflicts         2
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               50
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             641
;  :mk-clause               34
;  :num-allocs              4044844
;  :num-checks              99
;  :propagations            31
;  :quant-instantiations    44
;  :rlimit-count            149055)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))
(declare-const $k@99@07 $Perm)
(assert ($Perm.isReadVar $k@99@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@99@07 $Perm.No) (< $Perm.No $k@99@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               811
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      36
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               51
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             647
;  :mk-clause               36
;  :num-allocs              4044844
;  :num-checks              100
;  :propagations            32
;  :quant-instantiations    44
;  :rlimit-count            149572)
(assert (<= $Perm.No $k@99@07))
(assert (<= $k@99@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@99@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_dr != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               817
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               52
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             650
;  :mk-clause               36
;  :num-allocs              4044844
;  :num-checks              101
;  :propagations            32
;  :quant-instantiations    44
;  :rlimit-count            149995)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               823
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               53
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             653
;  :mk-clause               36
;  :num-allocs              4044844
;  :num-checks              102
;  :propagations            32
;  :quant-instantiations    45
;  :rlimit-count            150451)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               823
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               53
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             653
;  :mk-clause               36
;  :num-allocs              4044844
;  :num-checks              103
;  :propagations            32
;  :quant-instantiations    45
;  :rlimit-count            150464)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               828
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               54
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             654
;  :mk-clause               36
;  :num-allocs              4044844
;  :num-checks              104
;  :propagations            32
;  :quant-instantiations    45
;  :rlimit-count            150821)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               833
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               55
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             655
;  :mk-clause               36
;  :num-allocs              4044844
;  :num-checks              105
;  :propagations            32
;  :quant-instantiations    45
;  :rlimit-count            151188)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               838
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               56
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             656
;  :mk-clause               36
;  :num-allocs              4044844
;  :num-checks              106
;  :propagations            32
;  :quant-instantiations    45
;  :rlimit-count            151565)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      37
;  :arith-conflicts         2
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               57
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             657
;  :mk-clause               36
;  :num-allocs              4044844
;  :num-checks              107
;  :propagations            32
;  :quant-instantiations    45
;  :rlimit-count            151952)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))
(declare-const $k@100@07 $Perm)
(assert ($Perm.isReadVar $k@100@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@100@07 $Perm.No) (< $Perm.No $k@100@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               848
;  :arith-assert-diseq      18
;  :arith-assert-lower      50
;  :arith-assert-upper      38
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               58
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             662
;  :mk-clause               38
;  :num-allocs              4191961
;  :num-checks              108
;  :propagations            33
;  :quant-instantiations    45
;  :rlimit-count            152493)
(assert (<= $Perm.No $k@100@07))
(assert (<= $k@100@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@100@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@100@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               854
;  :arith-assert-diseq      18
;  :arith-assert-lower      50
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               59
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             665
;  :mk-clause               38
;  :num-allocs              4191961
;  :num-checks              109
;  :propagations            33
;  :quant-instantiations    45
;  :rlimit-count            152986)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@100@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      50
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               60
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             668
;  :mk-clause               38
;  :num-allocs              4191961
;  :num-checks              110
;  :propagations            33
;  :quant-instantiations    46
;  :rlimit-count            153520)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      50
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               60
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             668
;  :mk-clause               38
;  :num-allocs              4191961
;  :num-checks              111
;  :propagations            33
;  :quant-instantiations    46
;  :rlimit-count            153533)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               865
;  :arith-assert-diseq      18
;  :arith-assert-lower      50
;  :arith-assert-upper      39
;  :arith-conflicts         2
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               61
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             669
;  :mk-clause               38
;  :num-allocs              4191961
;  :num-checks              112
;  :propagations            33
;  :quant-instantiations    46
;  :rlimit-count            153960)
(declare-const $k@101@07 $Perm)
(assert ($Perm.isReadVar $k@101@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@101@07 $Perm.No) (< $Perm.No $k@101@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               865
;  :arith-assert-diseq      19
;  :arith-assert-lower      52
;  :arith-assert-upper      40
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               62
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             673
;  :mk-clause               40
;  :num-allocs              4191961
;  :num-checks              113
;  :propagations            34
;  :quant-instantiations    46
;  :rlimit-count            154159)
(assert (<= $Perm.No $k@101@07))
(assert (<= $k@101@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@101@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_alu.ALU_m == diz.Monitor_m
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               871
;  :arith-assert-diseq      19
;  :arith-assert-lower      52
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               63
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             676
;  :mk-clause               40
;  :num-allocs              4191961
;  :num-checks              114
;  :propagations            34
;  :quant-instantiations    46
;  :rlimit-count            154682)
(push) ; 4
(assert (not (< $Perm.No $k@101@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               871
;  :arith-assert-diseq      19
;  :arith-assert-lower      52
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               64
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             676
;  :mk-clause               40
;  :num-allocs              4191961
;  :num-checks              115
;  :propagations            34
;  :quant-instantiations    46
;  :rlimit-count            154730)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon == diz
(push) ; 4
(assert (not (< $Perm.No $k@100@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               880
;  :arith-assert-diseq      19
;  :arith-assert-lower      52
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               65
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             680
;  :mk-clause               40
;  :num-allocs              4191961
;  :num-checks              116
;  :propagations            34
;  :quant-instantiations    47
;  :rlimit-count            155328)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
  diz@76@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               888
;  :arith-assert-diseq      19
;  :arith-assert-lower      52
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               65
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              30
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             682
;  :mk-clause               40
;  :num-allocs              4191961
;  :num-checks              117
;  :propagations            34
;  :quant-instantiations    47
;  :rlimit-count            155802)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
(pop) ; 4
(push) ; 4
; [eval] !true
(pop) ; 4
(pop) ; 3
(push) ; 3
; Loop head block: Establish invariant
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               896
;  :arith-assert-diseq      19
;  :arith-assert-lower      52
;  :arith-assert-upper      41
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               65
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              38
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             688
;  :mk-clause               40
;  :num-allocs              4191961
;  :num-checks              118
;  :propagations            34
;  :quant-instantiations    50
;  :rlimit-count            156375)
; [eval] diz.Monitor_m != null
; [eval] |diz.Monitor_m.Main_process_state| == 1
; [eval] |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_event_state| == 2
; [eval] |diz.Monitor_m.Main_event_state|
; [eval] (forall i__78: Int :: { diz.Monitor_m.Main_process_state[i__78] } 0 <= i__78 && i__78 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__78] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|)
(declare-const i__78@102@07 Int)
(push) ; 4
; [eval] 0 <= i__78 && i__78 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__78] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= i__78 && i__78 < |diz.Monitor_m.Main_process_state|
; [eval] 0 <= i__78
(push) ; 5
; [then-branch: 8 | 0 <= i__78@102@07 | live]
; [else-branch: 8 | !(0 <= i__78@102@07) | live]
(push) ; 6
; [then-branch: 8 | 0 <= i__78@102@07]
(assert (<= 0 i__78@102@07))
; [eval] i__78 < |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 8 | !(0 <= i__78@102@07)]
(assert (not (<= 0 i__78@102@07)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 9 | i__78@102@07 < |First:(Second:(Second:(Second:($t@85@07))))| && 0 <= i__78@102@07 | live]
; [else-branch: 9 | !(i__78@102@07 < |First:(Second:(Second:(Second:($t@85@07))))| && 0 <= i__78@102@07) | live]
(push) ; 6
; [then-branch: 9 | i__78@102@07 < |First:(Second:(Second:(Second:($t@85@07))))| && 0 <= i__78@102@07]
(assert (and
  (<
    i__78@102@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
  (<= 0 i__78@102@07)))
; [eval] diz.Monitor_m.Main_process_state[i__78] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__78] == -1
; [eval] diz.Monitor_m.Main_process_state[i__78]
(push) ; 7
(assert (not (>= i__78@102@07 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               897
;  :arith-assert-diseq      19
;  :arith-assert-lower      53
;  :arith-assert-upper      42
;  :arith-conflicts         2
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               65
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              38
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             690
;  :mk-clause               40
;  :num-allocs              4191961
;  :num-checks              119
;  :propagations            34
;  :quant-instantiations    50
;  :rlimit-count            156515)
; [eval] -1
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:($t@85@07))))[i__78@102@07] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:($t@85@07))))[i__78@102@07] != -1 | live]
(push) ; 8
; [then-branch: 10 | First:(Second:(Second:(Second:($t@85@07))))[i__78@102@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
    i__78@102@07)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 10 | First:(Second:(Second:(Second:($t@85@07))))[i__78@102@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
      i__78@102@07)
    (- 0 1))))
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__78]
; [eval] diz.Monitor_m.Main_process_state[i__78]
(push) ; 9
(assert (not (>= i__78@102@07 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               899
;  :arith-assert-diseq      21
;  :arith-assert-lower      56
;  :arith-assert-upper      43
;  :arith-conflicts         2
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               65
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              38
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             697
;  :mk-clause               52
;  :num-allocs              4191961
;  :num-checks              120
;  :propagations            39
;  :quant-instantiations    51
;  :rlimit-count            156752)
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@85@07))))[i__78@102@07] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@85@07))))[i__78@102@07]) | live]
(push) ; 10
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@85@07))))[i__78@102@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
    i__78@102@07)))
; [eval] diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__78]
(push) ; 11
(assert (not (>= i__78@102@07 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      21
;  :arith-assert-lower      58
;  :arith-assert-upper      44
;  :arith-conflicts         2
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               65
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              38
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             701
;  :mk-clause               52
;  :num-allocs              4191961
;  :num-checks              121
;  :propagations            39
;  :quant-instantiations    51
;  :rlimit-count            156883)
; [eval] |diz.Monitor_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@85@07))))[i__78@102@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
      i__78@102@07))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(push) ; 6
; [else-branch: 9 | !(i__78@102@07 < |First:(Second:(Second:(Second:($t@85@07))))| && 0 <= i__78@102@07)]
(assert (not
  (and
    (<
      i__78@102@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
    (<= 0 i__78@102@07))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 4
(assert (not (forall ((i__78@102@07 Int)) (!
  (implies
    (and
      (<
        i__78@102@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
      (<= 0 i__78@102@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
          i__78@102@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
            i__78@102@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
            i__78@102@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
    i__78@102@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      22
;  :arith-assert-lower      59
;  :arith-assert-upper      45
;  :arith-conflicts         2
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               66
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             709
;  :mk-clause               64
;  :num-allocs              4191961
;  :num-checks              122
;  :propagations            41
;  :quant-instantiations    52
;  :rlimit-count            157329)
(assert (forall ((i__78@102@07 Int)) (!
  (implies
    (and
      (<
        i__78@102@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))
      (<= 0 i__78@102@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
          i__78@102@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
            i__78@102@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
            i__78@102@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))
    i__78@102@07))
  :qid |prog.l<no position>|)))
(declare-const $k@103@07 $Perm)
(assert ($Perm.isReadVar $k@103@07 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@103@07 $Perm.No) (< $Perm.No $k@103@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      61
;  :arith-assert-upper      46
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               67
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             714
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              123
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            157889)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@87@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      61
;  :arith-assert-upper      46
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               67
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             714
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              124
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            157900)
(assert (< $k@103@07 $k@87@07))
(assert (<= $Perm.No (- $k@87@07 $k@103@07)))
(assert (<= (- $k@87@07 $k@103@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@87@07 $k@103@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07)))
      $Ref.null))))
; [eval] diz.Monitor_m.Main_alu != null
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      47
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               68
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             717
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              125
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            158114)
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      47
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             717
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              126
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            158162)
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      47
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               70
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             717
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              127
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            158210)
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      47
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               71
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             717
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              128
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            158258)
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      47
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               72
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             717
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              129
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            158306)
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      47
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               73
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             717
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              130
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            158354)
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      47
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               74
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             717
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              131
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            158402)
; [eval] 0 <= diz.Monitor_m.Main_alu.ALU_RESULT
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      47
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             717
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              132
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            158450)
; [eval] diz.Monitor_m.Main_alu.ALU_RESULT <= 16
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      47
;  :arith-conflicts         2
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             717
;  :mk-clause               66
;  :num-allocs              4191961
;  :num-checks              133
;  :propagations            42
;  :quant-instantiations    52
;  :rlimit-count            158498)
(declare-const $k@104@07 $Perm)
(assert ($Perm.isReadVar $k@104@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@104@07 $Perm.No) (< $Perm.No $k@104@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      24
;  :arith-assert-lower      65
;  :arith-assert-upper      48
;  :arith-conflicts         2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             721
;  :mk-clause               68
;  :num-allocs              4191961
;  :num-checks              134
;  :propagations            43
;  :quant-instantiations    52
;  :rlimit-count            158696)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@88@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      24
;  :arith-assert-lower      65
;  :arith-assert-upper      48
;  :arith-conflicts         2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         7
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             721
;  :mk-clause               68
;  :num-allocs              4191961
;  :num-checks              135
;  :propagations            43
;  :quant-instantiations    52
;  :rlimit-count            158707)
(assert (< $k@104@07 $k@88@07))
(assert (<= $Perm.No (- $k@88@07 $k@104@07)))
(assert (<= (- $k@88@07 $k@104@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@88@07 $k@104@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07)))
      $Ref.null))))
; [eval] diz.Monitor_m.Main_dr != null
(push) ; 4
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      24
;  :arith-assert-lower      67
;  :arith-assert-upper      49
;  :arith-conflicts         2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             724
;  :mk-clause               68
;  :num-allocs              4191961
;  :num-checks              136
;  :propagations            43
;  :quant-instantiations    52
;  :rlimit-count            158927)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      24
;  :arith-assert-lower      67
;  :arith-assert-upper      49
;  :arith-conflicts         2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             724
;  :mk-clause               68
;  :num-allocs              4191961
;  :num-checks              137
;  :propagations            43
;  :quant-instantiations    52
;  :rlimit-count            158940)
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      24
;  :arith-assert-lower      67
;  :arith-assert-upper      49
;  :arith-conflicts         2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             724
;  :mk-clause               68
;  :num-allocs              4191961
;  :num-checks              138
;  :propagations            43
;  :quant-instantiations    52
;  :rlimit-count            158988)
(push) ; 4
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      24
;  :arith-assert-lower      67
;  :arith-assert-upper      49
;  :arith-conflicts         2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             724
;  :mk-clause               68
;  :num-allocs              4191961
;  :num-checks              139
;  :propagations            43
;  :quant-instantiations    52
;  :rlimit-count            159036)
(push) ; 4
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      24
;  :arith-assert-lower      67
;  :arith-assert-upper      49
;  :arith-conflicts         2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             724
;  :mk-clause               68
;  :num-allocs              4191961
;  :num-checks              140
;  :propagations            43
;  :quant-instantiations    52
;  :rlimit-count            159084)
(push) ; 4
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      24
;  :arith-assert-lower      67
;  :arith-assert-upper      49
;  :arith-conflicts         2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             724
;  :mk-clause               68
;  :num-allocs              4191961
;  :num-checks              141
;  :propagations            43
;  :quant-instantiations    52
;  :rlimit-count            159132)
(push) ; 4
(assert (not (< $Perm.No $k@88@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      24
;  :arith-assert-lower      67
;  :arith-assert-upper      49
;  :arith-conflicts         2
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               83
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             724
;  :mk-clause               68
;  :num-allocs              4191961
;  :num-checks              142
;  :propagations            43
;  :quant-instantiations    52
;  :rlimit-count            159180)
(declare-const $k@105@07 $Perm)
(assert ($Perm.isReadVar $k@105@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@105@07 $Perm.No) (< $Perm.No $k@105@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               901
;  :arith-assert-diseq      25
;  :arith-assert-lower      69
;  :arith-assert-upper      50
;  :arith-conflicts         2
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              62
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             728
;  :mk-clause               70
;  :num-allocs              4191961
;  :num-checks              143
;  :propagations            44
;  :quant-instantiations    52
;  :rlimit-count            159378)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= (+ $k@79@07 $k@89@07) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               902
;  :arith-assert-diseq      25
;  :arith-assert-lower      69
;  :arith-assert-upper      51
;  :arith-conflicts         3
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              64
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             730
;  :mk-clause               72
;  :num-allocs              4191961
;  :num-checks              144
;  :propagations            45
;  :quant-instantiations    52
;  :rlimit-count            159440)
(assert (< $k@105@07 (+ $k@79@07 $k@89@07)))
(assert (<= $Perm.No (- (+ $k@79@07 $k@89@07) $k@105@07)))
(assert (<= (- (+ $k@79@07 $k@89@07) $k@105@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@79@07 $k@89@07) $k@105@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07)))
      $Ref.null))))
; [eval] diz.Monitor_m.Main_mon != null
(push) ; 4
(assert (not (< $Perm.No (+ $k@79@07 $k@89@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               902
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      71
;  :arith-assert-upper      53
;  :arith-conflicts         4
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              64
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             734
;  :mk-clause               72
;  :num-allocs              4191961
;  :num-checks              145
;  :propagations            45
;  :quant-instantiations    52
;  :rlimit-count            159672)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               902
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      71
;  :arith-assert-upper      53
;  :arith-conflicts         4
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              64
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             734
;  :mk-clause               72
;  :num-allocs              4191961
;  :num-checks              146
;  :propagations            45
;  :quant-instantiations    52
;  :rlimit-count            159685)
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No (+ $k@79@07 $k@89@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               902
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      71
;  :arith-assert-upper      54
;  :arith-conflicts         5
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              64
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             735
;  :mk-clause               72
;  :num-allocs              4191961
;  :num-checks              147
;  :propagations            45
;  :quant-instantiations    52
;  :rlimit-count            159748)
(push) ; 4
(assert (not (= diz@76@07 $t@90@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               902
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      71
;  :arith-assert-upper      54
;  :arith-conflicts         5
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   59
;  :datatype-splits         52
;  :decisions               78
;  :del-clause              64
;  :final-checks            37
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             736
;  :mk-clause               72
;  :num-allocs              4191961
;  :num-checks              148
;  :propagations            45
;  :quant-instantiations    52
;  :rlimit-count            159808)
(push) ; 4
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               958
;  :arith-add-rows          1
;  :arith-assert-diseq      25
;  :arith-assert-lower      71
;  :arith-assert-upper      54
;  :arith-conflicts         5
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         9
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   67
;  :datatype-splits         69
;  :decisions               97
;  :del-clause              64
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             752
;  :mk-clause               72
;  :num-allocs              4191961
;  :num-checks              149
;  :propagations            46
;  :quant-instantiations    52
;  :rlimit-count            160463
;  :time                    0.00)
(declare-const $k@106@07 $Perm)
(assert ($Perm.isReadVar $k@106@07 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               958
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         5
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               89
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   67
;  :datatype-splits         69
;  :decisions               97
;  :del-clause              64
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             756
;  :mk-clause               74
;  :num-allocs              4191961
;  :num-checks              150
;  :propagations            47
;  :quant-instantiations    52
;  :rlimit-count            160659)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@106@07 $Perm.No) (< $Perm.No $k@106@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               958
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         5
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   67
;  :datatype-splits         69
;  :decisions               97
;  :del-clause              64
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             756
;  :mk-clause               74
;  :num-allocs              4191961
;  :num-checks              151
;  :propagations            47
;  :quant-instantiations    52
;  :rlimit-count            160709)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@91@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               958
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         5
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   67
;  :datatype-splits         69
;  :decisions               97
;  :del-clause              64
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             756
;  :mk-clause               74
;  :num-allocs              4191961
;  :num-checks              152
;  :propagations            47
;  :quant-instantiations    52
;  :rlimit-count            160720)
(assert (< $k@106@07 $k@91@07))
(assert (<= $Perm.No (- $k@91@07 $k@106@07)))
(assert (<= (- $k@91@07 $k@106@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@91@07 $k@106@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07))))))))))
      $Ref.null))))
; [eval] diz.Monitor_m.Main_alu.ALU_m == diz.Monitor_m
(push) ; 4
(assert (not (< $Perm.No $k@87@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               958
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      75
;  :arith-assert-upper      56
;  :arith-conflicts         5
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               91
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   67
;  :datatype-splits         69
;  :decisions               97
;  :del-clause              64
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             759
;  :mk-clause               74
;  :num-allocs              4191961
;  :num-checks              153
;  :propagations            47
;  :quant-instantiations    52
;  :rlimit-count            160934)
(push) ; 4
(assert (not (< $Perm.No $k@91@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               958
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      75
;  :arith-assert-upper      56
;  :arith-conflicts         5
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         9
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   67
;  :datatype-splits         69
;  :decisions               97
;  :del-clause              64
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             759
;  :mk-clause               74
;  :num-allocs              4191961
;  :num-checks              154
;  :propagations            47
;  :quant-instantiations    52
;  :rlimit-count            160982)
; [eval] diz.Monitor_m.Main_mon == diz
(push) ; 4
(assert (not (< $Perm.No (+ $k@79@07 $k@89@07))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               958
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      75
;  :arith-assert-upper      57
;  :arith-conflicts         6
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         10
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               93
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   67
;  :datatype-splits         69
;  :decisions               97
;  :del-clause              64
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             760
;  :mk-clause               74
;  :num-allocs              4191961
;  :num-checks              155
;  :propagations            47
;  :quant-instantiations    52
;  :rlimit-count            161045)
(set-option :timeout 0)
(push) ; 4
(assert (not (= $t@90@07 diz@76@07)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               958
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      75
;  :arith-assert-upper      57
;  :arith-conflicts         6
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         10
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               94
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   67
;  :datatype-splits         69
;  :decisions               97
;  :del-clause              64
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             760
;  :mk-clause               74
;  :num-allocs              4191961
;  :num-checks              156
;  :propagations            47
;  :quant-instantiations    52
;  :rlimit-count            161101)
(assert (= $t@90@07 diz@76@07))
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               958
;  :arith-add-rows          1
;  :arith-assert-diseq      26
;  :arith-assert-lower      75
;  :arith-assert-upper      57
;  :arith-conflicts         6
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         10
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               94
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 100
;  :datatype-occurs-check   67
;  :datatype-splits         69
;  :decisions               97
;  :del-clause              64
;  :final-checks            40
;  :max-generation          2
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             760
;  :mk-clause               74
;  :num-allocs              4191961
;  :num-checks              157
;  :propagations            47
;  :quant-instantiations    52
;  :rlimit-count            161149)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert ($Perm.isReadVar $k@98@07 $Perm.Write))
(assert ($Perm.isReadVar $k@99@07 $Perm.Write))
(assert ($Perm.isReadVar $k@100@07 $Perm.Write))
(assert ($Perm.isReadVar $k@101@07 $Perm.Write))
(assert (= $t@96@07 ($Snap.combine ($Snap.first $t@96@07) ($Snap.second $t@96@07))))
(assert (=
  ($Snap.second $t@96@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@96@07))
    ($Snap.second ($Snap.second $t@96@07)))))
(assert (= ($Snap.first ($Snap.second $t@96@07)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@96@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@96@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@96@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
  $Snap.unit))
(assert (forall ((i__78@97@07 Int)) (!
  (implies
    (and
      (<
        i__78@97@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))
      (<= 0 i__78@97@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
          i__78@97@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
            i__78@97@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
            i__78@97@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
    i__78@97@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))
(assert (<= $Perm.No $k@98@07))
(assert (<= $k@98@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@98@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
  $Snap.unit))
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))
  $Snap.unit))
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))
(assert (<= $Perm.No $k@99@07))
(assert (<= $k@99@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@99@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))
(assert (<= $Perm.No $k@100@07))
(assert (<= $k@100@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@100@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))))
(assert (<= $Perm.No $k@101@07))
(assert (<= $k@101@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@101@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))
  diz@76@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))))))))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
(push) ; 5
(assert (not false))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1635
;  :arith-add-rows          1
;  :arith-assert-diseq      30
;  :arith-assert-lower      92
;  :arith-assert-upper      72
;  :arith-conflicts         6
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         14
;  :arith-pivots            14
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              78
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             985
;  :mk-clause               90
;  :num-allocs              4347916
;  :num-checks              160
;  :propagations            60
;  :quant-instantiations    65
;  :rlimit-count            169878
;  :time                    0.00)
; [then-branch: 12 | True | live]
; [else-branch: 12 | False | dead]
(push) ; 5
; [then-branch: 12 | True]
; [exec]
; __flatten_45__75 := diz.Monitor_m
(declare-const __flatten_45__75@107@07 $Ref)
(assert (= __flatten_45__75@107@07 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07))))
; [exec]
; __flatten_47__77 := diz.Monitor_m
(declare-const __flatten_47__77@108@07 $Ref)
(assert (= __flatten_47__77@108@07 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07))))
; [exec]
; __flatten_46__76 := __flatten_47__77.Main_process_state[0 := 1]
; [eval] __flatten_47__77.Main_process_state[0 := 1]
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) __flatten_47__77@108@07)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1637
;  :arith-add-rows          1
;  :arith-assert-diseq      30
;  :arith-assert-lower      92
;  :arith-assert-upper      72
;  :arith-conflicts         6
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         14
;  :arith-pivots            14
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              78
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             987
;  :mk-clause               90
;  :num-allocs              4347916
;  :num-checks              161
;  :propagations            60
;  :quant-instantiations    65
;  :rlimit-count            169987)
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1637
;  :arith-add-rows          1
;  :arith-assert-diseq      30
;  :arith-assert-lower      92
;  :arith-assert-upper      72
;  :arith-conflicts         6
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         14
;  :arith-pivots            14
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              78
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             987
;  :mk-clause               90
;  :num-allocs              4347916
;  :num-checks              162
;  :propagations            60
;  :quant-instantiations    65
;  :rlimit-count            170002)
(declare-const __flatten_46__76@109@07 Seq<Int>)
(assert (Seq_equal
  __flatten_46__76@109@07
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))
    0
    1)))
; [exec]
; __flatten_45__75.Main_process_state := __flatten_46__76
(set-option :timeout 10)
(push) ; 6
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) __flatten_45__75@107@07)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1647
;  :arith-add-rows          4
;  :arith-assert-diseq      31
;  :arith-assert-lower      96
;  :arith-assert-upper      74
;  :arith-conflicts         6
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         16
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              78
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1010
;  :mk-clause               110
;  :num-allocs              4347916
;  :num-checks              163
;  :propagations            69
;  :quant-instantiations    70
;  :rlimit-count            170476)
(assert (not (= __flatten_45__75@107@07 $Ref.null)))
(push) ; 6
; Loop head block: Check well-definedness of invariant
(declare-const $t@110@07 $Snap)
(assert (= $t@110@07 ($Snap.combine ($Snap.first $t@110@07) ($Snap.second $t@110@07))))
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1653
;  :arith-add-rows          4
;  :arith-assert-diseq      31
;  :arith-assert-lower      96
;  :arith-assert-upper      74
;  :arith-conflicts         6
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         16
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              78
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             1012
;  :mk-clause               110
;  :num-allocs              4347916
;  :num-checks              164
;  :propagations            69
;  :quant-instantiations    70
;  :rlimit-count            170645)
(assert (=
  ($Snap.second $t@110@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@110@07))
    ($Snap.second ($Snap.second $t@110@07)))))
(assert (= ($Snap.first ($Snap.second $t@110@07)) $Snap.unit))
; [eval] diz.Monitor_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@110@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@110@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@110@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
  $Snap.unit))
; [eval] |diz.Monitor_m.Main_process_state| == 1
; [eval] |diz.Monitor_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
  $Snap.unit))
; [eval] |diz.Monitor_m.Main_event_state| == 2
; [eval] |diz.Monitor_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
  $Snap.unit))
; [eval] (forall i__79: Int :: { diz.Monitor_m.Main_process_state[i__79] } 0 <= i__79 && i__79 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__79] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|)
(declare-const i__79@111@07 Int)
(push) ; 7
; [eval] 0 <= i__79 && i__79 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__79] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= i__79 && i__79 < |diz.Monitor_m.Main_process_state|
; [eval] 0 <= i__79
(push) ; 8
; [then-branch: 13 | 0 <= i__79@111@07 | live]
; [else-branch: 13 | !(0 <= i__79@111@07) | live]
(push) ; 9
; [then-branch: 13 | 0 <= i__79@111@07]
(assert (<= 0 i__79@111@07))
; [eval] i__79 < |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 13 | !(0 <= i__79@111@07)]
(assert (not (<= 0 i__79@111@07)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 14 | i__79@111@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i__79@111@07 | live]
; [else-branch: 14 | !(i__79@111@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i__79@111@07) | live]
(push) ; 9
; [then-branch: 14 | i__79@111@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i__79@111@07]
(assert (and
  (<
    i__79@111@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
  (<= 0 i__79@111@07)))
; [eval] diz.Monitor_m.Main_process_state[i__79] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__79] == -1
; [eval] diz.Monitor_m.Main_process_state[i__79]
(push) ; 10
(assert (not (>= i__79@111@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1698
;  :arith-add-rows          4
;  :arith-assert-diseq      31
;  :arith-assert-lower      101
;  :arith-assert-upper      77
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              78
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1037
;  :mk-clause               110
;  :num-allocs              4507913
;  :num-checks              165
;  :propagations            69
;  :quant-instantiations    75
;  :rlimit-count            171928)
; [eval] -1
(push) ; 10
; [then-branch: 15 | First:(Second:(Second:(Second:($t@110@07))))[i__79@111@07] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:($t@110@07))))[i__79@111@07] != -1 | live]
(push) ; 11
; [then-branch: 15 | First:(Second:(Second:(Second:($t@110@07))))[i__79@111@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i__79@111@07)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 15 | First:(Second:(Second:(Second:($t@110@07))))[i__79@111@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      i__79@111@07)
    (- 0 1))))
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__79]
; [eval] diz.Monitor_m.Main_process_state[i__79]
(push) ; 12
(assert (not (>= i__79@111@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1698
;  :arith-add-rows          4
;  :arith-assert-diseq      31
;  :arith-assert-lower      101
;  :arith-assert-upper      77
;  :arith-conflicts         6
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              78
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1038
;  :mk-clause               110
;  :num-allocs              4507913
;  :num-checks              166
;  :propagations            69
;  :quant-instantiations    75
;  :rlimit-count            172103)
(push) ; 12
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@110@07))))[i__79@111@07] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@110@07))))[i__79@111@07]) | live]
(push) ; 13
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@110@07))))[i__79@111@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i__79@111@07)))
; [eval] diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__79]
(push) ; 14
(assert (not (>= i__79@111@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1698
;  :arith-add-rows          4
;  :arith-assert-diseq      32
;  :arith-assert-lower      104
;  :arith-assert-upper      77
;  :arith-conflicts         6
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              78
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1041
;  :mk-clause               111
;  :num-allocs              4507913
;  :num-checks              167
;  :propagations            69
;  :quant-instantiations    75
;  :rlimit-count            172226)
; [eval] |diz.Monitor_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@110@07))))[i__79@111@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      i__79@111@07))))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 14 | !(i__79@111@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i__79@111@07)]
(assert (not
  (and
    (<
      i__79@111@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
    (<= 0 i__79@111@07))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__79@111@07 Int)) (!
  (implies
    (and
      (<
        i__79@111@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
      (<= 0 i__79@111@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          i__79@111@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i__79@111@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i__79@111@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i__79@111@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))
(declare-const $k@112@07 $Perm)
(assert ($Perm.isReadVar $k@112@07 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@112@07 $Perm.No) (< $Perm.No $k@112@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      106
;  :arith-assert-upper      78
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    170
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1047
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              168
;  :propagations            70
;  :quant-instantiations    75
;  :rlimit-count            172995)
(assert (<= $Perm.No $k@112@07))
(assert (<= $k@112@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@112@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_alu != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1709
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      106
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               98
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1050
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              169
;  :propagations            70
;  :quant-instantiations    75
;  :rlimit-count            173318)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1715
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      106
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    172
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1053
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              170
;  :propagations            70
;  :quant-instantiations    76
;  :rlimit-count            173674)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1720
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      106
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1054
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              171
;  :propagations            70
;  :quant-instantiations    76
;  :rlimit-count            173931)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1725
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      106
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               101
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1055
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              172
;  :propagations            70
;  :quant-instantiations    76
;  :rlimit-count            174198)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1730
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      106
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               102
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1056
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              173
;  :propagations            70
;  :quant-instantiations    76
;  :rlimit-count            174475)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1735
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      106
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               103
;  :datatype-accessor-ax    176
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1057
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              174
;  :propagations            70
;  :quant-instantiations    76
;  :rlimit-count            174762)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1740
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      106
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               104
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1058
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              175
;  :propagations            70
;  :quant-instantiations    76
;  :rlimit-count            175059)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.Monitor_m.Main_alu.ALU_RESULT
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1746
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      106
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               105
;  :datatype-accessor-ax    178
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1060
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              176
;  :propagations            70
;  :quant-instantiations    76
;  :rlimit-count            175398)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_alu.ALU_RESULT <= 16
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1753
;  :arith-add-rows          4
;  :arith-assert-diseq      33
;  :arith-assert-lower      107
;  :arith-assert-upper      79
;  :arith-conflicts         6
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    179
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1064
;  :mk-clause               113
;  :num-allocs              4507913
;  :num-checks              177
;  :propagations            70
;  :quant-instantiations    77
;  :rlimit-count            175846)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))
(declare-const $k@113@07 $Perm)
(assert ($Perm.isReadVar $k@113@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@113@07 $Perm.No) (< $Perm.No $k@113@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1758
;  :arith-add-rows          4
;  :arith-assert-diseq      34
;  :arith-assert-lower      109
;  :arith-assert-upper      81
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    180
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1070
;  :mk-clause               115
;  :num-allocs              4507913
;  :num-checks              178
;  :propagations            71
;  :quant-instantiations    77
;  :rlimit-count            176362)
(assert (<= $Perm.No $k@113@07))
(assert (<= $k@113@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@113@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_dr != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1764
;  :arith-add-rows          4
;  :arith-assert-diseq      34
;  :arith-assert-lower      109
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1073
;  :mk-clause               115
;  :num-allocs              4507913
;  :num-checks              179
;  :propagations            71
;  :quant-instantiations    77
;  :rlimit-count            176785)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1770
;  :arith-add-rows          4
;  :arith-assert-diseq      34
;  :arith-assert-lower      109
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    182
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1076
;  :mk-clause               115
;  :num-allocs              4507913
;  :num-checks              180
;  :propagations            71
;  :quant-instantiations    78
;  :rlimit-count            177241)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1770
;  :arith-add-rows          4
;  :arith-assert-diseq      34
;  :arith-assert-lower      109
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    182
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1076
;  :mk-clause               115
;  :num-allocs              4507913
;  :num-checks              181
;  :propagations            71
;  :quant-instantiations    78
;  :rlimit-count            177254)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1775
;  :arith-add-rows          4
;  :arith-assert-diseq      34
;  :arith-assert-lower      109
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1077
;  :mk-clause               115
;  :num-allocs              4507913
;  :num-checks              182
;  :propagations            71
;  :quant-instantiations    78
;  :rlimit-count            177611)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1780
;  :arith-add-rows          4
;  :arith-assert-diseq      34
;  :arith-assert-lower      109
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               111
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1078
;  :mk-clause               115
;  :num-allocs              4507913
;  :num-checks              183
;  :propagations            71
;  :quant-instantiations    78
;  :rlimit-count            177978)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1785
;  :arith-add-rows          4
;  :arith-assert-diseq      34
;  :arith-assert-lower      109
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               112
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1079
;  :mk-clause               115
;  :num-allocs              4507913
;  :num-checks              184
;  :propagations            71
;  :quant-instantiations    78
;  :rlimit-count            178355)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1790
;  :arith-add-rows          4
;  :arith-assert-diseq      34
;  :arith-assert-lower      109
;  :arith-assert-upper      82
;  :arith-conflicts         6
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               113
;  :datatype-accessor-ax    186
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1080
;  :mk-clause               115
;  :num-allocs              4507913
;  :num-checks              185
;  :propagations            71
;  :quant-instantiations    78
;  :rlimit-count            178742)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
(declare-const $k@114@07 $Perm)
(assert ($Perm.isReadVar $k@114@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@114@07 $Perm.No) (< $Perm.No $k@114@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1795
;  :arith-add-rows          4
;  :arith-assert-diseq      35
;  :arith-assert-lower      111
;  :arith-assert-upper      83
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1085
;  :mk-clause               117
;  :num-allocs              4507913
;  :num-checks              186
;  :propagations            72
;  :quant-instantiations    78
;  :rlimit-count            179283)
(assert (<= $Perm.No $k@114@07))
(assert (<= $k@114@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@114@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@114@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1801
;  :arith-add-rows          4
;  :arith-assert-diseq      35
;  :arith-assert-lower      111
;  :arith-assert-upper      84
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               115
;  :datatype-accessor-ax    188
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1088
;  :mk-clause               117
;  :num-allocs              4507913
;  :num-checks              187
;  :propagations            72
;  :quant-instantiations    78
;  :rlimit-count            179776)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@114@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1807
;  :arith-add-rows          4
;  :arith-assert-diseq      35
;  :arith-assert-lower      111
;  :arith-assert-upper      84
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               116
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1091
;  :mk-clause               117
;  :num-allocs              4507913
;  :num-checks              188
;  :propagations            72
;  :quant-instantiations    79
;  :rlimit-count            180310)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1807
;  :arith-add-rows          4
;  :arith-assert-diseq      35
;  :arith-assert-lower      111
;  :arith-assert-upper      84
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               116
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1091
;  :mk-clause               117
;  :num-allocs              4507913
;  :num-checks              189
;  :propagations            72
;  :quant-instantiations    79
;  :rlimit-count            180323)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1812
;  :arith-add-rows          4
;  :arith-assert-diseq      35
;  :arith-assert-lower      111
;  :arith-assert-upper      84
;  :arith-conflicts         6
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               117
;  :datatype-accessor-ax    190
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1092
;  :mk-clause               117
;  :num-allocs              4507913
;  :num-checks              190
;  :propagations            72
;  :quant-instantiations    79
;  :rlimit-count            180750)
(declare-const $k@115@07 $Perm)
(assert ($Perm.isReadVar $k@115@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@115@07 $Perm.No) (< $Perm.No $k@115@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1812
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      85
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               118
;  :datatype-accessor-ax    190
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1096
;  :mk-clause               119
;  :num-allocs              4507913
;  :num-checks              191
;  :propagations            73
;  :quant-instantiations    79
;  :rlimit-count            180948)
(assert (<= $Perm.No $k@115@07))
(assert (<= $k@115@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@115@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_alu.ALU_m == diz.Monitor_m
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1818
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               119
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1099
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              192
;  :propagations            73
;  :quant-instantiations    79
;  :rlimit-count            181471)
(push) ; 7
(assert (not (< $Perm.No $k@115@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1818
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               120
;  :datatype-accessor-ax    191
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1099
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              193
;  :propagations            73
;  :quant-instantiations    79
;  :rlimit-count            181519)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon == diz
(push) ; 7
(assert (not (< $Perm.No $k@114@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1827
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    192
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1103
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              194
;  :propagations            73
;  :quant-instantiations    80
;  :rlimit-count            182117)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
  diz@76@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1835
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1105
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              195
;  :propagations            73
;  :quant-instantiations    80
;  :rlimit-count            182591)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 7
; [eval] diz.Monitor_m.Main_process_state[0] != -1 || diz.Monitor_m.Main_event_state[1] != -2
; [eval] diz.Monitor_m.Main_process_state[0] != -1
; [eval] diz.Monitor_m.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1845
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1110
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              196
;  :propagations            73
;  :quant-instantiations    82
;  :rlimit-count            183139)
; [eval] -1
(push) ; 8
; [then-branch: 17 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1 | live]
; [else-branch: 17 | First:(Second:(Second:(Second:($t@110@07))))[0] == -1 | live]
(push) ; 9
; [then-branch: 17 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 17 | First:(Second:(Second:(Second:($t@110@07))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    0)
  (- 0 1)))
; [eval] diz.Monitor_m.Main_event_state[1] != -2
; [eval] diz.Monitor_m.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1846
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1111
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              197
;  :propagations            73
;  :quant-instantiations    82
;  :rlimit-count            183301)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(push) ; 7
; [eval] !(diz.Monitor_m.Main_process_state[0] != -1 || diz.Monitor_m.Main_event_state[1] != -2)
; [eval] diz.Monitor_m.Main_process_state[0] != -1 || diz.Monitor_m.Main_event_state[1] != -2
; [eval] diz.Monitor_m.Main_process_state[0] != -1
; [eval] diz.Monitor_m.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1846
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1111
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              198
;  :propagations            73
;  :quant-instantiations    82
;  :rlimit-count            183321)
; [eval] -1
(push) ; 8
; [then-branch: 18 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:($t@110@07))))[0] == -1 | live]
(push) ; 9
; [then-branch: 18 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 18 | First:(Second:(Second:(Second:($t@110@07))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    0)
  (- 0 1)))
; [eval] diz.Monitor_m.Main_event_state[1] != -2
; [eval] diz.Monitor_m.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1847
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              79
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1112
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              199
;  :propagations            73
;  :quant-instantiations    82
;  :rlimit-count            183479)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
(pop) ; 6
(push) ; 6
; Loop head block: Establish invariant
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1847
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              87
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1112
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              200
;  :propagations            73
;  :quant-instantiations    82
;  :rlimit-count            183497)
; [eval] diz.Monitor_m != null
; [eval] |diz.Monitor_m.Main_process_state| == 1
; [eval] |diz.Monitor_m.Main_process_state|
(push) ; 7
(assert (not (= (Seq_length __flatten_46__76@109@07) 1)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1847
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      86
;  :arith-conflicts         6
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         17
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               122
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              87
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1115
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              201
;  :propagations            73
;  :quant-instantiations    82
;  :rlimit-count            183571)
(assert (= (Seq_length __flatten_46__76@109@07) 1))
; [eval] |diz.Monitor_m.Main_event_state| == 2
; [eval] |diz.Monitor_m.Main_event_state|
; [eval] (forall i__79: Int :: { diz.Monitor_m.Main_process_state[i__79] } 0 <= i__79 && i__79 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__79] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|)
(declare-const i__79@116@07 Int)
(push) ; 7
; [eval] 0 <= i__79 && i__79 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__79] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= i__79 && i__79 < |diz.Monitor_m.Main_process_state|
; [eval] 0 <= i__79
(push) ; 8
; [then-branch: 19 | 0 <= i__79@116@07 | live]
; [else-branch: 19 | !(0 <= i__79@116@07) | live]
(push) ; 9
; [then-branch: 19 | 0 <= i__79@116@07]
(assert (<= 0 i__79@116@07))
; [eval] i__79 < |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 19 | !(0 <= i__79@116@07)]
(assert (not (<= 0 i__79@116@07)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 20 | i__79@116@07 < |__flatten_46__76@109@07| && 0 <= i__79@116@07 | live]
; [else-branch: 20 | !(i__79@116@07 < |__flatten_46__76@109@07| && 0 <= i__79@116@07) | live]
(push) ; 9
; [then-branch: 20 | i__79@116@07 < |__flatten_46__76@109@07| && 0 <= i__79@116@07]
(assert (and (< i__79@116@07 (Seq_length __flatten_46__76@109@07)) (<= 0 i__79@116@07)))
; [eval] diz.Monitor_m.Main_process_state[i__79] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__79] == -1
; [eval] diz.Monitor_m.Main_process_state[i__79]
(push) ; 10
(assert (not (>= i__79@116@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1849
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      88
;  :arith-conflicts         6
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         18
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               122
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              87
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1120
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              202
;  :propagations            73
;  :quant-instantiations    82
;  :rlimit-count            183762)
; [eval] -1
(push) ; 10
; [then-branch: 21 | __flatten_46__76@109@07[i__79@116@07] == -1 | live]
; [else-branch: 21 | __flatten_46__76@109@07[i__79@116@07] != -1 | live]
(push) ; 11
; [then-branch: 21 | __flatten_46__76@109@07[i__79@116@07] == -1]
(assert (= (Seq_index __flatten_46__76@109@07 i__79@116@07) (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 21 | __flatten_46__76@109@07[i__79@116@07] != -1]
(assert (not (= (Seq_index __flatten_46__76@109@07 i__79@116@07) (- 0 1))))
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__79]
; [eval] diz.Monitor_m.Main_process_state[i__79]
(push) ; 12
(assert (not (>= i__79@116@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1851
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      115
;  :arith-assert-upper      88
;  :arith-conflicts         6
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         18
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               122
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              87
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1122
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              203
;  :propagations            73
;  :quant-instantiations    83
;  :rlimit-count            183922)
(push) ; 12
; [then-branch: 22 | 0 <= __flatten_46__76@109@07[i__79@116@07] | live]
; [else-branch: 22 | !(0 <= __flatten_46__76@109@07[i__79@116@07]) | live]
(push) ; 13
; [then-branch: 22 | 0 <= __flatten_46__76@109@07[i__79@116@07]]
(assert (<= 0 (Seq_index __flatten_46__76@109@07 i__79@116@07)))
; [eval] diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__79]
(push) ; 14
(assert (not (>= i__79@116@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1852
;  :arith-add-rows          4
;  :arith-assert-diseq      36
;  :arith-assert-lower      117
;  :arith-assert-upper      89
;  :arith-conflicts         6
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         18
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               122
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              87
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1126
;  :mk-clause               119
;  :num-allocs              4673388
;  :num-checks              204
;  :propagations            73
;  :quant-instantiations    83
;  :rlimit-count            183998)
; [eval] |diz.Monitor_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 22 | !(0 <= __flatten_46__76@109@07[i__79@116@07])]
(assert (not (<= 0 (Seq_index __flatten_46__76@109@07 i__79@116@07))))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 20 | !(i__79@116@07 < |__flatten_46__76@109@07| && 0 <= i__79@116@07)]
(assert (not
  (and (< i__79@116@07 (Seq_length __flatten_46__76@109@07)) (<= 0 i__79@116@07))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 7
(assert (not (forall ((i__79@116@07 Int)) (!
  (implies
    (and
      (< i__79@116@07 (Seq_length __flatten_46__76@109@07))
      (<= 0 i__79@116@07))
    (or
      (= (Seq_index __flatten_46__76@109@07 i__79@116@07) (- 0 1))
      (and
        (<
          (Seq_index __flatten_46__76@109@07 i__79@116@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
        (<= 0 (Seq_index __flatten_46__76@109@07 i__79@116@07)))))
  :pattern ((Seq_index __flatten_46__76@109@07 i__79@116@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      38
;  :arith-assert-lower      118
;  :arith-assert-upper      91
;  :arith-conflicts         6
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         19
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               123
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1142
;  :mk-clause               146
;  :num-allocs              4673388
;  :num-checks              205
;  :propagations            79
;  :quant-instantiations    84
;  :rlimit-count            184407)
(assert (forall ((i__79@116@07 Int)) (!
  (implies
    (and
      (< i__79@116@07 (Seq_length __flatten_46__76@109@07))
      (<= 0 i__79@116@07))
    (or
      (= (Seq_index __flatten_46__76@109@07 i__79@116@07) (- 0 1))
      (and
        (<
          (Seq_index __flatten_46__76@109@07 i__79@116@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))
        (<= 0 (Seq_index __flatten_46__76@109@07 i__79@116@07)))))
  :pattern ((Seq_index __flatten_46__76@109@07 i__79@116@07))
  :qid |prog.l<no position>|)))
(declare-const $k@117@07 $Perm)
(assert ($Perm.isReadVar $k@117@07 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@117@07 $Perm.No) (< $Perm.No $k@117@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      120
;  :arith-assert-upper      92
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               124
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1147
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              206
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            184877)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@98@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      120
;  :arith-assert-upper      92
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               124
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1147
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              207
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            184888)
(assert (< $k@117@07 $k@98@07))
(assert (<= $Perm.No (- $k@98@07 $k@117@07)))
(assert (<= (- $k@98@07 $k@117@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@98@07 $k@117@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null))))
; [eval] diz.Monitor_m.Main_alu != null
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      122
;  :arith-assert-upper      93
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1150
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              208
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            185102)
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      122
;  :arith-assert-upper      93
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               126
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1150
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              209
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            185150)
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      122
;  :arith-assert-upper      93
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               127
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1150
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              210
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            185198)
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      122
;  :arith-assert-upper      93
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               128
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1150
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              211
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            185246)
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      122
;  :arith-assert-upper      93
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               129
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1150
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              212
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            185294)
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      122
;  :arith-assert-upper      93
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               130
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1150
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              213
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            185342)
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      122
;  :arith-assert-upper      93
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               131
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1150
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              214
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            185390)
; [eval] 0 <= diz.Monitor_m.Main_alu.ALU_RESULT
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      122
;  :arith-assert-upper      93
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               132
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1150
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              215
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            185438)
; [eval] diz.Monitor_m.Main_alu.ALU_RESULT <= 16
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      39
;  :arith-assert-lower      122
;  :arith-assert-upper      93
;  :arith-conflicts         6
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               133
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1150
;  :mk-clause               148
;  :num-allocs              4673388
;  :num-checks              216
;  :propagations            80
;  :quant-instantiations    84
;  :rlimit-count            185486)
(declare-const $k@118@07 $Perm)
(assert ($Perm.isReadVar $k@118@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@118@07 $Perm.No) (< $Perm.No $k@118@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      40
;  :arith-assert-lower      124
;  :arith-assert-upper      94
;  :arith-conflicts         6
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               134
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1154
;  :mk-clause               150
;  :num-allocs              4673388
;  :num-checks              217
;  :propagations            81
;  :quant-instantiations    84
;  :rlimit-count            185685)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@99@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      40
;  :arith-assert-lower      124
;  :arith-assert-upper      94
;  :arith-conflicts         6
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         19
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               134
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1154
;  :mk-clause               150
;  :num-allocs              4673388
;  :num-checks              218
;  :propagations            81
;  :quant-instantiations    84
;  :rlimit-count            185696)
(assert (< $k@118@07 $k@99@07))
(assert (<= $Perm.No (- $k@99@07 $k@118@07)))
(assert (<= (- $k@99@07 $k@118@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@99@07 $k@118@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null))))
; [eval] diz.Monitor_m.Main_dr != null
(push) ; 7
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      40
;  :arith-assert-lower      126
;  :arith-assert-upper      95
;  :arith-conflicts         6
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               135
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1157
;  :mk-clause               150
;  :num-allocs              4673388
;  :num-checks              219
;  :propagations            81
;  :quant-instantiations    84
;  :rlimit-count            185910)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      40
;  :arith-assert-lower      126
;  :arith-assert-upper      95
;  :arith-conflicts         6
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               135
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1157
;  :mk-clause               150
;  :num-allocs              4673388
;  :num-checks              220
;  :propagations            81
;  :quant-instantiations    84
;  :rlimit-count            185923)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      40
;  :arith-assert-lower      126
;  :arith-assert-upper      95
;  :arith-conflicts         6
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               136
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1157
;  :mk-clause               150
;  :num-allocs              4673388
;  :num-checks              221
;  :propagations            81
;  :quant-instantiations    84
;  :rlimit-count            185971)
(push) ; 7
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      40
;  :arith-assert-lower      126
;  :arith-assert-upper      95
;  :arith-conflicts         6
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               137
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1157
;  :mk-clause               150
;  :num-allocs              4673388
;  :num-checks              222
;  :propagations            81
;  :quant-instantiations    84
;  :rlimit-count            186019)
(push) ; 7
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      40
;  :arith-assert-lower      126
;  :arith-assert-upper      95
;  :arith-conflicts         6
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               138
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1157
;  :mk-clause               150
;  :num-allocs              4673388
;  :num-checks              223
;  :propagations            81
;  :quant-instantiations    84
;  :rlimit-count            186067)
(push) ; 7
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      40
;  :arith-assert-lower      126
;  :arith-assert-upper      95
;  :arith-conflicts         6
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               139
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1157
;  :mk-clause               150
;  :num-allocs              4673388
;  :num-checks              224
;  :propagations            81
;  :quant-instantiations    84
;  :rlimit-count            186115)
(push) ; 7
(assert (not (< $Perm.No $k@99@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      40
;  :arith-assert-lower      126
;  :arith-assert-upper      95
;  :arith-conflicts         6
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               140
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1157
;  :mk-clause               150
;  :num-allocs              4673388
;  :num-checks              225
;  :propagations            81
;  :quant-instantiations    84
;  :rlimit-count            186163)
(declare-const $k@119@07 $Perm)
(assert ($Perm.isReadVar $k@119@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@119@07 $Perm.No) (< $Perm.No $k@119@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      41
;  :arith-assert-lower      128
;  :arith-assert-upper      96
;  :arith-conflicts         6
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               141
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1161
;  :mk-clause               152
;  :num-allocs              4673388
;  :num-checks              226
;  :propagations            82
;  :quant-instantiations    84
;  :rlimit-count            186361)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@100@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      41
;  :arith-assert-lower      128
;  :arith-assert-upper      96
;  :arith-conflicts         6
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               141
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1161
;  :mk-clause               152
;  :num-allocs              4673388
;  :num-checks              227
;  :propagations            82
;  :quant-instantiations    84
;  :rlimit-count            186372)
(assert (< $k@119@07 $k@100@07))
(assert (<= $Perm.No (- $k@100@07 $k@119@07)))
(assert (<= (- $k@100@07 $k@119@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@100@07 $k@119@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)) $Ref.null))))
; [eval] diz.Monitor_m.Main_mon != null
(push) ; 7
(assert (not (< $Perm.No $k@100@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      41
;  :arith-assert-lower      130
;  :arith-assert-upper      97
;  :arith-conflicts         6
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         19
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               142
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1164
;  :mk-clause               152
;  :num-allocs              4673388
;  :num-checks              228
;  :propagations            82
;  :quant-instantiations    84
;  :rlimit-count            186586)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      41
;  :arith-assert-lower      130
;  :arith-assert-upper      97
;  :arith-conflicts         6
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         19
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               142
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1164
;  :mk-clause               152
;  :num-allocs              4673388
;  :num-checks              229
;  :propagations            82
;  :quant-instantiations    84
;  :rlimit-count            186599)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@100@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1856
;  :arith-add-rows          4
;  :arith-assert-diseq      41
;  :arith-assert-lower      130
;  :arith-assert-upper      97
;  :arith-conflicts         6
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         19
;  :arith-pivots            19
;  :binary-propagations     16
;  :conflicts               143
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 274
;  :datatype-occurs-check   100
;  :datatype-splits         186
;  :decisions               260
;  :del-clause              114
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1164
;  :mk-clause               152
;  :num-allocs              4673388
;  :num-checks              230
;  :propagations            82
;  :quant-instantiations    84
;  :rlimit-count            186647)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1975
;  :arith-add-rows          4
;  :arith-assert-diseq      41
;  :arith-assert-lower      131
;  :arith-assert-upper      98
;  :arith-conflicts         6
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         20
;  :arith-pivots            21
;  :binary-propagations     16
;  :conflicts               143
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   111
;  :datatype-splits         225
;  :decisions               299
;  :del-clause              115
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1205
;  :mk-clause               153
;  :num-allocs              4673388
;  :num-checks              231
;  :propagations            85
;  :quant-instantiations    84
;  :rlimit-count            187702
;  :time                    0.00)
(declare-const $k@120@07 $Perm)
(assert ($Perm.isReadVar $k@120@07 $Perm.Write))
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1975
;  :arith-add-rows          4
;  :arith-assert-diseq      42
;  :arith-assert-lower      133
;  :arith-assert-upper      99
;  :arith-conflicts         6
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         20
;  :arith-pivots            21
;  :binary-propagations     16
;  :conflicts               144
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   111
;  :datatype-splits         225
;  :decisions               299
;  :del-clause              115
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1209
;  :mk-clause               155
;  :num-allocs              4673388
;  :num-checks              232
;  :propagations            86
;  :quant-instantiations    84
;  :rlimit-count            187899)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@120@07 $Perm.No) (< $Perm.No $k@120@07))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1975
;  :arith-add-rows          4
;  :arith-assert-diseq      42
;  :arith-assert-lower      133
;  :arith-assert-upper      99
;  :arith-conflicts         6
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         20
;  :arith-pivots            21
;  :binary-propagations     16
;  :conflicts               145
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   111
;  :datatype-splits         225
;  :decisions               299
;  :del-clause              115
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1209
;  :mk-clause               155
;  :num-allocs              4673388
;  :num-checks              233
;  :propagations            86
;  :quant-instantiations    84
;  :rlimit-count            187949)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@101@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1975
;  :arith-add-rows          4
;  :arith-assert-diseq      42
;  :arith-assert-lower      133
;  :arith-assert-upper      99
;  :arith-conflicts         6
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         20
;  :arith-pivots            21
;  :binary-propagations     16
;  :conflicts               145
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   111
;  :datatype-splits         225
;  :decisions               299
;  :del-clause              115
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1209
;  :mk-clause               155
;  :num-allocs              4673388
;  :num-checks              234
;  :propagations            86
;  :quant-instantiations    84
;  :rlimit-count            187960)
(assert (< $k@120@07 $k@101@07))
(assert (<= $Perm.No (- $k@101@07 $k@120@07)))
(assert (<= (- $k@101@07 $k@120@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@101@07 $k@120@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
      $Ref.null))))
; [eval] diz.Monitor_m.Main_alu.ALU_m == diz.Monitor_m
(push) ; 7
(assert (not (< $Perm.No $k@98@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1975
;  :arith-add-rows          4
;  :arith-assert-diseq      42
;  :arith-assert-lower      135
;  :arith-assert-upper      100
;  :arith-conflicts         6
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         20
;  :arith-pivots            22
;  :binary-propagations     16
;  :conflicts               146
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   111
;  :datatype-splits         225
;  :decisions               299
;  :del-clause              115
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1212
;  :mk-clause               155
;  :num-allocs              4673388
;  :num-checks              235
;  :propagations            86
;  :quant-instantiations    84
;  :rlimit-count            188174)
(push) ; 7
(assert (not (< $Perm.No $k@101@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1975
;  :arith-add-rows          4
;  :arith-assert-diseq      42
;  :arith-assert-lower      135
;  :arith-assert-upper      100
;  :arith-conflicts         6
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         20
;  :arith-pivots            22
;  :binary-propagations     16
;  :conflicts               147
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   111
;  :datatype-splits         225
;  :decisions               299
;  :del-clause              115
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1212
;  :mk-clause               155
;  :num-allocs              4673388
;  :num-checks              236
;  :propagations            86
;  :quant-instantiations    84
;  :rlimit-count            188222)
; [eval] diz.Monitor_m.Main_mon == diz
(push) ; 7
(assert (not (< $Perm.No $k@100@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1975
;  :arith-add-rows          4
;  :arith-assert-diseq      42
;  :arith-assert-lower      135
;  :arith-assert-upper      100
;  :arith-conflicts         6
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         20
;  :arith-pivots            22
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   111
;  :datatype-splits         225
;  :decisions               299
;  :del-clause              115
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1212
;  :mk-clause               155
;  :num-allocs              4673388
;  :num-checks              237
;  :propagations            86
;  :quant-instantiations    84
;  :rlimit-count            188270)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1975
;  :arith-add-rows          4
;  :arith-assert-diseq      42
;  :arith-assert-lower      135
;  :arith-assert-upper      100
;  :arith-conflicts         6
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         20
;  :arith-pivots            22
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   111
;  :datatype-splits         225
;  :decisions               299
;  :del-clause              115
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.55
;  :memory                  4.55
;  :mk-bool-var             1212
;  :mk-clause               155
;  :num-allocs              4673388
;  :num-checks              238
;  :propagations            86
;  :quant-instantiations    84
;  :rlimit-count            188283)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 7
(assert ($Perm.isReadVar $k@112@07 $Perm.Write))
(assert ($Perm.isReadVar $k@113@07 $Perm.Write))
(assert ($Perm.isReadVar $k@114@07 $Perm.Write))
(assert ($Perm.isReadVar $k@115@07 $Perm.Write))
(assert (= $t@110@07 ($Snap.combine ($Snap.first $t@110@07) ($Snap.second $t@110@07))))
(assert (=
  ($Snap.second $t@110@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@110@07))
    ($Snap.second ($Snap.second $t@110@07)))))
(assert (= ($Snap.first ($Snap.second $t@110@07)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@110@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@110@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@110@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
  $Snap.unit))
(assert (forall ((i__79@111@07 Int)) (!
  (implies
    (and
      (<
        i__79@111@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
      (<= 0 i__79@111@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          i__79@111@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i__79@111@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i__79@111@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i__79@111@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))
(assert (<= $Perm.No $k@112@07))
(assert (<= $k@112@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@112@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
  $Snap.unit))
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))
  $Snap.unit))
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))
(assert (<= $Perm.No $k@113@07))
(assert (<= $k@113@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@113@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
(assert (<= $Perm.No $k@114@07))
(assert (<= $k@114@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@114@07)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))))
(assert (<= $Perm.No $k@115@07))
(assert (<= $k@115@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@115@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
  diz@76@07))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
; [eval] diz.Monitor_m.Main_process_state[0] != -1 || diz.Monitor_m.Main_event_state[1] != -2
; [eval] diz.Monitor_m.Main_process_state[0] != -1
; [eval] diz.Monitor_m.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2656
;  :arith-add-rows          7
;  :arith-assert-diseq      46
;  :arith-assert-lower      154
;  :arith-assert-upper      117
;  :arith-conflicts         6
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         25
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 470
;  :datatype-occurs-check   137
;  :datatype-splits         341
;  :decisions               446
;  :del-clause              134
;  :final-checks            59
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1438
;  :mk-clause               175
;  :num-allocs              5021364
;  :num-checks              241
;  :propagations            99
;  :quant-instantiations    96
;  :rlimit-count            196641)
; [eval] -1
(push) ; 8
; [then-branch: 23 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1 | live]
; [else-branch: 23 | First:(Second:(Second:(Second:($t@110@07))))[0] == -1 | live]
(push) ; 9
; [then-branch: 23 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 23 | First:(Second:(Second:(Second:($t@110@07))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    0)
  (- 0 1)))
; [eval] diz.Monitor_m.Main_event_state[1] != -2
; [eval] diz.Monitor_m.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2657
;  :arith-add-rows          7
;  :arith-assert-diseq      46
;  :arith-assert-lower      154
;  :arith-assert-upper      117
;  :arith-conflicts         6
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         25
;  :arith-pivots            32
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    236
;  :datatype-constructor-ax 470
;  :datatype-occurs-check   137
;  :datatype-splits         341
;  :decisions               446
;  :del-clause              134
;  :final-checks            59
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1439
;  :mk-clause               175
;  :num-allocs              5021364
;  :num-checks              242
;  :propagations            99
;  :quant-instantiations    96
;  :rlimit-count            196799)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 8
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
          1)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2866
;  :arith-add-rows          7
;  :arith-assert-diseq      49
;  :arith-assert-lower      167
;  :arith-assert-upper      124
;  :arith-conflicts         6
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         29
;  :arith-pivots            40
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 531
;  :datatype-occurs-check   150
;  :datatype-splits         399
;  :decisions               504
;  :del-clause              161
;  :final-checks            62
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1527
;  :mk-clause               202
;  :num-allocs              5021364
;  :num-checks              243
;  :propagations            113
;  :quant-instantiations    100
;  :rlimit-count            198688
;  :time                    0.00)
(push) ; 8
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
        1)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3069
;  :arith-add-rows          8
;  :arith-assert-diseq      49
;  :arith-assert-lower      169
;  :arith-assert-upper      126
;  :arith-conflicts         6
;  :arith-eq-adapter        84
;  :arith-fixed-eqs         31
;  :arith-pivots            44
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              163
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1592
;  :mk-clause               204
;  :num-allocs              5021364
;  :num-checks              244
;  :propagations            117
;  :quant-instantiations    100
;  :rlimit-count            200317
;  :time                    0.00)
; [then-branch: 24 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@110@07))))))[1] != -2 | live]
; [else-branch: 24 | !(First:(Second:(Second:(Second:($t@110@07))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@110@07))))))[1] != -2) | live]
(push) ; 8
; [then-branch: 24 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@110@07))))))[1] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
        1)
      (- 0 2)))))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz.Monitor_m, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Monitor_m, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@121@07 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 25 | 0 <= i@121@07 | live]
; [else-branch: 25 | !(0 <= i@121@07) | live]
(push) ; 11
; [then-branch: 25 | 0 <= i@121@07]
(assert (<= 0 i@121@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 25 | !(0 <= i@121@07)]
(assert (not (<= 0 i@121@07)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 26 | i@121@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i@121@07 | live]
; [else-branch: 26 | !(i@121@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i@121@07) | live]
(push) ; 11
; [then-branch: 26 | i@121@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i@121@07]
(assert (and
  (<
    i@121@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
  (<= 0 i@121@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@121@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3070
;  :arith-add-rows          8
;  :arith-assert-diseq      49
;  :arith-assert-lower      170
;  :arith-assert-upper      127
;  :arith-conflicts         6
;  :arith-eq-adapter        84
;  :arith-fixed-eqs         32
;  :arith-pivots            44
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              163
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1596
;  :mk-clause               205
;  :num-allocs              5021364
;  :num-checks              245
;  :propagations            117
;  :quant-instantiations    100
;  :rlimit-count            200687)
; [eval] -1
(push) ; 12
; [then-branch: 27 | First:(Second:(Second:(Second:($t@110@07))))[i@121@07] == -1 | live]
; [else-branch: 27 | First:(Second:(Second:(Second:($t@110@07))))[i@121@07] != -1 | live]
(push) ; 13
; [then-branch: 27 | First:(Second:(Second:(Second:($t@110@07))))[i@121@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i@121@07)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 27 | First:(Second:(Second:(Second:($t@110@07))))[i@121@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      i@121@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@121@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3072
;  :arith-add-rows          8
;  :arith-assert-diseq      51
;  :arith-assert-lower      173
;  :arith-assert-upper      128
;  :arith-conflicts         6
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         32
;  :arith-pivots            44
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              163
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1602
;  :mk-clause               209
;  :num-allocs              5021364
;  :num-checks              246
;  :propagations            119
;  :quant-instantiations    101
;  :rlimit-count            200903)
(push) ; 14
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@110@07))))[i@121@07] | live]
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@110@07))))[i@121@07]) | live]
(push) ; 15
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@110@07))))[i@121@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i@121@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@121@07 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      51
;  :arith-assert-lower      175
;  :arith-assert-upper      129
;  :arith-conflicts         6
;  :arith-eq-adapter        86
;  :arith-fixed-eqs         33
;  :arith-pivots            45
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              163
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1606
;  :mk-clause               209
;  :num-allocs              5021364
;  :num-checks              247
;  :propagations            119
;  :quant-instantiations    101
;  :rlimit-count            201038)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@110@07))))[i@121@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      i@121@07))))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 26 | !(i@121@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i@121@07)]
(assert (not
  (and
    (<
      i@121@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
    (<= 0 i@121@07))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 9
(assert (not (forall ((i@121@07 Int)) (!
  (implies
    (and
      (<
        i@121@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
      (<= 0 i@121@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          i@121@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i@121@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i@121@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i@121@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      53
;  :arith-assert-lower      176
;  :arith-assert-upper      130
;  :arith-conflicts         6
;  :arith-eq-adapter        87
;  :arith-fixed-eqs         34
;  :arith-pivots            46
;  :binary-propagations     16
;  :conflicts               150
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1614
;  :mk-clause               223
;  :num-allocs              5021364
;  :num-checks              248
;  :propagations            121
;  :quant-instantiations    102
;  :rlimit-count            201487)
(assert (forall ((i@121@07 Int)) (!
  (implies
    (and
      (<
        i@121@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
      (<= 0 i@121@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          i@121@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i@121@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i@121@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i@121@07))
  :qid |prog.l<no position>|)))
(declare-const $k@122@07 $Perm)
(assert ($Perm.isReadVar $k@122@07 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@122@07 $Perm.No) (< $Perm.No $k@122@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      178
;  :arith-assert-upper      131
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            46
;  :binary-propagations     16
;  :conflicts               151
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1619
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              249
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202047)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@112@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      178
;  :arith-assert-upper      131
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            46
;  :binary-propagations     16
;  :conflicts               151
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1619
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              250
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202058)
(assert (< $k@122@07 $k@112@07))
(assert (<= $Perm.No (- $k@112@07 $k@122@07)))
(assert (<= (- $k@112@07 $k@122@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@112@07 $k@122@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
; [eval] diz.Main_alu != null
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               152
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1622
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              251
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202278)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               153
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1622
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              252
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202326)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1622
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              253
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202374)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1622
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              254
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202422)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               156
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1622
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              255
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202470)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               157
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1622
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              256
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202518)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1622
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              257
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202566)
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1622
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              258
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202614)
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      54
;  :arith-assert-lower      180
;  :arith-assert-upper      132
;  :arith-conflicts         6
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               160
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1622
;  :mk-clause               225
;  :num-allocs              5021364
;  :num-checks              259
;  :propagations            122
;  :quant-instantiations    102
;  :rlimit-count            202662)
(declare-const $k@123@07 $Perm)
(assert ($Perm.isReadVar $k@123@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@123@07 $Perm.No) (< $Perm.No $k@123@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      55
;  :arith-assert-lower      182
;  :arith-assert-upper      133
;  :arith-conflicts         6
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1626
;  :mk-clause               227
;  :num-allocs              5021364
;  :num-checks              260
;  :propagations            123
;  :quant-instantiations    102
;  :rlimit-count            202861)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@113@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      55
;  :arith-assert-lower      182
;  :arith-assert-upper      133
;  :arith-conflicts         6
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         34
;  :arith-pivots            48
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1626
;  :mk-clause               227
;  :num-allocs              5021364
;  :num-checks              261
;  :propagations            123
;  :quant-instantiations    102
;  :rlimit-count            202872)
(assert (< $k@123@07 $k@113@07))
(assert (<= $Perm.No (- $k@113@07 $k@123@07)))
(assert (<= (- $k@113@07 $k@123@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@113@07 $k@123@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
; [eval] diz.Main_dr != null
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      55
;  :arith-assert-lower      184
;  :arith-assert-upper      134
;  :arith-conflicts         6
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         34
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               162
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1629
;  :mk-clause               227
;  :num-allocs              5021364
;  :num-checks              262
;  :propagations            123
;  :quant-instantiations    102
;  :rlimit-count            203086)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      55
;  :arith-assert-lower      184
;  :arith-assert-upper      134
;  :arith-conflicts         6
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         34
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               162
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1629
;  :mk-clause               227
;  :num-allocs              5021364
;  :num-checks              263
;  :propagations            123
;  :quant-instantiations    102
;  :rlimit-count            203099)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      55
;  :arith-assert-lower      184
;  :arith-assert-upper      134
;  :arith-conflicts         6
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         34
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               163
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1629
;  :mk-clause               227
;  :num-allocs              5021364
;  :num-checks              264
;  :propagations            123
;  :quant-instantiations    102
;  :rlimit-count            203147)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      55
;  :arith-assert-lower      184
;  :arith-assert-upper      134
;  :arith-conflicts         6
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         34
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               164
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1629
;  :mk-clause               227
;  :num-allocs              5021364
;  :num-checks              265
;  :propagations            123
;  :quant-instantiations    102
;  :rlimit-count            203195)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      55
;  :arith-assert-lower      184
;  :arith-assert-upper      134
;  :arith-conflicts         6
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         34
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               165
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1629
;  :mk-clause               227
;  :num-allocs              5021364
;  :num-checks              266
;  :propagations            123
;  :quant-instantiations    102
;  :rlimit-count            203243)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      55
;  :arith-assert-lower      184
;  :arith-assert-upper      134
;  :arith-conflicts         6
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         34
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               166
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1629
;  :mk-clause               227
;  :num-allocs              5021364
;  :num-checks              267
;  :propagations            123
;  :quant-instantiations    102
;  :rlimit-count            203291)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      55
;  :arith-assert-lower      184
;  :arith-assert-upper      134
;  :arith-conflicts         6
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         34
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               167
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1629
;  :mk-clause               227
;  :num-allocs              5021364
;  :num-checks              268
;  :propagations            123
;  :quant-instantiations    102
;  :rlimit-count            203339)
(declare-const $k@124@07 $Perm)
(assert ($Perm.isReadVar $k@124@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@124@07 $Perm.No) (< $Perm.No $k@124@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      56
;  :arith-assert-lower      186
;  :arith-assert-upper      135
;  :arith-conflicts         6
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         34
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               168
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1633
;  :mk-clause               229
;  :num-allocs              5021364
;  :num-checks              269
;  :propagations            124
;  :quant-instantiations    102
;  :rlimit-count            203538)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@114@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      56
;  :arith-assert-lower      186
;  :arith-assert-upper      135
;  :arith-conflicts         6
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         34
;  :arith-pivots            49
;  :binary-propagations     16
;  :conflicts               168
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1633
;  :mk-clause               229
;  :num-allocs              5021364
;  :num-checks              270
;  :propagations            124
;  :quant-instantiations    102
;  :rlimit-count            203549)
(assert (< $k@124@07 $k@114@07))
(assert (<= $Perm.No (- $k@114@07 $k@124@07)))
(assert (<= (- $k@114@07 $k@124@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@114@07 $k@124@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
; [eval] diz.Main_mon != null
(push) ; 9
(assert (not (< $Perm.No $k@114@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      56
;  :arith-assert-lower      188
;  :arith-assert-upper      136
;  :arith-conflicts         6
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         34
;  :arith-pivots            50
;  :binary-propagations     16
;  :conflicts               169
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1636
;  :mk-clause               229
;  :num-allocs              5021364
;  :num-checks              271
;  :propagations            124
;  :quant-instantiations    102
;  :rlimit-count            203763)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      56
;  :arith-assert-lower      188
;  :arith-assert-upper      136
;  :arith-conflicts         6
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         34
;  :arith-pivots            50
;  :binary-propagations     16
;  :conflicts               169
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1636
;  :mk-clause               229
;  :num-allocs              5021364
;  :num-checks              272
;  :propagations            124
;  :quant-instantiations    102
;  :rlimit-count            203776)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@114@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3074
;  :arith-add-rows          8
;  :arith-assert-diseq      56
;  :arith-assert-lower      188
;  :arith-assert-upper      136
;  :arith-conflicts         6
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         34
;  :arith-pivots            50
;  :binary-propagations     16
;  :conflicts               170
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   163
;  :datatype-splits         457
;  :decisions               561
;  :del-clause              181
;  :final-checks            65
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1636
;  :mk-clause               229
;  :num-allocs              5021364
;  :num-checks              273
;  :propagations            124
;  :quant-instantiations    102
;  :rlimit-count            203824)
(push) ; 9
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3283
;  :arith-add-rows          8
;  :arith-assert-diseq      59
;  :arith-assert-lower      201
;  :arith-assert-upper      143
;  :arith-conflicts         6
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         38
;  :arith-pivots            58
;  :binary-propagations     16
;  :conflicts               170
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 653
;  :datatype-occurs-check   176
;  :datatype-splits         515
;  :decisions               619
;  :del-clause              207
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1722
;  :mk-clause               255
;  :num-allocs              5021364
;  :num-checks              274
;  :propagations            138
;  :quant-instantiations    107
;  :rlimit-count            205502
;  :time                    0.00)
(declare-const $k@125@07 $Perm)
(assert ($Perm.isReadVar $k@125@07 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3283
;  :arith-add-rows          8
;  :arith-assert-diseq      60
;  :arith-assert-lower      203
;  :arith-assert-upper      144
;  :arith-conflicts         6
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         38
;  :arith-pivots            58
;  :binary-propagations     16
;  :conflicts               171
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 653
;  :datatype-occurs-check   176
;  :datatype-splits         515
;  :decisions               619
;  :del-clause              207
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1726
;  :mk-clause               257
;  :num-allocs              5021364
;  :num-checks              275
;  :propagations            139
;  :quant-instantiations    107
;  :rlimit-count            205698)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@125@07 $Perm.No) (< $Perm.No $k@125@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3283
;  :arith-add-rows          8
;  :arith-assert-diseq      60
;  :arith-assert-lower      203
;  :arith-assert-upper      144
;  :arith-conflicts         6
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         38
;  :arith-pivots            58
;  :binary-propagations     16
;  :conflicts               172
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 653
;  :datatype-occurs-check   176
;  :datatype-splits         515
;  :decisions               619
;  :del-clause              207
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1726
;  :mk-clause               257
;  :num-allocs              5021364
;  :num-checks              276
;  :propagations            139
;  :quant-instantiations    107
;  :rlimit-count            205748)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@115@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3283
;  :arith-add-rows          8
;  :arith-assert-diseq      60
;  :arith-assert-lower      203
;  :arith-assert-upper      144
;  :arith-conflicts         6
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         38
;  :arith-pivots            58
;  :binary-propagations     16
;  :conflicts               172
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 653
;  :datatype-occurs-check   176
;  :datatype-splits         515
;  :decisions               619
;  :del-clause              207
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1726
;  :mk-clause               257
;  :num-allocs              5021364
;  :num-checks              277
;  :propagations            139
;  :quant-instantiations    107
;  :rlimit-count            205759)
(assert (< $k@125@07 $k@115@07))
(assert (<= $Perm.No (- $k@115@07 $k@125@07)))
(assert (<= (- $k@115@07 $k@125@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@115@07 $k@125@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
      $Ref.null))))
; [eval] diz.Main_alu.ALU_m == diz
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3283
;  :arith-add-rows          8
;  :arith-assert-diseq      60
;  :arith-assert-lower      205
;  :arith-assert-upper      145
;  :arith-conflicts         6
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         38
;  :arith-pivots            59
;  :binary-propagations     16
;  :conflicts               173
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 653
;  :datatype-occurs-check   176
;  :datatype-splits         515
;  :decisions               619
;  :del-clause              207
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1729
;  :mk-clause               257
;  :num-allocs              5021364
;  :num-checks              278
;  :propagations            139
;  :quant-instantiations    107
;  :rlimit-count            205973)
(push) ; 9
(assert (not (< $Perm.No $k@115@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3283
;  :arith-add-rows          8
;  :arith-assert-diseq      60
;  :arith-assert-lower      205
;  :arith-assert-upper      145
;  :arith-conflicts         6
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         38
;  :arith-pivots            59
;  :binary-propagations     16
;  :conflicts               174
;  :datatype-accessor-ax    248
;  :datatype-constructor-ax 653
;  :datatype-occurs-check   176
;  :datatype-splits         515
;  :decisions               619
;  :del-clause              207
;  :final-checks            68
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.75
;  :memory                  4.75
;  :mk-bool-var             1729
;  :mk-clause               257
;  :num-allocs              5021364
;  :num-checks              279
;  :propagations            139
;  :quant-instantiations    107
;  :rlimit-count            206021)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))
                                ($Snap.combine
                                  $Snap.unit
                                  ($Snap.combine
                                    $Snap.unit
                                    ($Snap.combine
                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))
                                      ($Snap.combine
                                        $Snap.unit
                                        ($Snap.combine
                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))
                                          ($Snap.combine
                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))
                                            ($Snap.combine
                                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))
                                              ($Snap.combine
                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))
                                                ($Snap.combine
                                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))
                                                  ($Snap.combine
                                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))
                                                    ($Snap.combine
                                                      $Snap.unit
                                                      ($Snap.combine
                                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))
                                                        ($Snap.combine
                                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
                                                          $Snap.unit))))))))))))))))))))))))))))) ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) globals@77@07))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Monitor_m, globals), write)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Monitor_m, globals), write)
(declare-const $t@126@07 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Monitor_m, globals), write)
(assert (= $t@126@07 ($Snap.combine ($Snap.first $t@126@07) ($Snap.second $t@126@07))))
(assert (= ($Snap.first $t@126@07) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@126@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@126@07))
    ($Snap.second ($Snap.second $t@126@07)))))
(assert (= ($Snap.first ($Snap.second $t@126@07)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@126@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@126@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@126@07))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@126@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@127@07 Int)
(push) ; 9
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 10
; [then-branch: 29 | 0 <= i@127@07 | live]
; [else-branch: 29 | !(0 <= i@127@07) | live]
(push) ; 11
; [then-branch: 29 | 0 <= i@127@07]
(assert (<= 0 i@127@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 29 | !(0 <= i@127@07)]
(assert (not (<= 0 i@127@07)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 30 | i@127@07 < |First:(Second:(Second:(Second:($t@126@07))))| && 0 <= i@127@07 | live]
; [else-branch: 30 | !(i@127@07 < |First:(Second:(Second:(Second:($t@126@07))))| && 0 <= i@127@07) | live]
(push) ; 11
; [then-branch: 30 | i@127@07 < |First:(Second:(Second:(Second:($t@126@07))))| && 0 <= i@127@07]
(assert (and
  (<
    i@127@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
  (<= 0 i@127@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 12
(assert (not (>= i@127@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3602
;  :arith-add-rows          9
;  :arith-assert-diseq      63
;  :arith-assert-lower      223
;  :arith-assert-upper      155
;  :arith-conflicts         6
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         43
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               174
;  :datatype-accessor-ax    289
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              241
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1842
;  :mk-clause               283
;  :num-allocs              5207032
;  :num-checks              281
;  :propagations            153
;  :quant-instantiations    116
;  :rlimit-count            210151)
; [eval] -1
(push) ; 12
; [then-branch: 31 | First:(Second:(Second:(Second:($t@126@07))))[i@127@07] == -1 | live]
; [else-branch: 31 | First:(Second:(Second:(Second:($t@126@07))))[i@127@07] != -1 | live]
(push) ; 13
; [then-branch: 31 | First:(Second:(Second:(Second:($t@126@07))))[i@127@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
    i@127@07)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 31 | First:(Second:(Second:(Second:($t@126@07))))[i@127@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
      i@127@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@127@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3602
;  :arith-add-rows          9
;  :arith-assert-diseq      63
;  :arith-assert-lower      223
;  :arith-assert-upper      155
;  :arith-conflicts         6
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         43
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               174
;  :datatype-accessor-ax    289
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              241
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1843
;  :mk-clause               283
;  :num-allocs              5207032
;  :num-checks              282
;  :propagations            153
;  :quant-instantiations    116
;  :rlimit-count            210326)
(push) ; 14
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@126@07))))[i@127@07] | live]
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@126@07))))[i@127@07]) | live]
(push) ; 15
; [then-branch: 32 | 0 <= First:(Second:(Second:(Second:($t@126@07))))[i@127@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
    i@127@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 16
(assert (not (>= i@127@07 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3602
;  :arith-add-rows          9
;  :arith-assert-diseq      64
;  :arith-assert-lower      226
;  :arith-assert-upper      155
;  :arith-conflicts         6
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         43
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               174
;  :datatype-accessor-ax    289
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              241
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1846
;  :mk-clause               284
;  :num-allocs              5207032
;  :num-checks              283
;  :propagations            153
;  :quant-instantiations    116
;  :rlimit-count            210449)
; [eval] |diz.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 32 | !(0 <= First:(Second:(Second:(Second:($t@126@07))))[i@127@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
      i@127@07))))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 30 | !(i@127@07 < |First:(Second:(Second:(Second:($t@126@07))))| && 0 <= i@127@07)]
(assert (not
  (and
    (<
      i@127@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
    (<= 0 i@127@07))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@127@07 Int)) (!
  (implies
    (and
      (<
        i@127@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
      (<= 0 i@127@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
          i@127@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
            i@127@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
            i@127@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
    i@127@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))
(declare-const $k@128@07 $Perm)
(assert ($Perm.isReadVar $k@128@07 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@128@07 $Perm.No) (< $Perm.No $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3607
;  :arith-add-rows          9
;  :arith-assert-diseq      65
;  :arith-assert-lower      228
;  :arith-assert-upper      156
;  :arith-conflicts         6
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         43
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               175
;  :datatype-accessor-ax    290
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1852
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              284
;  :propagations            154
;  :quant-instantiations    116
;  :rlimit-count            211218)
(declare-const $t@129@07 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@112@07 $k@122@07))
    (=
      $t@129@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))
  (implies
    (< $Perm.No $k@128@07)
    (=
      $t@129@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))
(assert (<= $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07)))
(assert (<= (+ (- $k@112@07 $k@122@07) $k@128@07) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))
  $Snap.unit))
; [eval] diz.Main_alu != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3617
;  :arith-add-rows          10
;  :arith-assert-diseq      65
;  :arith-assert-lower      229
;  :arith-assert-upper      158
;  :arith-conflicts         7
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         44
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               176
;  :datatype-accessor-ax    291
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1860
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              285
;  :propagations            154
;  :quant-instantiations    117
;  :rlimit-count            211898)
(assert (not (= $t@129@07 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3623
;  :arith-add-rows          10
;  :arith-assert-diseq      65
;  :arith-assert-lower      229
;  :arith-assert-upper      159
;  :arith-conflicts         8
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         45
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               177
;  :datatype-accessor-ax    292
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1863
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              286
;  :propagations            154
;  :quant-instantiations    117
;  :rlimit-count            212220)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          10
;  :arith-assert-diseq      65
;  :arith-assert-lower      229
;  :arith-assert-upper      160
;  :arith-conflicts         9
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         46
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               178
;  :datatype-accessor-ax    293
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1865
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              287
;  :propagations            154
;  :quant-instantiations    117
;  :rlimit-count            212507)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3633
;  :arith-add-rows          10
;  :arith-assert-diseq      65
;  :arith-assert-lower      229
;  :arith-assert-upper      161
;  :arith-conflicts         10
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         47
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               179
;  :datatype-accessor-ax    294
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1867
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              288
;  :propagations            154
;  :quant-instantiations    117
;  :rlimit-count            212804)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3638
;  :arith-add-rows          10
;  :arith-assert-diseq      65
;  :arith-assert-lower      229
;  :arith-assert-upper      162
;  :arith-conflicts         11
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         48
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               180
;  :datatype-accessor-ax    295
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1869
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              289
;  :propagations            154
;  :quant-instantiations    117
;  :rlimit-count            213111)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3643
;  :arith-add-rows          10
;  :arith-assert-diseq      65
;  :arith-assert-lower      229
;  :arith-assert-upper      163
;  :arith-conflicts         12
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         49
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               181
;  :datatype-accessor-ax    296
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1871
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              290
;  :propagations            154
;  :quant-instantiations    117
;  :rlimit-count            213428)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3648
;  :arith-add-rows          10
;  :arith-assert-diseq      65
;  :arith-assert-lower      229
;  :arith-assert-upper      164
;  :arith-conflicts         13
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         50
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               182
;  :datatype-accessor-ax    297
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1873
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              291
;  :propagations            154
;  :quant-instantiations    117
;  :rlimit-count            213755)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3654
;  :arith-add-rows          10
;  :arith-assert-diseq      65
;  :arith-assert-lower      229
;  :arith-assert-upper      165
;  :arith-conflicts         14
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         51
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               183
;  :datatype-accessor-ax    298
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1876
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              292
;  :propagations            154
;  :quant-instantiations    117
;  :rlimit-count            214124)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3661
;  :arith-add-rows          10
;  :arith-assert-diseq      65
;  :arith-assert-lower      230
;  :arith-assert-upper      166
;  :arith-conflicts         15
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         52
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               184
;  :datatype-accessor-ax    299
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1881
;  :mk-clause               286
;  :num-allocs              5207032
;  :num-checks              293
;  :propagations            154
;  :quant-instantiations    118
;  :rlimit-count            214602)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))
(declare-const $k@130@07 $Perm)
(assert ($Perm.isReadVar $k@130@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@130@07 $Perm.No) (< $Perm.No $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3666
;  :arith-add-rows          10
;  :arith-assert-diseq      66
;  :arith-assert-lower      232
;  :arith-assert-upper      168
;  :arith-conflicts         15
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         52
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               185
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1887
;  :mk-clause               288
;  :num-allocs              5207032
;  :num-checks              294
;  :propagations            155
;  :quant-instantiations    118
;  :rlimit-count            215119)
(declare-const $t@131@07 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@113@07 $k@123@07))
    (=
      $t@131@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))
  (implies
    (< $Perm.No $k@130@07)
    (=
      $t@131@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07)))
(assert (<= (+ (- $k@113@07 $k@123@07) $k@130@07) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_dr != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3676
;  :arith-add-rows          11
;  :arith-assert-diseq      66
;  :arith-assert-lower      233
;  :arith-assert-upper      170
;  :arith-conflicts         16
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         53
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               186
;  :datatype-accessor-ax    301
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1895
;  :mk-clause               288
;  :num-allocs              5207032
;  :num-checks              295
;  :propagations            155
;  :quant-instantiations    119
;  :rlimit-count            215999)
(assert (not (= $t@131@07 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3682
;  :arith-add-rows          11
;  :arith-assert-diseq      66
;  :arith-assert-lower      233
;  :arith-assert-upper      171
;  :arith-conflicts         17
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         54
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               187
;  :datatype-accessor-ax    302
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1898
;  :mk-clause               288
;  :num-allocs              5207032
;  :num-checks              296
;  :propagations            155
;  :quant-instantiations    119
;  :rlimit-count            216421)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3682
;  :arith-add-rows          11
;  :arith-assert-diseq      66
;  :arith-assert-lower      233
;  :arith-assert-upper      171
;  :arith-conflicts         17
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         54
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               187
;  :datatype-accessor-ax    302
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1898
;  :mk-clause               288
;  :num-allocs              5207032
;  :num-checks              297
;  :propagations            155
;  :quant-instantiations    119
;  :rlimit-count            216434)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3687
;  :arith-add-rows          11
;  :arith-assert-diseq      66
;  :arith-assert-lower      233
;  :arith-assert-upper      172
;  :arith-conflicts         18
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         55
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    303
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1900
;  :mk-clause               288
;  :num-allocs              5207032
;  :num-checks              298
;  :propagations            155
;  :quant-instantiations    119
;  :rlimit-count            216821)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3692
;  :arith-add-rows          11
;  :arith-assert-diseq      66
;  :arith-assert-lower      233
;  :arith-assert-upper      173
;  :arith-conflicts         19
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         56
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               189
;  :datatype-accessor-ax    304
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1902
;  :mk-clause               288
;  :num-allocs              5207032
;  :num-checks              299
;  :propagations            155
;  :quant-instantiations    119
;  :rlimit-count            217218)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3697
;  :arith-add-rows          11
;  :arith-assert-diseq      66
;  :arith-assert-lower      233
;  :arith-assert-upper      174
;  :arith-conflicts         20
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         57
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               190
;  :datatype-accessor-ax    305
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1904
;  :mk-clause               288
;  :num-allocs              5207032
;  :num-checks              300
;  :propagations            155
;  :quant-instantiations    119
;  :rlimit-count            217625)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3702
;  :arith-add-rows          11
;  :arith-assert-diseq      66
;  :arith-assert-lower      233
;  :arith-assert-upper      175
;  :arith-conflicts         21
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         58
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               191
;  :datatype-accessor-ax    306
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1906
;  :mk-clause               288
;  :num-allocs              5207032
;  :num-checks              301
;  :propagations            155
;  :quant-instantiations    119
;  :rlimit-count            218042)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))))
(declare-const $k@132@07 $Perm)
(assert ($Perm.isReadVar $k@132@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@132@07 $Perm.No) (< $Perm.No $k@132@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3707
;  :arith-add-rows          11
;  :arith-assert-diseq      67
;  :arith-assert-lower      235
;  :arith-assert-upper      176
;  :arith-conflicts         21
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         58
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               192
;  :datatype-accessor-ax    307
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1911
;  :mk-clause               290
;  :num-allocs              5207032
;  :num-checks              302
;  :propagations            156
;  :quant-instantiations    119
;  :rlimit-count            218582)
(declare-const $t@133@07 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@114@07 $k@124@07))
    (=
      $t@133@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@132@07)
    (=
      $t@133@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@114@07 $k@124@07) $k@132@07)))
(assert (<= (+ (- $k@114@07 $k@124@07) $k@132@07) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@114@07 $k@124@07) $k@132@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_mon != null
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@114@07 $k@124@07) $k@132@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3717
;  :arith-add-rows          12
;  :arith-assert-diseq      67
;  :arith-assert-lower      236
;  :arith-assert-upper      178
;  :arith-conflicts         22
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         59
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               193
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1919
;  :mk-clause               290
;  :num-allocs              5207032
;  :num-checks              303
;  :propagations            156
;  :quant-instantiations    120
;  :rlimit-count            219352)
(assert (not (= $t@133@07 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@114@07 $k@124@07) $k@132@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3722
;  :arith-add-rows          12
;  :arith-assert-diseq      67
;  :arith-assert-lower      236
;  :arith-assert-upper      179
;  :arith-conflicts         23
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         60
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               194
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1921
;  :mk-clause               290
;  :num-allocs              5207032
;  :num-checks              304
;  :propagations            156
;  :quant-instantiations    120
;  :rlimit-count            219819)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3722
;  :arith-add-rows          12
;  :arith-assert-diseq      67
;  :arith-assert-lower      236
;  :arith-assert-upper      179
;  :arith-conflicts         23
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         60
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               194
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1921
;  :mk-clause               290
;  :num-allocs              5207032
;  :num-checks              305
;  :propagations            156
;  :quant-instantiations    120
;  :rlimit-count            219832)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
  $t@133@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3722
;  :arith-add-rows          12
;  :arith-assert-diseq      67
;  :arith-assert-lower      236
;  :arith-assert-upper      179
;  :arith-conflicts         23
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         60
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               194
;  :datatype-accessor-ax    309
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1921
;  :mk-clause               290
;  :num-allocs              5207032
;  :num-checks              306
;  :propagations            156
;  :quant-instantiations    120
;  :rlimit-count            219843)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))))))))))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3730
;  :arith-add-rows          12
;  :arith-assert-diseq      67
;  :arith-assert-lower      236
;  :arith-assert-upper      180
;  :arith-conflicts         24
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         61
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               195
;  :datatype-accessor-ax    310
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1925
;  :mk-clause               290
;  :num-allocs              5207032
;  :num-checks              307
;  :propagations            156
;  :quant-instantiations    121
;  :rlimit-count            220377)
(declare-const $k@134@07 $Perm)
(assert ($Perm.isReadVar $k@134@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@134@07 $Perm.No) (< $Perm.No $k@134@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3730
;  :arith-add-rows          12
;  :arith-assert-diseq      68
;  :arith-assert-lower      238
;  :arith-assert-upper      181
;  :arith-conflicts         24
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         61
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               196
;  :datatype-accessor-ax    310
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1929
;  :mk-clause               292
;  :num-allocs              5207032
;  :num-checks              308
;  :propagations            157
;  :quant-instantiations    121
;  :rlimit-count            220576)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
  $t@129@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3730
;  :arith-add-rows          12
;  :arith-assert-diseq      68
;  :arith-assert-lower      238
;  :arith-assert-upper      181
;  :arith-conflicts         24
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         61
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               196
;  :datatype-accessor-ax    310
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1929
;  :mk-clause               292
;  :num-allocs              5207032
;  :num-checks              309
;  :propagations            157
;  :quant-instantiations    121
;  :rlimit-count            220587)
(declare-const $t@135@07 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@115@07 $k@125@07))
    (=
      $t@135@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@134@07)
    (=
      $t@135@07
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ (- $k@115@07 $k@125@07) $k@134@07)))
(assert (<= (+ (- $k@115@07 $k@125@07) $k@134@07) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@115@07 $k@125@07) $k@134@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_m == diz
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3739
;  :arith-add-rows          13
;  :arith-assert-diseq      68
;  :arith-assert-lower      239
;  :arith-assert-upper      183
;  :arith-conflicts         25
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         62
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               197
;  :datatype-accessor-ax    310
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1936
;  :mk-clause               292
;  :num-allocs              5207032
;  :num-checks              310
;  :propagations            157
;  :quant-instantiations    122
;  :rlimit-count            221281)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
  $t@129@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3739
;  :arith-add-rows          13
;  :arith-assert-diseq      68
;  :arith-assert-lower      239
;  :arith-assert-upper      183
;  :arith-conflicts         25
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         62
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               197
;  :datatype-accessor-ax    310
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1936
;  :mk-clause               292
;  :num-allocs              5207032
;  :num-checks              311
;  :propagations            157
;  :quant-instantiations    122
;  :rlimit-count            221292)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@115@07 $k@125@07) $k@134@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3739
;  :arith-add-rows          13
;  :arith-assert-diseq      68
;  :arith-assert-lower      239
;  :arith-assert-upper      184
;  :arith-conflicts         26
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         63
;  :arith-pivots            68
;  :binary-propagations     16
;  :conflicts               198
;  :datatype-accessor-ax    310
;  :datatype-constructor-ax 714
;  :datatype-occurs-check   274
;  :datatype-splits         573
;  :decisions               677
;  :del-clause              242
;  :final-checks            71
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.85
;  :memory                  4.85
;  :mk-bool-var             1937
;  :mk-clause               292
;  :num-allocs              5207032
;  :num-checks              312
;  :propagations            157
;  :quant-instantiations    122
;  :rlimit-count            221370)
(assert (= $t@135@07 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@126@07 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) globals@77@07))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Monitor_m, globals), write)
(declare-const $t@136@07 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; Loop head block: Re-establish invariant
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4453
;  :arith-add-rows          20
;  :arith-assert-diseq      79
;  :arith-assert-lower      289
;  :arith-assert-upper      212
;  :arith-conflicts         26
;  :arith-eq-adapter        140
;  :arith-fixed-eqs         80
;  :arith-pivots            98
;  :binary-propagations     16
;  :conflicts               199
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              347
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2198
;  :mk-clause               390
;  :num-allocs              5594059
;  :num-checks              315
;  :propagations            205
;  :quant-instantiations    138
;  :rlimit-count            226419)
; [eval] diz.Monitor_m != null
; [eval] |diz.Monitor_m.Main_process_state| == 1
; [eval] |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_event_state| == 2
; [eval] |diz.Monitor_m.Main_event_state|
; [eval] (forall i__79: Int :: { diz.Monitor_m.Main_process_state[i__79] } 0 <= i__79 && i__79 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__79] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|)
(declare-const i__79@137@07 Int)
(push) ; 9
; [eval] 0 <= i__79 && i__79 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__79] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= i__79 && i__79 < |diz.Monitor_m.Main_process_state|
; [eval] 0 <= i__79
(push) ; 10
; [then-branch: 33 | 0 <= i__79@137@07 | live]
; [else-branch: 33 | !(0 <= i__79@137@07) | live]
(push) ; 11
; [then-branch: 33 | 0 <= i__79@137@07]
(assert (<= 0 i__79@137@07))
; [eval] i__79 < |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 33 | !(0 <= i__79@137@07)]
(assert (not (<= 0 i__79@137@07)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 34 | i__79@137@07 < |First:(Second:(Second:(Second:($t@126@07))))| && 0 <= i__79@137@07 | live]
; [else-branch: 34 | !(i__79@137@07 < |First:(Second:(Second:(Second:($t@126@07))))| && 0 <= i__79@137@07) | live]
(push) ; 11
; [then-branch: 34 | i__79@137@07 < |First:(Second:(Second:(Second:($t@126@07))))| && 0 <= i__79@137@07]
(assert (and
  (<
    i__79@137@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
  (<= 0 i__79@137@07)))
; [eval] diz.Monitor_m.Main_process_state[i__79] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__79] == -1
; [eval] diz.Monitor_m.Main_process_state[i__79]
(push) ; 12
(assert (not (>= i__79@137@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4454
;  :arith-add-rows          20
;  :arith-assert-diseq      79
;  :arith-assert-lower      290
;  :arith-assert-upper      213
;  :arith-conflicts         26
;  :arith-eq-adapter        140
;  :arith-fixed-eqs         81
;  :arith-pivots            98
;  :binary-propagations     16
;  :conflicts               199
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              347
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2200
;  :mk-clause               390
;  :num-allocs              5594059
;  :num-checks              316
;  :propagations            205
;  :quant-instantiations    138
;  :rlimit-count            226559)
; [eval] -1
(push) ; 12
; [then-branch: 35 | First:(Second:(Second:(Second:($t@126@07))))[i__79@137@07] == -1 | live]
; [else-branch: 35 | First:(Second:(Second:(Second:($t@126@07))))[i__79@137@07] != -1 | live]
(push) ; 13
; [then-branch: 35 | First:(Second:(Second:(Second:($t@126@07))))[i__79@137@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
    i__79@137@07)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 35 | First:(Second:(Second:(Second:($t@126@07))))[i__79@137@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
      i__79@137@07)
    (- 0 1))))
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__79] && diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__79]
; [eval] diz.Monitor_m.Main_process_state[i__79]
(push) ; 14
(assert (not (>= i__79@137@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4456
;  :arith-add-rows          20
;  :arith-assert-diseq      81
;  :arith-assert-lower      293
;  :arith-assert-upper      214
;  :arith-conflicts         26
;  :arith-eq-adapter        141
;  :arith-fixed-eqs         81
;  :arith-pivots            98
;  :binary-propagations     16
;  :conflicts               199
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              347
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2207
;  :mk-clause               400
;  :num-allocs              5594059
;  :num-checks              317
;  :propagations            210
;  :quant-instantiations    139
;  :rlimit-count            226753)
(push) ; 14
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@126@07))))[i__79@137@07] | live]
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@126@07))))[i__79@137@07]) | live]
(push) ; 15
; [then-branch: 36 | 0 <= First:(Second:(Second:(Second:($t@126@07))))[i__79@137@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
    i__79@137@07)))
; [eval] diz.Monitor_m.Main_process_state[i__79] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__79]
(push) ; 16
(assert (not (>= i__79@137@07 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4458
;  :arith-add-rows          20
;  :arith-assert-diseq      81
;  :arith-assert-lower      295
;  :arith-assert-upper      215
;  :arith-conflicts         26
;  :arith-eq-adapter        142
;  :arith-fixed-eqs         82
;  :arith-pivots            99
;  :binary-propagations     16
;  :conflicts               199
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              347
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2211
;  :mk-clause               400
;  :num-allocs              5594059
;  :num-checks              318
;  :propagations            210
;  :quant-instantiations    139
;  :rlimit-count            226888)
; [eval] |diz.Monitor_m.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 36 | !(0 <= First:(Second:(Second:(Second:($t@126@07))))[i__79@137@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
      i__79@137@07))))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 34 | !(i__79@137@07 < |First:(Second:(Second:(Second:($t@126@07))))| && 0 <= i__79@137@07)]
(assert (not
  (and
    (<
      i__79@137@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
    (<= 0 i__79@137@07))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 9
(assert (not (forall ((i__79@137@07 Int)) (!
  (implies
    (and
      (<
        i__79@137@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
      (<= 0 i__79@137@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
          i__79@137@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
            i__79@137@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
            i__79@137@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
    i__79@137@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4458
;  :arith-add-rows          20
;  :arith-assert-diseq      83
;  :arith-assert-lower      296
;  :arith-assert-upper      216
;  :arith-conflicts         26
;  :arith-eq-adapter        143
;  :arith-fixed-eqs         83
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               200
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              371
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2219
;  :mk-clause               414
;  :num-allocs              5594059
;  :num-checks              319
;  :propagations            212
;  :quant-instantiations    140
;  :rlimit-count            227337)
(assert (forall ((i__79@137@07 Int)) (!
  (implies
    (and
      (<
        i__79@137@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))
      (<= 0 i__79@137@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
          i__79@137@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
            i__79@137@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
            i__79@137@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@126@07)))))
    i__79@137@07))
  :qid |prog.l<no position>|)))
(declare-const $k@138@07 $Perm)
(assert ($Perm.isReadVar $k@138@07 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@138@07 $Perm.No) (< $Perm.No $k@138@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4458
;  :arith-add-rows          20
;  :arith-assert-diseq      84
;  :arith-assert-lower      298
;  :arith-assert-upper      217
;  :arith-conflicts         26
;  :arith-eq-adapter        144
;  :arith-fixed-eqs         83
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               201
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              371
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2224
;  :mk-clause               416
;  :num-allocs              5594059
;  :num-checks              320
;  :propagations            213
;  :quant-instantiations    140
;  :rlimit-count            227898)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@112@07 $k@122@07) $k@128@07) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          20
;  :arith-assert-diseq      84
;  :arith-assert-lower      298
;  :arith-assert-upper      218
;  :arith-conflicts         27
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         83
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               202
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2226
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              321
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            227976)
(assert (< $k@138@07 (+ (- $k@112@07 $k@122@07) $k@128@07)))
(assert (<= $Perm.No (- (+ (- $k@112@07 $k@122@07) $k@128@07) $k@138@07)))
(assert (<= (- (+ (- $k@112@07 $k@122@07) $k@128@07) $k@138@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@112@07 $k@122@07) $k@128@07) $k@138@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
; [eval] diz.Monitor_m.Main_alu != null
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      84
;  :arith-assert-lower      300
;  :arith-assert-upper      220
;  :arith-conflicts         28
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         84
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2230
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              322
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            228241)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      84
;  :arith-assert-lower      300
;  :arith-assert-upper      221
;  :arith-conflicts         29
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         85
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               204
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2231
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              323
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            228319)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      84
;  :arith-assert-lower      300
;  :arith-assert-upper      222
;  :arith-conflicts         30
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         86
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               205
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2232
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              324
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            228397)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      84
;  :arith-assert-lower      300
;  :arith-assert-upper      223
;  :arith-conflicts         31
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         87
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               206
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2233
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              325
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            228475)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      84
;  :arith-assert-lower      300
;  :arith-assert-upper      224
;  :arith-conflicts         32
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         88
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2234
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              326
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            228553)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      84
;  :arith-assert-lower      300
;  :arith-assert-upper      225
;  :arith-conflicts         33
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         89
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               208
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2235
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              327
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            228631)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      84
;  :arith-assert-lower      300
;  :arith-assert-upper      226
;  :arith-conflicts         34
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         90
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               209
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2236
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              328
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            228709)
; [eval] 0 <= diz.Monitor_m.Main_alu.ALU_RESULT
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      84
;  :arith-assert-lower      300
;  :arith-assert-upper      227
;  :arith-conflicts         35
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         91
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               210
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2237
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              329
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            228787)
; [eval] diz.Monitor_m.Main_alu.ALU_RESULT <= 16
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      84
;  :arith-assert-lower      300
;  :arith-assert-upper      228
;  :arith-conflicts         36
;  :arith-eq-adapter        145
;  :arith-fixed-eqs         92
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               211
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2238
;  :mk-clause               418
;  :num-allocs              5594059
;  :num-checks              330
;  :propagations            214
;  :quant-instantiations    140
;  :rlimit-count            228865)
(declare-const $k@139@07 $Perm)
(assert ($Perm.isReadVar $k@139@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@139@07 $Perm.No) (< $Perm.No $k@139@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4459
;  :arith-add-rows          21
;  :arith-assert-diseq      85
;  :arith-assert-lower      302
;  :arith-assert-upper      229
;  :arith-conflicts         36
;  :arith-eq-adapter        146
;  :arith-fixed-eqs         92
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               212
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              373
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2242
;  :mk-clause               420
;  :num-allocs              5594059
;  :num-checks              331
;  :propagations            215
;  :quant-instantiations    140
;  :rlimit-count            229063)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@113@07 $k@123@07) $k@130@07) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4460
;  :arith-add-rows          21
;  :arith-assert-diseq      85
;  :arith-assert-lower      302
;  :arith-assert-upper      230
;  :arith-conflicts         37
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         92
;  :arith-pivots            100
;  :binary-propagations     16
;  :conflicts               213
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              375
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2244
;  :mk-clause               422
;  :num-allocs              5594059
;  :num-checks              332
;  :propagations            216
;  :quant-instantiations    140
;  :rlimit-count            229141)
(assert (< $k@139@07 (+ (- $k@113@07 $k@123@07) $k@130@07)))
(assert (<= $Perm.No (- (+ (- $k@113@07 $k@123@07) $k@130@07) $k@139@07)))
(assert (<= (- (+ (- $k@113@07 $k@123@07) $k@130@07) $k@139@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@113@07 $k@123@07) $k@130@07) $k@139@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
; [eval] diz.Monitor_m.Main_dr != null
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4460
;  :arith-add-rows          22
;  :arith-assert-diseq      85
;  :arith-assert-lower      304
;  :arith-assert-upper      232
;  :arith-conflicts         38
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         93
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               214
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              375
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2248
;  :mk-clause               422
;  :num-allocs              5594059
;  :num-checks              333
;  :propagations            216
;  :quant-instantiations    140
;  :rlimit-count            229413)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4460
;  :arith-add-rows          22
;  :arith-assert-diseq      85
;  :arith-assert-lower      304
;  :arith-assert-upper      232
;  :arith-conflicts         38
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         93
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               214
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              375
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2248
;  :mk-clause               422
;  :num-allocs              5594059
;  :num-checks              334
;  :propagations            216
;  :quant-instantiations    140
;  :rlimit-count            229426)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4460
;  :arith-add-rows          22
;  :arith-assert-diseq      85
;  :arith-assert-lower      304
;  :arith-assert-upper      233
;  :arith-conflicts         39
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         94
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               215
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              375
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2249
;  :mk-clause               422
;  :num-allocs              5594059
;  :num-checks              335
;  :propagations            216
;  :quant-instantiations    140
;  :rlimit-count            229504)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4460
;  :arith-add-rows          22
;  :arith-assert-diseq      85
;  :arith-assert-lower      304
;  :arith-assert-upper      234
;  :arith-conflicts         40
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         95
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               216
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              375
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2250
;  :mk-clause               422
;  :num-allocs              5594059
;  :num-checks              336
;  :propagations            216
;  :quant-instantiations    140
;  :rlimit-count            229582)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4460
;  :arith-add-rows          22
;  :arith-assert-diseq      85
;  :arith-assert-lower      304
;  :arith-assert-upper      235
;  :arith-conflicts         41
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         96
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               217
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              375
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2251
;  :mk-clause               422
;  :num-allocs              5594059
;  :num-checks              337
;  :propagations            216
;  :quant-instantiations    140
;  :rlimit-count            229660)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4460
;  :arith-add-rows          22
;  :arith-assert-diseq      85
;  :arith-assert-lower      304
;  :arith-assert-upper      236
;  :arith-conflicts         42
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         97
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               218
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              375
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2252
;  :mk-clause               422
;  :num-allocs              5594059
;  :num-checks              338
;  :propagations            216
;  :quant-instantiations    140
;  :rlimit-count            229738)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@113@07 $k@123@07) $k@130@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4460
;  :arith-add-rows          22
;  :arith-assert-diseq      85
;  :arith-assert-lower      304
;  :arith-assert-upper      237
;  :arith-conflicts         43
;  :arith-eq-adapter        147
;  :arith-fixed-eqs         98
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               219
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              375
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2253
;  :mk-clause               422
;  :num-allocs              5594059
;  :num-checks              339
;  :propagations            216
;  :quant-instantiations    140
;  :rlimit-count            229816)
(declare-const $k@140@07 $Perm)
(assert ($Perm.isReadVar $k@140@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@140@07 $Perm.No) (< $Perm.No $k@140@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4460
;  :arith-add-rows          22
;  :arith-assert-diseq      86
;  :arith-assert-lower      306
;  :arith-assert-upper      238
;  :arith-conflicts         43
;  :arith-eq-adapter        148
;  :arith-fixed-eqs         98
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               220
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              375
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2257
;  :mk-clause               424
;  :num-allocs              5594059
;  :num-checks              340
;  :propagations            217
;  :quant-instantiations    140
;  :rlimit-count            230014)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= (+ (- $k@114@07 $k@124@07) $k@132@07) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4461
;  :arith-add-rows          22
;  :arith-assert-diseq      86
;  :arith-assert-lower      306
;  :arith-assert-upper      239
;  :arith-conflicts         44
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         98
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               221
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              377
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2259
;  :mk-clause               426
;  :num-allocs              5594059
;  :num-checks              341
;  :propagations            218
;  :quant-instantiations    140
;  :rlimit-count            230094)
(assert (< $k@140@07 (+ (- $k@114@07 $k@124@07) $k@132@07)))
(assert (<= $Perm.No (- (+ (- $k@114@07 $k@124@07) $k@132@07) $k@140@07)))
(assert (<= (- (+ (- $k@114@07 $k@124@07) $k@132@07) $k@140@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@114@07 $k@124@07) $k@132@07) $k@140@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
; [eval] diz.Monitor_m.Main_mon != null
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@114@07 $k@124@07) $k@132@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4461
;  :arith-add-rows          24
;  :arith-assert-diseq      86
;  :arith-assert-lower      308
;  :arith-assert-upper      241
;  :arith-conflicts         45
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         99
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               222
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              377
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2263
;  :mk-clause               426
;  :num-allocs              5594059
;  :num-checks              342
;  :propagations            218
;  :quant-instantiations    140
;  :rlimit-count            230363)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4461
;  :arith-add-rows          24
;  :arith-assert-diseq      86
;  :arith-assert-lower      308
;  :arith-assert-upper      241
;  :arith-conflicts         45
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         99
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               222
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              377
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2263
;  :mk-clause               426
;  :num-allocs              5594059
;  :num-checks              343
;  :propagations            218
;  :quant-instantiations    140
;  :rlimit-count            230376)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@114@07 $k@124@07) $k@132@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4461
;  :arith-add-rows          24
;  :arith-assert-diseq      86
;  :arith-assert-lower      308
;  :arith-assert-upper      242
;  :arith-conflicts         46
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         100
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               223
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              377
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2264
;  :mk-clause               426
;  :num-allocs              5594059
;  :num-checks              344
;  :propagations            218
;  :quant-instantiations    140
;  :rlimit-count            230457)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))))))))))))))))))
  $t@133@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4461
;  :arith-add-rows          24
;  :arith-assert-diseq      86
;  :arith-assert-lower      308
;  :arith-assert-upper      242
;  :arith-conflicts         46
;  :arith-eq-adapter        149
;  :arith-fixed-eqs         100
;  :arith-pivots            101
;  :binary-propagations     16
;  :conflicts               223
;  :datatype-accessor-ax    320
;  :datatype-constructor-ax 912
;  :datatype-occurs-check   368
;  :datatype-splits         718
;  :decisions               868
;  :del-clause              377
;  :final-checks            78
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2264
;  :mk-clause               426
;  :num-allocs              5594059
;  :num-checks              345
;  :propagations            218
;  :quant-instantiations    140
;  :rlimit-count            230468)
(push) ; 9
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4738
;  :arith-add-rows          27
;  :arith-assert-diseq      90
;  :arith-assert-lower      326
;  :arith-assert-upper      252
;  :arith-conflicts         46
;  :arith-eq-adapter        159
;  :arith-fixed-eqs         106
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               223
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              414
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2376
;  :mk-clause               463
;  :num-allocs              5594059
;  :num-checks              346
;  :propagations            238
;  :quant-instantiations    147
;  :rlimit-count            232607
;  :time                    0.00)
(declare-const $k@141@07 $Perm)
(assert ($Perm.isReadVar $k@141@07 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4738
;  :arith-add-rows          27
;  :arith-assert-diseq      91
;  :arith-assert-lower      328
;  :arith-assert-upper      254
;  :arith-conflicts         47
;  :arith-eq-adapter        160
;  :arith-fixed-eqs         107
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               224
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              414
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2381
;  :mk-clause               465
;  :num-allocs              5594059
;  :num-checks              347
;  :propagations            239
;  :quant-instantiations    147
;  :rlimit-count            232834)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@141@07 $Perm.No) (< $Perm.No $k@141@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4738
;  :arith-add-rows          27
;  :arith-assert-diseq      91
;  :arith-assert-lower      328
;  :arith-assert-upper      254
;  :arith-conflicts         47
;  :arith-eq-adapter        160
;  :arith-fixed-eqs         107
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               225
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              414
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2381
;  :mk-clause               465
;  :num-allocs              5594059
;  :num-checks              348
;  :propagations            239
;  :quant-instantiations    147
;  :rlimit-count            232884)
(set-option :timeout 10)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
  $t@129@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4738
;  :arith-add-rows          27
;  :arith-assert-diseq      91
;  :arith-assert-lower      328
;  :arith-assert-upper      254
;  :arith-conflicts         47
;  :arith-eq-adapter        160
;  :arith-fixed-eqs         107
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               225
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              414
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2381
;  :mk-clause               465
;  :num-allocs              5594059
;  :num-checks              349
;  :propagations            239
;  :quant-instantiations    147
;  :rlimit-count            232895)
(push) ; 9
(assert (not (not (= (+ (- $k@115@07 $k@125@07) $k@134@07) $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4739
;  :arith-add-rows          27
;  :arith-assert-diseq      91
;  :arith-assert-lower      328
;  :arith-assert-upper      255
;  :arith-conflicts         48
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         107
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               226
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              416
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2383
;  :mk-clause               467
;  :num-allocs              5594059
;  :num-checks              350
;  :propagations            240
;  :quant-instantiations    147
;  :rlimit-count            232973)
(assert (< $k@141@07 (+ (- $k@115@07 $k@125@07) $k@134@07)))
(assert (<= $Perm.No (- (+ (- $k@115@07 $k@125@07) $k@134@07) $k@141@07)))
(assert (<= (- (+ (- $k@115@07 $k@125@07) $k@134@07) $k@141@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@115@07 $k@125@07) $k@134@07) $k@141@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
      $Ref.null))))
; [eval] diz.Monitor_m.Main_alu.ALU_m == diz.Monitor_m
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@112@07 $k@122@07) $k@128@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4739
;  :arith-add-rows          28
;  :arith-assert-diseq      91
;  :arith-assert-lower      330
;  :arith-assert-upper      257
;  :arith-conflicts         49
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         108
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              416
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2387
;  :mk-clause               467
;  :num-allocs              5594059
;  :num-checks              351
;  :propagations            240
;  :quant-instantiations    147
;  :rlimit-count            233238)
(push) ; 9
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
  $t@129@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4739
;  :arith-add-rows          28
;  :arith-assert-diseq      91
;  :arith-assert-lower      330
;  :arith-assert-upper      257
;  :arith-conflicts         49
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         108
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              416
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2387
;  :mk-clause               467
;  :num-allocs              5594059
;  :num-checks              352
;  :propagations            240
;  :quant-instantiations    147
;  :rlimit-count            233249)
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@115@07 $k@125@07) $k@134@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4739
;  :arith-add-rows          28
;  :arith-assert-diseq      91
;  :arith-assert-lower      330
;  :arith-assert-upper      258
;  :arith-conflicts         50
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         109
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               228
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              416
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2388
;  :mk-clause               467
;  :num-allocs              5594059
;  :num-checks              353
;  :propagations            240
;  :quant-instantiations    147
;  :rlimit-count            233327)
; [eval] diz.Monitor_m.Main_mon == diz
(push) ; 9
(assert (not (< $Perm.No (+ (- $k@114@07 $k@124@07) $k@132@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4739
;  :arith-add-rows          28
;  :arith-assert-diseq      91
;  :arith-assert-lower      330
;  :arith-assert-upper      259
;  :arith-conflicts         51
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         110
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               229
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              416
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2389
;  :mk-clause               467
;  :num-allocs              5594059
;  :num-checks              354
;  :propagations            240
;  :quant-instantiations    147
;  :rlimit-count            233408)
(set-option :timeout 0)
(push) ; 9
(assert (not (= $t@133@07 diz@76@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4739
;  :arith-add-rows          28
;  :arith-assert-diseq      91
;  :arith-assert-lower      330
;  :arith-assert-upper      259
;  :arith-conflicts         51
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         110
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               229
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              416
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2389
;  :mk-clause               467
;  :num-allocs              5594059
;  :num-checks              355
;  :propagations            240
;  :quant-instantiations    147
;  :rlimit-count            233419)
(assert (= $t@133@07 diz@76@07))
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4739
;  :arith-add-rows          28
;  :arith-assert-diseq      91
;  :arith-assert-lower      330
;  :arith-assert-upper      259
;  :arith-conflicts         51
;  :arith-eq-adapter        161
;  :arith-fixed-eqs         110
;  :arith-pivots            113
;  :binary-propagations     16
;  :conflicts               229
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 987
;  :datatype-occurs-check   415
;  :datatype-splits         790
;  :decisions               940
;  :del-clause              416
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  5.04
;  :mk-bool-var             2389
;  :mk-clause               467
;  :num-allocs              5594059
;  :num-checks              356
;  :propagations            240
;  :quant-instantiations    147
;  :rlimit-count            233435)
(pop) ; 8
(push) ; 8
; [else-branch: 24 | !(First:(Second:(Second:(Second:($t@110@07))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@110@07))))))[1] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
          1)
        (- 0 2))))))
(pop) ; 8
(set-option :timeout 10)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07)))))))))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4979
;  :arith-add-rows          29
;  :arith-assert-diseq      91
;  :arith-assert-lower      333
;  :arith-assert-upper      263
;  :arith-conflicts         51
;  :arith-eq-adapter        165
;  :arith-fixed-eqs         111
;  :arith-offset-eqs        2
;  :arith-pivots            125
;  :binary-propagations     16
;  :conflicts               230
;  :datatype-accessor-ax    330
;  :datatype-constructor-ax 1066
;  :datatype-occurs-check   429
;  :datatype-splits         850
;  :decisions               1015
;  :del-clause              432
;  :final-checks            86
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              5.04
;  :memory                  4.95
;  :mk-bool-var             2463
;  :mk-clause               473
;  :num-allocs              5796908
;  :num-checks              357
;  :propagations            245
;  :quant-instantiations    147
;  :rlimit-count            235439
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5191
;  :arith-add-rows          29
;  :arith-assert-diseq      91
;  :arith-assert-lower      335
;  :arith-assert-upper      265
;  :arith-conflicts         51
;  :arith-eq-adapter        167
;  :arith-fixed-eqs         113
;  :arith-offset-eqs        2
;  :arith-pivots            129
;  :binary-propagations     16
;  :conflicts               231
;  :datatype-accessor-ax    335
;  :datatype-constructor-ax 1143
;  :datatype-occurs-check   443
;  :datatype-splits         909
;  :decisions               1088
;  :del-clause              438
;  :final-checks            90
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  5.05
;  :mk-bool-var             2531
;  :mk-clause               479
;  :num-allocs              6001876
;  :num-checks              358
;  :propagations            251
;  :quant-instantiations    147
;  :rlimit-count            237109
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5410
;  :arith-add-rows          31
;  :arith-assert-diseq      91
;  :arith-assert-lower      338
;  :arith-assert-upper      268
;  :arith-conflicts         51
;  :arith-eq-adapter        170
;  :arith-fixed-eqs         116
;  :arith-offset-eqs        2
;  :arith-pivots            135
;  :binary-propagations     16
;  :conflicts               232
;  :datatype-accessor-ax    340
;  :datatype-constructor-ax 1222
;  :datatype-occurs-check   457
;  :datatype-splits         969
;  :decisions               1162
;  :del-clause              442
;  :final-checks            93
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  5.05
;  :mk-bool-var             2603
;  :mk-clause               483
;  :num-allocs              6413675
;  :num-checks              359
;  :propagations            255
;  :quant-instantiations    147
;  :rlimit-count            238823
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5629
;  :arith-add-rows          33
;  :arith-assert-diseq      91
;  :arith-assert-lower      341
;  :arith-assert-upper      271
;  :arith-conflicts         51
;  :arith-eq-adapter        173
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        2
;  :arith-pivots            141
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    345
;  :datatype-constructor-ax 1301
;  :datatype-occurs-check   471
;  :datatype-splits         1029
;  :decisions               1236
;  :del-clause              446
;  :final-checks            96
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  5.05
;  :mk-bool-var             2675
;  :mk-clause               487
;  :num-allocs              6828156
;  :num-checks              360
;  :propagations            259
;  :quant-instantiations    147
;  :rlimit-count            240537
;  :time                    0.00)
; [eval] !(diz.Monitor_m.Main_process_state[0] != -1 || diz.Monitor_m.Main_event_state[1] != -2)
; [eval] diz.Monitor_m.Main_process_state[0] != -1 || diz.Monitor_m.Main_event_state[1] != -2
; [eval] diz.Monitor_m.Main_process_state[0] != -1
; [eval] diz.Monitor_m.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5629
;  :arith-add-rows          33
;  :arith-assert-diseq      91
;  :arith-assert-lower      341
;  :arith-assert-upper      271
;  :arith-conflicts         51
;  :arith-eq-adapter        173
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        2
;  :arith-pivots            141
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    345
;  :datatype-constructor-ax 1301
;  :datatype-occurs-check   471
;  :datatype-splits         1029
;  :decisions               1236
;  :del-clause              446
;  :final-checks            96
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  5.05
;  :mk-bool-var             2675
;  :mk-clause               487
;  :num-allocs              6828156
;  :num-checks              361
;  :propagations            259
;  :quant-instantiations    147
;  :rlimit-count            240552)
; [eval] -1
(push) ; 8
; [then-branch: 37 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1 | live]
; [else-branch: 37 | First:(Second:(Second:(Second:($t@110@07))))[0] == -1 | live]
(push) ; 9
; [then-branch: 37 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      0)
    (- 0 1))))
(pop) ; 9
(push) ; 9
; [else-branch: 37 | First:(Second:(Second:(Second:($t@110@07))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    0)
  (- 0 1)))
; [eval] diz.Monitor_m.Main_event_state[1] != -2
; [eval] diz.Monitor_m.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5630
;  :arith-add-rows          33
;  :arith-assert-diseq      91
;  :arith-assert-lower      341
;  :arith-assert-upper      271
;  :arith-conflicts         51
;  :arith-eq-adapter        173
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        2
;  :arith-pivots            141
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    345
;  :datatype-constructor-ax 1301
;  :datatype-occurs-check   471
;  :datatype-splits         1029
;  :decisions               1236
;  :del-clause              446
;  :final-checks            96
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  5.05
;  :mk-bool-var             2676
;  :mk-clause               487
;  :num-allocs              6828156
;  :num-checks              362
;  :propagations            259
;  :quant-instantiations    147
;  :rlimit-count            240710)
; [eval] -2
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 8
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
        1)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5833
;  :arith-add-rows          33
;  :arith-assert-diseq      91
;  :arith-assert-lower      343
;  :arith-assert-upper      273
;  :arith-conflicts         51
;  :arith-eq-adapter        175
;  :arith-fixed-eqs         121
;  :arith-offset-eqs        2
;  :arith-pivots            145
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    349
;  :datatype-constructor-ax 1362
;  :datatype-occurs-check   484
;  :datatype-splits         1087
;  :decisions               1293
;  :del-clause              448
;  :final-checks            99
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2741
;  :mk-clause               489
;  :num-allocs              7036504
;  :num-checks              363
;  :propagations            263
;  :quant-instantiations    147
;  :rlimit-count            242336
;  :time                    0.00)
(push) ; 8
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
          1)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6042
;  :arith-add-rows          34
;  :arith-assert-diseq      94
;  :arith-assert-lower      356
;  :arith-assert-upper      280
;  :arith-conflicts         51
;  :arith-eq-adapter        182
;  :arith-fixed-eqs         125
;  :arith-offset-eqs        2
;  :arith-pivots            153
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              475
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2829
;  :mk-clause               516
;  :num-allocs              7036504
;  :num-checks              364
;  :propagations            277
;  :quant-instantiations    151
;  :rlimit-count            244198
;  :time                    0.00)
; [then-branch: 38 | !(First:(Second:(Second:(Second:($t@110@07))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@110@07))))))[1] != -2) | live]
; [else-branch: 38 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@110@07))))))[1] != -2 | live]
(push) ; 8
; [then-branch: 38 | !(First:(Second:(Second:(Second:($t@110@07))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@110@07))))))[1] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
          1)
        (- 0 2))))))
; Loop head block: Re-establish invariant
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6044
;  :arith-add-rows          34
;  :arith-assert-diseq      94
;  :arith-assert-lower      356
;  :arith-assert-upper      280
;  :arith-conflicts         51
;  :arith-eq-adapter        182
;  :arith-fixed-eqs         125
;  :arith-offset-eqs        2
;  :arith-pivots            153
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              475
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2831
;  :mk-clause               516
;  :num-allocs              7036504
;  :num-checks              365
;  :propagations            277
;  :quant-instantiations    151
;  :rlimit-count            244415)
; [eval] diz.Monitor_m != null
; [eval] |diz.Monitor_m.Main_process_state| == 1
; [eval] |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_event_state| == 2
; [eval] |diz.Monitor_m.Main_event_state|
; [eval] (forall i__78: Int :: { diz.Monitor_m.Main_process_state[i__78] } 0 <= i__78 && i__78 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__78] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|)
(declare-const i__78@142@07 Int)
(push) ; 9
; [eval] 0 <= i__78 && i__78 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__78] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= i__78 && i__78 < |diz.Monitor_m.Main_process_state|
; [eval] 0 <= i__78
(push) ; 10
; [then-branch: 39 | 0 <= i__78@142@07 | live]
; [else-branch: 39 | !(0 <= i__78@142@07) | live]
(push) ; 11
; [then-branch: 39 | 0 <= i__78@142@07]
(assert (<= 0 i__78@142@07))
; [eval] i__78 < |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_process_state|
(pop) ; 11
(push) ; 11
; [else-branch: 39 | !(0 <= i__78@142@07)]
(assert (not (<= 0 i__78@142@07)))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(push) ; 10
; [then-branch: 40 | i__78@142@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i__78@142@07 | live]
; [else-branch: 40 | !(i__78@142@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i__78@142@07) | live]
(push) ; 11
; [then-branch: 40 | i__78@142@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i__78@142@07]
(assert (and
  (<
    i__78@142@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
  (<= 0 i__78@142@07)))
; [eval] diz.Monitor_m.Main_process_state[i__78] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__78] == -1
; [eval] diz.Monitor_m.Main_process_state[i__78]
(push) ; 12
(assert (not (>= i__78@142@07 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6045
;  :arith-add-rows          34
;  :arith-assert-diseq      94
;  :arith-assert-lower      357
;  :arith-assert-upper      281
;  :arith-conflicts         51
;  :arith-eq-adapter        182
;  :arith-fixed-eqs         126
;  :arith-offset-eqs        2
;  :arith-pivots            153
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              475
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2833
;  :mk-clause               516
;  :num-allocs              7036504
;  :num-checks              366
;  :propagations            277
;  :quant-instantiations    151
;  :rlimit-count            244555)
; [eval] -1
(push) ; 12
; [then-branch: 41 | First:(Second:(Second:(Second:($t@110@07))))[i__78@142@07] == -1 | live]
; [else-branch: 41 | First:(Second:(Second:(Second:($t@110@07))))[i__78@142@07] != -1 | live]
(push) ; 13
; [then-branch: 41 | First:(Second:(Second:(Second:($t@110@07))))[i__78@142@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i__78@142@07)
  (- 0 1)))
(pop) ; 13
(push) ; 13
; [else-branch: 41 | First:(Second:(Second:(Second:($t@110@07))))[i__78@142@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      i__78@142@07)
    (- 0 1))))
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__78] && diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__78]
; [eval] diz.Monitor_m.Main_process_state[i__78]
(push) ; 14
(assert (not (>= i__78@142@07 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      94
;  :arith-assert-lower      357
;  :arith-assert-upper      281
;  :arith-conflicts         51
;  :arith-eq-adapter        182
;  :arith-fixed-eqs         126
;  :arith-offset-eqs        2
;  :arith-pivots            153
;  :binary-propagations     16
;  :conflicts               234
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              475
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2834
;  :mk-clause               516
;  :num-allocs              7036504
;  :num-checks              367
;  :propagations            277
;  :quant-instantiations    151
;  :rlimit-count            244723)
(push) ; 14
; [then-branch: 42 | 0 <= First:(Second:(Second:(Second:($t@110@07))))[i__78@142@07] | live]
; [else-branch: 42 | !(0 <= First:(Second:(Second:(Second:($t@110@07))))[i__78@142@07]) | live]
(push) ; 15
; [then-branch: 42 | 0 <= First:(Second:(Second:(Second:($t@110@07))))[i__78@142@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i__78@142@07)))
; [eval] diz.Monitor_m.Main_process_state[i__78] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__78]
(push) ; 16
(assert (not (>= i__78@142@07 0)))
(check-sat)
; unsat
(pop) ; 16
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      94
;  :arith-assert-lower      357
;  :arith-assert-upper      281
;  :arith-conflicts         51
;  :arith-eq-adapter        182
;  :arith-fixed-eqs         126
;  :arith-offset-eqs        2
;  :arith-pivots            153
;  :binary-propagations     16
;  :conflicts               234
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              475
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2835
;  :mk-clause               516
;  :num-allocs              7036504
;  :num-checks              368
;  :propagations            277
;  :quant-instantiations    151
;  :rlimit-count            244828)
; [eval] |diz.Monitor_m.Main_event_state|
(pop) ; 15
(push) ; 15
; [else-branch: 42 | !(0 <= First:(Second:(Second:(Second:($t@110@07))))[i__78@142@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
      i__78@142@07))))
(pop) ; 15
(pop) ; 14
; Joined path conditions
; Joined path conditions
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 40 | !(i__78@142@07 < |First:(Second:(Second:(Second:($t@110@07))))| && 0 <= i__78@142@07)]
(assert (not
  (and
    (<
      i__78@142@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
    (<= 0 i__78@142@07))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 9
(assert (not (forall ((i__78@142@07 Int)) (!
  (implies
    (and
      (<
        i__78@142@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
      (<= 0 i__78@142@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          i__78@142@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i__78@142@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i__78@142@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i__78@142@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      96
;  :arith-assert-lower      358
;  :arith-assert-upper      282
;  :arith-conflicts         51
;  :arith-eq-adapter        183
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            153
;  :binary-propagations     16
;  :conflicts               235
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2843
;  :mk-clause               530
;  :num-allocs              7036504
;  :num-checks              369
;  :propagations            279
;  :quant-instantiations    152
;  :rlimit-count            245271)
(assert (forall ((i__78@142@07 Int)) (!
  (implies
    (and
      (<
        i__78@142@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
      (<= 0 i__78@142@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
          i__78@142@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i__78@142@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
            i__78@142@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
    i__78@142@07))
  :qid |prog.l<no position>|)))
(declare-const $k@143@07 $Perm)
(assert ($Perm.isReadVar $k@143@07 $Perm.Write))
(push) ; 9
(assert (not (or (= $k@143@07 $Perm.No) (< $Perm.No $k@143@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      360
;  :arith-assert-upper      283
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            153
;  :binary-propagations     16
;  :conflicts               236
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2848
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              370
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            245832)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@112@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      360
;  :arith-assert-upper      283
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            153
;  :binary-propagations     16
;  :conflicts               236
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2848
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              371
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            245843)
(assert (< $k@143@07 $k@112@07))
(assert (<= $Perm.No (- $k@112@07 $k@143@07)))
(assert (<= (- $k@112@07 $k@143@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@112@07 $k@143@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
; [eval] diz.Monitor_m.Main_alu != null
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      362
;  :arith-assert-upper      284
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               237
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2851
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              372
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            246057)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      362
;  :arith-assert-upper      284
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               238
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2851
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              373
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            246105)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      362
;  :arith-assert-upper      284
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               239
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2851
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              374
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            246153)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      362
;  :arith-assert-upper      284
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               240
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2851
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              375
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            246201)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      362
;  :arith-assert-upper      284
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               241
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2851
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              376
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            246249)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      362
;  :arith-assert-upper      284
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               242
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2851
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              377
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            246297)
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      362
;  :arith-assert-upper      284
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               243
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2851
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              378
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            246345)
; [eval] 0 <= diz.Monitor_m.Main_alu.ALU_RESULT
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      362
;  :arith-assert-upper      284
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               244
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2851
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              379
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            246393)
; [eval] diz.Monitor_m.Main_alu.ALU_RESULT <= 16
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      97
;  :arith-assert-lower      362
;  :arith-assert-upper      284
;  :arith-conflicts         51
;  :arith-eq-adapter        184
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               245
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2851
;  :mk-clause               532
;  :num-allocs              7036504
;  :num-checks              380
;  :propagations            280
;  :quant-instantiations    152
;  :rlimit-count            246441)
(declare-const $k@144@07 $Perm)
(assert ($Perm.isReadVar $k@144@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@144@07 $Perm.No) (< $Perm.No $k@144@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      98
;  :arith-assert-lower      364
;  :arith-assert-upper      285
;  :arith-conflicts         51
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               246
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2855
;  :mk-clause               534
;  :num-allocs              7036504
;  :num-checks              381
;  :propagations            281
;  :quant-instantiations    152
;  :rlimit-count            246640)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@113@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      98
;  :arith-assert-lower      364
;  :arith-assert-upper      285
;  :arith-conflicts         51
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               246
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2855
;  :mk-clause               534
;  :num-allocs              7036504
;  :num-checks              382
;  :propagations            281
;  :quant-instantiations    152
;  :rlimit-count            246651)
(assert (< $k@144@07 $k@113@07))
(assert (<= $Perm.No (- $k@113@07 $k@144@07)))
(assert (<= (- $k@113@07 $k@144@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@113@07 $k@144@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
; [eval] diz.Monitor_m.Main_dr != null
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      98
;  :arith-assert-lower      366
;  :arith-assert-upper      286
;  :arith-conflicts         51
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               247
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2858
;  :mk-clause               534
;  :num-allocs              7036504
;  :num-checks              383
;  :propagations            281
;  :quant-instantiations    152
;  :rlimit-count            246859)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      98
;  :arith-assert-lower      366
;  :arith-assert-upper      286
;  :arith-conflicts         51
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               247
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2858
;  :mk-clause               534
;  :num-allocs              7036504
;  :num-checks              384
;  :propagations            281
;  :quant-instantiations    152
;  :rlimit-count            246872)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      98
;  :arith-assert-lower      366
;  :arith-assert-upper      286
;  :arith-conflicts         51
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               248
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2858
;  :mk-clause               534
;  :num-allocs              7036504
;  :num-checks              385
;  :propagations            281
;  :quant-instantiations    152
;  :rlimit-count            246920)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      98
;  :arith-assert-lower      366
;  :arith-assert-upper      286
;  :arith-conflicts         51
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               249
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2858
;  :mk-clause               534
;  :num-allocs              7036504
;  :num-checks              386
;  :propagations            281
;  :quant-instantiations    152
;  :rlimit-count            246968)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      98
;  :arith-assert-lower      366
;  :arith-assert-upper      286
;  :arith-conflicts         51
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               250
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2858
;  :mk-clause               534
;  :num-allocs              7036504
;  :num-checks              387
;  :propagations            281
;  :quant-instantiations    152
;  :rlimit-count            247016)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      98
;  :arith-assert-lower      366
;  :arith-assert-upper      286
;  :arith-conflicts         51
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               251
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2858
;  :mk-clause               534
;  :num-allocs              7036504
;  :num-checks              388
;  :propagations            281
;  :quant-instantiations    152
;  :rlimit-count            247064)
(push) ; 9
(assert (not (< $Perm.No $k@113@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      98
;  :arith-assert-lower      366
;  :arith-assert-upper      286
;  :arith-conflicts         51
;  :arith-eq-adapter        185
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               252
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2858
;  :mk-clause               534
;  :num-allocs              7036504
;  :num-checks              389
;  :propagations            281
;  :quant-instantiations    152
;  :rlimit-count            247112)
(declare-const $k@145@07 $Perm)
(assert ($Perm.isReadVar $k@145@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@145@07 $Perm.No) (< $Perm.No $k@145@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      99
;  :arith-assert-lower      368
;  :arith-assert-upper      287
;  :arith-conflicts         51
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               253
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2862
;  :mk-clause               536
;  :num-allocs              7036504
;  :num-checks              390
;  :propagations            282
;  :quant-instantiations    152
;  :rlimit-count            247310)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@114@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      99
;  :arith-assert-lower      368
;  :arith-assert-upper      287
;  :arith-conflicts         51
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            154
;  :binary-propagations     16
;  :conflicts               253
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2862
;  :mk-clause               536
;  :num-allocs              7036504
;  :num-checks              391
;  :propagations            282
;  :quant-instantiations    152
;  :rlimit-count            247321)
(assert (< $k@145@07 $k@114@07))
(assert (<= $Perm.No (- $k@114@07 $k@145@07)))
(assert (<= (- $k@114@07 $k@145@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@114@07 $k@145@07))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@110@07)) $Ref.null))))
; [eval] diz.Monitor_m.Main_mon != null
(push) ; 9
(assert (not (< $Perm.No $k@114@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      99
;  :arith-assert-lower      370
;  :arith-assert-upper      288
;  :arith-conflicts         51
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            155
;  :binary-propagations     16
;  :conflicts               254
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2865
;  :mk-clause               536
;  :num-allocs              7036504
;  :num-checks              392
;  :propagations            282
;  :quant-instantiations    152
;  :rlimit-count            247535)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      99
;  :arith-assert-lower      370
;  :arith-assert-upper      288
;  :arith-conflicts         51
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            155
;  :binary-propagations     16
;  :conflicts               254
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2865
;  :mk-clause               536
;  :num-allocs              7036504
;  :num-checks              393
;  :propagations            282
;  :quant-instantiations    152
;  :rlimit-count            247548)
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@114@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6046
;  :arith-add-rows          34
;  :arith-assert-diseq      99
;  :arith-assert-lower      370
;  :arith-assert-upper      288
;  :arith-conflicts         51
;  :arith-eq-adapter        186
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        2
;  :arith-pivots            155
;  :binary-propagations     16
;  :conflicts               255
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1423
;  :datatype-occurs-check   497
;  :datatype-splits         1145
;  :decisions               1351
;  :del-clause              489
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2865
;  :mk-clause               536
;  :num-allocs              7036504
;  :num-checks              394
;  :propagations            282
;  :quant-instantiations    152
;  :rlimit-count            247596)
(push) ; 9
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6247
;  :arith-add-rows          34
;  :arith-assert-diseq      99
;  :arith-assert-lower      372
;  :arith-assert-upper      290
;  :arith-conflicts         51
;  :arith-eq-adapter        188
;  :arith-fixed-eqs         129
;  :arith-offset-eqs        2
;  :arith-pivots            159
;  :binary-propagations     16
;  :conflicts               255
;  :datatype-accessor-ax    357
;  :datatype-constructor-ax 1484
;  :datatype-occurs-check   510
;  :datatype-splits         1203
;  :decisions               1408
;  :del-clause              491
;  :final-checks            105
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2928
;  :mk-clause               538
;  :num-allocs              7036504
;  :num-checks              395
;  :propagations            286
;  :quant-instantiations    152
;  :rlimit-count            249051
;  :time                    0.00)
(declare-const $k@146@07 $Perm)
(assert ($Perm.isReadVar $k@146@07 $Perm.Write))
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6247
;  :arith-add-rows          34
;  :arith-assert-diseq      100
;  :arith-assert-lower      374
;  :arith-assert-upper      291
;  :arith-conflicts         51
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         129
;  :arith-offset-eqs        2
;  :arith-pivots            159
;  :binary-propagations     16
;  :conflicts               256
;  :datatype-accessor-ax    357
;  :datatype-constructor-ax 1484
;  :datatype-occurs-check   510
;  :datatype-splits         1203
;  :decisions               1408
;  :del-clause              491
;  :final-checks            105
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2932
;  :mk-clause               540
;  :num-allocs              7036504
;  :num-checks              396
;  :propagations            287
;  :quant-instantiations    152
;  :rlimit-count            249247)
(set-option :timeout 0)
(push) ; 9
(assert (not (or (= $k@146@07 $Perm.No) (< $Perm.No $k@146@07))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6247
;  :arith-add-rows          34
;  :arith-assert-diseq      100
;  :arith-assert-lower      374
;  :arith-assert-upper      291
;  :arith-conflicts         51
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         129
;  :arith-offset-eqs        2
;  :arith-pivots            159
;  :binary-propagations     16
;  :conflicts               257
;  :datatype-accessor-ax    357
;  :datatype-constructor-ax 1484
;  :datatype-occurs-check   510
;  :datatype-splits         1203
;  :decisions               1408
;  :del-clause              491
;  :final-checks            105
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2932
;  :mk-clause               540
;  :num-allocs              7036504
;  :num-checks              397
;  :propagations            287
;  :quant-instantiations    152
;  :rlimit-count            249297)
(set-option :timeout 10)
(push) ; 9
(assert (not (not (= $k@115@07 $Perm.No))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6247
;  :arith-add-rows          34
;  :arith-assert-diseq      100
;  :arith-assert-lower      374
;  :arith-assert-upper      291
;  :arith-conflicts         51
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         129
;  :arith-offset-eqs        2
;  :arith-pivots            159
;  :binary-propagations     16
;  :conflicts               257
;  :datatype-accessor-ax    357
;  :datatype-constructor-ax 1484
;  :datatype-occurs-check   510
;  :datatype-splits         1203
;  :decisions               1408
;  :del-clause              491
;  :final-checks            105
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2932
;  :mk-clause               540
;  :num-allocs              7036504
;  :num-checks              398
;  :propagations            287
;  :quant-instantiations    152
;  :rlimit-count            249308)
(assert (< $k@146@07 $k@115@07))
(assert (<= $Perm.No (- $k@115@07 $k@146@07)))
(assert (<= (- $k@115@07 $k@146@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@115@07 $k@146@07))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07))))))))))
      $Ref.null))))
; [eval] diz.Monitor_m.Main_alu.ALU_m == diz.Monitor_m
(push) ; 9
(assert (not (< $Perm.No $k@112@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6247
;  :arith-add-rows          34
;  :arith-assert-diseq      100
;  :arith-assert-lower      376
;  :arith-assert-upper      292
;  :arith-conflicts         51
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         129
;  :arith-offset-eqs        2
;  :arith-pivots            160
;  :binary-propagations     16
;  :conflicts               258
;  :datatype-accessor-ax    357
;  :datatype-constructor-ax 1484
;  :datatype-occurs-check   510
;  :datatype-splits         1203
;  :decisions               1408
;  :del-clause              491
;  :final-checks            105
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2935
;  :mk-clause               540
;  :num-allocs              7036504
;  :num-checks              399
;  :propagations            287
;  :quant-instantiations    152
;  :rlimit-count            249522)
(push) ; 9
(assert (not (< $Perm.No $k@115@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6247
;  :arith-add-rows          34
;  :arith-assert-diseq      100
;  :arith-assert-lower      376
;  :arith-assert-upper      292
;  :arith-conflicts         51
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         129
;  :arith-offset-eqs        2
;  :arith-pivots            160
;  :binary-propagations     16
;  :conflicts               259
;  :datatype-accessor-ax    357
;  :datatype-constructor-ax 1484
;  :datatype-occurs-check   510
;  :datatype-splits         1203
;  :decisions               1408
;  :del-clause              491
;  :final-checks            105
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2935
;  :mk-clause               540
;  :num-allocs              7036504
;  :num-checks              400
;  :propagations            287
;  :quant-instantiations    152
;  :rlimit-count            249570)
; [eval] diz.Monitor_m.Main_mon == diz
(push) ; 9
(assert (not (< $Perm.No $k@114@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6247
;  :arith-add-rows          34
;  :arith-assert-diseq      100
;  :arith-assert-lower      376
;  :arith-assert-upper      292
;  :arith-conflicts         51
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         129
;  :arith-offset-eqs        2
;  :arith-pivots            160
;  :binary-propagations     16
;  :conflicts               260
;  :datatype-accessor-ax    357
;  :datatype-constructor-ax 1484
;  :datatype-occurs-check   510
;  :datatype-splits         1203
;  :decisions               1408
;  :del-clause              491
;  :final-checks            105
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2935
;  :mk-clause               540
;  :num-allocs              7036504
;  :num-checks              401
;  :propagations            287
;  :quant-instantiations    152
;  :rlimit-count            249618)
(set-option :timeout 0)
(push) ; 9
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6247
;  :arith-add-rows          34
;  :arith-assert-diseq      100
;  :arith-assert-lower      376
;  :arith-assert-upper      292
;  :arith-conflicts         51
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         129
;  :arith-offset-eqs        2
;  :arith-pivots            160
;  :binary-propagations     16
;  :conflicts               260
;  :datatype-accessor-ax    357
;  :datatype-constructor-ax 1484
;  :datatype-occurs-check   510
;  :datatype-splits         1203
;  :decisions               1408
;  :del-clause              491
;  :final-checks            105
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2935
;  :mk-clause               540
;  :num-allocs              7036504
;  :num-checks              402
;  :propagations            287
;  :quant-instantiations    152
;  :rlimit-count            249631)
(pop) ; 8
(push) ; 8
; [else-branch: 38 | First:(Second:(Second:(Second:($t@110@07))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@110@07))))))[1] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@110@07)))))))
        1)
      (- 0 2)))))
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@96@07))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@85@07)))))))))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6408
;  :arith-add-rows          35
;  :arith-assert-diseq      100
;  :arith-assert-lower      377
;  :arith-assert-upper      293
;  :arith-conflicts         51
;  :arith-eq-adapter        190
;  :arith-fixed-eqs         130
;  :arith-offset-eqs        2
;  :arith-pivots            171
;  :binary-propagations     16
;  :conflicts               261
;  :datatype-accessor-ax    361
;  :datatype-constructor-ax 1543
;  :datatype-occurs-check   521
;  :datatype-splits         1244
;  :decisions               1463
;  :del-clause              530
;  :final-checks            108
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             2982
;  :mk-clause               542
;  :num-allocs              7036504
;  :num-checks              403
;  :propagations            290
;  :quant-instantiations    152
;  :rlimit-count            251217
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6633
;  :arith-add-rows          35
;  :arith-assert-diseq      100
;  :arith-assert-lower      379
;  :arith-assert-upper      295
;  :arith-conflicts         51
;  :arith-eq-adapter        192
;  :arith-fixed-eqs         132
;  :arith-offset-eqs        2
;  :arith-pivots            175
;  :binary-propagations     16
;  :conflicts               262
;  :datatype-accessor-ax    368
;  :datatype-constructor-ax 1622
;  :datatype-occurs-check   535
;  :datatype-splits         1317
;  :decisions               1535
;  :del-clause              533
;  :final-checks            112
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             3063
;  :mk-clause               545
;  :num-allocs              7036504
;  :num-checks              404
;  :propagations            296
;  :quant-instantiations    152
;  :rlimit-count            252840
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6858
;  :arith-add-rows          35
;  :arith-assert-diseq      100
;  :arith-assert-lower      381
;  :arith-assert-upper      297
;  :arith-conflicts         51
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         134
;  :arith-offset-eqs        2
;  :arith-pivots            179
;  :binary-propagations     16
;  :conflicts               263
;  :datatype-accessor-ax    375
;  :datatype-constructor-ax 1701
;  :datatype-occurs-check   549
;  :datatype-splits         1390
;  :decisions               1607
;  :del-clause              536
;  :final-checks            116
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             3144
;  :mk-clause               548
;  :num-allocs              7036504
;  :num-checks              405
;  :propagations            302
;  :quant-instantiations    152
;  :rlimit-count            254463
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@96@07))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@78@07))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7084
;  :arith-add-rows          35
;  :arith-assert-diseq      100
;  :arith-assert-lower      383
;  :arith-assert-upper      300
;  :arith-conflicts         51
;  :arith-eq-adapter        197
;  :arith-fixed-eqs         135
;  :arith-offset-eqs        3
;  :arith-pivots            183
;  :binary-propagations     16
;  :conflicts               264
;  :datatype-accessor-ax    382
;  :datatype-constructor-ax 1780
;  :datatype-occurs-check   563
;  :datatype-splits         1463
;  :decisions               1680
;  :del-clause              541
;  :final-checks            121
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              5.05
;  :memory                  4.96
;  :mk-bool-var             3227
;  :mk-clause               553
;  :num-allocs              7036504
;  :num-checks              406
;  :propagations            309
;  :quant-instantiations    152
;  :rlimit-count            256101
;  :time                    0.00)
; [eval] !true
; [then-branch: 43 | False | dead]
; [else-branch: 43 | True | live]
(push) ; 5
; [else-branch: 43 | True]
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
