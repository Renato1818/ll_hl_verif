(get-info :version)
; (:version "4.8.6")
; Started: 2024-05-28 15:42:49
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
(declare-sort Set<Int>)
(declare-sort Set<Bool>)
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
(declare-const class_Main<TYPE> TYPE)
(declare-const class_Monitor<TYPE> TYPE)
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
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_ALU<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_Driver<TYPE> class_Main<TYPE> class_Monitor<TYPE> class_EncodedGlobalVariables<TYPE>))
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
  (directSuperclass<TYPE> (as class_Main<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Monitor<TYPE>  TYPE))
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
; ---------- ALU___contract_unsatisfiable__operate_EncodedGlobalVariables ----------
(declare-const diz@0@02 $Ref)
(declare-const globals@1@02 $Ref)
(declare-const diz@2@02 $Ref)
(declare-const globals@3@02 $Ref)
(push) ; 1
(declare-const $t@4@02 $Snap)
(assert (= $t@4@02 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@2@02 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.ALU_m, wildcard) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && (true && (true && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__20: Int :: { diz.ALU_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__20] == -1 || 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|)) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && acc(diz.ALU_m.Main_alu.ALU_data1, write) && acc(diz.ALU_m.Main_alu.ALU_data2, write) && acc(diz.ALU_m.Main_alu.ALU_result, write) && acc(diz.ALU_m.Main_alu.ALU_i, write) && acc(diz.ALU_m.Main_alu.ALU_bit, write) && acc(diz.ALU_m.Main_alu.ALU_divisor, write) && acc(diz.ALU_m.Main_alu.ALU_current_bit, write) && acc(diz.ALU_m.Main_dr, wildcard) && diz.ALU_m.Main_dr != null && acc(diz.ALU_m.Main_dr.Driver_z, write) && acc(diz.ALU_m.Main_dr.Driver_x, write) && acc(diz.ALU_m.Main_dr.Driver_y, write) && acc(diz.ALU_m.Main_dr.Driver_a, write) && acc(diz.ALU_m.Main_mon, wildcard) && diz.ALU_m.Main_mon != null && acc(diz.ALU_m.Main_alu.ALU_m, wildcard) && diz.ALU_m.Main_alu.ALU_m == diz.ALU_m) && diz.ALU_m.Main_alu == diz)
(declare-const $t@5@02 $Snap)
(assert (= $t@5@02 ($Snap.combine ($Snap.first $t@5@02) ($Snap.second $t@5@02))))
(assert (= ($Snap.first $t@5@02) $Snap.unit))
(assert (=
  ($Snap.second $t@5@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@5@02))
    ($Snap.second ($Snap.second $t@5@02)))))
(declare-const $k@6@02 $Perm)
(assert ($Perm.isReadVar $k@6@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@6@02 $Perm.No) (< $Perm.No $k@6@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             18
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             1
;  :datatype-accessor-ax  3
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           265
;  :mk-clause             3
;  :num-allocs            3554378
;  :num-checks            2
;  :propagations          17
;  :quant-instantiations  1
;  :rlimit-count          112053)
(assert (<= $Perm.No $k@6@02))
(assert (<= $k@6@02 $Perm.Write))
(assert (implies (< $Perm.No $k@6@02) (not (= diz@2@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@5@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@5@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@5@02))) $Snap.unit))
; [eval] diz.ALU_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             24
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             2
;  :datatype-accessor-ax  4
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           268
;  :mk-clause             3
;  :num-allocs            3554378
;  :num-checks            3
;  :propagations          17
;  :quant-instantiations  1
;  :rlimit-count          112306
;  :time                  0.00)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@5@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@5@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             30
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             3
;  :datatype-accessor-ax  5
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           271
;  :mk-clause             3
;  :num-allocs            3554378
;  :num-checks            4
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          112590
;  :time                  0.01)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             47
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             4
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           276
;  :mk-clause             3
;  :num-allocs            3554378
;  :num-checks            5
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113030)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             53
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             5
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           278
;  :mk-clause             3
;  :num-allocs            3672395
;  :num-checks            6
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113279)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             60
;  :arith-assert-diseq    2
;  :arith-assert-lower    6
;  :arith-assert-upper    4
;  :arith-eq-adapter      4
;  :binary-propagations   16
;  :conflicts             6
;  :datatype-accessor-ax  10
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           287
;  :mk-clause             6
;  :num-allocs            3672395
;  :num-checks            7
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          113664)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             66
;  :arith-assert-diseq    2
;  :arith-assert-lower    6
;  :arith-assert-upper    4
;  :arith-eq-adapter      4
;  :binary-propagations   16
;  :conflicts             7
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           289
;  :mk-clause             6
;  :num-allocs            3672395
;  :num-checks            8
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          113933)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
  $Snap.unit))
; [eval] (forall i__20: Int :: { diz.ALU_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__20] == -1 || 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|)
(declare-const i__20@7@02 Int)
(push) ; 3
; [eval] 0 <= i__20 && i__20 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__20] == -1 || 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 4
; [then-branch: 0 | 0 <= i__20@7@02 | live]
; [else-branch: 0 | !(0 <= i__20@7@02) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i__20@7@02]
(assert (<= 0 i__20@7@02))
; [eval] i__20 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             74
;  :arith-assert-diseq    3
;  :arith-assert-lower    10
;  :arith-assert-upper    5
;  :arith-eq-adapter      6
;  :binary-propagations   16
;  :conflicts             8
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           300
;  :mk-clause             9
;  :num-allocs            3672395
;  :num-checks            9
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114425)
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i__20@7@02)]
(assert (not (<= 0 i__20@7@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i__20@7@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))| && 0 <= i__20@7@02 | live]
; [else-branch: 1 | !(i__20@7@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))| && 0 <= i__20@7@02) | live]
(push) ; 5
; [then-branch: 1 | i__20@7@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))| && 0 <= i__20@7@02]
(assert (and
  (<
    i__20@7@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
  (<= 0 i__20@7@02)))
; [eval] diz.ALU_m.Main_process_state[i__20] == -1 || 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__20] == -1
; [eval] diz.ALU_m.Main_process_state[i__20]
(push) ; 6
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             9
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           302
;  :mk-clause             9
;  :num-allocs            3672395
;  :num-checks            10
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114586)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__20@7@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             9
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           302
;  :mk-clause             9
;  :num-allocs            3672395
;  :num-checks            11
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114595)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__20@7@02] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__20@7@02] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__20@7@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
    i__20@7@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__20@7@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
      i__20@7@02)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__20]
; [eval] diz.ALU_m.Main_process_state[i__20]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             10
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           303
;  :mk-clause             9
;  :num-allocs            3672395
;  :num-checks            12
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114845)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__20@7@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             10
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           303
;  :mk-clause             9
;  :num-allocs            3672395
;  :num-checks            13
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114854)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__20@7@02] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__20@7@02]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__20@7@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
    i__20@7@02)))
; [eval] diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__20]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             11
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           306
;  :mk-clause             10
;  :num-allocs            3672395
;  :num-checks            14
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115047)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__20@7@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             11
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           306
;  :mk-clause             10
;  :num-allocs            3672395
;  :num-checks            15
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115056)
; [eval] |diz.ALU_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             12
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           306
;  :mk-clause             10
;  :num-allocs            3672395
;  :num-checks            16
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115104)
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))[i__20@7@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
      i__20@7@02))))
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
; [else-branch: 1 | !(i__20@7@02 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@5@02)))))))| && 0 <= i__20@7@02)]
(assert (not
  (and
    (<
      i__20@7@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
    (<= 0 i__20@7@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__20@7@02 Int)) (!
  (implies
    (and
      (<
        i__20@7@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))
      (<= 0 i__20@7@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
          i__20@7@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
            i__20@7@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
            i__20@7@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))
    i__20@7@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             80
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             13
;  :datatype-accessor-ax  13
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           308
;  :mk-clause             10
;  :num-allocs            3672395
;  :num-checks            17
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115819)
(declare-const $k@8@02 $Perm)
(assert ($Perm.isReadVar $k@8@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@8@02 $Perm.No) (< $Perm.No $k@8@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             80
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    7
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             14
;  :datatype-accessor-ax  13
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           312
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            18
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116017)
(assert (<= $Perm.No $k@8@02))
(assert (<= $k@8@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@8@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             86
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             15
;  :datatype-accessor-ax  14
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           315
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            19
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116370)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             86
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             16
;  :datatype-accessor-ax  14
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           315
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            20
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116418)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             92
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             17
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           318
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            21
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          116804)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             92
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             18
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           318
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            22
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          116852)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             97
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             19
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           319
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            23
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117139)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             97
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             20
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           319
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            24
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117187)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             102
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             21
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           320
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            25
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117484)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             102
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             22
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           320
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            26
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117532)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             107
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             23
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           321
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            27
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117839)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             107
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             24
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           321
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            28
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117887)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             112
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             25
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           322
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            29
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118204)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             112
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             26
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           322
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            30
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118252)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             117
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             27
;  :datatype-accessor-ax  20
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           323
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            31
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118579)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             117
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             28
;  :datatype-accessor-ax  20
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           323
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            32
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118627)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             122
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             29
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           324
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            33
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118964)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             122
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             30
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           324
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            34
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119012)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             127
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             31
;  :datatype-accessor-ax  22
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            35
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119359)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             127
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             32
;  :datatype-accessor-ax  22
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            36
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119407)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             132
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             33
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           326
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            37
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119764)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             132
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             34
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           326
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            38
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119812)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             137
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             35
;  :datatype-accessor-ax  24
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           327
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            39
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120179)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             137
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             36
;  :datatype-accessor-ax  24
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           327
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            40
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120227)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             142
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             37
;  :datatype-accessor-ax  25
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           328
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            41
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120604)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             142
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             38
;  :datatype-accessor-ax  25
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           328
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            42
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120652)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             147
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             39
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            43
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121039)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             147
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             40
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.88
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3672395
;  :num-checks            44
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121087)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             152
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             41
;  :datatype-accessor-ax  27
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           330
;  :mk-clause             12
;  :num-allocs            3796459
;  :num-checks            45
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121484)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             152
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             42
;  :datatype-accessor-ax  27
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           330
;  :mk-clause             12
;  :num-allocs            3796459
;  :num-checks            46
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121532)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             157
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             43
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           331
;  :mk-clause             12
;  :num-allocs            3796459
;  :num-checks            47
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121939)
(declare-const $k@9@02 $Perm)
(assert ($Perm.isReadVar $k@9@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@9@02 $Perm.No) (< $Perm.No $k@9@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             157
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    9
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             44
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           335
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            48
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122138)
(assert (<= $Perm.No $k@9@02))
(assert (<= $k@9@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@9@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             163
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             45
;  :datatype-accessor-ax  29
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           338
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            49
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122641)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             163
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             46
;  :datatype-accessor-ax  29
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           338
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            50
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122689)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             169
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             47
;  :datatype-accessor-ax  30
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           341
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            51
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123249)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             169
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             48
;  :datatype-accessor-ax  30
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           341
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            52
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123297)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             174
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             49
;  :datatype-accessor-ax  31
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           342
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            53
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123734)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             174
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             50
;  :datatype-accessor-ax  31
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           342
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            54
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123782)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             179
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             51
;  :datatype-accessor-ax  32
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           343
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            55
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124229)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             179
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             52
;  :datatype-accessor-ax  32
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           343
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            56
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124277)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             184
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             53
;  :datatype-accessor-ax  33
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           344
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            57
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124734)
(push) ; 3
(assert (not (< $Perm.No $k@9@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             184
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             54
;  :datatype-accessor-ax  33
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           344
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            58
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124782
;  :time                  0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             189
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             55
;  :datatype-accessor-ax  34
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           345
;  :mk-clause             14
;  :num-allocs            3796459
;  :num-checks            59
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          125249)
(declare-const $k@10@02 $Perm)
(assert ($Perm.isReadVar $k@10@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@10@02 $Perm.No) (< $Perm.No $k@10@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             189
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    11
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             56
;  :datatype-accessor-ax  34
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           349
;  :mk-clause             16
;  :num-allocs            3796459
;  :num-checks            60
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          125448)
(assert (<= $Perm.No $k@10@02))
(assert (<= $k@10@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@10@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             195
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             57
;  :datatype-accessor-ax  35
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           352
;  :mk-clause             16
;  :num-allocs            3796459
;  :num-checks            61
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          126011)
(push) ; 3
(assert (not (< $Perm.No $k@10@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             195
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             58
;  :datatype-accessor-ax  35
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           352
;  :mk-clause             16
;  :num-allocs            3796459
;  :num-checks            62
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          126059)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             201
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             59
;  :datatype-accessor-ax  36
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           355
;  :mk-clause             16
;  :num-allocs            3796459
;  :num-checks            63
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          126661)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             201
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             60
;  :datatype-accessor-ax  36
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           355
;  :mk-clause             16
;  :num-allocs            3796459
;  :num-checks            64
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          126709)
(declare-const $k@11@02 $Perm)
(assert ($Perm.isReadVar $k@11@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@11@02 $Perm.No) (< $Perm.No $k@11@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             201
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    13
;  :arith-eq-adapter      11
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             61
;  :datatype-accessor-ax  36
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           359
;  :mk-clause             18
;  :num-allocs            3796459
;  :num-checks            65
;  :propagations          23
;  :quant-instantiations  11
;  :rlimit-count          126907)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@2@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               271
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               62
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   7
;  :datatype-splits         28
;  :decisions               28
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             389
;  :mk-clause               19
;  :num-allocs              3924714
;  :num-checks              66
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            127815
;  :time                    0.00)
(assert (<= $Perm.No $k@11@02))
(assert (<= $k@11@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@11@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_m == diz.ALU_m
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               277
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               63
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   7
;  :datatype-splits         28
;  :decisions               28
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             392
;  :mk-clause               19
;  :num-allocs              3924714
;  :num-checks              67
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128398)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               277
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               64
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   7
;  :datatype-splits         28
;  :decisions               28
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             392
;  :mk-clause               19
;  :num-allocs              3924714
;  :num-checks              68
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128446)
(push) ; 3
(assert (not (< $Perm.No $k@11@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               277
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               65
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   7
;  :datatype-splits         28
;  :decisions               28
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             392
;  :mk-clause               19
;  :num-allocs              3924714
;  :num-checks              69
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128494)
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               277
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               66
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   7
;  :datatype-splits         28
;  :decisions               28
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             392
;  :mk-clause               19
;  :num-allocs              3924714
;  :num-checks              70
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128542)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 3
(assert (not (< $Perm.No $k@6@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               281
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               67
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   7
;  :datatype-splits         28
;  :decisions               28
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             395
;  :mk-clause               19
;  :num-allocs              3924714
;  :num-checks              71
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            129103)
(push) ; 3
(assert (not (< $Perm.No $k@8@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               281
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               68
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   7
;  :datatype-splits         28
;  :decisions               28
;  :del-clause              2
;  :final-checks            4
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             395
;  :mk-clause               19
;  :num-allocs              3924714
;  :num-checks              72
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            129151)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02)))))))))))))
  diz@2@02))
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
(push) ; 3
(assert (not (=
  diz@2@02
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               473
;  :arith-assert-diseq      8
;  :arith-assert-lower      22
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         1
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 108
;  :datatype-occurs-check   21
;  :datatype-splits         58
;  :decisions               104
;  :del-clause              18
;  :final-checks            11
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             429
;  :mk-clause               20
;  :num-allocs              3924714
;  :num-checks              76
;  :propagations            25
;  :quant-instantiations    12
;  :rlimit-count            131351)
(declare-const $t@12@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@6@02)
    (= $t@12@02 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@5@02)))))
  (implies
    (< $Perm.No $k@11@02)
    (=
      $t@12@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@5@02))))))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@6@02 $k@11@02)))
(assert (<= (+ $k@6@02 $k@11@02) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@6@02 $k@11@02)) (not (= diz@2@02 $Ref.null))))
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Driver_run_EncodedGlobalVariables ----------
(declare-const diz@13@02 $Ref)
(declare-const globals@14@02 $Ref)
(declare-const diz@15@02 $Ref)
(declare-const globals@16@02 $Ref)
(push) ; 1
(declare-const $t@17@02 $Snap)
(assert (= $t@17@02 ($Snap.combine ($Snap.first $t@17@02) ($Snap.second $t@17@02))))
(assert (= ($Snap.first $t@17@02) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@15@02 $Ref.null)))
(assert (=
  ($Snap.second $t@17@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@17@02))
    ($Snap.second ($Snap.second $t@17@02)))))
(declare-const $k@18@02 $Perm)
(assert ($Perm.isReadVar $k@18@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@18@02 $Perm.No) (< $Perm.No $k@18@02))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               547
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      16
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               70
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             443
;  :mk-clause               22
;  :num-allocs              3924714
;  :num-checks              78
;  :propagations            27
;  :quant-instantiations    12
;  :rlimit-count            132751)
(assert (<= $Perm.No $k@18@02))
(assert (<= $k@18@02 $Perm.Write))
(assert (implies (< $Perm.No $k@18@02) (not (= diz@15@02 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@17@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@17@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@17@02))) $Snap.unit))
; [eval] diz.Driver_m != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               553
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      17
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               71
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             446
;  :mk-clause               22
;  :num-allocs              3924714
;  :num-checks              79
;  :propagations            27
;  :quant-instantiations    12
;  :rlimit-count            133004)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@17@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               559
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      17
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               72
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             449
;  :mk-clause               22
;  :num-allocs              3924714
;  :num-checks              80
;  :propagations            27
;  :quant-instantiations    13
;  :rlimit-count            133288)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               564
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      17
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               73
;  :datatype-accessor-ax    48
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             450
;  :mk-clause               22
;  :num-allocs              3924714
;  :num-checks              81
;  :propagations            27
;  :quant-instantiations    13
;  :rlimit-count            133475)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_process_state| == 1
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               570
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      17
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               74
;  :datatype-accessor-ax    49
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             452
;  :mk-clause               22
;  :num-allocs              3924714
;  :num-checks              82
;  :propagations            27
;  :quant-instantiations    13
;  :rlimit-count            133704)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               577
;  :arith-assert-diseq      10
;  :arith-assert-lower      28
;  :arith-assert-upper      18
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             461
;  :mk-clause               25
;  :num-allocs              3924714
;  :num-checks              83
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            134065)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_event_state| == 2
; [eval] |diz.Driver_m.Main_event_state|
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               583
;  :arith-assert-diseq      10
;  :arith-assert-lower      28
;  :arith-assert-upper      18
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             463
;  :mk-clause               25
;  :num-allocs              3924714
;  :num-checks              84
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            134314)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Driver_m.Main_process_state[i] } 0 <= i && i < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i] == -1 || 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|)
(declare-const i@19@02 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i] == -1 || 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= i && i < |diz.Driver_m.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 4 | 0 <= i@19@02 | live]
; [else-branch: 4 | !(0 <= i@19@02) | live]
(push) ; 4
; [then-branch: 4 | 0 <= i@19@02]
(assert (<= 0 i@19@02))
; [eval] i < |diz.Driver_m.Main_process_state|
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 5
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               591
;  :arith-assert-diseq      11
;  :arith-assert-lower      32
;  :arith-assert-upper      19
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             474
;  :mk-clause               28
;  :num-allocs              3924714
;  :num-checks              85
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            134785)
(pop) ; 4
(push) ; 4
; [else-branch: 4 | !(0 <= i@19@02)]
(assert (not (<= 0 i@19@02)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 5 | i@19@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i@19@02 | live]
; [else-branch: 5 | !(i@19@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i@19@02) | live]
(push) ; 4
; [then-branch: 5 | i@19@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i@19@02]
(assert (and
  (<
    i@19@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
  (<= 0 i@19@02)))
; [eval] diz.Driver_m.Main_process_state[i] == -1 || 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i] == -1
; [eval] diz.Driver_m.Main_process_state[i]
(push) ; 5
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               592
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      20
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             476
;  :mk-clause               28
;  :num-allocs              3924714
;  :num-checks              86
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            134946)
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@19@02 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               592
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      20
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             476
;  :mk-clause               28
;  :num-allocs              3924714
;  :num-checks              87
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            134955)
; [eval] -1
(push) ; 5
; [then-branch: 6 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@19@02] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@19@02] != -1 | live]
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@19@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i@19@02)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 6 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@19@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
      i@19@02)
    (- 0 1))))
; [eval] 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= diz.Driver_m.Main_process_state[i]
; [eval] diz.Driver_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               592
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      20
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             477
;  :mk-clause               28
;  :num-allocs              3924714
;  :num-checks              88
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135181)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i@19@02 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               592
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      20
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             477
;  :mk-clause               28
;  :num-allocs              3924714
;  :num-checks              89
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135190)
(push) ; 7
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@19@02] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@19@02]) | live]
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@19@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i@19@02)))
; [eval] diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               592
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             480
;  :mk-clause               29
;  :num-allocs              3924714
;  :num-checks              90
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135363)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@19@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               592
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             480
;  :mk-clause               29
;  :num-allocs              3924714
;  :num-checks              91
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135372)
; [eval] |diz.Driver_m.Main_event_state|
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               592
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             480
;  :mk-clause               29
;  :num-allocs              3924714
;  :num-checks              92
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135420)
(pop) ; 8
(push) ; 8
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@19@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
      i@19@02))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 5 | !(i@19@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i@19@02)]
(assert (not
  (and
    (<
      i@19@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
    (<= 0 i@19@02))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@19@02 Int)) (!
  (implies
    (and
      (<
        i@19@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
      (<= 0 i@19@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
          i@19@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
            i@19@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
            i@19@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i@19@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               597
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             482
;  :mk-clause               29
;  :num-allocs              3924714
;  :num-checks              93
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            136075)
(declare-const $k@20@02 $Perm)
(assert ($Perm.isReadVar $k@20@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@20@02 $Perm.No) (< $Perm.No $k@20@02))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               597
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      21
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               83
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             486
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              94
;  :propagations            30
;  :quant-instantiations    19
;  :rlimit-count            136273)
(assert (<= $Perm.No $k@20@02))
(assert (<= $k@20@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@20@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               603
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             489
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              95
;  :propagations            30
;  :quant-instantiations    19
;  :rlimit-count            136606)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               603
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             489
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              96
;  :propagations            30
;  :quant-instantiations    19
;  :rlimit-count            136654)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               609
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             492
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              97
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            137020)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               609
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             492
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              98
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            137068)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               614
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             493
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              99
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            137335)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               614
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               89
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             493
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              100
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            137383)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               619
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             494
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              101
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            137660)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               619
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               91
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             494
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              102
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            137708)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               624
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             495
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              103
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            137995)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               624
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               93
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             495
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              104
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138043)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               629
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               94
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             496
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              105
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138340)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               629
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               95
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             496
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              106
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138388)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               634
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             497
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              107
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138695)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               634
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             497
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              108
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138743)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               639
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               98
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             498
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              109
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139060)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               639
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             498
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              110
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139108)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               644
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             499
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              111
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139435)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               644
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               101
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             499
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              112
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139483)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               649
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               102
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             500
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              113
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139820)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               649
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               103
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             500
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              114
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139868)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               654
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               104
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             501
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              115
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            140215)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               654
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               105
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             501
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              116
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            140263)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               659
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             502
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              117
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            140620)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               659
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             502
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              118
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            140668)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               664
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             503
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              119
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            141035)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               664
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             503
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              120
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            141083)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             504
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              121
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            141460)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               669
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               111
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             504
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              122
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            141508)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               674
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               112
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             505
;  :mk-clause               31
;  :num-allocs              3924714
;  :num-checks              123
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            141895)
(declare-const $k@21@02 $Perm)
(assert ($Perm.isReadVar $k@21@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@21@02 $Perm.No) (< $Perm.No $k@21@02))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               674
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      23
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               113
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             509
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              124
;  :propagations            31
;  :quant-instantiations    20
;  :rlimit-count            142094)
(assert (<= $Perm.No $k@21@02))
(assert (<= $k@21@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@21@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               680
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             512
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              125
;  :propagations            31
;  :quant-instantiations    20
;  :rlimit-count            142577)
(push) ; 2
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               680
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               115
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             512
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              126
;  :propagations            31
;  :quant-instantiations    20
;  :rlimit-count            142625)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               686
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               116
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             515
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              127
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            143165)
(push) ; 2
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               686
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               117
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             515
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              128
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            143213)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               691
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               118
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             516
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              129
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            143630)
(push) ; 2
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               691
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               119
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             516
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              130
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            143678)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               696
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               120
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             517
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              131
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            144105)
(push) ; 2
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               696
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             517
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              132
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            144153)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               701
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               122
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             518
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              133
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            144590)
(push) ; 2
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               701
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               123
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             518
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              134
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            144638)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               706
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               124
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             519
;  :mk-clause               33
;  :num-allocs              3924714
;  :num-checks              135
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            145085)
(declare-const $k@22@02 $Perm)
(assert ($Perm.isReadVar $k@22@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@22@02 $Perm.No) (< $Perm.No $k@22@02))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               706
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      25
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             523
;  :mk-clause               35
;  :num-allocs              3924714
;  :num-checks              136
;  :propagations            32
;  :quant-instantiations    21
;  :rlimit-count            145284)
(assert (<= $Perm.No $k@22@02))
(assert (<= $k@22@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@22@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_mon != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               712
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               126
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             526
;  :mk-clause               35
;  :num-allocs              3924714
;  :num-checks              137
;  :propagations            32
;  :quant-instantiations    21
;  :rlimit-count            145827)
(push) ; 2
(assert (not (< $Perm.No $k@22@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               712
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               127
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             526
;  :mk-clause               35
;  :num-allocs              3924714
;  :num-checks              138
;  :propagations            32
;  :quant-instantiations    21
;  :rlimit-count            145875)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               718
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               128
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             529
;  :mk-clause               35
;  :num-allocs              3924714
;  :num-checks              139
;  :propagations            32
;  :quant-instantiations    22
;  :rlimit-count            146457)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               718
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               129
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             529
;  :mk-clause               35
;  :num-allocs              3924714
;  :num-checks              140
;  :propagations            32
;  :quant-instantiations    22
;  :rlimit-count            146505)
(declare-const $k@23@02 $Perm)
(assert ($Perm.isReadVar $k@23@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@23@02 $Perm.No) (< $Perm.No $k@23@02))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               718
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      27
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               130
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             533
;  :mk-clause               37
;  :num-allocs              3924714
;  :num-checks              141
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            146704)
(assert (<= $Perm.No $k@23@02))
(assert (<= $k@23@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@23@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu.ALU_m == diz.Driver_m
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               724
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               131
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             536
;  :mk-clause               37
;  :num-allocs              3924714
;  :num-checks              142
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            147267)
(push) ; 2
(assert (not (< $Perm.No $k@20@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               724
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               132
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             536
;  :mk-clause               37
;  :num-allocs              3924714
;  :num-checks              143
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            147315)
(push) ; 2
(assert (not (< $Perm.No $k@23@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               724
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               133
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             536
;  :mk-clause               37
;  :num-allocs              3924714
;  :num-checks              144
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            147363)
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               724
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               134
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             536
;  :mk-clause               37
;  :num-allocs              3924714
;  :num-checks              145
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            147411)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr == diz
(push) ; 2
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               728
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               135
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             539
;  :mk-clause               37
;  :num-allocs              3924714
;  :num-checks              146
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            147952)
(push) ; 2
(assert (not (< $Perm.No $k@21@02)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               728
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               136
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   25
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            13
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             539
;  :mk-clause               37
;  :num-allocs              3924714
;  :num-checks              147
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            148000)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  diz@15@02))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@24@02 $Snap)
(assert (= $t@24@02 ($Snap.combine ($Snap.first $t@24@02) ($Snap.second $t@24@02))))
(declare-const $k@25@02 $Perm)
(assert ($Perm.isReadVar $k@25@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@25@02 $Perm.No) (< $Perm.No $k@25@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               801
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      29
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               138
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             572
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              149
;  :propagations            34
;  :quant-instantiations    23
;  :rlimit-count            149284)
(assert (<= $Perm.No $k@25@02))
(assert (<= $k@25@02 $Perm.Write))
(assert (implies (< $Perm.No $k@25@02) (not (= diz@15@02 $Ref.null))))
(assert (=
  ($Snap.second $t@24@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@02))
    ($Snap.second ($Snap.second $t@24@02)))))
(assert (= ($Snap.first ($Snap.second $t@24@02)) $Snap.unit))
; [eval] diz.Driver_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               807
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               139
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             575
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              150
;  :propagations            34
;  :quant-instantiations    23
;  :rlimit-count            149527)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@02)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@24@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@24@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               813
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               140
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             578
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              151
;  :propagations            34
;  :quant-instantiations    24
;  :rlimit-count            149799
;  :time                    0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@24@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               818
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               141
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             579
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              152
;  :propagations            34
;  :quant-instantiations    24
;  :rlimit-count            149976)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_process_state| == 1
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               824
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               142
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             581
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              153
;  :propagations            34
;  :quant-instantiations    24
;  :rlimit-count            150195)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               831
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      31
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               143
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             587
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              154
;  :propagations            34
;  :quant-instantiations    26
;  :rlimit-count            150525)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_event_state| == 2
; [eval] |diz.Driver_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               837
;  :arith-assert-diseq      17
;  :arith-assert-lower      48
;  :arith-assert-upper      31
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               144
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             589
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              155
;  :propagations            34
;  :quant-instantiations    26
;  :rlimit-count            150764)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Driver_m.Main_process_state[i] } 0 <= i && i < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i] == -1 || 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|)
(declare-const i@26@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i] == -1 || 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= i && i < |diz.Driver_m.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 8 | 0 <= i@26@02 | live]
; [else-branch: 8 | !(0 <= i@26@02) | live]
(push) ; 5
; [then-branch: 8 | 0 <= i@26@02]
(assert (<= 0 i@26@02))
; [eval] i < |diz.Driver_m.Main_process_state|
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               845
;  :arith-assert-diseq      17
;  :arith-assert-lower      51
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               145
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             597
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              156
;  :propagations            34
;  :quant-instantiations    28
;  :rlimit-count            151203)
(pop) ; 5
(push) ; 5
; [else-branch: 8 | !(0 <= i@26@02)]
(assert (not (<= 0 i@26@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 9 | i@26@02 < |First:(Second:(Second:(Second:($t@24@02))))| && 0 <= i@26@02 | live]
; [else-branch: 9 | !(i@26@02 < |First:(Second:(Second:(Second:($t@24@02))))| && 0 <= i@26@02) | live]
(push) ; 5
; [then-branch: 9 | i@26@02 < |First:(Second:(Second:(Second:($t@24@02))))| && 0 <= i@26@02]
(assert (and
  (<
    i@26@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))
  (<= 0 i@26@02)))
; [eval] diz.Driver_m.Main_process_state[i] == -1 || 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i] == -1
; [eval] diz.Driver_m.Main_process_state[i]
(push) ; 6
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               846
;  :arith-assert-diseq      17
;  :arith-assert-lower      52
;  :arith-assert-upper      33
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               146
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              157
;  :propagations            34
;  :quant-instantiations    28
;  :rlimit-count            151364)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@26@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               846
;  :arith-assert-diseq      17
;  :arith-assert-lower      52
;  :arith-assert-upper      33
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               146
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              158
;  :propagations            34
;  :quant-instantiations    28
;  :rlimit-count            151373)
; [eval] -1
(push) ; 6
; [then-branch: 10 | First:(Second:(Second:(Second:($t@24@02))))[i@26@02] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:($t@24@02))))[i@26@02] != -1 | live]
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:($t@24@02))))[i@26@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
    i@26@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 10 | First:(Second:(Second:(Second:($t@24@02))))[i@26@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
      i@26@02)
    (- 0 1))))
; [eval] 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= diz.Driver_m.Main_process_state[i]
; [eval] diz.Driver_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               846
;  :arith-assert-diseq      17
;  :arith-assert-lower      52
;  :arith-assert-upper      33
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               147
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             600
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              159
;  :propagations            34
;  :quant-instantiations    28
;  :rlimit-count            151587)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i@26@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               846
;  :arith-assert-diseq      17
;  :arith-assert-lower      52
;  :arith-assert-upper      33
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               147
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             600
;  :mk-clause               40
;  :num-allocs              3924714
;  :num-checks              160
;  :propagations            34
;  :quant-instantiations    28
;  :rlimit-count            151596)
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@24@02))))[i@26@02] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@24@02))))[i@26@02]) | live]
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@24@02))))[i@26@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
    i@26@02)))
; [eval] diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               846
;  :arith-assert-diseq      18
;  :arith-assert-lower      55
;  :arith-assert-upper      33
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             603
;  :mk-clause               41
;  :num-allocs              3924714
;  :num-checks              161
;  :propagations            34
;  :quant-instantiations    28
;  :rlimit-count            151759)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i@26@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               846
;  :arith-assert-diseq      18
;  :arith-assert-lower      55
;  :arith-assert-upper      33
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             603
;  :mk-clause               41
;  :num-allocs              3924714
;  :num-checks              162
;  :propagations            34
;  :quant-instantiations    28
;  :rlimit-count            151768)
; [eval] |diz.Driver_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               846
;  :arith-assert-diseq      18
;  :arith-assert-lower      55
;  :arith-assert-upper      33
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              36
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             603
;  :mk-clause               41
;  :num-allocs              3924714
;  :num-checks              163
;  :propagations            34
;  :quant-instantiations    28
;  :rlimit-count            151816)
(pop) ; 9
(push) ; 9
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@24@02))))[i@26@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
      i@26@02))))
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
; [else-branch: 9 | !(i@26@02 < |First:(Second:(Second:(Second:($t@24@02))))| && 0 <= i@26@02)]
(assert (not
  (and
    (<
      i@26@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))
    (<= 0 i@26@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@26@02 Int)) (!
  (implies
    (and
      (<
        i@26@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))
      (<= 0 i@26@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
          i@26@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
            i@26@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
            i@26@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))
    i@26@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               851
;  :arith-assert-diseq      18
;  :arith-assert-lower      55
;  :arith-assert-upper      33
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               150
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             605
;  :mk-clause               41
;  :num-allocs              3924714
;  :num-checks              164
;  :propagations            34
;  :quant-instantiations    28
;  :rlimit-count            152441)
(declare-const $k@27@02 $Perm)
(assert ($Perm.isReadVar $k@27@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@27@02 $Perm.No) (< $Perm.No $k@27@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               851
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      34
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               151
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             609
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              165
;  :propagations            35
;  :quant-instantiations    28
;  :rlimit-count            152640)
(assert (<= $Perm.No $k@27@02))
(assert (<= $k@27@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@27@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               857
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               152
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             612
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              166
;  :propagations            35
;  :quant-instantiations    28
;  :rlimit-count            152963)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               857
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               153
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             612
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              167
;  :propagations            35
;  :quant-instantiations    28
;  :rlimit-count            153011)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               863
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             615
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              168
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            153367)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               863
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             615
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              169
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            153415)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               868
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               156
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             616
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              170
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            153672)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               868
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               157
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             616
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              171
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            153720)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               873
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             617
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              172
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            153987)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               873
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             617
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              173
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            154035)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               878
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               160
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             618
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              174
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            154312)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               878
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             618
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              175
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            154360)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               883
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               162
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             619
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              176
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            154647)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               883
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               163
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             619
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              177
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            154695)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               888
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               164
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             620
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              178
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            154992)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               888
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               165
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             620
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              179
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            155040)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               893
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               166
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             621
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              180
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            155347)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               893
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               167
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             621
;  :mk-clause               43
;  :num-allocs              3924714
;  :num-checks              181
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            155395)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               898
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               168
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             622
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              182
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            155712)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               898
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               169
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             622
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              183
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            155760)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               903
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               170
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             623
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              184
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            156087)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               903
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               171
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             623
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              185
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            156135)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               908
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               172
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             624
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              186
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            156472)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               908
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               173
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             624
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              187
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            156520)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               913
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               174
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             625
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              188
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            156867)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               913
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               175
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             625
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              189
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            156915)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               918
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               176
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             626
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              190
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            157272)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               918
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               177
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             626
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              191
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            157320)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               923
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               178
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             627
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              192
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            157687)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               923
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               179
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             627
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              193
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            157735)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               928
;  :arith-assert-diseq      19
;  :arith-assert-lower      57
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               180
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             628
;  :mk-clause               43
;  :num-allocs              4073669
;  :num-checks              194
;  :propagations            35
;  :quant-instantiations    29
;  :rlimit-count            158112)
(declare-const $k@28@02 $Perm)
(assert ($Perm.isReadVar $k@28@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@28@02 $Perm.No) (< $Perm.No $k@28@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               928
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      36
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               181
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             632
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              195
;  :propagations            36
;  :quant-instantiations    29
;  :rlimit-count            158310)
(assert (<= $Perm.No $k@28@02))
(assert (<= $k@28@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@28@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               934
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               182
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             635
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              196
;  :propagations            36
;  :quant-instantiations    29
;  :rlimit-count            158783)
(push) ; 3
(assert (not (< $Perm.No $k@28@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               934
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               183
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             635
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              197
;  :propagations            36
;  :quant-instantiations    29
;  :rlimit-count            158831)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               940
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               184
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             638
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              198
;  :propagations            36
;  :quant-instantiations    30
;  :rlimit-count            159361)
(push) ; 3
(assert (not (< $Perm.No $k@28@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               940
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               185
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             638
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              199
;  :propagations            36
;  :quant-instantiations    30
;  :rlimit-count            159409)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               945
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               186
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             639
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              200
;  :propagations            36
;  :quant-instantiations    30
;  :rlimit-count            159816)
(push) ; 3
(assert (not (< $Perm.No $k@28@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               945
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               187
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             639
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              201
;  :propagations            36
;  :quant-instantiations    30
;  :rlimit-count            159864)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               950
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             640
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              202
;  :propagations            36
;  :quant-instantiations    30
;  :rlimit-count            160281)
(push) ; 3
(assert (not (< $Perm.No $k@28@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               950
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               189
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             640
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              203
;  :propagations            36
;  :quant-instantiations    30
;  :rlimit-count            160329)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               955
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               190
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             641
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              204
;  :propagations            36
;  :quant-instantiations    30
;  :rlimit-count            160756)
(push) ; 3
(assert (not (< $Perm.No $k@28@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               955
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               191
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             641
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              205
;  :propagations            36
;  :quant-instantiations    30
;  :rlimit-count            160804)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               960
;  :arith-assert-diseq      20
;  :arith-assert-lower      59
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               192
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             642
;  :mk-clause               45
;  :num-allocs              4073669
;  :num-checks              206
;  :propagations            36
;  :quant-instantiations    30
;  :rlimit-count            161241)
(declare-const $k@29@02 $Perm)
(assert ($Perm.isReadVar $k@29@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@29@02 $Perm.No) (< $Perm.No $k@29@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               960
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               193
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             646
;  :mk-clause               47
;  :num-allocs              4073669
;  :num-checks              207
;  :propagations            37
;  :quant-instantiations    30
;  :rlimit-count            161440)
(assert (<= $Perm.No $k@29@02))
(assert (<= $k@29@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@29@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               966
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      39
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               194
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             649
;  :mk-clause               47
;  :num-allocs              4073669
;  :num-checks              208
;  :propagations            37
;  :quant-instantiations    30
;  :rlimit-count            161973)
(push) ; 3
(assert (not (< $Perm.No $k@29@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               966
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      39
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               195
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             649
;  :mk-clause               47
;  :num-allocs              4073669
;  :num-checks              209
;  :propagations            37
;  :quant-instantiations    30
;  :rlimit-count            162021)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               972
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      39
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               196
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             652
;  :mk-clause               47
;  :num-allocs              4073669
;  :num-checks              210
;  :propagations            37
;  :quant-instantiations    31
;  :rlimit-count            162593)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               972
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      39
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               197
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             652
;  :mk-clause               47
;  :num-allocs              4073669
;  :num-checks              211
;  :propagations            37
;  :quant-instantiations    31
;  :rlimit-count            162641)
(declare-const $k@30@02 $Perm)
(assert ($Perm.isReadVar $k@30@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@30@02 $Perm.No) (< $Perm.No $k@30@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               972
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      40
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               198
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             656
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              212
;  :propagations            38
;  :quant-instantiations    31
;  :rlimit-count            162840)
(assert (<= $Perm.No $k@30@02))
(assert (<= $k@30@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@30@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu.ALU_m == diz.Driver_m
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               978
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               199
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             659
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              213
;  :propagations            38
;  :quant-instantiations    31
;  :rlimit-count            163393)
(push) ; 3
(assert (not (< $Perm.No $k@27@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               978
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               200
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             659
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              214
;  :propagations            38
;  :quant-instantiations    31
;  :rlimit-count            163441)
(push) ; 3
(assert (not (< $Perm.No $k@30@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               978
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               201
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             659
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              215
;  :propagations            38
;  :quant-instantiations    31
;  :rlimit-count            163489)
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               978
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               202
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             659
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              216
;  :propagations            38
;  :quant-instantiations    31
;  :rlimit-count            163537)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@24@02))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr == diz
(push) ; 3
(assert (not (< $Perm.No $k@25@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               983
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             662
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              217
;  :propagations            38
;  :quant-instantiations    32
;  :rlimit-count            164069)
(push) ; 3
(assert (not (< $Perm.No $k@28@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               983
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               204
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              37
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             662
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              218
;  :propagations            38
;  :quant-instantiations    32
;  :rlimit-count            164117)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@02)))))))))))))))))))))))))
  diz@15@02))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_42__59: Int
(declare-const __flatten_42__59@31@02 Int)
; [exec]
; var __flatten_43__60: Int
(declare-const __flatten_43__60@32@02 Int)
; [exec]
; var __flatten_44__61: Ref
(declare-const __flatten_44__61@33@02 $Ref)
; [exec]
; var __flatten_45__62: Ref
(declare-const __flatten_45__62@34@02 $Ref)
; [exec]
; var __flatten_46__63: Int
(declare-const __flatten_46__63@35@02 Int)
; [exec]
; var __flatten_47__64: Ref
(declare-const __flatten_47__64@36@02 $Ref)
; [exec]
; var __flatten_48__65: Ref
(declare-const __flatten_48__65@37@02 $Ref)
; [exec]
; var __flatten_49__66: Int
(declare-const __flatten_49__66@38@02 Int)
; [exec]
; var __flatten_50__67: Ref
(declare-const __flatten_50__67@39@02 $Ref)
; [exec]
; var __flatten_51__68: Ref
(declare-const __flatten_51__68@40@02 $Ref)
; [exec]
; var __flatten_52__69: Int
(declare-const __flatten_52__69@41@02 Int)
; [exec]
; var __flatten_53__70: Int
(declare-const __flatten_53__70@42@02 Int)
; [exec]
; var __flatten_54__71: Ref
(declare-const __flatten_54__71@43@02 $Ref)
; [exec]
; var __flatten_55__72: Seq[Int]
(declare-const __flatten_55__72@44@02 Seq<Int>)
; [exec]
; var __flatten_56__73: Ref
(declare-const __flatten_56__73@45@02 $Ref)
; [exec]
; var __flatten_57__74: Ref
(declare-const __flatten_57__74@46@02 $Ref)
; [exec]
; var __flatten_58__75: Seq[Int]
(declare-const __flatten_58__75@47@02 Seq<Int>)
; [exec]
; var __flatten_59__76: Ref
(declare-const __flatten_59__76@48@02 $Ref)
; [exec]
; var __flatten_60__77: Int
(declare-const __flatten_60__77@49@02 Int)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Driver_m, globals), write)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               983
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               205
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   28
;  :datatype-splits         86
;  :decisions               155
;  :del-clause              47
;  :final-checks            16
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             662
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              219
;  :propagations            38
;  :quant-instantiations    32
;  :rlimit-count            164223)
(declare-const $t@50@02 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Driver_m, globals), write)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               206
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              221
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            164929)
(assert (= $t@50@02 ($Snap.combine ($Snap.first $t@50@02) ($Snap.second $t@50@02))))
(assert (= ($Snap.first $t@50@02) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@50@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@50@02))
    ($Snap.second ($Snap.second $t@50@02)))))
(assert (= ($Snap.first ($Snap.second $t@50@02)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@50@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@50@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@50@02))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@50@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@50@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))
(assert false)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@51@02 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 12 | 0 <= i@51@02 | live]
; [else-branch: 12 | !(0 <= i@51@02) | live]
(push) ; 5
; [then-branch: 12 | 0 <= i@51@02]
(assert (<= 0 i@51@02))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 12 | !(0 <= i@51@02)]
(assert (not (<= 0 i@51@02)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 13 | i@51@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i@51@02 | live]
; [else-branch: 13 | !(i@51@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i@51@02) | live]
(push) ; 5
; [then-branch: 13 | i@51@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i@51@02]
(assert (and
  (<
    i@51@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
  (<= 0 i@51@02)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@51@02 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              222
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165027)
; [eval] -1
(push) ; 6
; [then-branch: 14 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@51@02] == -1 | live]
; [else-branch: 14 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@51@02] != -1 | live]
(push) ; 7
; [then-branch: 14 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@51@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i@51@02)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 14 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@51@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
      i@51@02)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@51@02 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              223
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165035)
(push) ; 8
; [then-branch: 15 | 0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@51@02] | live]
; [else-branch: 15 | !(0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@51@02]) | live]
(push) ; 9
; [then-branch: 15 | 0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@51@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i@51@02)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@51@02 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              224
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165041)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 15 | !(0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i@51@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
      i@51@02))))
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
; [else-branch: 13 | !(i@51@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i@51@02)]
(assert (not
  (and
    (<
      i@51@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
    (<= 0 i@51@02))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@51@02 Int)) (!
  (implies
    (and
      (<
        i@51@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
      (<= 0 i@51@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
          i@51@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
            i@51@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
            i@51@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i@51@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))
(declare-const $k@52@02 $Perm)
(assert ($Perm.isReadVar $k@52@02 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@52@02 $Perm.No) (< $Perm.No $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              225
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165061)
(declare-const $t@53@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@20@02)
    (=
      $t@53@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))
  (implies
    (< $Perm.No $k@52@02)
    (=
      $t@53@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))
(assert (<= $Perm.No (+ $k@20@02 $k@52@02)))
(assert (<= (+ $k@20@02 $k@52@02) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@20@02 $k@52@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))
  $Snap.unit))
; [eval] diz.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              226
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165070)
(assert (not (= $t@53@02 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              227
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165075)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              228
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165078)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              229
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165083)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              230
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165086)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              231
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165091)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              232
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165094)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              233
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165099)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              234
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165102)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              235
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165107)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              236
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165110)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              237
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165115)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              238
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165118)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              239
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165123)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              240
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165126)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              241
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165131)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              242
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165134)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              243
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165139)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              244
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165142)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              245
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165147)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              246
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165150)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              247
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165155)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              248
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165158)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              249
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165163)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              250
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165166)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              251
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165171)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              252
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165174)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))
(declare-const $k@54@02 $Perm)
(assert ($Perm.isReadVar $k@54@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@54@02 $Perm.No) (< $Perm.No $k@54@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              253
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165190)
(declare-const $t@55@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@21@02)
    (=
      $t@55@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@54@02)
    (=
      $t@55@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@21@02 $k@54@02)))
(assert (<= (+ $k@21@02 $k@54@02) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@21@02 $k@54@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              254
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165199)
(assert (not (= $t@55@02 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              255
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165204)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  $t@55@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              256
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165207)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              257
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165212)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  $t@55@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              258
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165215)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              259
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165220)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  $t@55@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              260
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165223)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              261
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165228)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  $t@55@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              262
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165231)
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))))))
(declare-const $k@56@02 $Perm)
(assert ($Perm.isReadVar $k@56@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@56@02 $Perm.No) (< $Perm.No $k@56@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              263
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165247)
(declare-const $t@57@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@22@02)
    (=
      $t@57@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@56@02)
    (=
      $t@57@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@22@02 $k@56@02)))
(assert (<= (+ $k@22@02 $k@56@02) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@22@02 $k@56@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@22@02 $k@56@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              264
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165256)
(assert (not (= $t@57@02 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              265
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165261)
(declare-const $k@58@02 $Perm)
(assert ($Perm.isReadVar $k@58@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@58@02 $Perm.No) (< $Perm.No $k@58@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              266
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165275)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              267
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165278)
(declare-const $t@59@02 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@23@02)
    (=
      $t@59@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))))))))))))
  (implies
    (< $Perm.No $k@58@02)
    (=
      $t@59@02
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02)))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@23@02 $k@58@02)))
(assert (<= (+ $k@23@02 $k@58@02) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@23@02 $k@58@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@50@02))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_m == diz
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              268
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165286)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              269
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165289)
(push) ; 3
(assert (not (< $Perm.No (+ $k@23@02 $k@58@02))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              270
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165292)
(assert (= $t@59@02 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unsat
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@50@02 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02))) globals@16@02))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Driver_m, globals), write)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              272
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165298)
(declare-const $t@60@02 $Snap)
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@17@02)))) $t@60@02))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unsat
(declare-const __flatten_42__59@61@02 Int)
(declare-const __flatten_43__60@62@02 Int)
(declare-const __flatten_45__62@63@02 $Ref)
(declare-const __flatten_44__61@64@02 $Ref)
(declare-const __flatten_46__63@65@02 Int)
(declare-const __flatten_48__65@66@02 $Ref)
(declare-const __flatten_47__64@67@02 $Ref)
(declare-const __flatten_49__66@68@02 Int)
(declare-const __flatten_51__68@69@02 $Ref)
(declare-const __flatten_50__67@70@02 $Ref)
(declare-const __flatten_52__69@71@02 Int)
(declare-const __flatten_53__70@72@02 Int)
(declare-const __flatten_54__71@73@02 $Ref)
(declare-const __flatten_56__73@74@02 $Ref)
(declare-const __flatten_55__72@75@02 Seq<Int>)
(declare-const __flatten_57__74@76@02 $Ref)
(declare-const __flatten_59__76@77@02 $Ref)
(declare-const __flatten_58__75@78@02 Seq<Int>)
(declare-const __flatten_60__77@79@02 Int)
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@80@02 $Snap)
(assert (= $t@80@02 ($Snap.combine ($Snap.first $t@80@02) ($Snap.second $t@80@02))))
(declare-const $k@81@02 $Perm)
(assert ($Perm.isReadVar $k@81@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@81@02 $Perm.No) (< $Perm.No $k@81@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              274
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165316)
(assert (<= $Perm.No $k@81@02))
(assert (<= $k@81@02 $Perm.Write))
(assert (implies (< $Perm.No $k@81@02) (not (= diz@15@02 $Ref.null))))
(assert (=
  ($Snap.second $t@80@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@80@02))
    ($Snap.second ($Snap.second $t@80@02)))))
(assert (= ($Snap.first ($Snap.second $t@80@02)) $Snap.unit))
; [eval] diz.Driver_m != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              275
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165324)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@80@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@80@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              276
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165329)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@80@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              277
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165333)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_process_state| == 1
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              278
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165338)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              279
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165343)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_event_state| == 2
; [eval] |diz.Driver_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              280
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165348)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
  $Snap.unit))
; [eval] (forall i__78: Int :: { diz.Driver_m.Main_process_state[i__78] } 0 <= i__78 && i__78 < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i__78] == -1 || 0 <= diz.Driver_m.Main_process_state[i__78] && diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|)
(declare-const i__78@82@02 Int)
(push) ; 4
; [eval] 0 <= i__78 && i__78 < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i__78] == -1 || 0 <= diz.Driver_m.Main_process_state[i__78] && diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= i__78 && i__78 < |diz.Driver_m.Main_process_state|
; [eval] 0 <= i__78
(push) ; 5
; [then-branch: 16 | 0 <= i__78@82@02 | live]
; [else-branch: 16 | !(0 <= i__78@82@02) | live]
(push) ; 6
; [then-branch: 16 | 0 <= i__78@82@02]
(assert (<= 0 i__78@82@02))
; [eval] i__78 < |diz.Driver_m.Main_process_state|
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              281
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165358)
(pop) ; 6
(push) ; 6
; [else-branch: 16 | !(0 <= i__78@82@02)]
(assert (not (<= 0 i__78@82@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 17 | i__78@82@02 < |First:(Second:(Second:(Second:($t@80@02))))| && 0 <= i__78@82@02 | live]
; [else-branch: 17 | !(i__78@82@02 < |First:(Second:(Second:(Second:($t@80@02))))| && 0 <= i__78@82@02) | live]
(push) ; 6
; [then-branch: 17 | i__78@82@02 < |First:(Second:(Second:(Second:($t@80@02))))| && 0 <= i__78@82@02]
(assert (and
  (<
    i__78@82@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
  (<= 0 i__78@82@02)))
; [eval] diz.Driver_m.Main_process_state[i__78] == -1 || 0 <= diz.Driver_m.Main_process_state[i__78] && diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i__78] == -1
; [eval] diz.Driver_m.Main_process_state[i__78]
(push) ; 7
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              282
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165366)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i__78@82@02 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              283
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165369)
; [eval] -1
(push) ; 7
; [then-branch: 18 | First:(Second:(Second:(Second:($t@80@02))))[i__78@82@02] == -1 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:($t@80@02))))[i__78@82@02] != -1 | live]
(push) ; 8
; [then-branch: 18 | First:(Second:(Second:(Second:($t@80@02))))[i__78@82@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
    i__78@82@02)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 18 | First:(Second:(Second:(Second:($t@80@02))))[i__78@82@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
      i__78@82@02)
    (- 0 1))))
; [eval] 0 <= diz.Driver_m.Main_process_state[i__78] && diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= diz.Driver_m.Main_process_state[i__78]
; [eval] diz.Driver_m.Main_process_state[i__78]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              284
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165377)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i__78@82@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              285
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165380)
(push) ; 9
; [then-branch: 19 | 0 <= First:(Second:(Second:(Second:($t@80@02))))[i__78@82@02] | live]
; [else-branch: 19 | !(0 <= First:(Second:(Second:(Second:($t@80@02))))[i__78@82@02]) | live]
(push) ; 10
; [then-branch: 19 | 0 <= First:(Second:(Second:(Second:($t@80@02))))[i__78@82@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
    i__78@82@02)))
; [eval] diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i__78]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              286
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165386)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i__78@82@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              287
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165389)
; [eval] |diz.Driver_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              288
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165392)
(pop) ; 10
(push) ; 10
; [else-branch: 19 | !(0 <= First:(Second:(Second:(Second:($t@80@02))))[i__78@82@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
      i__78@82@02))))
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
; [else-branch: 17 | !(i__78@82@02 < |First:(Second:(Second:(Second:($t@80@02))))| && 0 <= i__78@82@02)]
(assert (not
  (and
    (<
      i__78@82@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
    (<= 0 i__78@82@02))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__78@82@02 Int)) (!
  (implies
    (and
      (<
        i__78@82@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
      (<= 0 i__78@82@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
          i__78@82@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
            i__78@82@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
            i__78@82@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
    i__78@82@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              289
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165401)
(declare-const $k@83@02 $Perm)
(assert ($Perm.isReadVar $k@83@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@83@02 $Perm.No) (< $Perm.No $k@83@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              290
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165415)
(assert (<= $Perm.No $k@83@02))
(assert (<= $k@83@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@83@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              291
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165423)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              292
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165426)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              293
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165431)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              294
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165434)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              295
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165438)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              296
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165441)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              297
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165445)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              298
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165448)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              299
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165452)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              300
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165455)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              301
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165459)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              302
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165462)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              303
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165466)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              304
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165469)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              305
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165473)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              306
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165476)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              307
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165480)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              308
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165483)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              309
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165487)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              310
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165490)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              311
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165494)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              312
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165497)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              313
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165501)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              314
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165504)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              315
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165508)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              316
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165511)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              317
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165515)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              318
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165518)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              319
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165522)
(declare-const $k@84@02 $Perm)
(assert ($Perm.isReadVar $k@84@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@84@02 $Perm.No) (< $Perm.No $k@84@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              320
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165536)
(assert (<= $Perm.No $k@84@02))
(assert (<= $k@84@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@84@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              321
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165544)
(push) ; 4
(assert (not (< $Perm.No $k@84@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              322
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165547)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              323
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165552)
(push) ; 4
(assert (not (< $Perm.No $k@84@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              324
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165555)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              325
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165559)
(push) ; 4
(assert (not (< $Perm.No $k@84@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              326
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165562)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              327
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165566)
(push) ; 4
(assert (not (< $Perm.No $k@84@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              328
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165569)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              329
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165573)
(push) ; 4
(assert (not (< $Perm.No $k@84@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              330
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165576)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              331
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165580)
(declare-const $k@85@02 $Perm)
(assert ($Perm.isReadVar $k@85@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@85@02 $Perm.No) (< $Perm.No $k@85@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              332
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165594)
(assert (<= $Perm.No $k@85@02))
(assert (<= $k@85@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@85@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_mon != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              333
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165602)
(push) ; 4
(assert (not (< $Perm.No $k@85@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              334
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165605)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              335
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165610)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              336
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165613)
(declare-const $k@86@02 $Perm)
(assert ($Perm.isReadVar $k@86@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@86@02 $Perm.No) (< $Perm.No $k@86@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              337
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165627)
(assert (<= $Perm.No $k@86@02))
(assert (<= $k@86@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@86@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu.ALU_m == diz.Driver_m
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              338
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165635)
(push) ; 4
(assert (not (< $Perm.No $k@83@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              339
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165638)
(push) ; 4
(assert (not (< $Perm.No $k@86@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              340
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165641)
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              341
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165644)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr == diz
(push) ; 4
(assert (not (< $Perm.No $k@81@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              342
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165649)
(push) ; 4
(assert (not (< $Perm.No $k@84@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              343
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165652)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
  diz@15@02))
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
(pop) ; 4
(push) ; 4
; [eval] !true
(pop) ; 4
(pop) ; 3
(push) ; 3
; Loop head block: Establish invariant
(declare-const $k@87@02 $Perm)
(assert ($Perm.isReadVar $k@87@02 $Perm.Write))
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@87@02 $Perm.No) (< $Perm.No $k@87@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              344
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165670)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@18@02 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              345
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165673)
(assert (< $k@87@02 $k@18@02))
(assert (<= $Perm.No (- $k@18@02 $k@87@02)))
(assert (<= (- $k@18@02 $k@87@02) $Perm.Write))
(assert (implies (< $Perm.No (- $k@18@02 $k@87@02)) (not (= diz@15@02 $Ref.null))))
; [eval] diz.Driver_m != null
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              346
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165680)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              347
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165683)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              348
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165686)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              349
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165689)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              350
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165692)
; [eval] |diz.Driver_m.Main_process_state| == 1
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              351
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165695)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              352
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165698)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              353
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165701)
; [eval] |diz.Driver_m.Main_event_state| == 2
; [eval] |diz.Driver_m.Main_event_state|
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              354
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165704)
; [eval] (forall i__78: Int :: { diz.Driver_m.Main_process_state[i__78] } 0 <= i__78 && i__78 < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i__78] == -1 || 0 <= diz.Driver_m.Main_process_state[i__78] && diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|)
(declare-const i__78@88@02 Int)
(push) ; 4
; [eval] 0 <= i__78 && i__78 < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i__78] == -1 || 0 <= diz.Driver_m.Main_process_state[i__78] && diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= i__78 && i__78 < |diz.Driver_m.Main_process_state|
; [eval] 0 <= i__78
(push) ; 5
; [then-branch: 20 | 0 <= i__78@88@02 | live]
; [else-branch: 20 | !(0 <= i__78@88@02) | live]
(push) ; 6
; [then-branch: 20 | 0 <= i__78@88@02]
(assert (<= 0 i__78@88@02))
; [eval] i__78 < |diz.Driver_m.Main_process_state|
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 7
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              355
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165711)
(pop) ; 6
(push) ; 6
; [else-branch: 20 | !(0 <= i__78@88@02)]
(assert (not (<= 0 i__78@88@02)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 21 | i__78@88@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i__78@88@02 | live]
; [else-branch: 21 | !(i__78@88@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i__78@88@02) | live]
(push) ; 6
; [then-branch: 21 | i__78@88@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i__78@88@02]
(assert (and
  (<
    i__78@88@02
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
  (<= 0 i__78@88@02)))
; [eval] diz.Driver_m.Main_process_state[i__78] == -1 || 0 <= diz.Driver_m.Main_process_state[i__78] && diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i__78] == -1
; [eval] diz.Driver_m.Main_process_state[i__78]
(push) ; 7
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              356
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165719)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i__78@88@02 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              357
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165722)
; [eval] -1
(push) ; 7
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i__78@88@02] == -1 | live]
; [else-branch: 22 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i__78@88@02] != -1 | live]
(push) ; 8
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i__78@88@02] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i__78@88@02)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 22 | First:(Second:(Second:(Second:(Second:($t@17@02)))))[i__78@88@02] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
      i__78@88@02)
    (- 0 1))))
; [eval] 0 <= diz.Driver_m.Main_process_state[i__78] && diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= diz.Driver_m.Main_process_state[i__78]
; [eval] diz.Driver_m.Main_process_state[i__78]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              358
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165730)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i__78@88@02 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              359
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165733)
(push) ; 9
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i__78@88@02] | live]
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i__78@88@02]) | live]
(push) ; 10
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i__78@88@02]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i__78@88@02)))
; [eval] diz.Driver_m.Main_process_state[i__78] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i__78]
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              360
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165739)
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i__78@88@02 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              361
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165742)
; [eval] |diz.Driver_m.Main_event_state|
(set-option :timeout 10)
(push) ; 11
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              362
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165745)
(pop) ; 10
(push) ; 10
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:(Second:($t@17@02)))))[i__78@88@02])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
      i__78@88@02))))
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
; [else-branch: 21 | !(i__78@88@02 < |First:(Second:(Second:(Second:(Second:($t@17@02)))))| && 0 <= i__78@88@02)]
(assert (not
  (and
    (<
      i__78@88@02
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
    (<= 0 i__78@88@02))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 4
(assert (not (forall ((i__78@88@02 Int)) (!
  (implies
    (and
      (<
        i__78@88@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
      (<= 0 i__78@88@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
          i__78@88@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
            i__78@88@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
            i__78@88@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i__78@88@02))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              363
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165752)
(assert (forall ((i__78@88@02 Int)) (!
  (implies
    (and
      (<
        i__78@88@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))
      (<= 0 i__78@88@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
          i__78@88@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
            i__78@88@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
            i__78@88@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))
    i__78@88@02))
  :qid |prog.l<no position>|)))
(declare-const $k@89@02 $Perm)
(assert ($Perm.isReadVar $k@89@02 $Perm.Write))
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              364
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165767)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@89@02 $Perm.No) (< $Perm.No $k@89@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              365
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165770)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= (+ $k@20@02 $k@52@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              366
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165773)
(assert (< $k@89@02 (+ $k@20@02 $k@52@02)))
(assert (<= $Perm.No (- (+ $k@20@02 $k@52@02) $k@89@02)))
(assert (<= (- (+ $k@20@02 $k@52@02) $k@89@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@20@02 $k@52@02) $k@89@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))
      $Ref.null))))
; [eval] diz.Driver_m.Main_alu != null
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              367
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165780)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              368
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165783)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              369
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165786)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              370
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165789)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              371
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165792)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              372
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165795)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              373
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165798)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              374
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165801)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              375
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165804)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              376
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165807)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              377
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165810)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              378
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165813)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              379
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165816)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              380
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165819)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              381
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165822)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              382
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165825)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              383
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165828)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              384
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165831)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              385
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165834)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              386
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165837)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              387
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165840)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              388
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165843)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              389
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165846)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              390
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165849)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              391
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165852)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              392
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165855)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              393
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165858)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              394
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165861)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              395
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165864)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              396
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165867)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              397
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165870)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              398
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165873)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              399
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165876)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              400
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165879)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              401
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165882)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              402
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165885)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              403
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165888)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              404
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165891)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              405
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165894)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              406
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165897)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              407
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165900)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              408
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165903)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              409
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165906)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              410
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165909)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              411
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165912)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              412
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165915)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              413
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165918)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              414
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165921)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              415
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165924)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              416
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165927)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              417
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165930)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              418
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165933)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              419
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165936)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              420
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165939)
(declare-const $k@90@02 $Perm)
(assert ($Perm.isReadVar $k@90@02 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              421
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165953)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@90@02 $Perm.No) (< $Perm.No $k@90@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              422
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165956)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= (+ $k@21@02 $k@54@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              423
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165959)
(assert (< $k@90@02 (+ $k@21@02 $k@54@02)))
(assert (<= $Perm.No (- (+ $k@21@02 $k@54@02) $k@90@02)))
(assert (<= (- (+ $k@21@02 $k@54@02) $k@90@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@21@02 $k@54@02) $k@90@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))
      $Ref.null))))
; [eval] diz.Driver_m.Main_dr != null
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              424
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165966)
(push) ; 4
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              425
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165969)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              426
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165972)
(push) ; 4
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              427
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165975)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  $t@55@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              428
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165978)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              429
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165981)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              430
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165984)
(push) ; 4
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              431
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165987)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  $t@55@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              432
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165990)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              433
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165993)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              434
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165996)
(push) ; 4
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              435
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            165999)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  $t@55@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              436
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166002)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              437
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166005)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              438
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166008)
(push) ; 4
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              439
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166011)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02))))))))))))))))))))))))))
  $t@55@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              440
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166014)
(push) ; 4
(assert (not (= $Perm.Write $Perm.No)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              441
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166017)
(declare-const $k@91@02 $Perm)
(assert ($Perm.isReadVar $k@91@02 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              442
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166031)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@91@02 $Perm.No) (< $Perm.No $k@91@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              443
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166034)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= (+ $k@22@02 $k@56@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              444
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166037)
(assert (< $k@91@02 (+ $k@22@02 $k@56@02)))
(assert (<= $Perm.No (- (+ $k@22@02 $k@56@02) $k@91@02)))
(assert (<= (- (+ $k@22@02 $k@56@02) $k@91@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@22@02 $k@56@02) $k@91@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@17@02)))
      $Ref.null))))
; [eval] diz.Driver_m.Main_mon != null
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              445
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166044)
(push) ; 4
(assert (not (< $Perm.No (+ $k@22@02 $k@56@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              446
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166047)
(declare-const $k@92@02 $Perm)
(assert ($Perm.isReadVar $k@92@02 $Perm.Write))
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              447
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166061)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              448
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166064)
(set-option :timeout 0)
(push) ; 4
(assert (not (or (= $k@92@02 $Perm.No) (< $Perm.No $k@92@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              449
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166067)
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              450
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166070)
(push) ; 4
(assert (not (not (= (+ $k@23@02 $k@58@02) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              451
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166073)
(assert (< $k@92@02 (+ $k@23@02 $k@58@02)))
(assert (<= $Perm.No (- (+ $k@23@02 $k@58@02) $k@92@02)))
(assert (<= (- (+ $k@23@02 $k@58@02) $k@92@02) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@23@02 $k@58@02) $k@92@02))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
      $Ref.null))))
; [eval] diz.Driver_m.Main_alu.ALU_m == diz.Driver_m
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              452
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166080)
(push) ; 4
(assert (not (< $Perm.No (+ $k@20@02 $k@52@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              453
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166083)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@17@02)))))))))))
  $t@53@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              454
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166086)
(push) ; 4
(assert (not (< $Perm.No (+ $k@23@02 $k@58@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              455
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166089)
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              456
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166092)
; [eval] diz.Driver_m.Main_dr == diz
(push) ; 4
(assert (not (< $Perm.No $k@18@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              457
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166095)
(push) ; 4
(assert (not (< $Perm.No (+ $k@21@02 $k@54@02))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              458
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166098)
(set-option :timeout 0)
(push) ; 4
(assert (not (= $t@55@02 diz@15@02)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1045
;  :arith-assert-diseq      22
;  :arith-assert-lower      63
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               207
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 187
;  :datatype-occurs-check   30
;  :datatype-splits         88
;  :decisions               180
;  :del-clause              47
;  :final-checks            18
;  :max-generation          1
;  :max-memory              4.17
;  :memory                  4.17
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              4073669
;  :num-checks              459
;  :propagations            39
;  :quant-instantiations    32
;  :rlimit-count            166101)
(assert (= $t@55@02 diz@15@02))
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert ($Perm.isReadVar $k@81@02 $Perm.Write))
(assert ($Perm.isReadVar $k@83@02 $Perm.Write))
(assert ($Perm.isReadVar $k@84@02 $Perm.Write))
(assert ($Perm.isReadVar $k@85@02 $Perm.Write))
(assert ($Perm.isReadVar $k@86@02 $Perm.Write))
(assert (= $t@80@02 ($Snap.combine ($Snap.first $t@80@02) ($Snap.second $t@80@02))))
(assert (<= $Perm.No $k@81@02))
(assert (<= $k@81@02 $Perm.Write))
(assert (implies (< $Perm.No $k@81@02) (not (= diz@15@02 $Ref.null))))
(assert (=
  ($Snap.second $t@80@02)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@80@02))
    ($Snap.second ($Snap.second $t@80@02)))))
(assert (= ($Snap.first ($Snap.second $t@80@02)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@80@02))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@80@02)))
    ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@80@02)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
  $Snap.unit))
(assert (forall ((i__78@82@02 Int)) (!
  (implies
    (and
      (<
        i__78@82@02
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))
      (<= 0 i__78@82@02))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
          i__78@82@02)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
            i__78@82@02)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
            i__78@82@02)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))
    i__78@82@02))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))
(assert (<= $Perm.No $k@83@02))
(assert (<= $k@83@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@83@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))
(assert (<= $Perm.No $k@84@02))
(assert (<= $k@84@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@84@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
(assert (<= $Perm.No $k@85@02))
(assert (<= $k@85@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@85@02)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No $k@86@02))
(assert (<= $k@86@02 $Perm.Write))
(assert (implies
  (< $Perm.No $k@86@02)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@80@02))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@80@02)))))))))))))))))))))))))
  diz@15@02))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unsat
(set-option :timeout 10)
(check-sat)
; unsat
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
