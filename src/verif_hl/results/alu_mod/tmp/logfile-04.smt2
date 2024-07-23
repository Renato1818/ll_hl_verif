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
; ---------- ALU___contract_unsatisfiable__set_bit_EncodedGlobalVariables_Integer_Integer_Integer ----------
(declare-const diz@0@04 $Ref)
(declare-const globals@1@04 $Ref)
(declare-const value@2@04 Int)
(declare-const pos@3@04 Int)
(declare-const bit@4@04 Int)
(declare-const sys__result@5@04 Int)
(declare-const diz@6@04 $Ref)
(declare-const globals@7@04 $Ref)
(declare-const value@8@04 Int)
(declare-const pos@9@04 Int)
(declare-const bit@10@04 Int)
(declare-const sys__result@11@04 Int)
(push) ; 1
(declare-const $t@12@04 $Snap)
(assert (= $t@12@04 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@6@04 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.ALU_m, wildcard) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && (true && (true && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__10: Int :: { diz.ALU_m.Main_process_state[i__10] } 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|)) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && acc(diz.ALU_m.Main_alu.ALU_data1, write) && acc(diz.ALU_m.Main_alu.ALU_data2, write) && acc(diz.ALU_m.Main_alu.ALU_result, write) && acc(diz.ALU_m.Main_alu.ALU_i, write) && acc(diz.ALU_m.Main_alu.ALU_bit, write) && acc(diz.ALU_m.Main_alu.ALU_divisor, write) && acc(diz.ALU_m.Main_alu.ALU_current_bit, write) && acc(diz.ALU_m.Main_dr, wildcard) && diz.ALU_m.Main_dr != null && acc(diz.ALU_m.Main_dr.Driver_z, write) && acc(diz.ALU_m.Main_dr.Driver_x, write) && acc(diz.ALU_m.Main_dr.Driver_y, write) && acc(diz.ALU_m.Main_dr.Driver_a, write) && acc(diz.ALU_m.Main_mon, wildcard) && diz.ALU_m.Main_mon != null && acc(diz.ALU_m.Main_alu.ALU_m, wildcard) && diz.ALU_m.Main_alu.ALU_m == diz.ALU_m) && diz.ALU_m.Main_alu == diz)
(declare-const $t@13@04 $Snap)
(assert (= $t@13@04 ($Snap.combine ($Snap.first $t@13@04) ($Snap.second $t@13@04))))
(assert (= ($Snap.first $t@13@04) $Snap.unit))
(assert (=
  ($Snap.second $t@13@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@13@04))
    ($Snap.second ($Snap.second $t@13@04)))))
(declare-const $k@14@04 $Perm)
(assert ($Perm.isReadVar $k@14@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@14@04 $Perm.No) (< $Perm.No $k@14@04))))
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
(assert (<= $Perm.No $k@14@04))
(assert (<= $k@14@04 $Perm.Write))
(assert (implies (< $Perm.No $k@14@04) (not (= diz@6@04 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@13@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@13@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@13@04))) $Snap.unit))
; [eval] diz.ALU_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :rlimit-count          112306)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@13@04))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@13@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
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
;  :rlimit-count          112590)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :rlimit-count          113030
;  :time                  0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.02s
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
;  :memory                3.87
;  :mk-bool-var           278
;  :mk-clause             3
;  :num-allocs            3672377
;  :num-checks            6
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113279
;  :time                  0.02)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           287
;  :mk-clause             6
;  :num-allocs            3672377
;  :num-checks            7
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          113664)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           289
;  :mk-clause             6
;  :num-allocs            3672377
;  :num-checks            8
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          113933)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))
  $Snap.unit))
; [eval] (forall i__10: Int :: { diz.ALU_m.Main_process_state[i__10] } 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|)
(declare-const i__10@15@04 Int)
(push) ; 3
; [eval] 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__10
(push) ; 4
; [then-branch: 0 | 0 <= i__10@15@04 | live]
; [else-branch: 0 | !(0 <= i__10@15@04) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i__10@15@04]
(assert (<= 0 i__10@15@04))
; [eval] i__10 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           300
;  :mk-clause             9
;  :num-allocs            3672377
;  :num-checks            9
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114425)
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i__10@15@04)]
(assert (not (<= 0 i__10@15@04)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i__10@15@04 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))| && 0 <= i__10@15@04 | live]
; [else-branch: 1 | !(i__10@15@04 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))| && 0 <= i__10@15@04) | live]
(push) ; 5
; [then-branch: 1 | i__10@15@04 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))| && 0 <= i__10@15@04]
(assert (and
  (<
    i__10@15@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))
  (<= 0 i__10@15@04)))
; [eval] diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__10] == -1
; [eval] diz.ALU_m.Main_process_state[i__10]
(push) ; 6
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           302
;  :mk-clause             9
;  :num-allocs            3672377
;  :num-checks            10
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114586)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__10@15@04 0)))
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
;  :memory                3.87
;  :mk-bool-var           302
;  :mk-clause             9
;  :num-allocs            3672377
;  :num-checks            11
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114595)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))[i__10@15@04] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))[i__10@15@04] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))[i__10@15@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
    i__10@15@04)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))[i__10@15@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
      i__10@15@04)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__10]
; [eval] diz.ALU_m.Main_process_state[i__10]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           303
;  :mk-clause             9
;  :num-allocs            3672377
;  :num-checks            12
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114845)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__10@15@04 0)))
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
;  :memory                3.87
;  :mk-bool-var           303
;  :mk-clause             9
;  :num-allocs            3672377
;  :num-checks            13
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114854)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))[i__10@15@04] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))[i__10@15@04]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))[i__10@15@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
    i__10@15@04)))
; [eval] diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__10]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           306
;  :mk-clause             10
;  :num-allocs            3672377
;  :num-checks            14
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115047
;  :time                  0.00)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__10@15@04 0)))
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
;  :memory                3.87
;  :mk-bool-var           306
;  :mk-clause             10
;  :num-allocs            3672377
;  :num-checks            15
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115056)
; [eval] |diz.ALU_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           306
;  :mk-clause             10
;  :num-allocs            3672377
;  :num-checks            16
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115104)
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))[i__10@15@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
      i__10@15@04))))
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
; [else-branch: 1 | !(i__10@15@04 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@13@04)))))))| && 0 <= i__10@15@04)]
(assert (not
  (and
    (<
      i__10@15@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))
    (<= 0 i__10@15@04))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__10@15@04 Int)) (!
  (implies
    (and
      (<
        i__10@15@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))
      (<= 0 i__10@15@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
          i__10@15@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
            i__10@15@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
            i__10@15@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))
    i__10@15@04))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           308
;  :mk-clause             10
;  :num-allocs            3672377
;  :num-checks            17
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115819)
(declare-const $k@16@04 $Perm)
(assert ($Perm.isReadVar $k@16@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@16@04 $Perm.No) (< $Perm.No $k@16@04))))
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
;  :memory                3.87
;  :mk-bool-var           312
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            18
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116017)
(assert (<= $Perm.No $k@16@04))
(assert (<= $k@16@04 $Perm.Write))
(assert (implies
  (< $Perm.No $k@16@04)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@13@04)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           315
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            19
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116370
;  :time                  0.00)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           315
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            20
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116418)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           318
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            21
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          116804)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           318
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            22
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          116852)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           319
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            23
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117139)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           319
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            24
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117187)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           320
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            25
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117484)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           320
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            26
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117532)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           321
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            27
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117839)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           321
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            28
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117887)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           322
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            29
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118204)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           322
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            30
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118252)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           323
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            31
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118579)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           323
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            32
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118627)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           324
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            33
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118964)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           324
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            34
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119012)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :conflicts             31
;  :datatype-accessor-ax  22
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          1
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            35
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119359)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            36
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119407)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           326
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            37
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119764)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           326
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            38
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119812)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           327
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            39
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120179)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           327
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            40
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120227)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           328
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            41
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120604)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           328
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            42
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120652)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            43
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121039)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
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
;  :memory                3.87
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            44
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121087)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                3.87
;  :mk-bool-var           330
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            45
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121484)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                3.87
;  :mk-bool-var           330
;  :mk-clause             12
;  :num-allocs            3672377
;  :num-checks            46
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121532)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :num-allocs            3796636
;  :num-checks            47
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121939)
(declare-const $k@17@04 $Perm)
(assert ($Perm.isReadVar $k@17@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@17@04 $Perm.No) (< $Perm.No $k@17@04))))
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
;  :num-allocs            3796636
;  :num-checks            48
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122138)
(assert (<= $Perm.No $k@17@04))
(assert (<= $k@17@04 $Perm.Write))
(assert (implies
  (< $Perm.No $k@17@04)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@13@04)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :num-allocs            3796636
;  :num-checks            49
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122641)
(push) ; 3
(assert (not (< $Perm.No $k@17@04)))
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
;  :num-allocs            3796636
;  :num-checks            50
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122689)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :num-allocs            3796636
;  :num-checks            51
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123249)
(push) ; 3
(assert (not (< $Perm.No $k@17@04)))
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
;  :num-allocs            3796636
;  :num-checks            52
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123297)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :num-allocs            3796636
;  :num-checks            53
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123734)
(push) ; 3
(assert (not (< $Perm.No $k@17@04)))
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
;  :num-allocs            3796636
;  :num-checks            54
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123782)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :num-allocs            3796636
;  :num-checks            55
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124229)
(push) ; 3
(assert (not (< $Perm.No $k@17@04)))
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
;  :num-allocs            3796636
;  :num-checks            56
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124277)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :num-allocs            3796636
;  :num-checks            57
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124734)
(push) ; 3
(assert (not (< $Perm.No $k@17@04)))
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
;  :num-allocs            3796636
;  :num-checks            58
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124782)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :num-allocs            3796636
;  :num-checks            59
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          125249)
(declare-const $k@18@04 $Perm)
(assert ($Perm.isReadVar $k@18@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@18@04 $Perm.No) (< $Perm.No $k@18@04))))
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
;  :num-allocs            3796636
;  :num-checks            60
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          125448)
(assert (<= $Perm.No $k@18@04))
(assert (<= $k@18@04 $Perm.Write))
(assert (implies
  (< $Perm.No $k@18@04)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@13@04)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :num-allocs            3796636
;  :num-checks            61
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          126011)
(push) ; 3
(assert (not (< $Perm.No $k@18@04)))
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
;  :num-allocs            3796636
;  :num-checks            62
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          126059)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :num-allocs            3796636
;  :num-checks            63
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          126661)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :num-allocs            3796636
;  :num-checks            64
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          126709)
(declare-const $k@19@04 $Perm)
(assert ($Perm.isReadVar $k@19@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@19@04 $Perm.No) (< $Perm.No $k@19@04))))
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
;  :num-allocs            3796636
;  :num-checks            65
;  :propagations          23
;  :quant-instantiations  11
;  :rlimit-count          126907)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@6@04
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))
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
;  :memory                  3.97
;  :mk-bool-var             389
;  :mk-clause               19
;  :num-allocs              3796636
;  :num-checks              66
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            127815)
(assert (<= $Perm.No $k@19@04))
(assert (<= $k@19@04 $Perm.Write))
(assert (implies
  (< $Perm.No $k@19@04)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_m == diz.ALU_m
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                  3.97
;  :mk-bool-var             392
;  :mk-clause               19
;  :num-allocs              3796636
;  :num-checks              67
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128398)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                  3.97
;  :mk-bool-var             392
;  :mk-clause               19
;  :num-allocs              3796636
;  :num-checks              68
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128446)
(push) ; 3
(assert (not (< $Perm.No $k@19@04)))
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
;  :memory                  3.97
;  :mk-bool-var             392
;  :mk-clause               19
;  :num-allocs              3796636
;  :num-checks              69
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128494)
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                  3.97
;  :mk-bool-var             392
;  :mk-clause               19
;  :num-allocs              3796636
;  :num-checks              70
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128542)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@13@04)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 3
(assert (not (< $Perm.No $k@14@04)))
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
;  :memory                  3.97
;  :mk-bool-var             395
;  :mk-clause               19
;  :num-allocs              3796636
;  :num-checks              71
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            129103)
(push) ; 3
(assert (not (< $Perm.No $k@16@04)))
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
;  :memory                  3.97
;  :mk-bool-var             395
;  :mk-clause               19
;  :num-allocs              3796636
;  :num-checks              72
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            129151)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04)))))))))))))
  diz@6@04))
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
  diz@6@04
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))
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
;  :num-allocs              3926318
;  :num-checks              76
;  :propagations            25
;  :quant-instantiations    12
;  :rlimit-count            131351)
(declare-const $t@20@04 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@14@04)
    (=
      $t@20@04
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@13@04)))))
  (implies
    (< $Perm.No $k@19@04)
    (=
      $t@20@04
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@04))))))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@14@04 $k@19@04)))
(assert (<= (+ $k@14@04 $k@19@04) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@14@04 $k@19@04)) (not (= diz@6@04 $Ref.null))))
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Main___contract_unsatisfiable__Main_EncodedGlobalVariables ----------
(declare-const diz@21@04 $Ref)
(declare-const globals@22@04 $Ref)
(declare-const diz@23@04 $Ref)
(declare-const globals@24@04 $Ref)
(push) ; 1
(declare-const $t@25@04 $Snap)
(assert (= $t@25@04 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@23@04 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@26@04 $Snap)
(assert (= $t@26@04 ($Snap.combine ($Snap.first $t@26@04) ($Snap.second $t@26@04))))
(assert (= ($Snap.first $t@26@04) $Snap.unit))
(assert (= ($Snap.second $t@26@04) $Snap.unit))
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
; ---------- Main___contract_unsatisfiable__main_EncodedGlobalVariables ----------
(declare-const diz@27@04 $Ref)
(declare-const globals@28@04 $Ref)
(declare-const diz@29@04 $Ref)
(declare-const globals@30@04 $Ref)
(push) ; 1
(declare-const $t@31@04 $Snap)
(assert (= $t@31@04 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@29@04 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@32@04 $Snap)
(assert (= $t@32@04 ($Snap.combine ($Snap.first $t@32@04) ($Snap.second $t@32@04))))
(assert (= ($Snap.first $t@32@04) $Snap.unit))
(assert (= ($Snap.second $t@32@04) $Snap.unit))
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
; ---------- Main_main_EncodedGlobalVariables ----------
(declare-const diz@33@04 $Ref)
(declare-const globals@34@04 $Ref)
(declare-const diz@35@04 $Ref)
(declare-const globals@36@04 $Ref)
(push) ; 1
(declare-const $t@37@04 $Snap)
(assert (= $t@37@04 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@35@04 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; var min_advance__91: Int
(declare-const min_advance__91@38@04 Int)
; [exec]
; var __flatten_74__89: Seq[Int]
(declare-const __flatten_74__89@39@04 Seq<Int>)
; [exec]
; var __flatten_75__90: Seq[Int]
(declare-const __flatten_75__90@40@04 Seq<Int>)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@41@04 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@41@04 ($Snap.combine ($Snap.first $t@41@04) ($Snap.second $t@41@04))))
(assert (= ($Snap.first $t@41@04) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@41@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@41@04))
    ($Snap.second ($Snap.second $t@41@04)))))
(assert (= ($Snap.first ($Snap.second $t@41@04)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@41@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@41@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@41@04))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@41@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@42@04 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@42@04 | live]
; [else-branch: 4 | !(0 <= i@42@04) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@42@04]
(assert (<= 0 i@42@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@42@04)]
(assert (not (<= 0 i@42@04)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@42@04 < |First:(Second:(Second:(Second:($t@41@04))))| && 0 <= i@42@04 | live]
; [else-branch: 5 | !(i@42@04 < |First:(Second:(Second:(Second:($t@41@04))))| && 0 <= i@42@04) | live]
(push) ; 5
; [then-branch: 5 | i@42@04 < |First:(Second:(Second:(Second:($t@41@04))))| && 0 <= i@42@04]
(assert (and
  (<
    i@42@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
  (<= 0 i@42@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@42@04 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               604
;  :arith-assert-diseq      10
;  :arith-assert-lower      30
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             479
;  :mk-clause               26
;  :num-allocs              3926318
;  :num-checks              90
;  :propagations            28
;  :quant-instantiations    18
;  :rlimit-count            137322)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@41@04))))[i@42@04] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@41@04))))[i@42@04] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@41@04))))[i@42@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
    i@42@04)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@41@04))))[i@42@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
      i@42@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@42@04 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               604
;  :arith-assert-diseq      10
;  :arith-assert-lower      30
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             480
;  :mk-clause               26
;  :num-allocs              3926318
;  :num-checks              91
;  :propagations            28
;  :quant-instantiations    18
;  :rlimit-count            137497)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@41@04))))[i@42@04] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@41@04))))[i@42@04]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@41@04))))[i@42@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
    i@42@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@42@04 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               604
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      18
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             483
;  :mk-clause               27
;  :num-allocs              3926318
;  :num-checks              92
;  :propagations            28
;  :quant-instantiations    18
;  :rlimit-count            137621)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@41@04))))[i@42@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
      i@42@04))))
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
; [else-branch: 5 | !(i@42@04 < |First:(Second:(Second:(Second:($t@41@04))))| && 0 <= i@42@04)]
(assert (not
  (and
    (<
      i@42@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
    (<= 0 i@42@04))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@42@04 Int)) (!
  (implies
    (and
      (<
        i@42@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
      (<= 0 i@42@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
          i@42@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
            i@42@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
            i@42@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
    i@42@04))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))
(declare-const $k@43@04 $Perm)
(assert ($Perm.isReadVar $k@43@04 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@43@04 $Perm.No) (< $Perm.No $k@43@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               609
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      19
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               70
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             489
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              93
;  :propagations            29
;  :quant-instantiations    18
;  :rlimit-count            138389)
(assert (<= $Perm.No $k@43@04))
(assert (<= $k@43@04 $Perm.Write))
(assert (implies (< $Perm.No $k@43@04) (not (= diz@35@04 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))
  $Snap.unit))
; [eval] diz.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               615
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               71
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             492
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              94
;  :propagations            29
;  :quant-instantiations    18
;  :rlimit-count            138712)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               621
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               72
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             495
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              95
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            139068)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               626
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               73
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             496
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              96
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            139325)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               631
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               74
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             497
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              97
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            139592)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               636
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             498
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              98
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            139869)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               641
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             499
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              99
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            140156)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               646
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             500
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              100
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            140453)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               651
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             501
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              101
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            140760)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               656
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             502
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              102
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            141077)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               661
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             503
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              103
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            141404)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               666
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             504
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              104
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            141741)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               671
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             505
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              105
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            142088)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               676
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               83
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             506
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              106
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            142445)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               681
;  :arith-assert-diseq      12
;  :arith-assert-lower      35
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             507
;  :mk-clause               29
;  :num-allocs              3926318
;  :num-checks              107
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            142812)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))
(declare-const $k@44@04 $Perm)
(assert ($Perm.isReadVar $k@44@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@44@04 $Perm.No) (< $Perm.No $k@44@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               686
;  :arith-assert-diseq      13
;  :arith-assert-lower      37
;  :arith-assert-upper      21
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             512
;  :mk-clause               31
;  :num-allocs              3926318
;  :num-checks              108
;  :propagations            30
;  :quant-instantiations    19
;  :rlimit-count            143333)
(assert (<= $Perm.No $k@44@04))
(assert (<= $k@44@04 $Perm.Write))
(assert (implies (< $Perm.No $k@44@04) (not (= diz@35@04 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               692
;  :arith-assert-diseq      13
;  :arith-assert-lower      37
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             515
;  :mk-clause               31
;  :num-allocs              3926318
;  :num-checks              109
;  :propagations            30
;  :quant-instantiations    19
;  :rlimit-count            143806)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               698
;  :arith-assert-diseq      13
;  :arith-assert-lower      37
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             518
;  :mk-clause               31
;  :num-allocs              3926318
;  :num-checks              110
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            144336)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               703
;  :arith-assert-diseq      13
;  :arith-assert-lower      37
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             519
;  :mk-clause               31
;  :num-allocs              3926318
;  :num-checks              111
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            144743)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               708
;  :arith-assert-diseq      13
;  :arith-assert-lower      37
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               89
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             520
;  :mk-clause               31
;  :num-allocs              3926318
;  :num-checks              112
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            145160)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               713
;  :arith-assert-diseq      13
;  :arith-assert-lower      37
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             521
;  :mk-clause               31
;  :num-allocs              3926318
;  :num-checks              113
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            145587)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))))))
(declare-const $k@45@04 $Perm)
(assert ($Perm.isReadVar $k@45@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@45@04 $Perm.No) (< $Perm.No $k@45@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               718
;  :arith-assert-diseq      14
;  :arith-assert-lower      39
;  :arith-assert-upper      23
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               91
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             526
;  :mk-clause               33
;  :num-allocs              3926318
;  :num-checks              114
;  :propagations            31
;  :quant-instantiations    20
;  :rlimit-count            146167)
(assert (<= $Perm.No $k@45@04))
(assert (<= $k@45@04 $Perm.Write))
(assert (implies (< $Perm.No $k@45@04) (not (= diz@35@04 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@45@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               724
;  :arith-assert-diseq      14
;  :arith-assert-lower      39
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             529
;  :mk-clause               33
;  :num-allocs              3926318
;  :num-checks              115
;  :propagations            31
;  :quant-instantiations    20
;  :rlimit-count            146700)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               730
;  :arith-assert-diseq      14
;  :arith-assert-lower      39
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               93
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             532
;  :mk-clause               33
;  :num-allocs              3926318
;  :num-checks              116
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            147272)
(declare-const $k@46@04 $Perm)
(assert ($Perm.isReadVar $k@46@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@46@04 $Perm.No) (< $Perm.No $k@46@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               730
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      25
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               94
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             536
;  :mk-clause               35
;  :num-allocs              3926318
;  :num-checks              117
;  :propagations            32
;  :quant-instantiations    21
;  :rlimit-count            147471)
(assert (<= $Perm.No $k@46@04))
(assert (<= $k@46@04 $Perm.Write))
(assert (implies
  (< $Perm.No $k@46@04)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               731
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               95
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             538
;  :mk-clause               35
;  :num-allocs              3926318
;  :num-checks              118
;  :propagations            32
;  :quant-instantiations    21
;  :rlimit-count            147937)
(push) ; 3
(assert (not (< $Perm.No $k@46@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               731
;  :arith-assert-diseq      15
;  :arith-assert-lower      41
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   45
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            25
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             538
;  :mk-clause               35
;  :num-allocs              3926318
;  :num-checks              119
;  :propagations            32
;  :quant-instantiations    21
;  :rlimit-count            147985
;  :time                    0.00)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))))))
  diz@35@04))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@41@04 diz@35@04 globals@36@04))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@47@04 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@48@04 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 8 | 0 <= i@48@04 | live]
; [else-branch: 8 | !(0 <= i@48@04) | live]
(push) ; 5
; [then-branch: 8 | 0 <= i@48@04]
(assert (<= 0 i@48@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 8 | !(0 <= i@48@04)]
(assert (not (<= 0 i@48@04)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 9 | i@48@04 < |First:(Second:(Second:(Second:($t@41@04))))| && 0 <= i@48@04 | live]
; [else-branch: 9 | !(i@48@04 < |First:(Second:(Second:(Second:($t@41@04))))| && 0 <= i@48@04) | live]
(push) ; 5
; [then-branch: 9 | i@48@04 < |First:(Second:(Second:(Second:($t@41@04))))| && 0 <= i@48@04]
(assert (and
  (<
    i@48@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
  (<= 0 i@48@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@48@04 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               858
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      27
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              34
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             572
;  :mk-clause               36
;  :num-allocs              3926318
;  :num-checks              122
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            149886)
; [eval] -1
(push) ; 6
; [then-branch: 10 | First:(Second:(Second:(Second:($t@41@04))))[i@48@04] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:($t@41@04))))[i@48@04] != -1 | live]
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:($t@41@04))))[i@48@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
    i@48@04)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 10 | First:(Second:(Second:(Second:($t@41@04))))[i@48@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
      i@48@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@48@04 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      17
;  :arith-assert-lower      45
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              34
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             579
;  :mk-clause               48
;  :num-allocs              3926318
;  :num-checks              123
;  :propagations            38
;  :quant-instantiations    23
;  :rlimit-count            150123)
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@41@04))))[i@48@04] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@41@04))))[i@48@04]) | live]
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@41@04))))[i@48@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
    i@48@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@48@04 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      17
;  :arith-assert-lower      47
;  :arith-assert-upper      29
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              34
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             583
;  :mk-clause               48
;  :num-allocs              3926318
;  :num-checks              124
;  :propagations            38
;  :quant-instantiations    23
;  :rlimit-count            150254)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@41@04))))[i@48@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
      i@48@04))))
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
; [else-branch: 9 | !(i@48@04 < |First:(Second:(Second:(Second:($t@41@04))))| && 0 <= i@48@04)]
(assert (not
  (and
    (<
      i@48@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
    (<= 0 i@48@04))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 3
(assert (not (forall ((i@48@04 Int)) (!
  (implies
    (and
      (<
        i@48@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
      (<= 0 i@48@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
          i@48@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
            i@48@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
            i@48@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
    i@48@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      19
;  :arith-assert-lower      48
;  :arith-assert-upper      30
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               98
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             591
;  :mk-clause               62
;  :num-allocs              3926318
;  :num-checks              125
;  :propagations            40
;  :quant-instantiations    24
;  :rlimit-count            150700)
(assert (forall ((i@48@04 Int)) (!
  (implies
    (and
      (<
        i@48@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))
      (<= 0 i@48@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
          i@48@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
            i@48@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
            i@48@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))
    i@48@04))
  :qid |prog.l<no position>|)))
(declare-const $k@49@04 $Perm)
(assert ($Perm.isReadVar $k@49@04 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@49@04 $Perm.No) (< $Perm.No $k@49@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      50
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             596
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              126
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151261)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $k@43@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      50
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             596
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              127
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151272)
(assert (< $k@49@04 $k@43@04))
(assert (<= $Perm.No (- $k@43@04 $k@49@04)))
(assert (<= (- $k@43@04 $k@49@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@43@04 $k@49@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_alu != null
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              128
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151480)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               101
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              129
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151528)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               102
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              130
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151576)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               103
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              131
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151624)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               104
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              132
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151672)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               105
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              133
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151720)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              134
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151768)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              135
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151816)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              136
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151864)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              137
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151912)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              138
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            151960)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               111
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              139
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            152008)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               112
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              140
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            152056)
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      20
;  :arith-assert-lower      52
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               113
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             599
;  :mk-clause               64
;  :num-allocs              3926318
;  :num-checks              141
;  :propagations            41
;  :quant-instantiations    24
;  :rlimit-count            152104)
(declare-const $k@50@04 $Perm)
(assert ($Perm.isReadVar $k@50@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@50@04 $Perm.No) (< $Perm.No $k@50@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      21
;  :arith-assert-lower      54
;  :arith-assert-upper      33
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             603
;  :mk-clause               66
;  :num-allocs              3926318
;  :num-checks              142
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            152303)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $k@44@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      21
;  :arith-assert-lower      54
;  :arith-assert-upper      33
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             603
;  :mk-clause               66
;  :num-allocs              3926318
;  :num-checks              143
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            152314)
(assert (< $k@50@04 $k@44@04))
(assert (<= $Perm.No (- $k@44@04 $k@50@04)))
(assert (<= (- $k@44@04 $k@50@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@44@04 $k@50@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_dr != null
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      21
;  :arith-assert-lower      56
;  :arith-assert-upper      34
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               115
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             606
;  :mk-clause               66
;  :num-allocs              3926318
;  :num-checks              144
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            152528)
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      21
;  :arith-assert-lower      56
;  :arith-assert-upper      34
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               116
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             606
;  :mk-clause               66
;  :num-allocs              3926318
;  :num-checks              145
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            152576)
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      21
;  :arith-assert-lower      56
;  :arith-assert-upper      34
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               117
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             606
;  :mk-clause               66
;  :num-allocs              3926318
;  :num-checks              146
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            152624)
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      21
;  :arith-assert-lower      56
;  :arith-assert-upper      34
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               118
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             606
;  :mk-clause               66
;  :num-allocs              3926318
;  :num-checks              147
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            152672)
(push) ; 3
(assert (not (< $Perm.No $k@44@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      21
;  :arith-assert-lower      56
;  :arith-assert-upper      34
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               119
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             606
;  :mk-clause               66
;  :num-allocs              3926318
;  :num-checks              148
;  :propagations            42
;  :quant-instantiations    24
;  :rlimit-count            152720)
(declare-const $k@51@04 $Perm)
(assert ($Perm.isReadVar $k@51@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@51@04 $Perm.No) (< $Perm.No $k@51@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      22
;  :arith-assert-lower      58
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               120
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             610
;  :mk-clause               68
;  :num-allocs              3926318
;  :num-checks              149
;  :propagations            43
;  :quant-instantiations    24
;  :rlimit-count            152918)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $k@45@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      22
;  :arith-assert-lower      58
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               120
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             610
;  :mk-clause               68
;  :num-allocs              3926318
;  :num-checks              150
;  :propagations            43
;  :quant-instantiations    24
;  :rlimit-count            152929)
(assert (< $k@51@04 $k@45@04))
(assert (<= $Perm.No (- $k@45@04 $k@51@04)))
(assert (<= (- $k@45@04 $k@51@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@45@04 $k@51@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_mon != null
(push) ; 3
(assert (not (< $Perm.No $k@45@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      22
;  :arith-assert-lower      60
;  :arith-assert-upper      36
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         5
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             613
;  :mk-clause               68
;  :num-allocs              3926318
;  :num-checks              151
;  :propagations            43
;  :quant-instantiations    24
;  :rlimit-count            153143)
(declare-const $k@52@04 $Perm)
(assert ($Perm.isReadVar $k@52@04 $Perm.Write))
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      23
;  :arith-assert-lower      62
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         5
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               122
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             617
;  :mk-clause               70
;  :num-allocs              3926318
;  :num-checks              152
;  :propagations            44
;  :quant-instantiations    24
;  :rlimit-count            153340)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@52@04 $Perm.No) (< $Perm.No $k@52@04))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      23
;  :arith-assert-lower      62
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         5
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               123
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             617
;  :mk-clause               70
;  :num-allocs              3926318
;  :num-checks              153
;  :propagations            44
;  :quant-instantiations    24
;  :rlimit-count            153390)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $k@46@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      23
;  :arith-assert-lower      62
;  :arith-assert-upper      37
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         5
;  :arith-pivots            4
;  :binary-propagations     16
;  :conflicts               123
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             617
;  :mk-clause               70
;  :num-allocs              3926318
;  :num-checks              154
;  :propagations            44
;  :quant-instantiations    24
;  :rlimit-count            153401)
(assert (< $k@52@04 $k@46@04))
(assert (<= $Perm.No (- $k@46@04 $k@52@04)))
(assert (<= (- $k@46@04 $k@52@04) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@46@04 $k@52@04))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))
      $Ref.null))))
; [eval] diz.Main_alu.ALU_m == diz
(push) ; 3
(assert (not (< $Perm.No $k@43@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      23
;  :arith-assert-lower      64
;  :arith-assert-upper      38
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               124
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             620
;  :mk-clause               70
;  :num-allocs              3926318
;  :num-checks              155
;  :propagations            44
;  :quant-instantiations    24
;  :rlimit-count            153615)
(push) ; 3
(assert (not (< $Perm.No $k@46@04)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               862
;  :arith-assert-diseq      23
;  :arith-assert-lower      64
;  :arith-assert-upper      38
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 185
;  :datatype-occurs-check   55
;  :datatype-splits         87
;  :decisions               178
;  :del-clause              60
;  :final-checks            30
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             620
;  :mk-clause               70
;  :num-allocs              3926318
;  :num-checks              156
;  :propagations            44
;  :quant-instantiations    24
;  :rlimit-count            153663)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@41@04))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))
                                  ($Snap.combine
                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))
                                    ($Snap.combine
                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))
                                      ($Snap.combine
                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))
                                        ($Snap.combine
                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))
                                          ($Snap.combine
                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))
                                            ($Snap.combine
                                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))
                                              ($Snap.combine
                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))
                                                ($Snap.combine
                                                  $Snap.unit
                                                  ($Snap.combine
                                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))
                                                    ($Snap.combine
                                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))
                                                      ($Snap.combine
                                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))
                                                        ($Snap.combine
                                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04)))))))))))))))))))))))))))))
                                                          ($Snap.combine
                                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))))
                                                            ($Snap.combine
                                                              $Snap.unit
                                                              ($Snap.combine
                                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@41@04))))))))))))))))))))))))))))))))
                                                                $Snap.unit)))))))))))))))))))))))))))))))) diz@35@04 globals@36@04))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const min_advance__91@53@04 Int)
(declare-const __flatten_75__90@54@04 Seq<Int>)
(declare-const __flatten_74__89@55@04 Seq<Int>)
(push) ; 3
; Loop head block: Check well-definedness of invariant
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
(pop) ; 4
(push) ; 4
; [eval] !true
(pop) ; 4
(pop) ; 3
(push) ; 3
; Loop head block: Establish invariant
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
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
; (:added-eqs               1141
;  :arith-assert-diseq      23
;  :arith-assert-lower      64
;  :arith-assert-upper      38
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         5
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 260
;  :datatype-occurs-check   67
;  :datatype-splits         93
;  :decisions               250
;  :del-clause              60
;  :final-checks            36
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             630
;  :mk-clause               70
;  :num-allocs              4076311
;  :num-checks              159
;  :propagations            47
;  :quant-instantiations    24
;  :rlimit-count            157014
;  :time                    0.00)
; [then-branch: 12 | True | live]
; [else-branch: 12 | False | dead]
(push) ; 5
; [then-branch: 12 | True]
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@56@04 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@56@04 ($Snap.combine ($Snap.first $t@56@04) ($Snap.second $t@56@04))))
(assert (= ($Snap.first $t@56@04) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@56@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@56@04))
    ($Snap.second ($Snap.second $t@56@04)))))
(assert (= ($Snap.first ($Snap.second $t@56@04)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@56@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@56@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@56@04))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@56@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@57@04 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 13 | 0 <= i@57@04 | live]
; [else-branch: 13 | !(0 <= i@57@04) | live]
(push) ; 8
; [then-branch: 13 | 0 <= i@57@04]
(assert (<= 0 i@57@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 13 | !(0 <= i@57@04)]
(assert (not (<= 0 i@57@04)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 14 | i@57@04 < |First:(Second:(Second:(Second:($t@56@04))))| && 0 <= i@57@04 | live]
; [else-branch: 14 | !(i@57@04 < |First:(Second:(Second:(Second:($t@56@04))))| && 0 <= i@57@04) | live]
(push) ; 8
; [then-branch: 14 | i@57@04 < |First:(Second:(Second:(Second:($t@56@04))))| && 0 <= i@57@04]
(assert (and
  (<
    i@57@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
  (<= 0 i@57@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@57@04 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1252
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              60
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             659
;  :mk-clause               70
;  :num-allocs              4076311
;  :num-checks              161
;  :propagations            48
;  :quant-instantiations    28
;  :rlimit-count            158992)
; [eval] -1
(push) ; 9
; [then-branch: 15 | First:(Second:(Second:(Second:($t@56@04))))[i@57@04] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:($t@56@04))))[i@57@04] != -1 | live]
(push) ; 10
; [then-branch: 15 | First:(Second:(Second:(Second:($t@56@04))))[i@57@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    i@57@04)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 15 | First:(Second:(Second:(Second:($t@56@04))))[i@57@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      i@57@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@57@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1252
;  :arith-assert-diseq      23
;  :arith-assert-lower      69
;  :arith-assert-upper      41
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              60
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             660
;  :mk-clause               70
;  :num-allocs              4076311
;  :num-checks              162
;  :propagations            48
;  :quant-instantiations    28
;  :rlimit-count            159167)
(push) ; 11
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@56@04))))[i@57@04] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@56@04))))[i@57@04]) | live]
(push) ; 12
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@56@04))))[i@57@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    i@57@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@57@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1252
;  :arith-assert-diseq      24
;  :arith-assert-lower      72
;  :arith-assert-upper      41
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              60
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             663
;  :mk-clause               71
;  :num-allocs              4076311
;  :num-checks              163
;  :propagations            48
;  :quant-instantiations    28
;  :rlimit-count            159290)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@56@04))))[i@57@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      i@57@04))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 14 | !(i@57@04 < |First:(Second:(Second:(Second:($t@56@04))))| && 0 <= i@57@04)]
(assert (not
  (and
    (<
      i@57@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
    (<= 0 i@57@04))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@57@04 Int)) (!
  (implies
    (and
      (<
        i@57@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
      (<= 0 i@57@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
          i@57@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
            i@57@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
            i@57@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    i@57@04))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))
(declare-const $k@58@04 $Perm)
(assert ($Perm.isReadVar $k@58@04 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@58@04 $Perm.No) (< $Perm.No $k@58@04))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1257
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      42
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               126
;  :datatype-accessor-ax    126
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             669
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              164
;  :propagations            49
;  :quant-instantiations    28
;  :rlimit-count            160059)
(assert (<= $Perm.No $k@58@04))
(assert (<= $k@58@04 $Perm.Write))
(assert (implies (< $Perm.No $k@58@04) (not (= diz@35@04 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))
  $Snap.unit))
; [eval] diz.Main_alu != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1263
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               127
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             672
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              165
;  :propagations            49
;  :quant-instantiations    28
;  :rlimit-count            160382)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1269
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               128
;  :datatype-accessor-ax    128
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             675
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              166
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            160738)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1274
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               129
;  :datatype-accessor-ax    129
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             676
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              167
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            160995)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1279
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               130
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             677
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              168
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            161262)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1284
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               131
;  :datatype-accessor-ax    131
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             678
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              169
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            161539)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1289
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               132
;  :datatype-accessor-ax    132
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             679
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              170
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            161826)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1294
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               133
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             680
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              171
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            162123)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1299
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               134
;  :datatype-accessor-ax    134
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             681
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              172
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            162430)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1304
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               135
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             682
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              173
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            162747)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1309
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               136
;  :datatype-accessor-ax    136
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             683
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              174
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            163074)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1314
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               137
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             684
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              175
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            163411)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1319
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               138
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             685
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              176
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            163758)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1324
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               139
;  :datatype-accessor-ax    139
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             686
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              177
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            164115)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1329
;  :arith-assert-diseq      25
;  :arith-assert-lower      74
;  :arith-assert-upper      43
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               140
;  :datatype-accessor-ax    140
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.16
;  :memory                  4.16
;  :mk-bool-var             687
;  :mk-clause               73
;  :num-allocs              4076311
;  :num-checks              178
;  :propagations            49
;  :quant-instantiations    29
;  :rlimit-count            164482)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))
(declare-const $k@59@04 $Perm)
(assert ($Perm.isReadVar $k@59@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 6
(assert (not (or (= $k@59@04 $Perm.No) (< $Perm.No $k@59@04))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1334
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               141
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             692
;  :mk-clause               75
;  :num-allocs              4232718
;  :num-checks              179
;  :propagations            50
;  :quant-instantiations    29
;  :rlimit-count            165002)
(assert (<= $Perm.No $k@59@04))
(assert (<= $k@59@04 $Perm.Write))
(assert (implies (< $Perm.No $k@59@04) (not (= diz@35@04 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_dr != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1340
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      45
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               142
;  :datatype-accessor-ax    142
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             695
;  :mk-clause               75
;  :num-allocs              4232718
;  :num-checks              180
;  :propagations            50
;  :quant-instantiations    29
;  :rlimit-count            165475)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1346
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      45
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               143
;  :datatype-accessor-ax    143
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             698
;  :mk-clause               75
;  :num-allocs              4232718
;  :num-checks              181
;  :propagations            50
;  :quant-instantiations    30
;  :rlimit-count            166005)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1351
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      45
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               144
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             699
;  :mk-clause               75
;  :num-allocs              4232718
;  :num-checks              182
;  :propagations            50
;  :quant-instantiations    30
;  :rlimit-count            166412)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1356
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      45
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               145
;  :datatype-accessor-ax    145
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             700
;  :mk-clause               75
;  :num-allocs              4232718
;  :num-checks              183
;  :propagations            50
;  :quant-instantiations    30
;  :rlimit-count            166829)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1361
;  :arith-assert-diseq      26
;  :arith-assert-lower      76
;  :arith-assert-upper      45
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               146
;  :datatype-accessor-ax    146
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             701
;  :mk-clause               75
;  :num-allocs              4232718
;  :num-checks              184
;  :propagations            50
;  :quant-instantiations    30
;  :rlimit-count            167256)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))))))
(declare-const $k@60@04 $Perm)
(assert ($Perm.isReadVar $k@60@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 6
(assert (not (or (= $k@60@04 $Perm.No) (< $Perm.No $k@60@04))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1366
;  :arith-assert-diseq      27
;  :arith-assert-lower      78
;  :arith-assert-upper      46
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               147
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             706
;  :mk-clause               77
;  :num-allocs              4232718
;  :num-checks              185
;  :propagations            51
;  :quant-instantiations    30
;  :rlimit-count            167837)
(assert (<= $Perm.No $k@60@04))
(assert (<= $k@60@04 $Perm.Write))
(assert (implies (< $Perm.No $k@60@04) (not (= diz@35@04 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_mon != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@60@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1372
;  :arith-assert-diseq      27
;  :arith-assert-lower      78
;  :arith-assert-upper      47
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    148
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             709
;  :mk-clause               77
;  :num-allocs              4232718
;  :num-checks              186
;  :propagations            51
;  :quant-instantiations    30
;  :rlimit-count            168370)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1378
;  :arith-assert-diseq      27
;  :arith-assert-lower      78
;  :arith-assert-upper      47
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             712
;  :mk-clause               77
;  :num-allocs              4232718
;  :num-checks              187
;  :propagations            51
;  :quant-instantiations    31
;  :rlimit-count            168942)
(declare-const $k@61@04 $Perm)
(assert ($Perm.isReadVar $k@61@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 6
(assert (not (or (= $k@61@04 $Perm.No) (< $Perm.No $k@61@04))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1378
;  :arith-assert-diseq      28
;  :arith-assert-lower      80
;  :arith-assert-upper      48
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               150
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             716
;  :mk-clause               79
;  :num-allocs              4232718
;  :num-checks              188
;  :propagations            52
;  :quant-instantiations    31
;  :rlimit-count            169140)
(assert (<= $Perm.No $k@61@04))
(assert (<= $k@61@04 $Perm.Write))
(assert (implies
  (< $Perm.No $k@61@04)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_m == diz
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1379
;  :arith-assert-diseq      28
;  :arith-assert-lower      80
;  :arith-assert-upper      49
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               151
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             718
;  :mk-clause               79
;  :num-allocs              4232718
;  :num-checks              189
;  :propagations            52
;  :quant-instantiations    31
;  :rlimit-count            169606)
(push) ; 6
(assert (not (< $Perm.No $k@61@04)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1379
;  :arith-assert-diseq      28
;  :arith-assert-lower      80
;  :arith-assert-upper      49
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         6
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               152
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 285
;  :datatype-occurs-check   71
;  :datatype-splits         95
;  :decisions               274
;  :del-clause              61
;  :final-checks            38
;  :max-generation          1
;  :max-memory              4.26
;  :memory                  4.26
;  :mk-bool-var             718
;  :mk-clause               79
;  :num-allocs              4232718
;  :num-checks              190
;  :propagations            52
;  :quant-instantiations    31
;  :rlimit-count            169654)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))))))
  diz@35@04))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@56@04 diz@35@04 globals@36@04))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@62@04 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; Main_immediate_wakeup_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@63@04 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 17 | 0 <= i@63@04 | live]
; [else-branch: 17 | !(0 <= i@63@04) | live]
(push) ; 8
; [then-branch: 17 | 0 <= i@63@04]
(assert (<= 0 i@63@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 17 | !(0 <= i@63@04)]
(assert (not (<= 0 i@63@04)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 18 | i@63@04 < |First:(Second:(Second:(Second:($t@56@04))))| && 0 <= i@63@04 | live]
; [else-branch: 18 | !(i@63@04 < |First:(Second:(Second:(Second:($t@56@04))))| && 0 <= i@63@04) | live]
(push) ; 8
; [then-branch: 18 | i@63@04 < |First:(Second:(Second:(Second:($t@56@04))))| && 0 <= i@63@04]
(assert (and
  (<
    i@63@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
  (<= 0 i@63@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@63@04 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1741
;  :arith-assert-diseq      28
;  :arith-assert-lower      81
;  :arith-assert-upper      50
;  :arith-eq-adapter        34
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               153
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              69
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             803
;  :mk-clause               80
;  :num-allocs              4392386
;  :num-checks              193
;  :propagations            55
;  :quant-instantiations    32
;  :rlimit-count            172683)
; [eval] -1
(push) ; 9
; [then-branch: 19 | First:(Second:(Second:(Second:($t@56@04))))[i@63@04] == -1 | live]
; [else-branch: 19 | First:(Second:(Second:(Second:($t@56@04))))[i@63@04] != -1 | live]
(push) ; 10
; [then-branch: 19 | First:(Second:(Second:(Second:($t@56@04))))[i@63@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    i@63@04)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 19 | First:(Second:(Second:(Second:($t@56@04))))[i@63@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      i@63@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@63@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1743
;  :arith-assert-diseq      30
;  :arith-assert-lower      84
;  :arith-assert-upper      51
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     16
;  :conflicts               153
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              69
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             810
;  :mk-clause               90
;  :num-allocs              4392386
;  :num-checks              194
;  :propagations            60
;  :quant-instantiations    33
;  :rlimit-count            172914)
(push) ; 11
; [then-branch: 20 | 0 <= First:(Second:(Second:(Second:($t@56@04))))[i@63@04] | live]
; [else-branch: 20 | !(0 <= First:(Second:(Second:(Second:($t@56@04))))[i@63@04]) | live]
(push) ; 12
; [then-branch: 20 | 0 <= First:(Second:(Second:(Second:($t@56@04))))[i@63@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    i@63@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@63@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1745
;  :arith-assert-diseq      30
;  :arith-assert-lower      86
;  :arith-assert-upper      52
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         8
;  :arith-pivots            7
;  :binary-propagations     16
;  :conflicts               153
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              69
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             814
;  :mk-clause               90
;  :num-allocs              4392386
;  :num-checks              195
;  :propagations            60
;  :quant-instantiations    33
;  :rlimit-count            173055)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 20 | !(0 <= First:(Second:(Second:(Second:($t@56@04))))[i@63@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      i@63@04))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 18 | !(i@63@04 < |First:(Second:(Second:(Second:($t@56@04))))| && 0 <= i@63@04)]
(assert (not
  (and
    (<
      i@63@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
    (<= 0 i@63@04))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 6
(assert (not (forall ((i@63@04 Int)) (!
  (implies
    (and
      (<
        i@63@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
      (<= 0 i@63@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
          i@63@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
            i@63@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
            i@63@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    i@63@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1745
;  :arith-assert-diseq      32
;  :arith-assert-lower      87
;  :arith-assert-upper      53
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         9
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              93
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             822
;  :mk-clause               104
;  :num-allocs              4392386
;  :num-checks              196
;  :propagations            62
;  :quant-instantiations    34
;  :rlimit-count            173504)
(assert (forall ((i@63@04 Int)) (!
  (implies
    (and
      (<
        i@63@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
      (<= 0 i@63@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
          i@63@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
            i@63@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
            i@63@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    i@63@04))
  :qid |prog.l<no position>|)))
(declare-const $t@64@04 $Snap)
(assert (= $t@64@04 ($Snap.combine ($Snap.first $t@64@04) ($Snap.second $t@64@04))))
(assert (=
  ($Snap.second $t@64@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@64@04))
    ($Snap.second ($Snap.second $t@64@04)))))
(assert (=
  ($Snap.second ($Snap.second $t@64@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@64@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@64@04))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@64@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@65@04 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 21 | 0 <= i@65@04 | live]
; [else-branch: 21 | !(0 <= i@65@04) | live]
(push) ; 8
; [then-branch: 21 | 0 <= i@65@04]
(assert (<= 0 i@65@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 21 | !(0 <= i@65@04)]
(assert (not (<= 0 i@65@04)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 22 | i@65@04 < |First:(Second:($t@64@04))| && 0 <= i@65@04 | live]
; [else-branch: 22 | !(i@65@04 < |First:(Second:($t@64@04))| && 0 <= i@65@04) | live]
(push) ; 8
; [then-branch: 22 | i@65@04 < |First:(Second:($t@64@04))| && 0 <= i@65@04]
(assert (and
  (<
    i@65@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))
  (<= 0 i@65@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@65@04 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1783
;  :arith-assert-diseq      32
;  :arith-assert-lower      92
;  :arith-assert-upper      56
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         10
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    159
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              93
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             844
;  :mk-clause               104
;  :num-allocs              4392386
;  :num-checks              197
;  :propagations            62
;  :quant-instantiations    38
;  :rlimit-count            174937)
; [eval] -1
(push) ; 9
; [then-branch: 23 | First:(Second:($t@64@04))[i@65@04] == -1 | live]
; [else-branch: 23 | First:(Second:($t@64@04))[i@65@04] != -1 | live]
(push) ; 10
; [then-branch: 23 | First:(Second:($t@64@04))[i@65@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
    i@65@04)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 23 | First:(Second:($t@64@04))[i@65@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
      i@65@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@65@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1783
;  :arith-assert-diseq      32
;  :arith-assert-lower      92
;  :arith-assert-upper      56
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         10
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    159
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              93
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             845
;  :mk-clause               104
;  :num-allocs              4392386
;  :num-checks              198
;  :propagations            62
;  :quant-instantiations    38
;  :rlimit-count            175088)
(push) ; 11
; [then-branch: 24 | 0 <= First:(Second:($t@64@04))[i@65@04] | live]
; [else-branch: 24 | !(0 <= First:(Second:($t@64@04))[i@65@04]) | live]
(push) ; 12
; [then-branch: 24 | 0 <= First:(Second:($t@64@04))[i@65@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
    i@65@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@65@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1783
;  :arith-assert-diseq      33
;  :arith-assert-lower      95
;  :arith-assert-upper      56
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         10
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    159
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              93
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             848
;  :mk-clause               105
;  :num-allocs              4392386
;  :num-checks              199
;  :propagations            62
;  :quant-instantiations    38
;  :rlimit-count            175192)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 24 | !(0 <= First:(Second:($t@64@04))[i@65@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
      i@65@04))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 22 | !(i@65@04 < |First:(Second:($t@64@04))| && 0 <= i@65@04)]
(assert (not
  (and
    (<
      i@65@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))
    (<= 0 i@65@04))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@65@04 Int)) (!
  (implies
    (and
      (<
        i@65@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))
      (<= 0 i@65@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
          i@65@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
            i@65@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
            i@65@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
    i@65@04))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 ==> diz.Main_process_state[0] == -1
; [eval] 0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1801
;  :arith-assert-diseq      33
;  :arith-assert-lower      96
;  :arith-assert-upper      57
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              94
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             868
;  :mk-clause               115
;  :num-allocs              4392386
;  :num-checks              200
;  :propagations            66
;  :quant-instantiations    40
;  :rlimit-count            176265)
(push) ; 6
; [then-branch: 25 | 0 <= First:(Second:(Second:(Second:($t@56@04))))[0] | live]
; [else-branch: 25 | !(0 <= First:(Second:(Second:(Second:($t@56@04))))[0]) | live]
(push) ; 7
; [then-branch: 25 | 0 <= First:(Second:(Second:(Second:($t@56@04))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1801
;  :arith-assert-diseq      33
;  :arith-assert-lower      97
;  :arith-assert-upper      57
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              94
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             874
;  :mk-clause               122
;  :num-allocs              4392386
;  :num-checks              201
;  :propagations            66
;  :quant-instantiations    42
;  :rlimit-count            176442)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1801
;  :arith-assert-diseq      33
;  :arith-assert-lower      97
;  :arith-assert-upper      57
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              94
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             874
;  :mk-clause               122
;  :num-allocs              4392386
;  :num-checks              202
;  :propagations            66
;  :quant-instantiations    42
;  :rlimit-count            176451)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1802
;  :arith-assert-diseq      33
;  :arith-assert-lower      98
;  :arith-assert-upper      58
;  :arith-conflicts         1
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    161
;  :datatype-constructor-ax 406
;  :datatype-occurs-check   87
;  :datatype-splits         170
;  :decisions               391
;  :del-clause              94
;  :final-checks            44
;  :max-generation          1
;  :max-memory              4.36
;  :memory                  4.36
;  :mk-bool-var             874
;  :mk-clause               122
;  :num-allocs              4392386
;  :num-checks              203
;  :propagations            70
;  :quant-instantiations    42
;  :rlimit-count            176568)
(pop) ; 7
(push) ; 7
; [else-branch: 25 | !(0 <= First:(Second:(Second:(Second:($t@56@04))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      0))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1975
;  :arith-assert-diseq      36
;  :arith-assert-lower      109
;  :arith-assert-upper      63
;  :arith-conflicts         1
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         13
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 458
;  :datatype-occurs-check   98
;  :datatype-splits         199
;  :decisions               441
;  :del-clause              123
;  :final-checks            47
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             930
;  :mk-clause               144
;  :num-allocs              4555574
;  :num-checks              204
;  :propagations            81
;  :quant-instantiations    47
;  :rlimit-count            178190
;  :time                    0.00)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2140
;  :arith-assert-diseq      36
;  :arith-assert-lower      110
;  :arith-assert-upper      65
;  :arith-conflicts         1
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         13
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   109
;  :datatype-splits         228
;  :decisions               492
;  :del-clause              126
;  :final-checks            50
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             968
;  :mk-clause               147
;  :num-allocs              4555574
;  :num-checks              205
;  :propagations            84
;  :quant-instantiations    49
;  :rlimit-count            179629
;  :time                    0.00)
; [then-branch: 26 | First:(Second:(Second:(Second:(Second:(Second:($t@56@04))))))[First:(Second:(Second:(Second:($t@56@04))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@56@04))))[0] | live]
; [else-branch: 26 | !(First:(Second:(Second:(Second:(Second:(Second:($t@56@04))))))[First:(Second:(Second:(Second:($t@56@04))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@56@04))))[0]) | live]
(push) ; 7
; [then-branch: 26 | First:(Second:(Second:(Second:(Second:(Second:($t@56@04))))))[First:(Second:(Second:(Second:($t@56@04))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@56@04))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2141
;  :arith-assert-diseq      36
;  :arith-assert-lower      111
;  :arith-assert-upper      65
;  :arith-conflicts         1
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         13
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   109
;  :datatype-splits         228
;  :decisions               492
;  :del-clause              126
;  :final-checks            50
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             975
;  :mk-clause               154
;  :num-allocs              4555574
;  :num-checks              206
;  :propagations            84
;  :quant-instantiations    51
;  :rlimit-count            179845)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 26 | !(First:(Second:(Second:(Second:(Second:(Second:($t@56@04))))))[First:(Second:(Second:(Second:($t@56@04))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@56@04))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
        0)))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@64@04))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0) ==> diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] !(0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0)
; [eval] 0 <= old(diz.Main_process_state[0]) && old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2142
;  :arith-assert-diseq      36
;  :arith-assert-lower      111
;  :arith-assert-upper      65
;  :arith-conflicts         1
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         13
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   109
;  :datatype-splits         228
;  :decisions               492
;  :del-clause              133
;  :final-checks            50
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             979
;  :mk-clause               155
;  :num-allocs              4555574
;  :num-checks              207
;  :propagations            84
;  :quant-instantiations    51
;  :rlimit-count            180253)
(push) ; 6
; [then-branch: 27 | 0 <= First:(Second:(Second:(Second:($t@56@04))))[0] | live]
; [else-branch: 27 | !(0 <= First:(Second:(Second:(Second:($t@56@04))))[0]) | live]
(push) ; 7
; [then-branch: 27 | 0 <= First:(Second:(Second:(Second:($t@56@04))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2142
;  :arith-assert-diseq      36
;  :arith-assert-lower      112
;  :arith-assert-upper      65
;  :arith-conflicts         1
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         13
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   109
;  :datatype-splits         228
;  :decisions               492
;  :del-clause              133
;  :final-checks            50
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             984
;  :mk-clause               162
;  :num-allocs              4555574
;  :num-checks              208
;  :propagations            84
;  :quant-instantiations    53
;  :rlimit-count            180382)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2142
;  :arith-assert-diseq      36
;  :arith-assert-lower      112
;  :arith-assert-upper      65
;  :arith-conflicts         1
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         13
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   109
;  :datatype-splits         228
;  :decisions               492
;  :del-clause              133
;  :final-checks            50
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             984
;  :mk-clause               162
;  :num-allocs              4555574
;  :num-checks              209
;  :propagations            84
;  :quant-instantiations    53
;  :rlimit-count            180391)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2143
;  :arith-assert-diseq      36
;  :arith-assert-lower      113
;  :arith-assert-upper      66
;  :arith-conflicts         2
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         13
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               156
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 510
;  :datatype-occurs-check   109
;  :datatype-splits         228
;  :decisions               492
;  :del-clause              133
;  :final-checks            50
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             984
;  :mk-clause               162
;  :num-allocs              4555574
;  :num-checks              210
;  :propagations            88
;  :quant-instantiations    53
;  :rlimit-count            180508)
(pop) ; 7
(push) ; 7
; [else-branch: 27 | !(0 <= First:(Second:(Second:(Second:($t@56@04))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      0))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2307
;  :arith-assert-diseq      36
;  :arith-assert-lower      114
;  :arith-assert-upper      68
;  :arith-conflicts         2
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         13
;  :arith-pivots            12
;  :binary-propagations     16
;  :conflicts               156
;  :datatype-accessor-ax    167
;  :datatype-constructor-ax 561
;  :datatype-occurs-check   120
;  :datatype-splits         256
;  :decisions               542
;  :del-clause              143
;  :final-checks            53
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1019
;  :mk-clause               165
;  :num-allocs              4555574
;  :num-checks              211
;  :propagations            91
;  :quant-instantiations    55
;  :rlimit-count            181952
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2571
;  :arith-assert-diseq      38
;  :arith-assert-lower      121
;  :arith-assert-upper      71
;  :arith-conflicts         2
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         14
;  :arith-pivots            14
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 639
;  :datatype-occurs-check   134
;  :datatype-splits         288
;  :decisions               616
;  :del-clause              161
;  :final-checks            57
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1080
;  :mk-clause               183
;  :num-allocs              4555574
;  :num-checks              212
;  :propagations            100
;  :quant-instantiations    59
;  :rlimit-count            183843
;  :time                    0.00)
; [then-branch: 28 | !(First:(Second:(Second:(Second:(Second:(Second:($t@56@04))))))[First:(Second:(Second:(Second:($t@56@04))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@56@04))))[0]) | live]
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:(Second:($t@56@04))))))[First:(Second:(Second:(Second:($t@56@04))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@56@04))))[0] | live]
(push) ; 7
; [then-branch: 28 | !(First:(Second:(Second:(Second:(Second:(Second:($t@56@04))))))[First:(Second:(Second:(Second:($t@56@04))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@56@04))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2571
;  :arith-assert-diseq      38
;  :arith-assert-lower      121
;  :arith-assert-upper      71
;  :arith-conflicts         2
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         14
;  :arith-pivots            14
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 639
;  :datatype-occurs-check   134
;  :datatype-splits         288
;  :decisions               616
;  :del-clause              161
;  :final-checks            57
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1080
;  :mk-clause               184
;  :num-allocs              4555574
;  :num-checks              213
;  :propagations            100
;  :quant-instantiations    59
;  :rlimit-count            184042)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2571
;  :arith-assert-diseq      38
;  :arith-assert-lower      121
;  :arith-assert-upper      71
;  :arith-conflicts         2
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         14
;  :arith-pivots            14
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 639
;  :datatype-occurs-check   134
;  :datatype-splits         288
;  :decisions               616
;  :del-clause              161
;  :final-checks            57
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1080
;  :mk-clause               184
;  :num-allocs              4555574
;  :num-checks              214
;  :propagations            100
;  :quant-instantiations    59
;  :rlimit-count            184057)
(pop) ; 7
(push) ; 7
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:(Second:($t@56@04))))))[First:(Second:(Second:(Second:($t@56@04))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@56@04))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      0))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
            0))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))
      0))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Main_reset_events_no_delta_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@66@04 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 29 | 0 <= i@66@04 | live]
; [else-branch: 29 | !(0 <= i@66@04) | live]
(push) ; 8
; [then-branch: 29 | 0 <= i@66@04]
(assert (<= 0 i@66@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 29 | !(0 <= i@66@04)]
(assert (not (<= 0 i@66@04)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 30 | i@66@04 < |First:(Second:($t@64@04))| && 0 <= i@66@04 | live]
; [else-branch: 30 | !(i@66@04 < |First:(Second:($t@64@04))| && 0 <= i@66@04) | live]
(push) ; 8
; [then-branch: 30 | i@66@04 < |First:(Second:($t@64@04))| && 0 <= i@66@04]
(assert (and
  (<
    i@66@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))
  (<= 0 i@66@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@66@04 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2740
;  :arith-assert-diseq      38
;  :arith-assert-lower      124
;  :arith-assert-upper      75
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         16
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 690
;  :datatype-occurs-check   145
;  :datatype-splits         316
;  :decisions               666
;  :del-clause              180
;  :final-checks            60
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1129
;  :mk-clause               200
;  :num-allocs              4555574
;  :num-checks              216
;  :propagations            106
;  :quant-instantiations    62
;  :rlimit-count            185765)
; [eval] -1
(push) ; 9
; [then-branch: 31 | First:(Second:($t@64@04))[i@66@04] == -1 | live]
; [else-branch: 31 | First:(Second:($t@64@04))[i@66@04] != -1 | live]
(push) ; 10
; [then-branch: 31 | First:(Second:($t@64@04))[i@66@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
    i@66@04)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 31 | First:(Second:($t@64@04))[i@66@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
      i@66@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@66@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2742
;  :arith-assert-diseq      40
;  :arith-assert-lower      127
;  :arith-assert-upper      76
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         16
;  :arith-pivots            16
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 690
;  :datatype-occurs-check   145
;  :datatype-splits         316
;  :decisions               666
;  :del-clause              180
;  :final-checks            60
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1133
;  :mk-clause               208
;  :num-allocs              4555574
;  :num-checks              217
;  :propagations            110
;  :quant-instantiations    63
;  :rlimit-count            185933)
(push) ; 11
; [then-branch: 32 | 0 <= First:(Second:($t@64@04))[i@66@04] | live]
; [else-branch: 32 | !(0 <= First:(Second:($t@64@04))[i@66@04]) | live]
(push) ; 12
; [then-branch: 32 | 0 <= First:(Second:($t@64@04))[i@66@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
    i@66@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@66@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2744
;  :arith-assert-diseq      40
;  :arith-assert-lower      129
;  :arith-assert-upper      77
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         17
;  :arith-pivots            17
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 690
;  :datatype-occurs-check   145
;  :datatype-splits         316
;  :decisions               666
;  :del-clause              180
;  :final-checks            60
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1137
;  :mk-clause               208
;  :num-allocs              4555574
;  :num-checks              218
;  :propagations            110
;  :quant-instantiations    63
;  :rlimit-count            186048)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 32 | !(0 <= First:(Second:($t@64@04))[i@66@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
      i@66@04))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 30 | !(i@66@04 < |First:(Second:($t@64@04))| && 0 <= i@66@04)]
(assert (not
  (and
    (<
      i@66@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))
    (<= 0 i@66@04))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 6
(assert (not (forall ((i@66@04 Int)) (!
  (implies
    (and
      (<
        i@66@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))
      (<= 0 i@66@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
          i@66@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
            i@66@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
            i@66@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
    i@66@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2744
;  :arith-assert-diseq      41
;  :arith-assert-lower      130
;  :arith-assert-upper      78
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         18
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    173
;  :datatype-constructor-ax 690
;  :datatype-occurs-check   145
;  :datatype-splits         316
;  :decisions               666
;  :del-clause              200
;  :final-checks            60
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1145
;  :mk-clause               220
;  :num-allocs              4555574
;  :num-checks              219
;  :propagations            112
;  :quant-instantiations    64
;  :rlimit-count            186473)
(assert (forall ((i@66@04 Int)) (!
  (implies
    (and
      (<
        i@66@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))
      (<= 0 i@66@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
          i@66@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
            i@66@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
            i@66@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))
    i@66@04))
  :qid |prog.l<no position>|)))
(declare-const $t@67@04 $Snap)
(assert (= $t@67@04 ($Snap.combine ($Snap.first $t@67@04) ($Snap.second $t@67@04))))
(assert (=
  ($Snap.second $t@67@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@67@04))
    ($Snap.second ($Snap.second $t@67@04)))))
(assert (=
  ($Snap.second ($Snap.second $t@67@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@67@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@67@04))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@67@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@68@04 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 33 | 0 <= i@68@04 | live]
; [else-branch: 33 | !(0 <= i@68@04) | live]
(push) ; 8
; [then-branch: 33 | 0 <= i@68@04]
(assert (<= 0 i@68@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 33 | !(0 <= i@68@04)]
(assert (not (<= 0 i@68@04)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 34 | i@68@04 < |First:(Second:($t@67@04))| && 0 <= i@68@04 | live]
; [else-branch: 34 | !(i@68@04 < |First:(Second:($t@67@04))| && 0 <= i@68@04) | live]
(push) ; 8
; [then-branch: 34 | i@68@04 < |First:(Second:($t@67@04))| && 0 <= i@68@04]
(assert (and
  (<
    i@68@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
  (<= 0 i@68@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@68@04 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2782
;  :arith-assert-diseq      41
;  :arith-assert-lower      135
;  :arith-assert-upper      81
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    179
;  :datatype-constructor-ax 690
;  :datatype-occurs-check   145
;  :datatype-splits         316
;  :decisions               666
;  :del-clause              200
;  :final-checks            60
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1167
;  :mk-clause               220
;  :num-allocs              4555574
;  :num-checks              220
;  :propagations            112
;  :quant-instantiations    68
;  :rlimit-count            187864)
; [eval] -1
(push) ; 9
; [then-branch: 35 | First:(Second:($t@67@04))[i@68@04] == -1 | live]
; [else-branch: 35 | First:(Second:($t@67@04))[i@68@04] != -1 | live]
(push) ; 10
; [then-branch: 35 | First:(Second:($t@67@04))[i@68@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@68@04)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 35 | First:(Second:($t@67@04))[i@68@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      i@68@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@68@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2782
;  :arith-assert-diseq      41
;  :arith-assert-lower      135
;  :arith-assert-upper      81
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    179
;  :datatype-constructor-ax 690
;  :datatype-occurs-check   145
;  :datatype-splits         316
;  :decisions               666
;  :del-clause              200
;  :final-checks            60
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1168
;  :mk-clause               220
;  :num-allocs              4555574
;  :num-checks              221
;  :propagations            112
;  :quant-instantiations    68
;  :rlimit-count            188015)
(push) ; 11
; [then-branch: 36 | 0 <= First:(Second:($t@67@04))[i@68@04] | live]
; [else-branch: 36 | !(0 <= First:(Second:($t@67@04))[i@68@04]) | live]
(push) ; 12
; [then-branch: 36 | 0 <= First:(Second:($t@67@04))[i@68@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@68@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@68@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2782
;  :arith-assert-diseq      42
;  :arith-assert-lower      138
;  :arith-assert-upper      81
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         19
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    179
;  :datatype-constructor-ax 690
;  :datatype-occurs-check   145
;  :datatype-splits         316
;  :decisions               666
;  :del-clause              200
;  :final-checks            60
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1171
;  :mk-clause               221
;  :num-allocs              4555574
;  :num-checks              222
;  :propagations            112
;  :quant-instantiations    68
;  :rlimit-count            188119)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 36 | !(0 <= First:(Second:($t@67@04))[i@68@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      i@68@04))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
(push) ; 8
; [else-branch: 34 | !(i@68@04 < |First:(Second:($t@67@04))| && 0 <= i@68@04)]
(assert (not
  (and
    (<
      i@68@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
    (<= 0 i@68@04))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@68@04 Int)) (!
  (implies
    (and
      (<
        i@68@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
      (<= 0 i@68@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          i@68@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@68@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@68@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@68@04))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@64@04)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2799
;  :arith-assert-diseq      42
;  :arith-assert-lower      139
;  :arith-assert-upper      82
;  :arith-bound-prop        2
;  :arith-conflicts         2
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         20
;  :arith-pivots            18
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 690
;  :datatype-occurs-check   145
;  :datatype-splits         316
;  :decisions               666
;  :del-clause              201
;  :final-checks            60
;  :max-generation          1
;  :max-memory              4.46
;  :memory                  4.46
;  :mk-bool-var             1190
;  :mk-clause               231
;  :num-allocs              4555574
;  :num-checks              223
;  :propagations            116
;  :quant-instantiations    70
;  :rlimit-count            189132)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3149
;  :arith-add-rows          3
;  :arith-assert-diseq      42
;  :arith-assert-lower      146
;  :arith-assert-upper      91
;  :arith-bound-prop        4
;  :arith-conflicts         2
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         24
;  :arith-pivots            23
;  :binary-propagations     16
;  :conflicts               160
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 793
;  :datatype-occurs-check   163
;  :datatype-splits         377
;  :decisions               767
;  :del-clause              239
;  :final-checks            64
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1291
;  :mk-clause               269
;  :num-allocs              4727106
;  :num-checks              224
;  :propagations            141
;  :quant-instantiations    80
;  :rlimit-count            191487
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3498
;  :arith-add-rows          6
;  :arith-assert-diseq      42
;  :arith-assert-lower      153
;  :arith-assert-upper      100
;  :arith-bound-prop        6
;  :arith-conflicts         2
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         28
;  :arith-pivots            27
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   181
;  :datatype-splits         438
;  :decisions               868
;  :del-clause              277
;  :final-checks            68
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1392
;  :mk-clause               307
;  :num-allocs              4727106
;  :num-checks              225
;  :propagations            166
;  :quant-instantiations    90
;  :rlimit-count            193817
;  :time                    0.00)
; [then-branch: 37 | First:(Second:(Second:(Second:($t@64@04))))[0] == 0 | live]
; [else-branch: 37 | First:(Second:(Second:(Second:($t@64@04))))[0] != 0 | live]
(push) ; 7
; [then-branch: 37 | First:(Second:(Second:(Second:($t@64@04))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
    0)
  0))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3499
;  :arith-add-rows          6
;  :arith-assert-diseq      42
;  :arith-assert-lower      153
;  :arith-assert-upper      100
;  :arith-bound-prop        6
;  :arith-conflicts         2
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         28
;  :arith-pivots            27
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   181
;  :datatype-splits         438
;  :decisions               868
;  :del-clause              277
;  :final-checks            68
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1393
;  :mk-clause               307
;  :num-allocs              4727106
;  :num-checks              226
;  :propagations            166
;  :quant-instantiations    90
;  :rlimit-count            193945)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 37 | First:(Second:(Second:(Second:($t@64@04))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      0)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3505
;  :arith-add-rows          6
;  :arith-assert-diseq      42
;  :arith-assert-lower      153
;  :arith-assert-upper      100
;  :arith-bound-prop        6
;  :arith-conflicts         2
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         28
;  :arith-pivots            27
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    190
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   181
;  :datatype-splits         438
;  :decisions               868
;  :del-clause              277
;  :final-checks            68
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1397
;  :mk-clause               308
;  :num-allocs              4727106
;  :num-checks              227
;  :propagations            166
;  :quant-instantiations    90
;  :rlimit-count            194380)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3853
;  :arith-add-rows          9
;  :arith-assert-diseq      42
;  :arith-assert-lower      160
;  :arith-assert-upper      109
;  :arith-bound-prop        8
;  :arith-conflicts         2
;  :arith-eq-adapter        84
;  :arith-fixed-eqs         32
;  :arith-pivots            31
;  :binary-propagations     16
;  :conflicts               162
;  :datatype-accessor-ax    194
;  :datatype-constructor-ax 999
;  :datatype-occurs-check   200
;  :datatype-splits         499
;  :decisions               971
;  :del-clause              315
;  :final-checks            72
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1498
;  :mk-clause               346
;  :num-allocs              4727106
;  :num-checks              228
;  :propagations            191
;  :quant-instantiations    100
;  :rlimit-count            196736
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4200
;  :arith-add-rows          12
;  :arith-assert-diseq      42
;  :arith-assert-lower      167
;  :arith-assert-upper      118
;  :arith-bound-prop        10
;  :arith-conflicts         2
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         36
;  :arith-pivots            35
;  :binary-propagations     16
;  :conflicts               163
;  :datatype-accessor-ax    198
;  :datatype-constructor-ax 1102
;  :datatype-occurs-check   219
;  :datatype-splits         560
;  :decisions               1074
;  :del-clause              353
;  :final-checks            76
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1599
;  :mk-clause               384
;  :num-allocs              4727106
;  :num-checks              229
;  :propagations            216
;  :quant-instantiations    110
;  :rlimit-count            199101
;  :time                    0.00)
; [then-branch: 38 | First:(Second:(Second:(Second:($t@64@04))))[1] == 0 | live]
; [else-branch: 38 | First:(Second:(Second:(Second:($t@64@04))))[1] != 0 | live]
(push) ; 7
; [then-branch: 38 | First:(Second:(Second:(Second:($t@64@04))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
    1)
  0))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4201
;  :arith-add-rows          12
;  :arith-assert-diseq      42
;  :arith-assert-lower      167
;  :arith-assert-upper      118
;  :arith-bound-prop        10
;  :arith-conflicts         2
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         36
;  :arith-pivots            35
;  :binary-propagations     16
;  :conflicts               163
;  :datatype-accessor-ax    198
;  :datatype-constructor-ax 1102
;  :datatype-occurs-check   219
;  :datatype-splits         560
;  :decisions               1074
;  :del-clause              353
;  :final-checks            76
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1600
;  :mk-clause               384
;  :num-allocs              4727106
;  :num-checks              230
;  :propagations            216
;  :quant-instantiations    110
;  :rlimit-count            199229)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 38 | First:(Second:(Second:(Second:($t@64@04))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      1)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0)
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4207
;  :arith-add-rows          12
;  :arith-assert-diseq      42
;  :arith-assert-lower      167
;  :arith-assert-upper      118
;  :arith-bound-prop        10
;  :arith-conflicts         2
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         36
;  :arith-pivots            35
;  :binary-propagations     16
;  :conflicts               163
;  :datatype-accessor-ax    199
;  :datatype-constructor-ax 1102
;  :datatype-occurs-check   219
;  :datatype-splits         560
;  :decisions               1074
;  :del-clause              353
;  :final-checks            76
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1604
;  :mk-clause               385
;  :num-allocs              4727106
;  :num-checks              231
;  :propagations            216
;  :quant-instantiations    110
;  :rlimit-count            199670)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4556
;  :arith-add-rows          15
;  :arith-assert-diseq      42
;  :arith-assert-lower      174
;  :arith-assert-upper      127
;  :arith-bound-prop        12
;  :arith-conflicts         2
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         40
;  :arith-pivots            39
;  :binary-propagations     16
;  :conflicts               164
;  :datatype-accessor-ax    203
;  :datatype-constructor-ax 1205
;  :datatype-occurs-check   238
;  :datatype-splits         621
;  :decisions               1177
;  :del-clause              391
;  :final-checks            80
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1704
;  :mk-clause               423
;  :num-allocs              4727106
;  :num-checks              232
;  :propagations            241
;  :quant-instantiations    120
;  :rlimit-count            202033
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4912
;  :arith-add-rows          18
;  :arith-assert-diseq      42
;  :arith-assert-lower      181
;  :arith-assert-upper      136
;  :arith-bound-prop        14
;  :arith-conflicts         2
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         44
;  :arith-pivots            43
;  :binary-propagations     16
;  :conflicts               166
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 1311
;  :datatype-occurs-check   263
;  :datatype-splits         684
;  :decisions               1282
;  :del-clause              430
;  :final-checks            85
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1816
;  :mk-clause               462
;  :num-allocs              4727106
;  :num-checks              233
;  :propagations            267
;  :quant-instantiations    130
;  :rlimit-count            204436
;  :time                    0.00)
; [then-branch: 39 | First:(Second:(Second:(Second:($t@64@04))))[0] != 0 | live]
; [else-branch: 39 | First:(Second:(Second:(Second:($t@64@04))))[0] == 0 | live]
(push) ; 7
; [then-branch: 39 | First:(Second:(Second:(Second:($t@64@04))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      0)
    0)))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4912
;  :arith-add-rows          18
;  :arith-assert-diseq      42
;  :arith-assert-lower      181
;  :arith-assert-upper      136
;  :arith-bound-prop        14
;  :arith-conflicts         2
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         44
;  :arith-pivots            43
;  :binary-propagations     16
;  :conflicts               166
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 1311
;  :datatype-occurs-check   263
;  :datatype-splits         684
;  :decisions               1282
;  :del-clause              430
;  :final-checks            85
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1816
;  :mk-clause               462
;  :num-allocs              4727106
;  :num-checks              234
;  :propagations            267
;  :quant-instantiations    130
;  :rlimit-count            204566)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4912
;  :arith-add-rows          18
;  :arith-assert-diseq      42
;  :arith-assert-lower      181
;  :arith-assert-upper      136
;  :arith-bound-prop        14
;  :arith-conflicts         2
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         44
;  :arith-pivots            43
;  :binary-propagations     16
;  :conflicts               166
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 1311
;  :datatype-occurs-check   263
;  :datatype-splits         684
;  :decisions               1282
;  :del-clause              430
;  :final-checks            85
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1816
;  :mk-clause               462
;  :num-allocs              4727106
;  :num-checks              235
;  :propagations            267
;  :quant-instantiations    130
;  :rlimit-count            204581)
(pop) ; 7
(push) ; 7
; [else-branch: 39 | First:(Second:(Second:(Second:($t@64@04))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
    0)
  0))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
        0)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0)
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4917
;  :arith-add-rows          18
;  :arith-assert-diseq      42
;  :arith-assert-lower      181
;  :arith-assert-upper      136
;  :arith-bound-prop        14
;  :arith-conflicts         2
;  :arith-eq-adapter        105
;  :arith-fixed-eqs         44
;  :arith-pivots            43
;  :binary-propagations     16
;  :conflicts               166
;  :datatype-accessor-ax    208
;  :datatype-constructor-ax 1311
;  :datatype-occurs-check   263
;  :datatype-splits         684
;  :decisions               1282
;  :del-clause              430
;  :final-checks            85
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1818
;  :mk-clause               463
;  :num-allocs              4727106
;  :num-checks              236
;  :propagations            267
;  :quant-instantiations    130
;  :rlimit-count            204901)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5265
;  :arith-add-rows          21
;  :arith-assert-diseq      42
;  :arith-assert-lower      188
;  :arith-assert-upper      145
;  :arith-bound-prop        16
;  :arith-conflicts         2
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         48
;  :arith-pivots            47
;  :binary-propagations     16
;  :conflicts               167
;  :datatype-accessor-ax    212
;  :datatype-constructor-ax 1413
;  :datatype-occurs-check   282
;  :datatype-splits         743
;  :decisions               1384
;  :del-clause              468
;  :final-checks            89
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             1916
;  :mk-clause               501
;  :num-allocs              4727106
;  :num-checks              237
;  :propagations            294
;  :quant-instantiations    140
;  :rlimit-count            207267
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5621
;  :arith-add-rows          24
;  :arith-assert-diseq      42
;  :arith-assert-lower      195
;  :arith-assert-upper      154
;  :arith-bound-prop        18
;  :arith-conflicts         2
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         52
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               169
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 1518
;  :datatype-occurs-check   307
;  :datatype-splits         804
;  :decisions               1488
;  :del-clause              507
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             2026
;  :mk-clause               540
;  :num-allocs              4727106
;  :num-checks              238
;  :propagations            322
;  :quant-instantiations    150
;  :rlimit-count            209668
;  :time                    0.00)
; [then-branch: 40 | First:(Second:(Second:(Second:($t@64@04))))[1] != 0 | live]
; [else-branch: 40 | First:(Second:(Second:(Second:($t@64@04))))[1] == 0 | live]
(push) ; 7
; [then-branch: 40 | First:(Second:(Second:(Second:($t@64@04))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      1)
    0)))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5621
;  :arith-add-rows          24
;  :arith-assert-diseq      42
;  :arith-assert-lower      195
;  :arith-assert-upper      154
;  :arith-bound-prop        18
;  :arith-conflicts         2
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         52
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               169
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 1518
;  :datatype-occurs-check   307
;  :datatype-splits         804
;  :decisions               1488
;  :del-clause              507
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             2026
;  :mk-clause               540
;  :num-allocs              4727106
;  :num-checks              239
;  :propagations            322
;  :quant-instantiations    150
;  :rlimit-count            209798)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5621
;  :arith-add-rows          24
;  :arith-assert-diseq      42
;  :arith-assert-lower      195
;  :arith-assert-upper      154
;  :arith-bound-prop        18
;  :arith-conflicts         2
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         52
;  :arith-pivots            51
;  :binary-propagations     16
;  :conflicts               169
;  :datatype-accessor-ax    217
;  :datatype-constructor-ax 1518
;  :datatype-occurs-check   307
;  :datatype-splits         804
;  :decisions               1488
;  :del-clause              507
;  :final-checks            94
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             2026
;  :mk-clause               540
;  :num-allocs              4727106
;  :num-checks              240
;  :propagations            322
;  :quant-instantiations    150
;  :rlimit-count            209813)
(pop) ; 7
(push) ; 7
; [else-branch: 40 | First:(Second:(Second:(Second:($t@64@04))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
    1)
  0))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
        1)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@64@04)))))
      1))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] diz.Main_process_state[0] != -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5971
;  :arith-add-rows          27
;  :arith-assert-diseq      42
;  :arith-assert-lower      202
;  :arith-assert-upper      163
;  :arith-bound-prop        20
;  :arith-conflicts         2
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         56
;  :arith-pivots            55
;  :binary-propagations     16
;  :conflicts               170
;  :datatype-accessor-ax    221
;  :datatype-constructor-ax 1620
;  :datatype-occurs-check   326
;  :datatype-splits         863
;  :decisions               1592
;  :del-clause              552
;  :final-checks            98
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             2127
;  :mk-clause               580
;  :num-allocs              4727106
;  :num-checks              242
;  :propagations            351
;  :quant-instantiations    160
;  :rlimit-count            212320)
; [eval] -1
(set-option :timeout 10)
(push) ; 6
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6165
;  :arith-add-rows          31
;  :arith-assert-diseq      46
;  :arith-assert-lower      217
;  :arith-assert-upper      171
;  :arith-bound-prop        20
;  :arith-conflicts         2
;  :arith-eq-adapter        135
;  :arith-fixed-eqs         59
;  :arith-pivots            60
;  :binary-propagations     16
;  :conflicts               171
;  :datatype-accessor-ax    224
;  :datatype-constructor-ax 1675
;  :datatype-occurs-check   340
;  :datatype-splits         895
;  :decisions               1648
;  :del-clause              584
;  :final-checks            102
;  :interface-eqs           1
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :mk-bool-var             2187
;  :mk-clause               612
;  :num-allocs              4727106
;  :num-checks              243
;  :propagations            376
;  :quant-instantiations    167
;  :rlimit-count            214109
;  :time                    0.00)
(push) ; 6
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6485
;  :arith-add-rows          32
;  :arith-assert-diseq      51
;  :arith-assert-lower      229
;  :arith-assert-upper      179
;  :arith-bound-prop        24
;  :arith-conflicts         2
;  :arith-eq-adapter        143
;  :arith-fixed-eqs         64
;  :arith-pivots            63
;  :binary-propagations     16
;  :conflicts               177
;  :datatype-accessor-ax    231
;  :datatype-constructor-ax 1764
;  :datatype-occurs-check   365
;  :datatype-splits         935
;  :decisions               1734
;  :del-clause              622
;  :final-checks            108
;  :interface-eqs           2
;  :max-generation          1
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2281
;  :mk-clause               650
;  :num-allocs              4727106
;  :num-checks              244
;  :propagations            397
;  :quant-instantiations    171
;  :rlimit-count            216272
;  :time                    0.00)
; [then-branch: 41 | First:(Second:($t@67@04))[0] != -1 | live]
; [else-branch: 41 | First:(Second:($t@67@04))[0] == -1 | live]
(push) ; 6
; [then-branch: 41 | First:(Second:($t@67@04))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0)
    (- 0 1))))
; [exec]
; min_advance__91 := Main_find_minimum_advance_Sequence$Integer$(diz, diz.Main_event_state)
; [eval] Main_find_minimum_advance_Sequence$Integer$(diz, diz.Main_event_state)
(push) ; 7
; [eval] diz != null
; [eval] |vals| == 2
; [eval] |vals|
(pop) ; 7
; Joined path conditions
(declare-const min_advance__91@69@04 Int)
(assert (=
  min_advance__91@69@04
  (Main_find_minimum_advance_Sequence$Integer$ ($Snap.combine
    $Snap.unit
    $Snap.unit) diz@35@04 ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04))))))))
; [eval] min_advance__91 == -1
; [eval] -1
(push) ; 7
(assert (not (not (= min_advance__91@69@04 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6697
;  :arith-add-rows          35
;  :arith-assert-diseq      63
;  :arith-assert-lower      247
;  :arith-assert-upper      196
;  :arith-bound-prop        27
;  :arith-conflicts         2
;  :arith-eq-adapter        156
;  :arith-fixed-eqs         68
;  :arith-pivots            67
;  :binary-propagations     16
;  :conflicts               179
;  :datatype-accessor-ax    235
;  :datatype-constructor-ax 1819
;  :datatype-occurs-check   379
;  :datatype-splits         967
;  :decisions               1792
;  :del-clause              657
;  :final-checks            112
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2377
;  :mk-clause               727
;  :num-allocs              4727106
;  :num-checks              245
;  :propagations            439
;  :quant-instantiations    181
;  :rlimit-count            218536
;  :time                    0.00)
(push) ; 7
(assert (not (= min_advance__91@69@04 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6898
;  :arith-add-rows          35
;  :arith-assert-diseq      78
;  :arith-assert-lower      259
;  :arith-assert-upper      212
;  :arith-bound-prop        31
;  :arith-conflicts         2
;  :arith-eq-adapter        168
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        2
;  :arith-pivots            69
;  :binary-propagations     16
;  :conflicts               180
;  :datatype-accessor-ax    238
;  :datatype-constructor-ax 1874
;  :datatype-occurs-check   393
;  :datatype-splits         999
;  :decisions               1850
;  :del-clause              710
;  :final-checks            116
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2454
;  :mk-clause               780
;  :num-allocs              4727106
;  :num-checks              246
;  :propagations            470
;  :quant-instantiations    185
;  :rlimit-count            220232
;  :time                    0.00)
; [then-branch: 42 | min_advance__91@69@04 == -1 | live]
; [else-branch: 42 | min_advance__91@69@04 != -1 | live]
(push) ; 7
; [then-branch: 42 | min_advance__91@69@04 == -1]
(assert (= min_advance__91@69@04 (- 0 1)))
; [exec]
; min_advance__91 := 0
; [exec]
; __flatten_75__90 := Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__91), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__91))
; [eval] Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__91), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__91))
; [eval] (diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__91)
; [eval] diz.Main_event_state[0] < -1
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6900
;  :arith-add-rows          35
;  :arith-assert-diseq      78
;  :arith-assert-lower      260
;  :arith-assert-upper      213
;  :arith-bound-prop        31
;  :arith-conflicts         2
;  :arith-eq-adapter        169
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        2
;  :arith-pivots            69
;  :binary-propagations     16
;  :conflicts               180
;  :datatype-accessor-ax    238
;  :datatype-constructor-ax 1874
;  :datatype-occurs-check   393
;  :datatype-splits         999
;  :decisions               1850
;  :del-clause              710
;  :final-checks            116
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2458
;  :mk-clause               780
;  :num-allocs              4727106
;  :num-checks              247
;  :propagations            470
;  :quant-instantiations    185
;  :rlimit-count            220307)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7099
;  :arith-add-rows          35
;  :arith-assert-diseq      88
;  :arith-assert-lower      270
;  :arith-assert-upper      226
;  :arith-bound-prop        34
;  :arith-conflicts         2
;  :arith-eq-adapter        179
;  :arith-fixed-eqs         72
;  :arith-offset-eqs        3
;  :arith-pivots            71
;  :binary-propagations     16
;  :conflicts               182
;  :datatype-accessor-ax    241
;  :datatype-constructor-ax 1929
;  :datatype-occurs-check   407
;  :datatype-splits         1031
;  :decisions               1907
;  :del-clause              738
;  :final-checks            120
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2525
;  :mk-clause               808
;  :num-allocs              4727106
;  :num-checks              248
;  :propagations            500
;  :quant-instantiations    189
;  :rlimit-count            222037
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7296
;  :arith-add-rows          35
;  :arith-assert-diseq      98
;  :arith-assert-lower      281
;  :arith-assert-upper      239
;  :arith-bound-prop        37
;  :arith-conflicts         2
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         75
;  :arith-offset-eqs        3
;  :arith-pivots            73
;  :binary-propagations     16
;  :conflicts               183
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 1984
;  :datatype-occurs-check   421
;  :datatype-splits         1063
;  :decisions               1964
;  :del-clause              770
;  :final-checks            124
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2593
;  :mk-clause               840
;  :num-allocs              4727106
;  :num-checks              249
;  :propagations            526
;  :quant-instantiations    193
;  :rlimit-count            223742
;  :time                    0.00)
; [then-branch: 43 | First:(Second:(Second:(Second:($t@67@04))))[0] < -1 | live]
; [else-branch: 43 | !(First:(Second:(Second:(Second:($t@67@04))))[0] < -1) | live]
(push) ; 9
; [then-branch: 43 | First:(Second:(Second:(Second:($t@67@04))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 43 | !(First:(Second:(Second:(Second:($t@67@04))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__91
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7296
;  :arith-add-rows          35
;  :arith-assert-diseq      98
;  :arith-assert-lower      283
;  :arith-assert-upper      239
;  :arith-bound-prop        37
;  :arith-conflicts         2
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         75
;  :arith-offset-eqs        3
;  :arith-pivots            73
;  :binary-propagations     16
;  :conflicts               183
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 1984
;  :datatype-occurs-check   421
;  :datatype-splits         1063
;  :decisions               1964
;  :del-clause              770
;  :final-checks            124
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2593
;  :mk-clause               840
;  :num-allocs              4727106
;  :num-checks              250
;  :propagations            528
;  :quant-instantiations    193
;  :rlimit-count            223905)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__91)
; [eval] diz.Main_event_state[1] < -1
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7296
;  :arith-add-rows          35
;  :arith-assert-diseq      98
;  :arith-assert-lower      283
;  :arith-assert-upper      239
;  :arith-bound-prop        37
;  :arith-conflicts         2
;  :arith-eq-adapter        189
;  :arith-fixed-eqs         75
;  :arith-offset-eqs        3
;  :arith-pivots            73
;  :binary-propagations     16
;  :conflicts               183
;  :datatype-accessor-ax    244
;  :datatype-constructor-ax 1984
;  :datatype-occurs-check   421
;  :datatype-splits         1063
;  :decisions               1964
;  :del-clause              770
;  :final-checks            124
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2593
;  :mk-clause               840
;  :num-allocs              4727106
;  :num-checks              251
;  :propagations            528
;  :quant-instantiations    193
;  :rlimit-count            223920)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7495
;  :arith-add-rows          35
;  :arith-assert-diseq      108
;  :arith-assert-lower      293
;  :arith-assert-upper      252
;  :arith-bound-prop        40
;  :arith-conflicts         2
;  :arith-eq-adapter        199
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        4
;  :arith-pivots            75
;  :binary-propagations     16
;  :conflicts               185
;  :datatype-accessor-ax    247
;  :datatype-constructor-ax 2039
;  :datatype-occurs-check   435
;  :datatype-splits         1095
;  :decisions               2021
;  :del-clause              798
;  :final-checks            128
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2660
;  :mk-clause               868
;  :num-allocs              4727106
;  :num-checks              252
;  :propagations            558
;  :quant-instantiations    197
;  :rlimit-count            225650
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7693
;  :arith-add-rows          35
;  :arith-assert-diseq      118
;  :arith-assert-lower      303
;  :arith-assert-upper      265
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         79
;  :arith-offset-eqs        5
;  :arith-pivots            77
;  :binary-propagations     16
;  :conflicts               186
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              830
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2727
;  :mk-clause               900
;  :num-allocs              4727106
;  :num-checks              253
;  :propagations            584
;  :quant-instantiations    201
;  :rlimit-count            227353
;  :time                    0.00)
; [then-branch: 44 | First:(Second:(Second:(Second:($t@67@04))))[1] < -1 | live]
; [else-branch: 44 | !(First:(Second:(Second:(Second:($t@67@04))))[1] < -1) | live]
(push) ; 9
; [then-branch: 44 | First:(Second:(Second:(Second:($t@67@04))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 44 | !(First:(Second:(Second:(Second:($t@67@04))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__91
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7693
;  :arith-add-rows          35
;  :arith-assert-diseq      118
;  :arith-assert-lower      305
;  :arith-assert-upper      265
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        209
;  :arith-fixed-eqs         79
;  :arith-offset-eqs        5
;  :arith-pivots            77
;  :binary-propagations     16
;  :conflicts               186
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              830
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2727
;  :mk-clause               900
;  :num-allocs              4727106
;  :num-checks              254
;  :propagations            586
;  :quant-instantiations    201
;  :rlimit-count            227516)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (=
  (Seq_length
    (Seq_append
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
            0)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
          0)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
            1)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
          1)))))
  2))
(declare-const __flatten_75__90@70@04 Seq<Int>)
(assert (Seq_equal
  __flatten_75__90@70@04
  (Seq_append
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
          0)
        (- 0 1))
      (- 0 3)
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
        0)))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
          1)
        (- 0 1))
      (- 0 3)
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
        1))))))
; [exec]
; __flatten_74__89 := __flatten_75__90
; [exec]
; diz.Main_event_state := __flatten_74__89
; [exec]
; Main_wakeup_after_wait_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(push) ; 8
(assert (not (= (Seq_length __flatten_75__90@70@04) 2)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7700
;  :arith-add-rows          36
;  :arith-assert-diseq      118
;  :arith-assert-lower      308
;  :arith-assert-upper      267
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        213
;  :arith-fixed-eqs         80
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               187
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              830
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2758
;  :mk-clause               921
;  :num-allocs              4727106
;  :num-checks              255
;  :propagations            591
;  :quant-instantiations    205
;  :rlimit-count            228191)
(assert (= (Seq_length __flatten_75__90@70@04) 2))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@71@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 45 | 0 <= i@71@04 | live]
; [else-branch: 45 | !(0 <= i@71@04) | live]
(push) ; 10
; [then-branch: 45 | 0 <= i@71@04]
(assert (<= 0 i@71@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 45 | !(0 <= i@71@04)]
(assert (not (<= 0 i@71@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 46 | i@71@04 < |First:(Second:($t@67@04))| && 0 <= i@71@04 | live]
; [else-branch: 46 | !(i@71@04 < |First:(Second:($t@67@04))| && 0 <= i@71@04) | live]
(push) ; 10
; [then-branch: 46 | i@71@04 < |First:(Second:($t@67@04))| && 0 <= i@71@04]
(assert (and
  (<
    i@71@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
  (<= 0 i@71@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@71@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7702
;  :arith-add-rows          36
;  :arith-assert-diseq      118
;  :arith-assert-lower      310
;  :arith-assert-upper      269
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         81
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               187
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              830
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2763
;  :mk-clause               921
;  :num-allocs              4727106
;  :num-checks              256
;  :propagations            591
;  :quant-instantiations    205
;  :rlimit-count            228382)
; [eval] -1
(push) ; 11
; [then-branch: 47 | First:(Second:($t@67@04))[i@71@04] == -1 | live]
; [else-branch: 47 | First:(Second:($t@67@04))[i@71@04] != -1 | live]
(push) ; 12
; [then-branch: 47 | First:(Second:($t@67@04))[i@71@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@71@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 47 | First:(Second:($t@67@04))[i@71@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      i@71@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@71@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7704
;  :arith-add-rows          36
;  :arith-assert-diseq      119
;  :arith-assert-lower      310
;  :arith-assert-upper      269
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        214
;  :arith-fixed-eqs         81
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               187
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              830
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2764
;  :mk-clause               921
;  :num-allocs              4727106
;  :num-checks              257
;  :propagations            591
;  :quant-instantiations    205
;  :rlimit-count            228530)
(push) ; 13
; [then-branch: 48 | 0 <= First:(Second:($t@67@04))[i@71@04] | live]
; [else-branch: 48 | !(0 <= First:(Second:($t@67@04))[i@71@04]) | live]
(push) ; 14
; [then-branch: 48 | 0 <= First:(Second:($t@67@04))[i@71@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@71@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@71@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7706
;  :arith-add-rows          37
;  :arith-assert-diseq      119
;  :arith-assert-lower      312
;  :arith-assert-upper      270
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        215
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               187
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              830
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2768
;  :mk-clause               921
;  :num-allocs              4727106
;  :num-checks              258
;  :propagations            591
;  :quant-instantiations    205
;  :rlimit-count            228642)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 48 | !(0 <= First:(Second:($t@67@04))[i@71@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      i@71@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 46 | !(i@71@04 < |First:(Second:($t@67@04))| && 0 <= i@71@04)]
(assert (not
  (and
    (<
      i@71@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
    (<= 0 i@71@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@71@04 Int)) (!
  (implies
    (and
      (<
        i@71@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
      (<= 0 i@71@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          i@71@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@71@04)
          (Seq_length __flatten_75__90@70@04))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@71@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@71@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.19s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7706
;  :arith-add-rows          37
;  :arith-assert-diseq      121
;  :arith-assert-lower      313
;  :arith-assert-upper      271
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        216
;  :arith-fixed-eqs         83
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    250
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              850
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2780
;  :mk-clause               941
;  :num-allocs              4727106
;  :num-checks              259
;  :propagations            593
;  :quant-instantiations    208
;  :rlimit-count            229130)
(assert (forall ((i@71@04 Int)) (!
  (implies
    (and
      (<
        i@71@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
      (<= 0 i@71@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          i@71@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@71@04)
          (Seq_length __flatten_75__90@70@04))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@71@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@71@04))
  :qid |prog.l<no position>|)))
(declare-const $t@72@04 $Snap)
(assert (= $t@72@04 ($Snap.combine ($Snap.first $t@72@04) ($Snap.second $t@72@04))))
(assert (=
  ($Snap.second $t@72@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@72@04))
    ($Snap.second ($Snap.second $t@72@04)))))
(assert (=
  ($Snap.second ($Snap.second $t@72@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@72@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@72@04))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@72@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@73@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 49 | 0 <= i@73@04 | live]
; [else-branch: 49 | !(0 <= i@73@04) | live]
(push) ; 10
; [then-branch: 49 | 0 <= i@73@04]
(assert (<= 0 i@73@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 49 | !(0 <= i@73@04)]
(assert (not (<= 0 i@73@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 50 | i@73@04 < |First:(Second:($t@72@04))| && 0 <= i@73@04 | live]
; [else-branch: 50 | !(i@73@04 < |First:(Second:($t@72@04))| && 0 <= i@73@04) | live]
(push) ; 10
; [then-branch: 50 | i@73@04 < |First:(Second:($t@72@04))| && 0 <= i@73@04]
(assert (and
  (<
    i@73@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))
  (<= 0 i@73@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@73@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7744
;  :arith-add-rows          37
;  :arith-assert-diseq      121
;  :arith-assert-lower      318
;  :arith-assert-upper      274
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        218
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    256
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              850
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2802
;  :mk-clause               941
;  :num-allocs              4727106
;  :num-checks              260
;  :propagations            593
;  :quant-instantiations    213
;  :rlimit-count            230548)
; [eval] -1
(push) ; 11
; [then-branch: 51 | First:(Second:($t@72@04))[i@73@04] == -1 | live]
; [else-branch: 51 | First:(Second:($t@72@04))[i@73@04] != -1 | live]
(push) ; 12
; [then-branch: 51 | First:(Second:($t@72@04))[i@73@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
    i@73@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 51 | First:(Second:($t@72@04))[i@73@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
      i@73@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@73@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7744
;  :arith-add-rows          37
;  :arith-assert-diseq      121
;  :arith-assert-lower      318
;  :arith-assert-upper      274
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        218
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    256
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              850
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2803
;  :mk-clause               941
;  :num-allocs              4727106
;  :num-checks              261
;  :propagations            593
;  :quant-instantiations    213
;  :rlimit-count            230699)
(push) ; 13
; [then-branch: 52 | 0 <= First:(Second:($t@72@04))[i@73@04] | live]
; [else-branch: 52 | !(0 <= First:(Second:($t@72@04))[i@73@04]) | live]
(push) ; 14
; [then-branch: 52 | 0 <= First:(Second:($t@72@04))[i@73@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
    i@73@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@73@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7744
;  :arith-add-rows          37
;  :arith-assert-diseq      122
;  :arith-assert-lower      321
;  :arith-assert-upper      274
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        219
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    256
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              850
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2806
;  :mk-clause               942
;  :num-allocs              4727106
;  :num-checks              262
;  :propagations            593
;  :quant-instantiations    213
;  :rlimit-count            230803)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 52 | !(0 <= First:(Second:($t@72@04))[i@73@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
      i@73@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 50 | !(i@73@04 < |First:(Second:($t@72@04))| && 0 <= i@73@04)]
(assert (not
  (and
    (<
      i@73@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))
    (<= 0 i@73@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@73@04 Int)) (!
  (implies
    (and
      (<
        i@73@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))
      (<= 0 i@73@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
          i@73@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
            i@73@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
            i@73@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
    i@73@04))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
  __flatten_75__90@70@04))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1) ==> diz.Main_process_state[0] == -1
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7765
;  :arith-add-rows          37
;  :arith-assert-diseq      122
;  :arith-assert-lower      322
;  :arith-assert-upper      275
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        221
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    258
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              851
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2830
;  :mk-clause               958
;  :num-allocs              4727106
;  :num-checks              263
;  :propagations            599
;  :quant-instantiations    215
;  :rlimit-count            231828)
(push) ; 8
; [then-branch: 53 | 0 <= First:(Second:($t@67@04))[0] | live]
; [else-branch: 53 | !(0 <= First:(Second:($t@67@04))[0]) | live]
(push) ; 9
; [then-branch: 53 | 0 <= First:(Second:($t@67@04))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7765
;  :arith-add-rows          37
;  :arith-assert-diseq      122
;  :arith-assert-lower      322
;  :arith-assert-upper      275
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        221
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    258
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              851
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2830
;  :mk-clause               958
;  :num-allocs              4727106
;  :num-checks              264
;  :propagations            599
;  :quant-instantiations    215
;  :rlimit-count            231928)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7765
;  :arith-add-rows          37
;  :arith-assert-diseq      122
;  :arith-assert-lower      322
;  :arith-assert-upper      275
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        221
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    258
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              851
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2830
;  :mk-clause               958
;  :num-allocs              4727106
;  :num-checks              265
;  :propagations            599
;  :quant-instantiations    215
;  :rlimit-count            231937)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (Seq_length __flatten_75__90@70@04))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7765
;  :arith-add-rows          37
;  :arith-assert-diseq      122
;  :arith-assert-lower      322
;  :arith-assert-upper      275
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        221
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               189
;  :datatype-accessor-ax    258
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              851
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2830
;  :mk-clause               958
;  :num-allocs              4727106
;  :num-checks              266
;  :propagations            599
;  :quant-instantiations    215
;  :rlimit-count            232025)
(push) ; 10
; [then-branch: 54 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 | live]
; [else-branch: 54 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] != 0 | live]
(push) ; 11
; [then-branch: 54 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_75__90@70@04
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 54 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_75__90@70@04
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 12
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7766
;  :arith-add-rows          38
;  :arith-assert-diseq      122
;  :arith-assert-lower      322
;  :arith-assert-upper      275
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        221
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               189
;  :datatype-accessor-ax    258
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              851
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2835
;  :mk-clause               963
;  :num-allocs              4727106
;  :num-checks              267
;  :propagations            599
;  :quant-instantiations    216
;  :rlimit-count            232240)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7766
;  :arith-add-rows          38
;  :arith-assert-diseq      122
;  :arith-assert-lower      322
;  :arith-assert-upper      275
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        221
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               189
;  :datatype-accessor-ax    258
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              851
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2835
;  :mk-clause               963
;  :num-allocs              4727106
;  :num-checks              268
;  :propagations            599
;  :quant-instantiations    216
;  :rlimit-count            232249)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (Seq_length __flatten_75__90@70@04))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7766
;  :arith-add-rows          38
;  :arith-assert-diseq      122
;  :arith-assert-lower      322
;  :arith-assert-upper      275
;  :arith-bound-prop        43
;  :arith-conflicts         2
;  :arith-eq-adapter        221
;  :arith-fixed-eqs         85
;  :arith-offset-eqs        5
;  :arith-pivots            78
;  :binary-propagations     16
;  :conflicts               190
;  :datatype-accessor-ax    258
;  :datatype-constructor-ax 2094
;  :datatype-occurs-check   449
;  :datatype-splits         1127
;  :decisions               2078
;  :del-clause              851
;  :final-checks            132
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.57
;  :memory                  4.57
;  :minimized-lits          1
;  :mk-bool-var             2835
;  :mk-clause               963
;  :num-allocs              4727106
;  :num-checks              269
;  :propagations            599
;  :quant-instantiations    216
;  :rlimit-count            232337)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 53 | !(0 <= First:(Second:($t@67@04))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8263
;  :arith-add-rows          46
;  :arith-assert-diseq      154
;  :arith-assert-lower      372
;  :arith-assert-upper      312
;  :arith-bound-prop        48
;  :arith-conflicts         3
;  :arith-eq-adapter        259
;  :arith-fixed-eqs         107
;  :arith-offset-eqs        5
;  :arith-pivots            88
;  :binary-propagations     16
;  :conflicts               198
;  :datatype-accessor-ax    264
;  :datatype-constructor-ax 2205
;  :datatype-occurs-check   471
;  :datatype-splits         1196
;  :decisions               2198
;  :del-clause              984
;  :final-checks            137
;  :interface-eqs           9
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3065
;  :mk-clause               1091
;  :num-allocs              5119594
;  :num-checks              270
;  :propagations            689
;  :quant-instantiations    249
;  :rlimit-count            236090
;  :time                    0.00)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_75__90@70@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      0)
    (=
      (Seq_index
        __flatten_75__90@70@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8743
;  :arith-add-rows          58
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      353
;  :arith-bound-prop        51
;  :arith-conflicts         3
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 2316
;  :datatype-occurs-check   493
;  :datatype-splits         1265
;  :decisions               2317
;  :del-clause              1087
;  :final-checks            143
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3282
;  :mk-clause               1194
;  :num-allocs              5119594
;  :num-checks              271
;  :propagations            774
;  :quant-instantiations    279
;  :rlimit-count            239723
;  :time                    0.00)
; [then-branch: 55 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0] | live]
; [else-branch: 55 | !(__flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0]) | live]
(push) ; 9
; [then-branch: 55 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_75__90@70@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      0)
    (=
      (Seq_index
        __flatten_75__90@70@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8743
;  :arith-add-rows          58
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      353
;  :arith-bound-prop        51
;  :arith-conflicts         3
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 2316
;  :datatype-occurs-check   493
;  :datatype-splits         1265
;  :decisions               2317
;  :del-clause              1087
;  :final-checks            143
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3284
;  :mk-clause               1195
;  :num-allocs              5119594
;  :num-checks              272
;  :propagations            774
;  :quant-instantiations    279
;  :rlimit-count            239891)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 55 | !(__flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@72@04))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)) ==> diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8748
;  :arith-add-rows          58
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      353
;  :arith-bound-prop        51
;  :arith-conflicts         3
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 2316
;  :datatype-occurs-check   493
;  :datatype-splits         1265
;  :decisions               2317
;  :del-clause              1088
;  :final-checks            143
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3289
;  :mk-clause               1199
;  :num-allocs              5119594
;  :num-checks              273
;  :propagations            774
;  :quant-instantiations    279
;  :rlimit-count            240273)
(push) ; 8
; [then-branch: 56 | 0 <= First:(Second:($t@67@04))[0] | live]
; [else-branch: 56 | !(0 <= First:(Second:($t@67@04))[0]) | live]
(push) ; 9
; [then-branch: 56 | 0 <= First:(Second:($t@67@04))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8748
;  :arith-add-rows          58
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      353
;  :arith-bound-prop        51
;  :arith-conflicts         3
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 2316
;  :datatype-occurs-check   493
;  :datatype-splits         1265
;  :decisions               2317
;  :del-clause              1088
;  :final-checks            143
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3289
;  :mk-clause               1199
;  :num-allocs              5119594
;  :num-checks              274
;  :propagations            774
;  :quant-instantiations    279
;  :rlimit-count            240373)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8748
;  :arith-add-rows          58
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      353
;  :arith-bound-prop        51
;  :arith-conflicts         3
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 2316
;  :datatype-occurs-check   493
;  :datatype-splits         1265
;  :decisions               2317
;  :del-clause              1088
;  :final-checks            143
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3289
;  :mk-clause               1199
;  :num-allocs              5119594
;  :num-checks              275
;  :propagations            774
;  :quant-instantiations    279
;  :rlimit-count            240382)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (Seq_length __flatten_75__90@70@04))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8748
;  :arith-add-rows          58
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      353
;  :arith-bound-prop        51
;  :arith-conflicts         3
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :binary-propagations     16
;  :conflicts               204
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 2316
;  :datatype-occurs-check   493
;  :datatype-splits         1265
;  :decisions               2317
;  :del-clause              1088
;  :final-checks            143
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3289
;  :mk-clause               1199
;  :num-allocs              5119594
;  :num-checks              276
;  :propagations            774
;  :quant-instantiations    279
;  :rlimit-count            240470)
(push) ; 10
; [then-branch: 57 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 | live]
; [else-branch: 57 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] != 0 | live]
(push) ; 11
; [then-branch: 57 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_75__90@70@04
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 57 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_75__90@70@04
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 12
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8749
;  :arith-add-rows          59
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      353
;  :arith-bound-prop        51
;  :arith-conflicts         3
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :binary-propagations     16
;  :conflicts               204
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 2316
;  :datatype-occurs-check   493
;  :datatype-splits         1265
;  :decisions               2317
;  :del-clause              1088
;  :final-checks            143
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3293
;  :mk-clause               1204
;  :num-allocs              5119594
;  :num-checks              277
;  :propagations            774
;  :quant-instantiations    280
;  :rlimit-count            240623)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8749
;  :arith-add-rows          59
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      353
;  :arith-bound-prop        51
;  :arith-conflicts         3
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :binary-propagations     16
;  :conflicts               204
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 2316
;  :datatype-occurs-check   493
;  :datatype-splits         1265
;  :decisions               2317
;  :del-clause              1088
;  :final-checks            143
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3293
;  :mk-clause               1204
;  :num-allocs              5119594
;  :num-checks              278
;  :propagations            774
;  :quant-instantiations    280
;  :rlimit-count            240632)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (Seq_length __flatten_75__90@70@04))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8749
;  :arith-add-rows          59
;  :arith-assert-diseq      186
;  :arith-assert-lower      419
;  :arith-assert-upper      353
;  :arith-bound-prop        51
;  :arith-conflicts         3
;  :arith-eq-adapter        297
;  :arith-fixed-eqs         119
;  :arith-offset-eqs        6
;  :arith-pivots            94
;  :binary-propagations     16
;  :conflicts               205
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 2316
;  :datatype-occurs-check   493
;  :datatype-splits         1265
;  :decisions               2317
;  :del-clause              1088
;  :final-checks            143
;  :interface-eqs           11
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3293
;  :mk-clause               1204
;  :num-allocs              5119594
;  :num-checks              279
;  :propagations            774
;  :quant-instantiations    280
;  :rlimit-count            240720)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 56 | !(0 <= First:(Second:($t@67@04))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_75__90@70@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      0)
    (=
      (Seq_index
        __flatten_75__90@70@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9223
;  :arith-add-rows          61
;  :arith-assert-diseq      218
;  :arith-assert-lower      464
;  :arith-assert-upper      394
;  :arith-bound-prop        54
;  :arith-conflicts         3
;  :arith-eq-adapter        335
;  :arith-fixed-eqs         127
;  :arith-offset-eqs        9
;  :arith-pivots            98
;  :binary-propagations     16
;  :conflicts               210
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 2426
;  :datatype-occurs-check   515
;  :datatype-splits         1332
;  :decisions               2435
;  :del-clause              1189
;  :final-checks            149
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          11
;  :mk-bool-var             3501
;  :mk-clause               1300
;  :num-allocs              5119594
;  :num-checks              280
;  :propagations            857
;  :quant-instantiations    310
;  :rlimit-count            244200
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9813
;  :arith-add-rows          70
;  :arith-assert-diseq      248
;  :arith-assert-lower      506
;  :arith-assert-upper      427
;  :arith-bound-prop        59
;  :arith-conflicts         4
;  :arith-eq-adapter        369
;  :arith-fixed-eqs         147
;  :arith-offset-eqs        9
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               221
;  :datatype-accessor-ax    285
;  :datatype-constructor-ax 2566
;  :datatype-occurs-check   543
;  :datatype-splits         1403
;  :decisions               2582
;  :del-clause              1307
;  :final-checks            155
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             3727
;  :mk-clause               1418
;  :num-allocs              5119594
;  :num-checks              281
;  :propagations            946
;  :quant-instantiations    341
;  :rlimit-count            248177
;  :time                    0.00)
; [then-branch: 58 | !(__flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0]) | live]
; [else-branch: 58 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0] | live]
(push) ; 9
; [then-branch: 58 | !(__flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@70@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9814
;  :arith-add-rows          71
;  :arith-assert-diseq      248
;  :arith-assert-lower      506
;  :arith-assert-upper      427
;  :arith-bound-prop        59
;  :arith-conflicts         4
;  :arith-eq-adapter        369
;  :arith-fixed-eqs         147
;  :arith-offset-eqs        9
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               221
;  :datatype-accessor-ax    285
;  :datatype-constructor-ax 2566
;  :datatype-occurs-check   543
;  :datatype-splits         1403
;  :decisions               2582
;  :del-clause              1307
;  :final-checks            155
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             3731
;  :mk-clause               1423
;  :num-allocs              5119594
;  :num-checks              282
;  :propagations            948
;  :quant-instantiations    342
;  :rlimit-count            248360)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9814
;  :arith-add-rows          71
;  :arith-assert-diseq      248
;  :arith-assert-lower      506
;  :arith-assert-upper      427
;  :arith-bound-prop        59
;  :arith-conflicts         4
;  :arith-eq-adapter        369
;  :arith-fixed-eqs         147
;  :arith-offset-eqs        9
;  :arith-pivots            104
;  :binary-propagations     16
;  :conflicts               221
;  :datatype-accessor-ax    285
;  :datatype-constructor-ax 2566
;  :datatype-occurs-check   543
;  :datatype-splits         1403
;  :decisions               2582
;  :del-clause              1307
;  :final-checks            155
;  :interface-eqs           14
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             3731
;  :mk-clause               1423
;  :num-allocs              5119594
;  :num-checks              283
;  :propagations            948
;  :quant-instantiations    342
;  :rlimit-count            248375)
(pop) ; 9
(push) ; 9
; [else-branch: 58 | __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@70@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_75__90@70@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      0)
    (=
      (Seq_index
        __flatten_75__90@70@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (or
        (=
          (Seq_index
            __flatten_75__90@70@04
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
              0))
          0)
        (=
          (Seq_index
            __flatten_75__90@70@04
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Main_reset_all_events_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@74@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 59 | 0 <= i@74@04 | live]
; [else-branch: 59 | !(0 <= i@74@04) | live]
(push) ; 10
; [then-branch: 59 | 0 <= i@74@04]
(assert (<= 0 i@74@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 59 | !(0 <= i@74@04)]
(assert (not (<= 0 i@74@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 60 | i@74@04 < |First:(Second:($t@72@04))| && 0 <= i@74@04 | live]
; [else-branch: 60 | !(i@74@04 < |First:(Second:($t@72@04))| && 0 <= i@74@04) | live]
(push) ; 10
; [then-branch: 60 | i@74@04 < |First:(Second:($t@72@04))| && 0 <= i@74@04]
(assert (and
  (<
    i@74@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))
  (<= 0 i@74@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@74@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10295
;  :arith-add-rows          82
;  :arith-assert-diseq      281
;  :arith-assert-lower      558
;  :arith-assert-upper      471
;  :arith-bound-prop        63
;  :arith-conflicts         4
;  :arith-eq-adapter        409
;  :arith-fixed-eqs         160
;  :arith-offset-eqs        11
;  :arith-pivots            114
;  :binary-propagations     16
;  :conflicts               226
;  :datatype-accessor-ax    291
;  :datatype-constructor-ax 2676
;  :datatype-occurs-check   565
;  :datatype-splits         1470
;  :decisions               2702
;  :del-clause              1435
;  :final-checks            161
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             3955
;  :mk-clause               1538
;  :num-allocs              5119594
;  :num-checks              285
;  :propagations            1039
;  :quant-instantiations    375
;  :rlimit-count            252274)
; [eval] -1
(push) ; 11
; [then-branch: 61 | First:(Second:($t@72@04))[i@74@04] == -1 | live]
; [else-branch: 61 | First:(Second:($t@72@04))[i@74@04] != -1 | live]
(push) ; 12
; [then-branch: 61 | First:(Second:($t@72@04))[i@74@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
    i@74@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 61 | First:(Second:($t@72@04))[i@74@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
      i@74@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@74@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10302
;  :arith-add-rows          84
;  :arith-assert-diseq      283
;  :arith-assert-lower      562
;  :arith-assert-upper      473
;  :arith-bound-prop        63
;  :arith-conflicts         4
;  :arith-eq-adapter        411
;  :arith-fixed-eqs         161
;  :arith-offset-eqs        11
;  :arith-pivots            114
;  :binary-propagations     16
;  :conflicts               226
;  :datatype-accessor-ax    291
;  :datatype-constructor-ax 2676
;  :datatype-occurs-check   565
;  :datatype-splits         1470
;  :decisions               2702
;  :del-clause              1435
;  :final-checks            161
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             3968
;  :mk-clause               1547
;  :num-allocs              5119594
;  :num-checks              286
;  :propagations            1046
;  :quant-instantiations    377
;  :rlimit-count            252475)
(push) ; 13
; [then-branch: 62 | 0 <= First:(Second:($t@72@04))[i@74@04] | live]
; [else-branch: 62 | !(0 <= First:(Second:($t@72@04))[i@74@04]) | live]
(push) ; 14
; [then-branch: 62 | 0 <= First:(Second:($t@72@04))[i@74@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
    i@74@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@74@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10304
;  :arith-add-rows          85
;  :arith-assert-diseq      283
;  :arith-assert-lower      564
;  :arith-assert-upper      474
;  :arith-bound-prop        63
;  :arith-conflicts         4
;  :arith-eq-adapter        412
;  :arith-fixed-eqs         162
;  :arith-offset-eqs        11
;  :arith-pivots            114
;  :binary-propagations     16
;  :conflicts               226
;  :datatype-accessor-ax    291
;  :datatype-constructor-ax 2676
;  :datatype-occurs-check   565
;  :datatype-splits         1470
;  :decisions               2702
;  :del-clause              1435
;  :final-checks            161
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             3972
;  :mk-clause               1547
;  :num-allocs              5119594
;  :num-checks              287
;  :propagations            1046
;  :quant-instantiations    377
;  :rlimit-count            252587)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 62 | !(0 <= First:(Second:($t@72@04))[i@74@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
      i@74@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 60 | !(i@74@04 < |First:(Second:($t@72@04))| && 0 <= i@74@04)]
(assert (not
  (and
    (<
      i@74@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))
    (<= 0 i@74@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@74@04 Int)) (!
  (implies
    (and
      (<
        i@74@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))
      (<= 0 i@74@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
          i@74@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
            i@74@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
            i@74@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
    i@74@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10304
;  :arith-add-rows          85
;  :arith-assert-diseq      284
;  :arith-assert-lower      565
;  :arith-assert-upper      475
;  :arith-bound-prop        63
;  :arith-conflicts         4
;  :arith-eq-adapter        413
;  :arith-fixed-eqs         163
;  :arith-offset-eqs        11
;  :arith-pivots            114
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    291
;  :datatype-constructor-ax 2676
;  :datatype-occurs-check   565
;  :datatype-splits         1470
;  :decisions               2702
;  :del-clause              1456
;  :final-checks            161
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             3980
;  :mk-clause               1559
;  :num-allocs              5119594
;  :num-checks              288
;  :propagations            1048
;  :quant-instantiations    378
;  :rlimit-count            253009)
(assert (forall ((i@74@04 Int)) (!
  (implies
    (and
      (<
        i@74@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))
      (<= 0 i@74@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
          i@74@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
            i@74@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
            i@74@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))
    i@74@04))
  :qid |prog.l<no position>|)))
(declare-const $t@75@04 $Snap)
(assert (= $t@75@04 ($Snap.combine ($Snap.first $t@75@04) ($Snap.second $t@75@04))))
(assert (=
  ($Snap.second $t@75@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@75@04))
    ($Snap.second ($Snap.second $t@75@04)))))
(assert (=
  ($Snap.second ($Snap.second $t@75@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@75@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@75@04))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@75@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@76@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 63 | 0 <= i@76@04 | live]
; [else-branch: 63 | !(0 <= i@76@04) | live]
(push) ; 10
; [then-branch: 63 | 0 <= i@76@04]
(assert (<= 0 i@76@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 63 | !(0 <= i@76@04)]
(assert (not (<= 0 i@76@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 64 | i@76@04 < |First:(Second:($t@75@04))| && 0 <= i@76@04 | live]
; [else-branch: 64 | !(i@76@04 < |First:(Second:($t@75@04))| && 0 <= i@76@04) | live]
(push) ; 10
; [then-branch: 64 | i@76@04 < |First:(Second:($t@75@04))| && 0 <= i@76@04]
(assert (and
  (<
    i@76@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))))
  (<= 0 i@76@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@76@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10342
;  :arith-add-rows          85
;  :arith-assert-diseq      284
;  :arith-assert-lower      570
;  :arith-assert-upper      478
;  :arith-bound-prop        63
;  :arith-conflicts         4
;  :arith-eq-adapter        415
;  :arith-fixed-eqs         164
;  :arith-offset-eqs        11
;  :arith-pivots            114
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    297
;  :datatype-constructor-ax 2676
;  :datatype-occurs-check   565
;  :datatype-splits         1470
;  :decisions               2702
;  :del-clause              1456
;  :final-checks            161
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             4002
;  :mk-clause               1559
;  :num-allocs              5119594
;  :num-checks              289
;  :propagations            1048
;  :quant-instantiations    382
;  :rlimit-count            254401)
; [eval] -1
(push) ; 11
; [then-branch: 65 | First:(Second:($t@75@04))[i@76@04] == -1 | live]
; [else-branch: 65 | First:(Second:($t@75@04))[i@76@04] != -1 | live]
(push) ; 12
; [then-branch: 65 | First:(Second:($t@75@04))[i@76@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
    i@76@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 65 | First:(Second:($t@75@04))[i@76@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
      i@76@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@76@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10342
;  :arith-add-rows          85
;  :arith-assert-diseq      284
;  :arith-assert-lower      570
;  :arith-assert-upper      478
;  :arith-bound-prop        63
;  :arith-conflicts         4
;  :arith-eq-adapter        415
;  :arith-fixed-eqs         164
;  :arith-offset-eqs        11
;  :arith-pivots            114
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    297
;  :datatype-constructor-ax 2676
;  :datatype-occurs-check   565
;  :datatype-splits         1470
;  :decisions               2702
;  :del-clause              1456
;  :final-checks            161
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             4003
;  :mk-clause               1559
;  :num-allocs              5119594
;  :num-checks              290
;  :propagations            1048
;  :quant-instantiations    382
;  :rlimit-count            254552)
(push) ; 13
; [then-branch: 66 | 0 <= First:(Second:($t@75@04))[i@76@04] | live]
; [else-branch: 66 | !(0 <= First:(Second:($t@75@04))[i@76@04]) | live]
(push) ; 14
; [then-branch: 66 | 0 <= First:(Second:($t@75@04))[i@76@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
    i@76@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@76@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10342
;  :arith-add-rows          85
;  :arith-assert-diseq      285
;  :arith-assert-lower      573
;  :arith-assert-upper      478
;  :arith-bound-prop        63
;  :arith-conflicts         4
;  :arith-eq-adapter        416
;  :arith-fixed-eqs         164
;  :arith-offset-eqs        11
;  :arith-pivots            114
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    297
;  :datatype-constructor-ax 2676
;  :datatype-occurs-check   565
;  :datatype-splits         1470
;  :decisions               2702
;  :del-clause              1456
;  :final-checks            161
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             4006
;  :mk-clause               1560
;  :num-allocs              5119594
;  :num-checks              291
;  :propagations            1048
;  :quant-instantiations    382
;  :rlimit-count            254656)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 66 | !(0 <= First:(Second:($t@75@04))[i@76@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
      i@76@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 64 | !(i@76@04 < |First:(Second:($t@75@04))| && 0 <= i@76@04)]
(assert (not
  (and
    (<
      i@76@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))))
    (<= 0 i@76@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@76@04 Int)) (!
  (implies
    (and
      (<
        i@76@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))))
      (<= 0 i@76@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
          i@76@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
            i@76@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
            i@76@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
    i@76@04))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@72@04)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10360
;  :arith-add-rows          85
;  :arith-assert-diseq      285
;  :arith-assert-lower      574
;  :arith-assert-upper      479
;  :arith-bound-prop        63
;  :arith-conflicts         4
;  :arith-eq-adapter        417
;  :arith-fixed-eqs         165
;  :arith-offset-eqs        11
;  :arith-pivots            114
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    299
;  :datatype-constructor-ax 2676
;  :datatype-occurs-check   565
;  :datatype-splits         1470
;  :decisions               2702
;  :del-clause              1457
;  :final-checks            161
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             4026
;  :mk-clause               1570
;  :num-allocs              5119594
;  :num-checks              292
;  :propagations            1052
;  :quant-instantiations    384
;  :rlimit-count            255671)
(push) ; 8
; [then-branch: 67 | First:(Second:(Second:(Second:($t@72@04))))[0] == 0 | live]
; [else-branch: 67 | First:(Second:(Second:(Second:($t@72@04))))[0] != 0 | live]
(push) ; 9
; [then-branch: 67 | First:(Second:(Second:(Second:($t@72@04))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 67 | First:(Second:(Second:(Second:($t@72@04))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10361
;  :arith-add-rows          85
;  :arith-assert-diseq      285
;  :arith-assert-lower      574
;  :arith-assert-upper      479
;  :arith-bound-prop        63
;  :arith-conflicts         4
;  :arith-eq-adapter        417
;  :arith-fixed-eqs         165
;  :arith-offset-eqs        11
;  :arith-pivots            114
;  :binary-propagations     16
;  :conflicts               227
;  :datatype-accessor-ax    299
;  :datatype-constructor-ax 2676
;  :datatype-occurs-check   565
;  :datatype-splits         1470
;  :decisions               2702
;  :del-clause              1457
;  :final-checks            161
;  :interface-eqs           16
;  :max-generation          3
;  :max-memory              4.76
;  :memory                  4.76
;  :minimized-lits          21
;  :mk-bool-var             4031
;  :mk-clause               1575
;  :num-allocs              5119594
;  :num-checks              293
;  :propagations            1052
;  :quant-instantiations    385
;  :rlimit-count            255883)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10905
;  :arith-add-rows          98
;  :arith-assert-diseq      325
;  :arith-assert-lower      640
;  :arith-assert-upper      512
;  :arith-bound-prop        68
;  :arith-conflicts         4
;  :arith-eq-adapter        464
;  :arith-fixed-eqs         189
;  :arith-offset-eqs        12
;  :arith-pivots            130
;  :binary-propagations     16
;  :conflicts               233
;  :datatype-accessor-ax    307
;  :datatype-constructor-ax 2793
;  :datatype-occurs-check   590
;  :datatype-splits         1545
;  :decisions               2826
;  :del-clause              1627
;  :final-checks            166
;  :interface-eqs           17
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          23
;  :mk-bool-var             4291
;  :mk-clause               1740
;  :num-allocs              5327977
;  :num-checks              294
;  :propagations            1170
;  :quant-instantiations    424
;  :rlimit-count            259900
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11556
;  :arith-add-rows          116
;  :arith-assert-diseq      376
;  :arith-assert-lower      712
;  :arith-assert-upper      573
;  :arith-bound-prop        71
;  :arith-conflicts         4
;  :arith-eq-adapter        528
;  :arith-fixed-eqs         205
;  :arith-offset-eqs        16
;  :arith-pivots            145
;  :binary-propagations     16
;  :conflicts               242
;  :datatype-accessor-ax    315
;  :datatype-constructor-ax 2931
;  :datatype-occurs-check   615
;  :datatype-splits         1620
;  :decisions               2976
;  :del-clause              1786
;  :final-checks            172
;  :interface-eqs           19
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          23
;  :mk-bool-var             4577
;  :mk-clause               1899
;  :num-allocs              5327977
;  :num-checks              295
;  :propagations            1339
;  :quant-instantiations    478
;  :rlimit-count            264652
;  :time                    0.00)
; [then-branch: 68 | First:(Second:(Second:(Second:($t@72@04))))[0] == 0 || First:(Second:(Second:(Second:($t@72@04))))[0] == -1 | live]
; [else-branch: 68 | !(First:(Second:(Second:(Second:($t@72@04))))[0] == 0 || First:(Second:(Second:(Second:($t@72@04))))[0] == -1) | live]
(push) ; 9
; [then-branch: 68 | First:(Second:(Second:(Second:($t@72@04))))[0] == 0 || First:(Second:(Second:(Second:($t@72@04))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11556
;  :arith-add-rows          116
;  :arith-assert-diseq      376
;  :arith-assert-lower      712
;  :arith-assert-upper      573
;  :arith-bound-prop        71
;  :arith-conflicts         4
;  :arith-eq-adapter        528
;  :arith-fixed-eqs         205
;  :arith-offset-eqs        16
;  :arith-pivots            145
;  :binary-propagations     16
;  :conflicts               242
;  :datatype-accessor-ax    315
;  :datatype-constructor-ax 2931
;  :datatype-occurs-check   615
;  :datatype-splits         1620
;  :decisions               2976
;  :del-clause              1786
;  :final-checks            172
;  :interface-eqs           19
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          23
;  :mk-bool-var             4579
;  :mk-clause               1900
;  :num-allocs              5327977
;  :num-checks              296
;  :propagations            1339
;  :quant-instantiations    478
;  :rlimit-count            264801)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 68 | !(First:(Second:(Second:(Second:($t@72@04))))[0] == 0 || First:(Second:(Second:(Second:($t@72@04))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11562
;  :arith-add-rows          116
;  :arith-assert-diseq      376
;  :arith-assert-lower      712
;  :arith-assert-upper      573
;  :arith-bound-prop        71
;  :arith-conflicts         4
;  :arith-eq-adapter        528
;  :arith-fixed-eqs         205
;  :arith-offset-eqs        16
;  :arith-pivots            145
;  :binary-propagations     16
;  :conflicts               242
;  :datatype-accessor-ax    316
;  :datatype-constructor-ax 2931
;  :datatype-occurs-check   615
;  :datatype-splits         1620
;  :decisions               2976
;  :del-clause              1787
;  :final-checks            172
;  :interface-eqs           19
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          23
;  :mk-bool-var             4585
;  :mk-clause               1904
;  :num-allocs              5327977
;  :num-checks              297
;  :propagations            1339
;  :quant-instantiations    478
;  :rlimit-count            265284)
(push) ; 8
; [then-branch: 69 | First:(Second:(Second:(Second:($t@72@04))))[1] == 0 | live]
; [else-branch: 69 | First:(Second:(Second:(Second:($t@72@04))))[1] != 0 | live]
(push) ; 9
; [then-branch: 69 | First:(Second:(Second:(Second:($t@72@04))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 69 | First:(Second:(Second:(Second:($t@72@04))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11563
;  :arith-add-rows          116
;  :arith-assert-diseq      376
;  :arith-assert-lower      712
;  :arith-assert-upper      573
;  :arith-bound-prop        71
;  :arith-conflicts         4
;  :arith-eq-adapter        528
;  :arith-fixed-eqs         205
;  :arith-offset-eqs        16
;  :arith-pivots            145
;  :binary-propagations     16
;  :conflicts               242
;  :datatype-accessor-ax    316
;  :datatype-constructor-ax 2931
;  :datatype-occurs-check   615
;  :datatype-splits         1620
;  :decisions               2976
;  :del-clause              1787
;  :final-checks            172
;  :interface-eqs           19
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          23
;  :mk-bool-var             4590
;  :mk-clause               1909
;  :num-allocs              5327977
;  :num-checks              298
;  :propagations            1339
;  :quant-instantiations    479
;  :rlimit-count            265468)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12280
;  :arith-add-rows          135
;  :arith-assert-diseq      433
;  :arith-assert-lower      812
;  :arith-assert-upper      650
;  :arith-bound-prop        74
;  :arith-conflicts         4
;  :arith-eq-adapter        604
;  :arith-fixed-eqs         233
;  :arith-offset-eqs        20
;  :arith-pivots            161
;  :binary-propagations     16
;  :conflicts               254
;  :datatype-accessor-ax    324
;  :datatype-constructor-ax 3069
;  :datatype-occurs-check   641
;  :datatype-splits         1695
;  :decisions               3136
;  :del-clause              2037
;  :final-checks            178
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          30
;  :mk-bool-var             4970
;  :mk-clause               2154
;  :num-allocs              5327977
;  :num-checks              299
;  :propagations            1556
;  :quant-instantiations    556
;  :rlimit-count            270829
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12874
;  :arith-add-rows          147
;  :arith-assert-diseq      478
;  :arith-assert-lower      878
;  :arith-assert-upper      683
;  :arith-bound-prop        79
;  :arith-conflicts         4
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         259
;  :arith-offset-eqs        22
;  :arith-pivots            176
;  :binary-propagations     16
;  :conflicts               263
;  :datatype-accessor-ax    335
;  :datatype-constructor-ax 3195
;  :datatype-occurs-check   675
;  :datatype-splits         1776
;  :decisions               3266
;  :del-clause              2209
;  :final-checks            184
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          35
;  :mk-bool-var             5256
;  :mk-clause               2326
;  :num-allocs              5327977
;  :num-checks              300
;  :propagations            1683
;  :quant-instantiations    597
;  :rlimit-count            275034
;  :time                    0.01)
; [then-branch: 70 | First:(Second:(Second:(Second:($t@72@04))))[1] == 0 || First:(Second:(Second:(Second:($t@72@04))))[1] == -1 | live]
; [else-branch: 70 | !(First:(Second:(Second:(Second:($t@72@04))))[1] == 0 || First:(Second:(Second:(Second:($t@72@04))))[1] == -1) | live]
(push) ; 9
; [then-branch: 70 | First:(Second:(Second:(Second:($t@72@04))))[1] == 0 || First:(Second:(Second:(Second:($t@72@04))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12874
;  :arith-add-rows          147
;  :arith-assert-diseq      478
;  :arith-assert-lower      878
;  :arith-assert-upper      683
;  :arith-bound-prop        79
;  :arith-conflicts         4
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         259
;  :arith-offset-eqs        22
;  :arith-pivots            176
;  :binary-propagations     16
;  :conflicts               263
;  :datatype-accessor-ax    335
;  :datatype-constructor-ax 3195
;  :datatype-occurs-check   675
;  :datatype-splits         1776
;  :decisions               3266
;  :del-clause              2209
;  :final-checks            184
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          35
;  :mk-bool-var             5258
;  :mk-clause               2327
;  :num-allocs              5327977
;  :num-checks              301
;  :propagations            1683
;  :quant-instantiations    597
;  :rlimit-count            275183)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 70 | !(First:(Second:(Second:(Second:($t@72@04))))[1] == 0 || First:(Second:(Second:(Second:($t@72@04))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1)
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12880
;  :arith-add-rows          147
;  :arith-assert-diseq      478
;  :arith-assert-lower      878
;  :arith-assert-upper      683
;  :arith-bound-prop        79
;  :arith-conflicts         4
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         259
;  :arith-offset-eqs        22
;  :arith-pivots            176
;  :binary-propagations     16
;  :conflicts               263
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 3195
;  :datatype-occurs-check   675
;  :datatype-splits         1776
;  :decisions               3266
;  :del-clause              2210
;  :final-checks            184
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          35
;  :mk-bool-var             5264
;  :mk-clause               2331
;  :num-allocs              5327977
;  :num-checks              302
;  :propagations            1683
;  :quant-instantiations    597
;  :rlimit-count            275672)
(push) ; 8
; [then-branch: 71 | First:(Second:(Second:(Second:($t@72@04))))[0] == 0 | live]
; [else-branch: 71 | First:(Second:(Second:(Second:($t@72@04))))[0] != 0 | live]
(push) ; 9
; [then-branch: 71 | First:(Second:(Second:(Second:($t@72@04))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 71 | First:(Second:(Second:(Second:($t@72@04))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12881
;  :arith-add-rows          147
;  :arith-assert-diseq      478
;  :arith-assert-lower      878
;  :arith-assert-upper      683
;  :arith-bound-prop        79
;  :arith-conflicts         4
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         259
;  :arith-offset-eqs        22
;  :arith-pivots            176
;  :binary-propagations     16
;  :conflicts               263
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 3195
;  :datatype-occurs-check   675
;  :datatype-splits         1776
;  :decisions               3266
;  :del-clause              2210
;  :final-checks            184
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          35
;  :mk-bool-var             5268
;  :mk-clause               2336
;  :num-allocs              5327977
;  :num-checks              303
;  :propagations            1683
;  :quant-instantiations    598
;  :rlimit-count            275840)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13592
;  :arith-add-rows          170
;  :arith-assert-diseq      531
;  :arith-assert-lower      958
;  :arith-assert-upper      748
;  :arith-bound-prop        82
;  :arith-conflicts         4
;  :arith-eq-adapter        719
;  :arith-fixed-eqs         279
;  :arith-offset-eqs        26
;  :arith-pivots            189
;  :binary-propagations     16
;  :conflicts               276
;  :datatype-accessor-ax    347
;  :datatype-constructor-ax 3342
;  :datatype-occurs-check   709
;  :datatype-splits         1857
;  :decisions               3424
;  :del-clause              2405
;  :final-checks            191
;  :interface-eqs           24
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          37
;  :mk-bool-var             5605
;  :mk-clause               2526
;  :num-allocs              5327977
;  :num-checks              304
;  :propagations            1873
;  :quant-instantiations    659
;  :rlimit-count            280929
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14200
;  :arith-add-rows          185
;  :arith-assert-diseq      577
;  :arith-assert-lower      1026
;  :arith-assert-upper      781
;  :arith-bound-prop        87
;  :arith-conflicts         4
;  :arith-eq-adapter        768
;  :arith-fixed-eqs         306
;  :arith-offset-eqs        28
;  :arith-pivots            206
;  :binary-propagations     16
;  :conflicts               286
;  :datatype-accessor-ax    358
;  :datatype-constructor-ax 3468
;  :datatype-occurs-check   743
;  :datatype-splits         1938
;  :decisions               3557
;  :del-clause              2579
;  :final-checks            197
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          39
;  :mk-bool-var             5902
;  :mk-clause               2700
;  :num-allocs              5327977
;  :num-checks              305
;  :propagations            2005
;  :quant-instantiations    703
;  :rlimit-count            285229
;  :time                    0.00)
; [then-branch: 72 | !(First:(Second:(Second:(Second:($t@72@04))))[0] == 0 || First:(Second:(Second:(Second:($t@72@04))))[0] == -1) | live]
; [else-branch: 72 | First:(Second:(Second:(Second:($t@72@04))))[0] == 0 || First:(Second:(Second:(Second:($t@72@04))))[0] == -1 | live]
(push) ; 9
; [then-branch: 72 | !(First:(Second:(Second:(Second:($t@72@04))))[0] == 0 || First:(Second:(Second:(Second:($t@72@04))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14201
;  :arith-add-rows          185
;  :arith-assert-diseq      577
;  :arith-assert-lower      1026
;  :arith-assert-upper      781
;  :arith-bound-prop        87
;  :arith-conflicts         4
;  :arith-eq-adapter        768
;  :arith-fixed-eqs         306
;  :arith-offset-eqs        28
;  :arith-pivots            206
;  :binary-propagations     16
;  :conflicts               286
;  :datatype-accessor-ax    358
;  :datatype-constructor-ax 3468
;  :datatype-occurs-check   743
;  :datatype-splits         1938
;  :decisions               3557
;  :del-clause              2579
;  :final-checks            197
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          39
;  :mk-bool-var             5906
;  :mk-clause               2705
;  :num-allocs              5327977
;  :num-checks              306
;  :propagations            2006
;  :quant-instantiations    704
;  :rlimit-count            285418)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14201
;  :arith-add-rows          185
;  :arith-assert-diseq      577
;  :arith-assert-lower      1026
;  :arith-assert-upper      781
;  :arith-bound-prop        87
;  :arith-conflicts         4
;  :arith-eq-adapter        768
;  :arith-fixed-eqs         306
;  :arith-offset-eqs        28
;  :arith-pivots            206
;  :binary-propagations     16
;  :conflicts               286
;  :datatype-accessor-ax    358
;  :datatype-constructor-ax 3468
;  :datatype-occurs-check   743
;  :datatype-splits         1938
;  :decisions               3557
;  :del-clause              2579
;  :final-checks            197
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          39
;  :mk-bool-var             5906
;  :mk-clause               2705
;  :num-allocs              5327977
;  :num-checks              307
;  :propagations            2006
;  :quant-instantiations    704
;  :rlimit-count            285433)
(pop) ; 9
(push) ; 9
; [else-branch: 72 | First:(Second:(Second:(Second:($t@72@04))))[0] == 0 || First:(Second:(Second:(Second:($t@72@04))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@04))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1)
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14208
;  :arith-add-rows          185
;  :arith-assert-diseq      577
;  :arith-assert-lower      1026
;  :arith-assert-upper      781
;  :arith-bound-prop        87
;  :arith-conflicts         4
;  :arith-eq-adapter        768
;  :arith-fixed-eqs         306
;  :arith-offset-eqs        28
;  :arith-pivots            206
;  :binary-propagations     16
;  :conflicts               286
;  :datatype-accessor-ax    358
;  :datatype-constructor-ax 3468
;  :datatype-occurs-check   743
;  :datatype-splits         1938
;  :decisions               3557
;  :del-clause              2584
;  :final-checks            197
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          39
;  :mk-bool-var             5908
;  :mk-clause               2706
;  :num-allocs              5327977
;  :num-checks              308
;  :propagations            2006
;  :quant-instantiations    704
;  :rlimit-count            285785)
(push) ; 8
; [then-branch: 73 | First:(Second:(Second:(Second:($t@72@04))))[1] == 0 | live]
; [else-branch: 73 | First:(Second:(Second:(Second:($t@72@04))))[1] != 0 | live]
(push) ; 9
; [then-branch: 73 | First:(Second:(Second:(Second:($t@72@04))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 73 | First:(Second:(Second:(Second:($t@72@04))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14209
;  :arith-add-rows          185
;  :arith-assert-diseq      577
;  :arith-assert-lower      1026
;  :arith-assert-upper      781
;  :arith-bound-prop        87
;  :arith-conflicts         4
;  :arith-eq-adapter        768
;  :arith-fixed-eqs         306
;  :arith-offset-eqs        28
;  :arith-pivots            206
;  :binary-propagations     16
;  :conflicts               286
;  :datatype-accessor-ax    358
;  :datatype-constructor-ax 3468
;  :datatype-occurs-check   743
;  :datatype-splits         1938
;  :decisions               3557
;  :del-clause              2584
;  :final-checks            197
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          39
;  :mk-bool-var             5912
;  :mk-clause               2711
;  :num-allocs              5327977
;  :num-checks              309
;  :propagations            2006
;  :quant-instantiations    705
;  :rlimit-count            285953)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14797
;  :arith-add-rows          204
;  :arith-assert-diseq      621
;  :arith-assert-lower      1092
;  :arith-assert-upper      814
;  :arith-bound-prop        92
;  :arith-conflicts         4
;  :arith-eq-adapter        815
;  :arith-fixed-eqs         331
;  :arith-offset-eqs        30
;  :arith-pivots            222
;  :binary-propagations     16
;  :conflicts               295
;  :datatype-accessor-ax    369
;  :datatype-constructor-ax 3593
;  :datatype-occurs-check   777
;  :datatype-splits         2017
;  :decisions               3686
;  :del-clause              2761
;  :final-checks            203
;  :interface-eqs           26
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          42
;  :mk-bool-var             6190
;  :mk-clause               2883
;  :num-allocs              5327977
;  :num-checks              310
;  :propagations            2134
;  :quant-instantiations    744
;  :rlimit-count            290227
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15562
;  :arith-add-rows          232
;  :arith-assert-diseq      678
;  :arith-assert-lower      1192
;  :arith-assert-upper      891
;  :arith-bound-prop        95
;  :arith-conflicts         4
;  :arith-eq-adapter        891
;  :arith-fixed-eqs         361
;  :arith-offset-eqs        33
;  :arith-pivots            241
;  :binary-propagations     16
;  :conflicts               311
;  :datatype-accessor-ax    380
;  :datatype-constructor-ax 3739
;  :datatype-occurs-check   811
;  :datatype-splits         2096
;  :decisions               3850
;  :del-clause              3017
;  :final-checks            210
;  :interface-eqs           28
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          50
;  :mk-bool-var             6596
;  :mk-clause               3139
;  :num-allocs              5327977
;  :num-checks              311
;  :propagations            2366
;  :quant-instantiations    823
;  :rlimit-count            295896
;  :time                    0.01)
; [then-branch: 74 | !(First:(Second:(Second:(Second:($t@72@04))))[1] == 0 || First:(Second:(Second:(Second:($t@72@04))))[1] == -1) | live]
; [else-branch: 74 | First:(Second:(Second:(Second:($t@72@04))))[1] == 0 || First:(Second:(Second:(Second:($t@72@04))))[1] == -1 | live]
(push) ; 9
; [then-branch: 74 | !(First:(Second:(Second:(Second:($t@72@04))))[1] == 0 || First:(Second:(Second:(Second:($t@72@04))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15563
;  :arith-add-rows          232
;  :arith-assert-diseq      678
;  :arith-assert-lower      1192
;  :arith-assert-upper      891
;  :arith-bound-prop        95
;  :arith-conflicts         4
;  :arith-eq-adapter        891
;  :arith-fixed-eqs         361
;  :arith-offset-eqs        33
;  :arith-pivots            241
;  :binary-propagations     16
;  :conflicts               311
;  :datatype-accessor-ax    380
;  :datatype-constructor-ax 3739
;  :datatype-occurs-check   811
;  :datatype-splits         2096
;  :decisions               3850
;  :del-clause              3017
;  :final-checks            210
;  :interface-eqs           28
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          50
;  :mk-bool-var             6600
;  :mk-clause               3144
;  :num-allocs              5327977
;  :num-checks              312
;  :propagations            2367
;  :quant-instantiations    824
;  :rlimit-count            296085)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15563
;  :arith-add-rows          232
;  :arith-assert-diseq      678
;  :arith-assert-lower      1192
;  :arith-assert-upper      891
;  :arith-bound-prop        95
;  :arith-conflicts         4
;  :arith-eq-adapter        891
;  :arith-fixed-eqs         361
;  :arith-offset-eqs        33
;  :arith-pivots            241
;  :binary-propagations     16
;  :conflicts               311
;  :datatype-accessor-ax    380
;  :datatype-constructor-ax 3739
;  :datatype-occurs-check   811
;  :datatype-splits         2096
;  :decisions               3850
;  :del-clause              3017
;  :final-checks            210
;  :interface-eqs           28
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          50
;  :mk-bool-var             6600
;  :mk-clause               3144
;  :num-allocs              5327977
;  :num-checks              313
;  :propagations            2367
;  :quant-instantiations    824
;  :rlimit-count            296100)
(pop) ; 9
(push) ; 9
; [else-branch: 74 | First:(Second:(Second:(Second:($t@72@04))))[1] == 0 || First:(Second:(Second:(Second:($t@72@04))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@72@04)))))
      1))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@77@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 75 | 0 <= i@77@04 | live]
; [else-branch: 75 | !(0 <= i@77@04) | live]
(push) ; 10
; [then-branch: 75 | 0 <= i@77@04]
(assert (<= 0 i@77@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 75 | !(0 <= i@77@04)]
(assert (not (<= 0 i@77@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 76 | i@77@04 < |First:(Second:($t@75@04))| && 0 <= i@77@04 | live]
; [else-branch: 76 | !(i@77@04 < |First:(Second:($t@75@04))| && 0 <= i@77@04) | live]
(push) ; 10
; [then-branch: 76 | i@77@04 < |First:(Second:($t@75@04))| && 0 <= i@77@04]
(assert (and
  (<
    i@77@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))))
  (<= 0 i@77@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@77@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16165
;  :arith-add-rows          247
;  :arith-assert-diseq      721
;  :arith-assert-lower      1260
;  :arith-assert-upper      925
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        939
;  :arith-fixed-eqs         388
;  :arith-offset-eqs        35
;  :arith-pivots            256
;  :binary-propagations     16
;  :conflicts               320
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3192
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6892
;  :mk-clause               3319
;  :num-allocs              5327977
;  :num-checks              315
;  :propagations            2499
;  :quant-instantiations    866
;  :rlimit-count            300551)
; [eval] -1
(push) ; 11
; [then-branch: 77 | First:(Second:($t@75@04))[i@77@04] == -1 | live]
; [else-branch: 77 | First:(Second:($t@75@04))[i@77@04] != -1 | live]
(push) ; 12
; [then-branch: 77 | First:(Second:($t@75@04))[i@77@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
    i@77@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 77 | First:(Second:($t@75@04))[i@77@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
      i@77@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@77@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16176
;  :arith-add-rows          249
;  :arith-assert-diseq      724
;  :arith-assert-lower      1268
;  :arith-assert-upper      929
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        943
;  :arith-fixed-eqs         390
;  :arith-offset-eqs        35
;  :arith-pivots            257
;  :binary-propagations     16
;  :conflicts               320
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3192
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6913
;  :mk-clause               3340
;  :num-allocs              5327977
;  :num-checks              316
;  :propagations            2511
;  :quant-instantiations    870
;  :rlimit-count            300814)
(push) ; 13
; [then-branch: 78 | 0 <= First:(Second:($t@75@04))[i@77@04] | live]
; [else-branch: 78 | !(0 <= First:(Second:($t@75@04))[i@77@04]) | live]
(push) ; 14
; [then-branch: 78 | 0 <= First:(Second:($t@75@04))[i@77@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
    i@77@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@77@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      724
;  :arith-assert-lower      1270
;  :arith-assert-upper      930
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        944
;  :arith-fixed-eqs         391
;  :arith-offset-eqs        35
;  :arith-pivots            258
;  :binary-propagations     16
;  :conflicts               320
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3192
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6917
;  :mk-clause               3340
;  :num-allocs              5327977
;  :num-checks              317
;  :propagations            2511
;  :quant-instantiations    870
;  :rlimit-count            300931)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 78 | !(0 <= First:(Second:($t@75@04))[i@77@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
      i@77@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 76 | !(i@77@04 < |First:(Second:($t@75@04))| && 0 <= i@77@04)]
(assert (not
  (and
    (<
      i@77@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))))
    (<= 0 i@77@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@77@04 Int)) (!
  (implies
    (and
      (<
        i@77@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))))
      (<= 0 i@77@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
          i@77@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
            i@77@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
            i@77@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
    i@77@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      726
;  :arith-assert-lower      1271
;  :arith-assert-upper      931
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        945
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            260
;  :binary-propagations     16
;  :conflicts               321
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6929
;  :mk-clause               3360
;  :num-allocs              5327977
;  :num-checks              318
;  :propagations            2513
;  :quant-instantiations    873
;  :rlimit-count            301428)
(assert (forall ((i@77@04 Int)) (!
  (implies
    (and
      (<
        i@77@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))))
      (<= 0 i@77@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
          i@77@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
            i@77@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
            i@77@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@04)))
    i@77@04))
  :qid |prog.l<no position>|)))
(declare-const $k@78@04 $Perm)
(assert ($Perm.isReadVar $k@78@04 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@78@04 $Perm.No) (< $Perm.No $k@78@04))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1273
;  :arith-assert-upper      932
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            260
;  :binary-propagations     16
;  :conflicts               322
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6934
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              319
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            301952)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@58@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1273
;  :arith-assert-upper      932
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            260
;  :binary-propagations     16
;  :conflicts               322
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6934
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              320
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            301963)
(assert (< $k@78@04 $k@58@04))
(assert (<= $Perm.No (- $k@58@04 $k@78@04)))
(assert (<= (- $k@58@04 $k@78@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@58@04 $k@78@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_alu != null
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               323
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              321
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302183)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               324
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              322
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302231)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               325
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              323
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302279)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               326
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              324
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302327)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               327
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              325
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302375)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               328
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              326
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302423)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               329
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              327
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302471)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               330
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              328
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302519)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               331
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              329
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302567)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               332
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              330
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302615)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               333
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              331
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302663)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               334
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              332
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302711)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               335
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              333
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302759)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      727
;  :arith-assert-lower      1275
;  :arith-assert-upper      933
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        946
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               336
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6937
;  :mk-clause               3362
;  :num-allocs              5327977
;  :num-checks              334
;  :propagations            2514
;  :quant-instantiations    873
;  :rlimit-count            302807)
(declare-const $k@79@04 $Perm)
(assert ($Perm.isReadVar $k@79@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@79@04 $Perm.No) (< $Perm.No $k@79@04))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      728
;  :arith-assert-lower      1277
;  :arith-assert-upper      934
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        947
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               337
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6941
;  :mk-clause               3364
;  :num-allocs              5327977
;  :num-checks              335
;  :propagations            2515
;  :quant-instantiations    873
;  :rlimit-count            303005)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@59@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      728
;  :arith-assert-lower      1277
;  :arith-assert-upper      934
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        947
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            262
;  :binary-propagations     16
;  :conflicts               337
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6941
;  :mk-clause               3364
;  :num-allocs              5327977
;  :num-checks              336
;  :propagations            2515
;  :quant-instantiations    873
;  :rlimit-count            303016)
(assert (< $k@79@04 $k@59@04))
(assert (<= $Perm.No (- $k@59@04 $k@79@04)))
(assert (<= (- $k@59@04 $k@79@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@59@04 $k@79@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_dr != null
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      728
;  :arith-assert-lower      1279
;  :arith-assert-upper      935
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        947
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            263
;  :binary-propagations     16
;  :conflicts               338
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6944
;  :mk-clause               3364
;  :num-allocs              5327977
;  :num-checks              337
;  :propagations            2515
;  :quant-instantiations    873
;  :rlimit-count            303230)
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      728
;  :arith-assert-lower      1279
;  :arith-assert-upper      935
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        947
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            263
;  :binary-propagations     16
;  :conflicts               339
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6944
;  :mk-clause               3364
;  :num-allocs              5327977
;  :num-checks              338
;  :propagations            2515
;  :quant-instantiations    873
;  :rlimit-count            303278)
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      728
;  :arith-assert-lower      1279
;  :arith-assert-upper      935
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        947
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            263
;  :binary-propagations     16
;  :conflicts               340
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6944
;  :mk-clause               3364
;  :num-allocs              5327977
;  :num-checks              339
;  :propagations            2515
;  :quant-instantiations    873
;  :rlimit-count            303326)
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      728
;  :arith-assert-lower      1279
;  :arith-assert-upper      935
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        947
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            263
;  :binary-propagations     16
;  :conflicts               341
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6944
;  :mk-clause               3364
;  :num-allocs              5327977
;  :num-checks              340
;  :propagations            2515
;  :quant-instantiations    873
;  :rlimit-count            303374)
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      728
;  :arith-assert-lower      1279
;  :arith-assert-upper      935
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        947
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            263
;  :binary-propagations     16
;  :conflicts               342
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6944
;  :mk-clause               3364
;  :num-allocs              5327977
;  :num-checks              341
;  :propagations            2515
;  :quant-instantiations    873
;  :rlimit-count            303422)
(declare-const $k@80@04 $Perm)
(assert ($Perm.isReadVar $k@80@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@80@04 $Perm.No) (< $Perm.No $k@80@04))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      729
;  :arith-assert-lower      1281
;  :arith-assert-upper      936
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        948
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            263
;  :binary-propagations     16
;  :conflicts               343
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6948
;  :mk-clause               3366
;  :num-allocs              5327977
;  :num-checks              342
;  :propagations            2516
;  :quant-instantiations    873
;  :rlimit-count            303620)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@60@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      729
;  :arith-assert-lower      1281
;  :arith-assert-upper      936
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        948
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            263
;  :binary-propagations     16
;  :conflicts               343
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6948
;  :mk-clause               3366
;  :num-allocs              5327977
;  :num-checks              343
;  :propagations            2516
;  :quant-instantiations    873
;  :rlimit-count            303631)
(assert (< $k@80@04 $k@60@04))
(assert (<= $Perm.No (- $k@60@04 $k@80@04)))
(assert (<= (- $k@60@04 $k@80@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@60@04 $k@80@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_mon != null
(push) ; 8
(assert (not (< $Perm.No $k@60@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      729
;  :arith-assert-lower      1283
;  :arith-assert-upper      937
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        948
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            265
;  :binary-propagations     16
;  :conflicts               344
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6951
;  :mk-clause               3366
;  :num-allocs              5327977
;  :num-checks              344
;  :propagations            2516
;  :quant-instantiations    873
;  :rlimit-count            303851)
(declare-const $k@81@04 $Perm)
(assert ($Perm.isReadVar $k@81@04 $Perm.Write))
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      730
;  :arith-assert-lower      1285
;  :arith-assert-upper      938
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        949
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            265
;  :binary-propagations     16
;  :conflicts               345
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6955
;  :mk-clause               3368
;  :num-allocs              5327977
;  :num-checks              345
;  :propagations            2517
;  :quant-instantiations    873
;  :rlimit-count            304048)
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@81@04 $Perm.No) (< $Perm.No $k@81@04))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      730
;  :arith-assert-lower      1285
;  :arith-assert-upper      938
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        949
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            265
;  :binary-propagations     16
;  :conflicts               346
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6955
;  :mk-clause               3368
;  :num-allocs              5327977
;  :num-checks              346
;  :propagations            2517
;  :quant-instantiations    873
;  :rlimit-count            304098)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@61@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      730
;  :arith-assert-lower      1285
;  :arith-assert-upper      938
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        949
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            265
;  :binary-propagations     16
;  :conflicts               346
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6955
;  :mk-clause               3368
;  :num-allocs              5327977
;  :num-checks              347
;  :propagations            2517
;  :quant-instantiations    873
;  :rlimit-count            304109)
(assert (< $k@81@04 $k@61@04))
(assert (<= $Perm.No (- $k@61@04 $k@81@04)))
(assert (<= (- $k@61@04 $k@81@04) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@61@04 $k@81@04))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))
      $Ref.null))))
; [eval] diz.Main_alu.ALU_m == diz
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      730
;  :arith-assert-lower      1287
;  :arith-assert-upper      939
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        949
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            265
;  :binary-propagations     16
;  :conflicts               347
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6958
;  :mk-clause               3368
;  :num-allocs              5327977
;  :num-checks              348
;  :propagations            2517
;  :quant-instantiations    873
;  :rlimit-count            304317)
(push) ; 8
(assert (not (< $Perm.No $k@61@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16178
;  :arith-add-rows          250
;  :arith-assert-diseq      730
;  :arith-assert-lower      1287
;  :arith-assert-upper      939
;  :arith-bound-prop        100
;  :arith-conflicts         4
;  :arith-eq-adapter        949
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        35
;  :arith-pivots            265
;  :binary-propagations     16
;  :conflicts               348
;  :datatype-accessor-ax    391
;  :datatype-constructor-ax 3864
;  :datatype-occurs-check   845
;  :datatype-splits         2175
;  :decisions               3980
;  :del-clause              3233
;  :final-checks            216
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             6958
;  :mk-clause               3368
;  :num-allocs              5327977
;  :num-checks              349
;  :propagations            2517
;  :quant-instantiations    873
;  :rlimit-count            304365)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@75@04))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@04))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))
                                  ($Snap.combine
                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))
                                    ($Snap.combine
                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))
                                      ($Snap.combine
                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))
                                        ($Snap.combine
                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))
                                          ($Snap.combine
                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))
                                            ($Snap.combine
                                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))
                                              ($Snap.combine
                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))
                                                ($Snap.combine
                                                  $Snap.unit
                                                  ($Snap.combine
                                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))
                                                    ($Snap.combine
                                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))
                                                      ($Snap.combine
                                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))
                                                        ($Snap.combine
                                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))
                                                          ($Snap.combine
                                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))
                                                            ($Snap.combine
                                                              $Snap.unit
                                                              ($Snap.combine
                                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))))
                                                                $Snap.unit)))))))))))))))))))))))))))))))) diz@35@04 globals@36@04))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 42 | min_advance__91@69@04 != -1]
(assert (not (= min_advance__91@69@04 (- 0 1))))
(pop) ; 7
; [eval] !(min_advance__91 == -1)
; [eval] min_advance__91 == -1
; [eval] -1
(push) ; 7
(assert (not (= min_advance__91@69@04 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16379
;  :arith-add-rows          251
;  :arith-assert-diseq      745
;  :arith-assert-lower      1299
;  :arith-assert-upper      955
;  :arith-bound-prop        104
;  :arith-conflicts         4
;  :arith-eq-adapter        961
;  :arith-fixed-eqs         394
;  :arith-offset-eqs        37
;  :arith-pivots            272
;  :binary-propagations     16
;  :conflicts               349
;  :datatype-accessor-ax    394
;  :datatype-constructor-ax 3919
;  :datatype-occurs-check   859
;  :datatype-splits         2207
;  :decisions               4038
;  :del-clause              3351
;  :final-checks            220
;  :interface-eqs           30
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7035
;  :mk-clause               3421
;  :num-allocs              5327977
;  :num-checks              350
;  :propagations            2548
;  :quant-instantiations    877
;  :rlimit-count            306290
;  :time                    0.00)
(push) ; 7
(assert (not (not (= min_advance__91@69@04 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16579
;  :arith-add-rows          251
;  :arith-assert-diseq      755
;  :arith-assert-lower      1311
;  :arith-assert-upper      969
;  :arith-bound-prop        107
;  :arith-conflicts         4
;  :arith-eq-adapter        972
;  :arith-fixed-eqs         397
;  :arith-offset-eqs        37
;  :arith-pivots            274
;  :binary-propagations     16
;  :conflicts               351
;  :datatype-accessor-ax    397
;  :datatype-constructor-ax 3974
;  :datatype-occurs-check   873
;  :datatype-splits         2239
;  :decisions               4096
;  :del-clause              3386
;  :final-checks            224
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7107
;  :mk-clause               3456
;  :num-allocs              5327977
;  :num-checks              351
;  :propagations            2580
;  :quant-instantiations    881
;  :rlimit-count            307972
;  :time                    0.00)
; [then-branch: 79 | min_advance__91@69@04 != -1 | live]
; [else-branch: 79 | min_advance__91@69@04 == -1 | live]
(push) ; 7
; [then-branch: 79 | min_advance__91@69@04 != -1]
(assert (not (= min_advance__91@69@04 (- 0 1))))
; [exec]
; __flatten_75__90 := Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__91), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__91))
; [eval] Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__91), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__91))
; [eval] (diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__91)
; [eval] diz.Main_event_state[0] < -1
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16580
;  :arith-add-rows          251
;  :arith-assert-diseq      757
;  :arith-assert-lower      1311
;  :arith-assert-upper      969
;  :arith-bound-prop        107
;  :arith-conflicts         4
;  :arith-eq-adapter        973
;  :arith-fixed-eqs         397
;  :arith-offset-eqs        37
;  :arith-pivots            274
;  :binary-propagations     16
;  :conflicts               351
;  :datatype-accessor-ax    397
;  :datatype-constructor-ax 3974
;  :datatype-occurs-check   873
;  :datatype-splits         2239
;  :decisions               4096
;  :del-clause              3386
;  :final-checks            224
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7111
;  :mk-clause               3460
;  :num-allocs              5327977
;  :num-checks              352
;  :propagations            2580
;  :quant-instantiations    881
;  :rlimit-count            308062)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16781
;  :arith-add-rows          251
;  :arith-assert-diseq      770
;  :arith-assert-lower      1322
;  :arith-assert-upper      985
;  :arith-bound-prop        111
;  :arith-conflicts         4
;  :arith-eq-adapter        984
;  :arith-fixed-eqs         398
;  :arith-offset-eqs        40
;  :arith-pivots            276
;  :binary-propagations     16
;  :conflicts               352
;  :datatype-accessor-ax    400
;  :datatype-constructor-ax 4029
;  :datatype-occurs-check   887
;  :datatype-splits         2271
;  :decisions               4153
;  :del-clause              3429
;  :final-checks            228
;  :interface-eqs           32
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7183
;  :mk-clause               3503
;  :num-allocs              5327977
;  :num-checks              353
;  :propagations            2609
;  :quant-instantiations    885
;  :rlimit-count            309792
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16978
;  :arith-add-rows          253
;  :arith-assert-diseq      780
;  :arith-assert-lower      1338
;  :arith-assert-upper      994
;  :arith-bound-prop        115
;  :arith-conflicts         4
;  :arith-eq-adapter        994
;  :arith-fixed-eqs         400
;  :arith-offset-eqs        41
;  :arith-pivots            280
;  :binary-propagations     16
;  :conflicts               353
;  :datatype-accessor-ax    403
;  :datatype-constructor-ax 4084
;  :datatype-occurs-check   901
;  :datatype-splits         2303
;  :decisions               4210
;  :del-clause              3469
;  :final-checks            232
;  :interface-eqs           33
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7250
;  :mk-clause               3543
;  :num-allocs              5327977
;  :num-checks              354
;  :propagations            2638
;  :quant-instantiations    889
;  :rlimit-count            311540
;  :time                    0.00)
; [then-branch: 80 | First:(Second:(Second:(Second:($t@67@04))))[0] < -1 | live]
; [else-branch: 80 | !(First:(Second:(Second:(Second:($t@67@04))))[0] < -1) | live]
(push) ; 9
; [then-branch: 80 | First:(Second:(Second:(Second:($t@67@04))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 80 | !(First:(Second:(Second:(Second:($t@67@04))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__91
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16978
;  :arith-add-rows          253
;  :arith-assert-diseq      780
;  :arith-assert-lower      1340
;  :arith-assert-upper      994
;  :arith-bound-prop        115
;  :arith-conflicts         4
;  :arith-eq-adapter        994
;  :arith-fixed-eqs         400
;  :arith-offset-eqs        41
;  :arith-pivots            280
;  :binary-propagations     16
;  :conflicts               353
;  :datatype-accessor-ax    403
;  :datatype-constructor-ax 4084
;  :datatype-occurs-check   901
;  :datatype-splits         2303
;  :decisions               4210
;  :del-clause              3469
;  :final-checks            232
;  :interface-eqs           33
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7250
;  :mk-clause               3543
;  :num-allocs              5327977
;  :num-checks              355
;  :propagations            2640
;  :quant-instantiations    889
;  :rlimit-count            311703)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__91)
; [eval] diz.Main_event_state[1] < -1
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16978
;  :arith-add-rows          253
;  :arith-assert-diseq      780
;  :arith-assert-lower      1340
;  :arith-assert-upper      994
;  :arith-bound-prop        115
;  :arith-conflicts         4
;  :arith-eq-adapter        994
;  :arith-fixed-eqs         400
;  :arith-offset-eqs        41
;  :arith-pivots            280
;  :binary-propagations     16
;  :conflicts               353
;  :datatype-accessor-ax    403
;  :datatype-constructor-ax 4084
;  :datatype-occurs-check   901
;  :datatype-splits         2303
;  :decisions               4210
;  :del-clause              3469
;  :final-checks            232
;  :interface-eqs           33
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7250
;  :mk-clause               3543
;  :num-allocs              5327977
;  :num-checks              356
;  :propagations            2640
;  :quant-instantiations    889
;  :rlimit-count            311718)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17179
;  :arith-add-rows          253
;  :arith-assert-diseq      793
;  :arith-assert-lower      1351
;  :arith-assert-upper      1010
;  :arith-bound-prop        119
;  :arith-conflicts         4
;  :arith-eq-adapter        1005
;  :arith-fixed-eqs         401
;  :arith-offset-eqs        44
;  :arith-pivots            283
;  :binary-propagations     16
;  :conflicts               354
;  :datatype-accessor-ax    406
;  :datatype-constructor-ax 4139
;  :datatype-occurs-check   915
;  :datatype-splits         2335
;  :decisions               4267
;  :del-clause              3512
;  :final-checks            236
;  :interface-eqs           34
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7322
;  :mk-clause               3586
;  :num-allocs              5327977
;  :num-checks              357
;  :propagations            2669
;  :quant-instantiations    893
;  :rlimit-count            313450
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17376
;  :arith-add-rows          255
;  :arith-assert-diseq      803
;  :arith-assert-lower      1368
;  :arith-assert-upper      1019
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1015
;  :arith-fixed-eqs         404
;  :arith-offset-eqs        44
;  :arith-pivots            287
;  :binary-propagations     16
;  :conflicts               355
;  :datatype-accessor-ax    409
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3552
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7390
;  :mk-clause               3626
;  :num-allocs              5327977
;  :num-checks              358
;  :propagations            2698
;  :quant-instantiations    897
;  :rlimit-count            315203
;  :time                    0.00)
; [then-branch: 81 | First:(Second:(Second:(Second:($t@67@04))))[1] < -1 | live]
; [else-branch: 81 | !(First:(Second:(Second:(Second:($t@67@04))))[1] < -1) | live]
(push) ; 9
; [then-branch: 81 | First:(Second:(Second:(Second:($t@67@04))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 81 | !(First:(Second:(Second:(Second:($t@67@04))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__91
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17376
;  :arith-add-rows          255
;  :arith-assert-diseq      803
;  :arith-assert-lower      1370
;  :arith-assert-upper      1019
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1015
;  :arith-fixed-eqs         404
;  :arith-offset-eqs        44
;  :arith-pivots            287
;  :binary-propagations     16
;  :conflicts               355
;  :datatype-accessor-ax    409
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3552
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7390
;  :mk-clause               3626
;  :num-allocs              5327977
;  :num-checks              359
;  :propagations            2700
;  :quant-instantiations    897
;  :rlimit-count            315366)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (=
  (Seq_length
    (Seq_append
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
            0)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
            0)
          min_advance__91@69@04)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
            1)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
            1)
          min_advance__91@69@04)))))
  2))
(declare-const __flatten_75__90@82@04 Seq<Int>)
(assert (Seq_equal
  __flatten_75__90@82@04
  (Seq_append
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
          0)
        (- 0 1))
      (- 0 3)
      (-
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
          0)
        min_advance__91@69@04)))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
          1)
        (- 0 1))
      (- 0 3)
      (-
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))
          1)
        min_advance__91@69@04))))))
; [exec]
; __flatten_74__89 := __flatten_75__90
; [exec]
; diz.Main_event_state := __flatten_74__89
; [exec]
; Main_wakeup_after_wait_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(push) ; 8
(assert (not (= (Seq_length __flatten_75__90@82@04) 2)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17386
;  :arith-add-rows          259
;  :arith-assert-diseq      803
;  :arith-assert-lower      1374
;  :arith-assert-upper      1022
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1020
;  :arith-fixed-eqs         406
;  :arith-offset-eqs        45
;  :arith-pivots            289
;  :binary-propagations     16
;  :conflicts               356
;  :datatype-accessor-ax    409
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3552
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7424
;  :mk-clause               3648
;  :num-allocs              5327977
;  :num-checks              360
;  :propagations            2705
;  :quant-instantiations    901
;  :rlimit-count            316151)
(assert (= (Seq_length __flatten_75__90@82@04) 2))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@83@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 82 | 0 <= i@83@04 | live]
; [else-branch: 82 | !(0 <= i@83@04) | live]
(push) ; 10
; [then-branch: 82 | 0 <= i@83@04]
(assert (<= 0 i@83@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 82 | !(0 <= i@83@04)]
(assert (not (<= 0 i@83@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 83 | i@83@04 < |First:(Second:($t@67@04))| && 0 <= i@83@04 | live]
; [else-branch: 83 | !(i@83@04 < |First:(Second:($t@67@04))| && 0 <= i@83@04) | live]
(push) ; 10
; [then-branch: 83 | i@83@04 < |First:(Second:($t@67@04))| && 0 <= i@83@04]
(assert (and
  (<
    i@83@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
  (<= 0 i@83@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@83@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17388
;  :arith-add-rows          259
;  :arith-assert-diseq      803
;  :arith-assert-lower      1376
;  :arith-assert-upper      1024
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1021
;  :arith-fixed-eqs         407
;  :arith-offset-eqs        45
;  :arith-pivots            289
;  :binary-propagations     16
;  :conflicts               356
;  :datatype-accessor-ax    409
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3552
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7429
;  :mk-clause               3648
;  :num-allocs              5327977
;  :num-checks              361
;  :propagations            2705
;  :quant-instantiations    901
;  :rlimit-count            316342)
; [eval] -1
(push) ; 11
; [then-branch: 84 | First:(Second:($t@67@04))[i@83@04] == -1 | live]
; [else-branch: 84 | First:(Second:($t@67@04))[i@83@04] != -1 | live]
(push) ; 12
; [then-branch: 84 | First:(Second:($t@67@04))[i@83@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@83@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 84 | First:(Second:($t@67@04))[i@83@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      i@83@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@83@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17390
;  :arith-add-rows          259
;  :arith-assert-diseq      804
;  :arith-assert-lower      1376
;  :arith-assert-upper      1024
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1021
;  :arith-fixed-eqs         407
;  :arith-offset-eqs        45
;  :arith-pivots            289
;  :binary-propagations     16
;  :conflicts               356
;  :datatype-accessor-ax    409
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3552
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7430
;  :mk-clause               3648
;  :num-allocs              5327977
;  :num-checks              362
;  :propagations            2705
;  :quant-instantiations    901
;  :rlimit-count            316490)
(push) ; 13
; [then-branch: 85 | 0 <= First:(Second:($t@67@04))[i@83@04] | live]
; [else-branch: 85 | !(0 <= First:(Second:($t@67@04))[i@83@04]) | live]
(push) ; 14
; [then-branch: 85 | 0 <= First:(Second:($t@67@04))[i@83@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@83@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@83@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17392
;  :arith-add-rows          260
;  :arith-assert-diseq      804
;  :arith-assert-lower      1378
;  :arith-assert-upper      1025
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1022
;  :arith-fixed-eqs         408
;  :arith-offset-eqs        45
;  :arith-pivots            290
;  :binary-propagations     16
;  :conflicts               356
;  :datatype-accessor-ax    409
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3552
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7434
;  :mk-clause               3648
;  :num-allocs              5327977
;  :num-checks              363
;  :propagations            2705
;  :quant-instantiations    901
;  :rlimit-count            316607)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 85 | !(0 <= First:(Second:($t@67@04))[i@83@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      i@83@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 83 | !(i@83@04 < |First:(Second:($t@67@04))| && 0 <= i@83@04)]
(assert (not
  (and
    (<
      i@83@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
    (<= 0 i@83@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@83@04 Int)) (!
  (implies
    (and
      (<
        i@83@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
      (<= 0 i@83@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          i@83@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@83@04)
          (Seq_length __flatten_75__90@82@04))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@83@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@83@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17392
;  :arith-add-rows          260
;  :arith-assert-diseq      805
;  :arith-assert-lower      1379
;  :arith-assert-upper      1026
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1023
;  :arith-fixed-eqs         409
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               357
;  :datatype-accessor-ax    409
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3570
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7446
;  :mk-clause               3666
;  :num-allocs              5327977
;  :num-checks              364
;  :propagations            2707
;  :quant-instantiations    904
;  :rlimit-count            317099)
(assert (forall ((i@83@04 Int)) (!
  (implies
    (and
      (<
        i@83@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
      (<= 0 i@83@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          i@83@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@83@04)
          (Seq_length __flatten_75__90@82@04))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@83@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@83@04))
  :qid |prog.l<no position>|)))
(declare-const $t@84@04 $Snap)
(assert (= $t@84@04 ($Snap.combine ($Snap.first $t@84@04) ($Snap.second $t@84@04))))
(assert (=
  ($Snap.second $t@84@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@84@04))
    ($Snap.second ($Snap.second $t@84@04)))))
(assert (=
  ($Snap.second ($Snap.second $t@84@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@84@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@84@04))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@84@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@85@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 86 | 0 <= i@85@04 | live]
; [else-branch: 86 | !(0 <= i@85@04) | live]
(push) ; 10
; [then-branch: 86 | 0 <= i@85@04]
(assert (<= 0 i@85@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 86 | !(0 <= i@85@04)]
(assert (not (<= 0 i@85@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 87 | i@85@04 < |First:(Second:($t@84@04))| && 0 <= i@85@04 | live]
; [else-branch: 87 | !(i@85@04 < |First:(Second:($t@84@04))| && 0 <= i@85@04) | live]
(push) ; 10
; [then-branch: 87 | i@85@04 < |First:(Second:($t@84@04))| && 0 <= i@85@04]
(assert (and
  (<
    i@85@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))
  (<= 0 i@85@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@85@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17430
;  :arith-add-rows          260
;  :arith-assert-diseq      805
;  :arith-assert-lower      1384
;  :arith-assert-upper      1029
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1025
;  :arith-fixed-eqs         410
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               357
;  :datatype-accessor-ax    415
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3570
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7468
;  :mk-clause               3666
;  :num-allocs              5327977
;  :num-checks              365
;  :propagations            2707
;  :quant-instantiations    909
;  :rlimit-count            318517)
; [eval] -1
(push) ; 11
; [then-branch: 88 | First:(Second:($t@84@04))[i@85@04] == -1 | live]
; [else-branch: 88 | First:(Second:($t@84@04))[i@85@04] != -1 | live]
(push) ; 12
; [then-branch: 88 | First:(Second:($t@84@04))[i@85@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
    i@85@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 88 | First:(Second:($t@84@04))[i@85@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
      i@85@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@85@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17430
;  :arith-add-rows          260
;  :arith-assert-diseq      805
;  :arith-assert-lower      1384
;  :arith-assert-upper      1029
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1025
;  :arith-fixed-eqs         410
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               357
;  :datatype-accessor-ax    415
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3570
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7469
;  :mk-clause               3666
;  :num-allocs              5327977
;  :num-checks              366
;  :propagations            2707
;  :quant-instantiations    909
;  :rlimit-count            318668)
(push) ; 13
; [then-branch: 89 | 0 <= First:(Second:($t@84@04))[i@85@04] | live]
; [else-branch: 89 | !(0 <= First:(Second:($t@84@04))[i@85@04]) | live]
(push) ; 14
; [then-branch: 89 | 0 <= First:(Second:($t@84@04))[i@85@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
    i@85@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@85@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17430
;  :arith-add-rows          260
;  :arith-assert-diseq      806
;  :arith-assert-lower      1387
;  :arith-assert-upper      1029
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1026
;  :arith-fixed-eqs         410
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               357
;  :datatype-accessor-ax    415
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3570
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7472
;  :mk-clause               3667
;  :num-allocs              5327977
;  :num-checks              367
;  :propagations            2707
;  :quant-instantiations    909
;  :rlimit-count            318772)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 89 | !(0 <= First:(Second:($t@84@04))[i@85@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
      i@85@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 87 | !(i@85@04 < |First:(Second:($t@84@04))| && 0 <= i@85@04)]
(assert (not
  (and
    (<
      i@85@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))
    (<= 0 i@85@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@85@04 Int)) (!
  (implies
    (and
      (<
        i@85@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))
      (<= 0 i@85@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
          i@85@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
            i@85@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
            i@85@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
    i@85@04))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
  __flatten_75__90@82@04))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))))
  $Snap.unit))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1) ==> diz.Main_process_state[0] == -1
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17450
;  :arith-add-rows          260
;  :arith-assert-diseq      806
;  :arith-assert-lower      1388
;  :arith-assert-upper      1030
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1028
;  :arith-fixed-eqs         411
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               357
;  :datatype-accessor-ax    417
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3571
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7495
;  :mk-clause               3683
;  :num-allocs              5327977
;  :num-checks              368
;  :propagations            2713
;  :quant-instantiations    911
;  :rlimit-count            319801)
(push) ; 8
; [then-branch: 90 | 0 <= First:(Second:($t@67@04))[0] | live]
; [else-branch: 90 | !(0 <= First:(Second:($t@67@04))[0]) | live]
(push) ; 9
; [then-branch: 90 | 0 <= First:(Second:($t@67@04))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17450
;  :arith-add-rows          260
;  :arith-assert-diseq      806
;  :arith-assert-lower      1388
;  :arith-assert-upper      1030
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1028
;  :arith-fixed-eqs         411
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               357
;  :datatype-accessor-ax    417
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3571
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7495
;  :mk-clause               3683
;  :num-allocs              5327977
;  :num-checks              369
;  :propagations            2713
;  :quant-instantiations    911
;  :rlimit-count            319901)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17450
;  :arith-add-rows          260
;  :arith-assert-diseq      806
;  :arith-assert-lower      1388
;  :arith-assert-upper      1030
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1028
;  :arith-fixed-eqs         411
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               357
;  :datatype-accessor-ax    417
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3571
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7495
;  :mk-clause               3683
;  :num-allocs              5327977
;  :num-checks              370
;  :propagations            2713
;  :quant-instantiations    911
;  :rlimit-count            319910)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (Seq_length __flatten_75__90@82@04))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17450
;  :arith-add-rows          260
;  :arith-assert-diseq      806
;  :arith-assert-lower      1388
;  :arith-assert-upper      1030
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1028
;  :arith-fixed-eqs         411
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               358
;  :datatype-accessor-ax    417
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3571
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7495
;  :mk-clause               3683
;  :num-allocs              5327977
;  :num-checks              371
;  :propagations            2713
;  :quant-instantiations    911
;  :rlimit-count            319998)
(push) ; 10
; [then-branch: 91 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 | live]
; [else-branch: 91 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] != 0 | live]
(push) ; 11
; [then-branch: 91 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_75__90@82@04
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 91 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_75__90@82@04
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 12
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17451
;  :arith-add-rows          261
;  :arith-assert-diseq      806
;  :arith-assert-lower      1388
;  :arith-assert-upper      1030
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1028
;  :arith-fixed-eqs         411
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               358
;  :datatype-accessor-ax    417
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3571
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7500
;  :mk-clause               3688
;  :num-allocs              5327977
;  :num-checks              372
;  :propagations            2713
;  :quant-instantiations    912
;  :rlimit-count            320213)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17451
;  :arith-add-rows          261
;  :arith-assert-diseq      806
;  :arith-assert-lower      1388
;  :arith-assert-upper      1030
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1028
;  :arith-fixed-eqs         411
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               358
;  :datatype-accessor-ax    417
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3571
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7500
;  :mk-clause               3688
;  :num-allocs              5327977
;  :num-checks              373
;  :propagations            2713
;  :quant-instantiations    912
;  :rlimit-count            320222)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (Seq_length __flatten_75__90@82@04))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17451
;  :arith-add-rows          261
;  :arith-assert-diseq      806
;  :arith-assert-lower      1388
;  :arith-assert-upper      1030
;  :arith-bound-prop        123
;  :arith-conflicts         4
;  :arith-eq-adapter        1028
;  :arith-fixed-eqs         411
;  :arith-offset-eqs        45
;  :arith-pivots            291
;  :binary-propagations     16
;  :conflicts               359
;  :datatype-accessor-ax    417
;  :datatype-constructor-ax 4194
;  :datatype-occurs-check   929
;  :datatype-splits         2367
;  :decisions               4324
;  :del-clause              3571
;  :final-checks            240
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          53
;  :mk-bool-var             7500
;  :mk-clause               3688
;  :num-allocs              5327977
;  :num-checks              374
;  :propagations            2713
;  :quant-instantiations    912
;  :rlimit-count            320310)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 90 | !(0 <= First:(Second:($t@67@04))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18047
;  :arith-add-rows          291
;  :arith-assert-diseq      854
;  :arith-assert-lower      1464
;  :arith-assert-upper      1072
;  :arith-bound-prop        136
;  :arith-conflicts         5
;  :arith-eq-adapter        1073
;  :arith-fixed-eqs         448
;  :arith-offset-eqs        59
;  :arith-pivots            302
;  :binary-propagations     16
;  :conflicts               373
;  :datatype-accessor-ax    425
;  :datatype-constructor-ax 4311
;  :datatype-occurs-check   959
;  :datatype-splits         2440
;  :decisions               4452
;  :del-clause              3771
;  :final-checks            246
;  :interface-eqs           36
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             7803
;  :mk-clause               3883
;  :num-allocs              5327977
;  :num-checks              375
;  :propagations            2840
;  :quant-instantiations    959
;  :rlimit-count            324877
;  :time                    0.01)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_75__90@82@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      0)
    (=
      (Seq_index
        __flatten_75__90@82@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18541
;  :arith-add-rows          314
;  :arith-assert-diseq      884
;  :arith-assert-lower      1506
;  :arith-assert-upper      1118
;  :arith-bound-prop        140
;  :arith-conflicts         5
;  :arith-eq-adapter        1108
;  :arith-fixed-eqs         461
;  :arith-offset-eqs        72
;  :arith-pivots            310
;  :binary-propagations     16
;  :conflicts               376
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 4422
;  :datatype-occurs-check   981
;  :datatype-splits         2509
;  :decisions               4571
;  :del-clause              3897
;  :final-checks            252
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8017
;  :mk-clause               4009
;  :num-allocs              5327977
;  :num-checks              376
;  :propagations            2925
;  :quant-instantiations    985
;  :rlimit-count            328682
;  :time                    0.00)
; [then-branch: 92 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0] | live]
; [else-branch: 92 | !(__flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0]) | live]
(push) ; 9
; [then-branch: 92 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_75__90@82@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      0)
    (=
      (Seq_index
        __flatten_75__90@82@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18541
;  :arith-add-rows          314
;  :arith-assert-diseq      884
;  :arith-assert-lower      1506
;  :arith-assert-upper      1118
;  :arith-bound-prop        140
;  :arith-conflicts         5
;  :arith-eq-adapter        1108
;  :arith-fixed-eqs         461
;  :arith-offset-eqs        72
;  :arith-pivots            310
;  :binary-propagations     16
;  :conflicts               376
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 4422
;  :datatype-occurs-check   981
;  :datatype-splits         2509
;  :decisions               4571
;  :del-clause              3897
;  :final-checks            252
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8019
;  :mk-clause               4010
;  :num-allocs              5327977
;  :num-checks              377
;  :propagations            2925
;  :quant-instantiations    985
;  :rlimit-count            328850)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 92 | !(__flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@84@04))))))))
  $Snap.unit))
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)) ==> diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] !(0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1))
; [eval] 0 <= old(diz.Main_process_state[0]) && (old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1)
; [eval] 0 <= old(diz.Main_process_state[0])
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18546
;  :arith-add-rows          314
;  :arith-assert-diseq      884
;  :arith-assert-lower      1506
;  :arith-assert-upper      1118
;  :arith-bound-prop        140
;  :arith-conflicts         5
;  :arith-eq-adapter        1108
;  :arith-fixed-eqs         461
;  :arith-offset-eqs        72
;  :arith-pivots            310
;  :binary-propagations     16
;  :conflicts               376
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 4422
;  :datatype-occurs-check   981
;  :datatype-splits         2509
;  :decisions               4571
;  :del-clause              3898
;  :final-checks            252
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8024
;  :mk-clause               4014
;  :num-allocs              5327977
;  :num-checks              378
;  :propagations            2925
;  :quant-instantiations    985
;  :rlimit-count            329232)
(push) ; 8
; [then-branch: 93 | 0 <= First:(Second:($t@67@04))[0] | live]
; [else-branch: 93 | !(0 <= First:(Second:($t@67@04))[0]) | live]
(push) ; 9
; [then-branch: 93 | 0 <= First:(Second:($t@67@04))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0 || old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == 0
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18546
;  :arith-add-rows          314
;  :arith-assert-diseq      884
;  :arith-assert-lower      1506
;  :arith-assert-upper      1118
;  :arith-bound-prop        140
;  :arith-conflicts         5
;  :arith-eq-adapter        1108
;  :arith-fixed-eqs         461
;  :arith-offset-eqs        72
;  :arith-pivots            310
;  :binary-propagations     16
;  :conflicts               376
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 4422
;  :datatype-occurs-check   981
;  :datatype-splits         2509
;  :decisions               4571
;  :del-clause              3898
;  :final-checks            252
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8024
;  :mk-clause               4014
;  :num-allocs              5327977
;  :num-checks              379
;  :propagations            2925
;  :quant-instantiations    985
;  :rlimit-count            329332)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18546
;  :arith-add-rows          314
;  :arith-assert-diseq      884
;  :arith-assert-lower      1506
;  :arith-assert-upper      1118
;  :arith-bound-prop        140
;  :arith-conflicts         5
;  :arith-eq-adapter        1108
;  :arith-fixed-eqs         461
;  :arith-offset-eqs        72
;  :arith-pivots            310
;  :binary-propagations     16
;  :conflicts               376
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 4422
;  :datatype-occurs-check   981
;  :datatype-splits         2509
;  :decisions               4571
;  :del-clause              3898
;  :final-checks            252
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8024
;  :mk-clause               4014
;  :num-allocs              5327977
;  :num-checks              380
;  :propagations            2925
;  :quant-instantiations    985
;  :rlimit-count            329341)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (Seq_length __flatten_75__90@82@04))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18546
;  :arith-add-rows          314
;  :arith-assert-diseq      884
;  :arith-assert-lower      1506
;  :arith-assert-upper      1118
;  :arith-bound-prop        140
;  :arith-conflicts         5
;  :arith-eq-adapter        1108
;  :arith-fixed-eqs         461
;  :arith-offset-eqs        72
;  :arith-pivots            310
;  :binary-propagations     16
;  :conflicts               377
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 4422
;  :datatype-occurs-check   981
;  :datatype-splits         2509
;  :decisions               4571
;  :del-clause              3898
;  :final-checks            252
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8024
;  :mk-clause               4014
;  :num-allocs              5327977
;  :num-checks              381
;  :propagations            2925
;  :quant-instantiations    985
;  :rlimit-count            329429)
(push) ; 10
; [then-branch: 94 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 | live]
; [else-branch: 94 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] != 0 | live]
(push) ; 11
; [then-branch: 94 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_75__90@82@04
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 94 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_75__90@82@04
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0))
    0)))
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])]) == -1
; [eval] old(diz.Main_event_state[old(diz.Main_process_state[0])])
; [eval] diz.Main_event_state[old(diz.Main_process_state[0])]
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 12
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18547
;  :arith-add-rows          315
;  :arith-assert-diseq      884
;  :arith-assert-lower      1506
;  :arith-assert-upper      1118
;  :arith-bound-prop        140
;  :arith-conflicts         5
;  :arith-eq-adapter        1108
;  :arith-fixed-eqs         461
;  :arith-offset-eqs        72
;  :arith-pivots            310
;  :binary-propagations     16
;  :conflicts               377
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 4422
;  :datatype-occurs-check   981
;  :datatype-splits         2509
;  :decisions               4571
;  :del-clause              3898
;  :final-checks            252
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8028
;  :mk-clause               4019
;  :num-allocs              5327977
;  :num-checks              382
;  :propagations            2925
;  :quant-instantiations    986
;  :rlimit-count            329582)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18547
;  :arith-add-rows          315
;  :arith-assert-diseq      884
;  :arith-assert-lower      1506
;  :arith-assert-upper      1118
;  :arith-bound-prop        140
;  :arith-conflicts         5
;  :arith-eq-adapter        1108
;  :arith-fixed-eqs         461
;  :arith-offset-eqs        72
;  :arith-pivots            310
;  :binary-propagations     16
;  :conflicts               377
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 4422
;  :datatype-occurs-check   981
;  :datatype-splits         2509
;  :decisions               4571
;  :del-clause              3898
;  :final-checks            252
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8028
;  :mk-clause               4019
;  :num-allocs              5327977
;  :num-checks              383
;  :propagations            2925
;  :quant-instantiations    986
;  :rlimit-count            329591)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (Seq_length __flatten_75__90@82@04))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18547
;  :arith-add-rows          315
;  :arith-assert-diseq      884
;  :arith-assert-lower      1506
;  :arith-assert-upper      1118
;  :arith-bound-prop        140
;  :arith-conflicts         5
;  :arith-eq-adapter        1108
;  :arith-fixed-eqs         461
;  :arith-offset-eqs        72
;  :arith-pivots            310
;  :binary-propagations     16
;  :conflicts               378
;  :datatype-accessor-ax    431
;  :datatype-constructor-ax 4422
;  :datatype-occurs-check   981
;  :datatype-splits         2509
;  :decisions               4571
;  :del-clause              3898
;  :final-checks            252
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8028
;  :mk-clause               4019
;  :num-allocs              5327977
;  :num-checks              384
;  :propagations            2925
;  :quant-instantiations    986
;  :rlimit-count            329679)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 93 | !(0 <= First:(Second:($t@67@04))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_75__90@82@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      0)
    (=
      (Seq_index
        __flatten_75__90@82@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19035
;  :arith-add-rows          318
;  :arith-assert-diseq      914
;  :arith-assert-lower      1546
;  :arith-assert-upper      1164
;  :arith-bound-prop        144
;  :arith-conflicts         5
;  :arith-eq-adapter        1143
;  :arith-fixed-eqs         470
;  :arith-offset-eqs        87
;  :arith-pivots            312
;  :binary-propagations     16
;  :conflicts               381
;  :datatype-accessor-ax    437
;  :datatype-constructor-ax 4532
;  :datatype-occurs-check   1003
;  :datatype-splits         2576
;  :decisions               4689
;  :del-clause              4022
;  :final-checks            258
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          89
;  :mk-bool-var             8233
;  :mk-clause               4138
;  :num-allocs              5327977
;  :num-checks              385
;  :propagations            3008
;  :quant-instantiations    1012
;  :rlimit-count            333159
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19737
;  :arith-add-rows          334
;  :arith-assert-diseq      960
;  :arith-assert-lower      1615
;  :arith-assert-upper      1203
;  :arith-bound-prop        155
;  :arith-conflicts         6
;  :arith-eq-adapter        1185
;  :arith-fixed-eqs         501
;  :arith-offset-eqs        99
;  :arith-pivots            319
;  :binary-propagations     16
;  :conflicts               399
;  :datatype-accessor-ax    449
;  :datatype-constructor-ax 4681
;  :datatype-occurs-check   1039
;  :datatype-splits         2653
;  :decisions               4846
;  :del-clause              4206
;  :final-checks            265
;  :interface-eqs           41
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          116
;  :mk-bool-var             8535
;  :mk-clause               4322
;  :num-allocs              5327977
;  :num-checks              386
;  :propagations            3133
;  :quant-instantiations    1057
;  :rlimit-count            337860
;  :time                    0.00)
; [then-branch: 95 | !(__flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0]) | live]
; [else-branch: 95 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0] | live]
(push) ; 9
; [then-branch: 95 | !(__flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        0)
      (=
        (Seq_index
          __flatten_75__90@82@04
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19738
;  :arith-add-rows          335
;  :arith-assert-diseq      960
;  :arith-assert-lower      1615
;  :arith-assert-upper      1203
;  :arith-bound-prop        155
;  :arith-conflicts         6
;  :arith-eq-adapter        1185
;  :arith-fixed-eqs         501
;  :arith-offset-eqs        99
;  :arith-pivots            319
;  :binary-propagations     16
;  :conflicts               399
;  :datatype-accessor-ax    449
;  :datatype-constructor-ax 4681
;  :datatype-occurs-check   1039
;  :datatype-splits         2653
;  :decisions               4846
;  :del-clause              4206
;  :final-checks            265
;  :interface-eqs           41
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          116
;  :mk-bool-var             8539
;  :mk-clause               4327
;  :num-allocs              5327977
;  :num-checks              387
;  :propagations            3135
;  :quant-instantiations    1058
;  :rlimit-count            338043)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19738
;  :arith-add-rows          335
;  :arith-assert-diseq      960
;  :arith-assert-lower      1615
;  :arith-assert-upper      1203
;  :arith-bound-prop        155
;  :arith-conflicts         6
;  :arith-eq-adapter        1185
;  :arith-fixed-eqs         501
;  :arith-offset-eqs        99
;  :arith-pivots            319
;  :binary-propagations     16
;  :conflicts               399
;  :datatype-accessor-ax    449
;  :datatype-constructor-ax 4681
;  :datatype-occurs-check   1039
;  :datatype-splits         2653
;  :decisions               4846
;  :del-clause              4206
;  :final-checks            265
;  :interface-eqs           41
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          116
;  :mk-bool-var             8539
;  :mk-clause               4327
;  :num-allocs              5327977
;  :num-checks              388
;  :propagations            3135
;  :quant-instantiations    1058
;  :rlimit-count            338058)
(pop) ; 9
(push) ; 9
; [else-branch: 95 | __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == 0 || __flatten_75__90@82@04[First:(Second:($t@67@04))[0]] == -1 && 0 <= First:(Second:($t@67@04))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_75__90@82@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      0)
    (=
      (Seq_index
        __flatten_75__90@82@04
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (and
      (or
        (=
          (Seq_index
            __flatten_75__90@82@04
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
              0))
          0)
        (=
          (Seq_index
            __flatten_75__90@82@04
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; Main_reset_all_events_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@86@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 96 | 0 <= i@86@04 | live]
; [else-branch: 96 | !(0 <= i@86@04) | live]
(push) ; 10
; [then-branch: 96 | 0 <= i@86@04]
(assert (<= 0 i@86@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 96 | !(0 <= i@86@04)]
(assert (not (<= 0 i@86@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 97 | i@86@04 < |First:(Second:($t@84@04))| && 0 <= i@86@04 | live]
; [else-branch: 97 | !(i@86@04 < |First:(Second:($t@84@04))| && 0 <= i@86@04) | live]
(push) ; 10
; [then-branch: 97 | i@86@04 < |First:(Second:($t@84@04))| && 0 <= i@86@04]
(assert (and
  (<
    i@86@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))
  (<= 0 i@86@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@86@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20228
;  :arith-add-rows          351
;  :arith-assert-diseq      991
;  :arith-assert-lower      1662
;  :arith-assert-upper      1252
;  :arith-bound-prop        160
;  :arith-conflicts         6
;  :arith-eq-adapter        1222
;  :arith-fixed-eqs         514
;  :arith-offset-eqs        112
;  :arith-pivots            328
;  :binary-propagations     16
;  :conflicts               402
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 4791
;  :datatype-occurs-check   1061
;  :datatype-splits         2720
;  :decisions               4966
;  :del-clause              4358
;  :final-checks            271
;  :interface-eqs           43
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          116
;  :mk-bool-var             8757
;  :mk-clause               4467
;  :num-allocs              5327977
;  :num-checks              390
;  :propagations            3225
;  :quant-instantiations    1086
;  :rlimit-count            341990)
; [eval] -1
(push) ; 11
; [then-branch: 98 | First:(Second:($t@84@04))[i@86@04] == -1 | live]
; [else-branch: 98 | First:(Second:($t@84@04))[i@86@04] != -1 | live]
(push) ; 12
; [then-branch: 98 | First:(Second:($t@84@04))[i@86@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
    i@86@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 98 | First:(Second:($t@84@04))[i@86@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
      i@86@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@86@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20235
;  :arith-add-rows          353
;  :arith-assert-diseq      993
;  :arith-assert-lower      1666
;  :arith-assert-upper      1254
;  :arith-bound-prop        160
;  :arith-conflicts         6
;  :arith-eq-adapter        1224
;  :arith-fixed-eqs         515
;  :arith-offset-eqs        112
;  :arith-pivots            329
;  :binary-propagations     16
;  :conflicts               402
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 4791
;  :datatype-occurs-check   1061
;  :datatype-splits         2720
;  :decisions               4966
;  :del-clause              4358
;  :final-checks            271
;  :interface-eqs           43
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          116
;  :mk-bool-var             8770
;  :mk-clause               4476
;  :num-allocs              5327977
;  :num-checks              391
;  :propagations            3232
;  :quant-instantiations    1088
;  :rlimit-count            342227)
(push) ; 13
; [then-branch: 99 | 0 <= First:(Second:($t@84@04))[i@86@04] | live]
; [else-branch: 99 | !(0 <= First:(Second:($t@84@04))[i@86@04]) | live]
(push) ; 14
; [then-branch: 99 | 0 <= First:(Second:($t@84@04))[i@86@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
    i@86@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@86@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20237
;  :arith-add-rows          354
;  :arith-assert-diseq      993
;  :arith-assert-lower      1668
;  :arith-assert-upper      1255
;  :arith-bound-prop        160
;  :arith-conflicts         6
;  :arith-eq-adapter        1225
;  :arith-fixed-eqs         516
;  :arith-offset-eqs        112
;  :arith-pivots            329
;  :binary-propagations     16
;  :conflicts               402
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 4791
;  :datatype-occurs-check   1061
;  :datatype-splits         2720
;  :decisions               4966
;  :del-clause              4358
;  :final-checks            271
;  :interface-eqs           43
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          116
;  :mk-bool-var             8774
;  :mk-clause               4476
;  :num-allocs              5327977
;  :num-checks              392
;  :propagations            3232
;  :quant-instantiations    1088
;  :rlimit-count            342339)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 99 | !(0 <= First:(Second:($t@84@04))[i@86@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
      i@86@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 97 | !(i@86@04 < |First:(Second:($t@84@04))| && 0 <= i@86@04)]
(assert (not
  (and
    (<
      i@86@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))
    (<= 0 i@86@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@86@04 Int)) (!
  (implies
    (and
      (<
        i@86@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))
      (<= 0 i@86@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
          i@86@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
            i@86@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
            i@86@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
    i@86@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20237
;  :arith-add-rows          354
;  :arith-assert-diseq      995
;  :arith-assert-lower      1669
;  :arith-assert-upper      1256
;  :arith-bound-prop        160
;  :arith-conflicts         6
;  :arith-eq-adapter        1226
;  :arith-fixed-eqs         517
;  :arith-offset-eqs        112
;  :arith-pivots            330
;  :binary-propagations     16
;  :conflicts               403
;  :datatype-accessor-ax    455
;  :datatype-constructor-ax 4791
;  :datatype-occurs-check   1061
;  :datatype-splits         2720
;  :decisions               4966
;  :del-clause              4381
;  :final-checks            271
;  :interface-eqs           43
;  :max-generation          3
;  :max-memory              4.86
;  :memory                  4.86
;  :minimized-lits          116
;  :mk-bool-var             8782
;  :mk-clause               4490
;  :num-allocs              5327977
;  :num-checks              393
;  :propagations            3234
;  :quant-instantiations    1089
;  :rlimit-count            342766)
(assert (forall ((i@86@04 Int)) (!
  (implies
    (and
      (<
        i@86@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))
      (<= 0 i@86@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
          i@86@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
            i@86@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
            i@86@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))
    i@86@04))
  :qid |prog.l<no position>|)))
(declare-const $t@87@04 $Snap)
(assert (= $t@87@04 ($Snap.combine ($Snap.first $t@87@04) ($Snap.second $t@87@04))))
(assert (=
  ($Snap.second $t@87@04)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@87@04))
    ($Snap.second ($Snap.second $t@87@04)))))
(assert (=
  ($Snap.second ($Snap.second $t@87@04))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@87@04)))
    ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@87@04))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@87@04)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@88@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 100 | 0 <= i@88@04 | live]
; [else-branch: 100 | !(0 <= i@88@04) | live]
(push) ; 10
; [then-branch: 100 | 0 <= i@88@04]
(assert (<= 0 i@88@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 100 | !(0 <= i@88@04)]
(assert (not (<= 0 i@88@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 101 | i@88@04 < |First:(Second:($t@87@04))| && 0 <= i@88@04 | live]
; [else-branch: 101 | !(i@88@04 < |First:(Second:($t@87@04))| && 0 <= i@88@04) | live]
(push) ; 10
; [then-branch: 101 | i@88@04 < |First:(Second:($t@87@04))| && 0 <= i@88@04]
(assert (and
  (<
    i@88@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))))
  (<= 0 i@88@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@88@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20275
;  :arith-add-rows          354
;  :arith-assert-diseq      995
;  :arith-assert-lower      1674
;  :arith-assert-upper      1259
;  :arith-bound-prop        160
;  :arith-conflicts         6
;  :arith-eq-adapter        1228
;  :arith-fixed-eqs         518
;  :arith-offset-eqs        112
;  :arith-pivots            330
;  :binary-propagations     16
;  :conflicts               403
;  :datatype-accessor-ax    461
;  :datatype-constructor-ax 4791
;  :datatype-occurs-check   1061
;  :datatype-splits         2720
;  :decisions               4966
;  :del-clause              4381
;  :final-checks            271
;  :interface-eqs           43
;  :max-generation          3
;  :max-memory              4.96
;  :memory                  4.96
;  :minimized-lits          116
;  :mk-bool-var             8804
;  :mk-clause               4490
;  :num-allocs              5580736
;  :num-checks              394
;  :propagations            3234
;  :quant-instantiations    1093
;  :rlimit-count            344159)
; [eval] -1
(push) ; 11
; [then-branch: 102 | First:(Second:($t@87@04))[i@88@04] == -1 | live]
; [else-branch: 102 | First:(Second:($t@87@04))[i@88@04] != -1 | live]
(push) ; 12
; [then-branch: 102 | First:(Second:($t@87@04))[i@88@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
    i@88@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 102 | First:(Second:($t@87@04))[i@88@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
      i@88@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@88@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20275
;  :arith-add-rows          354
;  :arith-assert-diseq      995
;  :arith-assert-lower      1674
;  :arith-assert-upper      1259
;  :arith-bound-prop        160
;  :arith-conflicts         6
;  :arith-eq-adapter        1228
;  :arith-fixed-eqs         518
;  :arith-offset-eqs        112
;  :arith-pivots            330
;  :binary-propagations     16
;  :conflicts               403
;  :datatype-accessor-ax    461
;  :datatype-constructor-ax 4791
;  :datatype-occurs-check   1061
;  :datatype-splits         2720
;  :decisions               4966
;  :del-clause              4381
;  :final-checks            271
;  :interface-eqs           43
;  :max-generation          3
;  :max-memory              4.96
;  :memory                  4.96
;  :minimized-lits          116
;  :mk-bool-var             8805
;  :mk-clause               4490
;  :num-allocs              5580736
;  :num-checks              395
;  :propagations            3234
;  :quant-instantiations    1093
;  :rlimit-count            344310)
(push) ; 13
; [then-branch: 103 | 0 <= First:(Second:($t@87@04))[i@88@04] | live]
; [else-branch: 103 | !(0 <= First:(Second:($t@87@04))[i@88@04]) | live]
(push) ; 14
; [then-branch: 103 | 0 <= First:(Second:($t@87@04))[i@88@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
    i@88@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@88@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20275
;  :arith-add-rows          354
;  :arith-assert-diseq      996
;  :arith-assert-lower      1677
;  :arith-assert-upper      1259
;  :arith-bound-prop        160
;  :arith-conflicts         6
;  :arith-eq-adapter        1229
;  :arith-fixed-eqs         518
;  :arith-offset-eqs        112
;  :arith-pivots            330
;  :binary-propagations     16
;  :conflicts               403
;  :datatype-accessor-ax    461
;  :datatype-constructor-ax 4791
;  :datatype-occurs-check   1061
;  :datatype-splits         2720
;  :decisions               4966
;  :del-clause              4381
;  :final-checks            271
;  :interface-eqs           43
;  :max-generation          3
;  :max-memory              4.96
;  :memory                  4.96
;  :minimized-lits          116
;  :mk-bool-var             8808
;  :mk-clause               4491
;  :num-allocs              5580736
;  :num-checks              396
;  :propagations            3234
;  :quant-instantiations    1093
;  :rlimit-count            344414)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 103 | !(0 <= First:(Second:($t@87@04))[i@88@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
      i@88@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 101 | !(i@88@04 < |First:(Second:($t@87@04))| && 0 <= i@88@04)]
(assert (not
  (and
    (<
      i@88@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))))
    (<= 0 i@88@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@88@04 Int)) (!
  (implies
    (and
      (<
        i@88@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))))
      (<= 0 i@88@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
          i@88@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
            i@88@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
            i@88@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
    i@88@04))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@84@04)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20292
;  :arith-add-rows          354
;  :arith-assert-diseq      996
;  :arith-assert-lower      1678
;  :arith-assert-upper      1260
;  :arith-bound-prop        160
;  :arith-conflicts         6
;  :arith-eq-adapter        1230
;  :arith-fixed-eqs         519
;  :arith-offset-eqs        112
;  :arith-pivots            330
;  :binary-propagations     16
;  :conflicts               403
;  :datatype-accessor-ax    463
;  :datatype-constructor-ax 4791
;  :datatype-occurs-check   1061
;  :datatype-splits         2720
;  :decisions               4966
;  :del-clause              4382
;  :final-checks            271
;  :interface-eqs           43
;  :max-generation          3
;  :max-memory              4.96
;  :memory                  4.96
;  :minimized-lits          116
;  :mk-bool-var             8827
;  :mk-clause               4501
;  :num-allocs              5580736
;  :num-checks              397
;  :propagations            3238
;  :quant-instantiations    1095
;  :rlimit-count            345427)
(push) ; 8
; [then-branch: 104 | First:(Second:(Second:(Second:($t@84@04))))[0] == 0 | live]
; [else-branch: 104 | First:(Second:(Second:(Second:($t@84@04))))[0] != 0 | live]
(push) ; 9
; [then-branch: 104 | First:(Second:(Second:(Second:($t@84@04))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 104 | First:(Second:(Second:(Second:($t@84@04))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20293
;  :arith-add-rows          354
;  :arith-assert-diseq      996
;  :arith-assert-lower      1678
;  :arith-assert-upper      1260
;  :arith-bound-prop        160
;  :arith-conflicts         6
;  :arith-eq-adapter        1230
;  :arith-fixed-eqs         519
;  :arith-offset-eqs        112
;  :arith-pivots            330
;  :binary-propagations     16
;  :conflicts               403
;  :datatype-accessor-ax    463
;  :datatype-constructor-ax 4791
;  :datatype-occurs-check   1061
;  :datatype-splits         2720
;  :decisions               4966
;  :del-clause              4382
;  :final-checks            271
;  :interface-eqs           43
;  :max-generation          3
;  :max-memory              4.96
;  :memory                  4.96
;  :minimized-lits          116
;  :mk-bool-var             8832
;  :mk-clause               4506
;  :num-allocs              5580736
;  :num-checks              398
;  :propagations            3238
;  :quant-instantiations    1096
;  :rlimit-count            345645)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               21139
;  :arith-add-rows          397
;  :arith-assert-diseq      1054
;  :arith-assert-lower      1798
;  :arith-assert-upper      1302
;  :arith-bound-prop        172
;  :arith-conflicts         9
;  :arith-eq-adapter        1299
;  :arith-fixed-eqs         567
;  :arith-offset-eqs        135
;  :arith-pivots            348
;  :binary-propagations     16
;  :conflicts               421
;  :datatype-accessor-ax    476
;  :datatype-constructor-ax 4945
;  :datatype-occurs-check   1100
;  :datatype-splits         2803
;  :decisions               5145
;  :del-clause              4625
;  :final-checks            279
;  :interface-eqs           45
;  :max-generation          3
;  :max-memory              4.96
;  :memory                  4.96
;  :minimized-lits          130
;  :mk-bool-var             9203
;  :mk-clause               4744
;  :num-allocs              5580736
;  :num-checks              399
;  :propagations            3432
;  :quant-instantiations    1156
;  :rlimit-count            351903
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22029
;  :arith-add-rows          433
;  :arith-assert-diseq      1112
;  :arith-assert-lower      1917
;  :arith-assert-upper      1349
;  :arith-bound-prop        178
;  :arith-conflicts         12
;  :arith-eq-adapter        1365
;  :arith-fixed-eqs         591
;  :arith-offset-eqs        150
;  :arith-pivots            377
;  :binary-propagations     16
;  :conflicts               429
;  :datatype-accessor-ax    491
;  :datatype-constructor-ax 5143
;  :datatype-occurs-check   1159
;  :datatype-splits         2962
;  :decisions               5363
;  :del-clause              4857
;  :final-checks            292
;  :interface-eqs           49
;  :max-generation          3
;  :max-memory              5.06
;  :memory                  5.06
;  :minimized-lits          131
;  :mk-bool-var             9618
;  :mk-clause               4976
;  :num-allocs              5839066
;  :num-checks              400
;  :propagations            3582
;  :quant-instantiations    1201
;  :rlimit-count            358061
;  :time                    0.00)
; [then-branch: 105 | First:(Second:(Second:(Second:($t@84@04))))[0] == 0 || First:(Second:(Second:(Second:($t@84@04))))[0] == -1 | live]
; [else-branch: 105 | !(First:(Second:(Second:(Second:($t@84@04))))[0] == 0 || First:(Second:(Second:(Second:($t@84@04))))[0] == -1) | live]
(push) ; 9
; [then-branch: 105 | First:(Second:(Second:(Second:($t@84@04))))[0] == 0 || First:(Second:(Second:(Second:($t@84@04))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22029
;  :arith-add-rows          433
;  :arith-assert-diseq      1112
;  :arith-assert-lower      1917
;  :arith-assert-upper      1349
;  :arith-bound-prop        178
;  :arith-conflicts         12
;  :arith-eq-adapter        1365
;  :arith-fixed-eqs         591
;  :arith-offset-eqs        150
;  :arith-pivots            377
;  :binary-propagations     16
;  :conflicts               429
;  :datatype-accessor-ax    491
;  :datatype-constructor-ax 5143
;  :datatype-occurs-check   1159
;  :datatype-splits         2962
;  :decisions               5363
;  :del-clause              4857
;  :final-checks            292
;  :interface-eqs           49
;  :max-generation          3
;  :max-memory              5.06
;  :memory                  5.06
;  :minimized-lits          131
;  :mk-bool-var             9620
;  :mk-clause               4977
;  :num-allocs              5839066
;  :num-checks              401
;  :propagations            3582
;  :quant-instantiations    1201
;  :rlimit-count            358210)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 105 | !(First:(Second:(Second:(Second:($t@84@04))))[0] == 0 || First:(Second:(Second:(Second:($t@84@04))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22035
;  :arith-add-rows          433
;  :arith-assert-diseq      1112
;  :arith-assert-lower      1917
;  :arith-assert-upper      1349
;  :arith-bound-prop        178
;  :arith-conflicts         12
;  :arith-eq-adapter        1365
;  :arith-fixed-eqs         591
;  :arith-offset-eqs        150
;  :arith-pivots            377
;  :binary-propagations     16
;  :conflicts               429
;  :datatype-accessor-ax    492
;  :datatype-constructor-ax 5143
;  :datatype-occurs-check   1159
;  :datatype-splits         2962
;  :decisions               5363
;  :del-clause              4858
;  :final-checks            292
;  :interface-eqs           49
;  :max-generation          3
;  :max-memory              5.06
;  :memory                  5.06
;  :minimized-lits          131
;  :mk-bool-var             9626
;  :mk-clause               4981
;  :num-allocs              5839066
;  :num-checks              402
;  :propagations            3582
;  :quant-instantiations    1201
;  :rlimit-count            358693)
(push) ; 8
; [then-branch: 106 | First:(Second:(Second:(Second:($t@84@04))))[1] == 0 | live]
; [else-branch: 106 | First:(Second:(Second:(Second:($t@84@04))))[1] != 0 | live]
(push) ; 9
; [then-branch: 106 | First:(Second:(Second:(Second:($t@84@04))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 106 | First:(Second:(Second:(Second:($t@84@04))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22036
;  :arith-add-rows          434
;  :arith-assert-diseq      1112
;  :arith-assert-lower      1917
;  :arith-assert-upper      1349
;  :arith-bound-prop        178
;  :arith-conflicts         12
;  :arith-eq-adapter        1365
;  :arith-fixed-eqs         591
;  :arith-offset-eqs        150
;  :arith-pivots            377
;  :binary-propagations     16
;  :conflicts               429
;  :datatype-accessor-ax    492
;  :datatype-constructor-ax 5143
;  :datatype-occurs-check   1159
;  :datatype-splits         2962
;  :decisions               5363
;  :del-clause              4858
;  :final-checks            292
;  :interface-eqs           49
;  :max-generation          3
;  :max-memory              5.06
;  :memory                  5.06
;  :minimized-lits          131
;  :mk-bool-var             9631
;  :mk-clause               4986
;  :num-allocs              5839066
;  :num-checks              403
;  :propagations            3582
;  :quant-instantiations    1202
;  :rlimit-count            358912)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               22584
;  :arith-add-rows          449
;  :arith-assert-diseq      1157
;  :arith-assert-lower      1999
;  :arith-assert-upper      1378
;  :arith-bound-prop        182
;  :arith-conflicts         14
;  :arith-eq-adapter        1410
;  :arith-fixed-eqs         607
;  :arith-offset-eqs        156
;  :arith-pivots            391
;  :binary-propagations     16
;  :conflicts               435
;  :datatype-accessor-ax    501
;  :datatype-constructor-ax 5263
;  :datatype-occurs-check   1192
;  :datatype-splits         3039
;  :decisions               5505
;  :del-clause              5016
;  :final-checks            299
;  :interface-eqs           51
;  :max-generation          3
;  :max-memory              5.06
;  :memory                  4.96
;  :minimized-lits          131
;  :mk-bool-var             9878
;  :mk-clause               5139
;  :num-allocs              6099008
;  :num-checks              404
;  :propagations            3693
;  :quant-instantiations    1236
;  :rlimit-count            363040
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               23415
;  :arith-add-rows          480
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2132
;  :arith-assert-upper      1422
;  :arith-bound-prop        198
;  :arith-conflicts         16
;  :arith-eq-adapter        1488
;  :arith-fixed-eqs         648
;  :arith-offset-eqs        172
;  :arith-pivots            416
;  :binary-propagations     16
;  :conflicts               450
;  :datatype-accessor-ax    516
;  :datatype-constructor-ax 5429
;  :datatype-occurs-check   1248
;  :datatype-splits         3163
;  :decisions               5684
;  :del-clause              5274
;  :final-checks            310
;  :interface-eqs           54
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          138
;  :mk-bool-var             10304
;  :mk-clause               5397
;  :num-allocs              6362201
;  :num-checks              405
;  :propagations            3869
;  :quant-instantiations    1293
;  :rlimit-count            368815
;  :time                    0.00)
; [then-branch: 107 | First:(Second:(Second:(Second:($t@84@04))))[1] == 0 || First:(Second:(Second:(Second:($t@84@04))))[1] == -1 | live]
; [else-branch: 107 | !(First:(Second:(Second:(Second:($t@84@04))))[1] == 0 || First:(Second:(Second:(Second:($t@84@04))))[1] == -1) | live]
(push) ; 9
; [then-branch: 107 | First:(Second:(Second:(Second:($t@84@04))))[1] == 0 || First:(Second:(Second:(Second:($t@84@04))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               23415
;  :arith-add-rows          480
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2132
;  :arith-assert-upper      1422
;  :arith-bound-prop        198
;  :arith-conflicts         16
;  :arith-eq-adapter        1488
;  :arith-fixed-eqs         648
;  :arith-offset-eqs        172
;  :arith-pivots            416
;  :binary-propagations     16
;  :conflicts               450
;  :datatype-accessor-ax    516
;  :datatype-constructor-ax 5429
;  :datatype-occurs-check   1248
;  :datatype-splits         3163
;  :decisions               5684
;  :del-clause              5274
;  :final-checks            310
;  :interface-eqs           54
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          138
;  :mk-bool-var             10306
;  :mk-clause               5398
;  :num-allocs              6362201
;  :num-checks              406
;  :propagations            3869
;  :quant-instantiations    1293
;  :rlimit-count            368964)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 107 | !(First:(Second:(Second:(Second:($t@84@04))))[1] == 0 || First:(Second:(Second:(Second:($t@84@04))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      (- 0 1)))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1)
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               23421
;  :arith-add-rows          480
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2132
;  :arith-assert-upper      1422
;  :arith-bound-prop        198
;  :arith-conflicts         16
;  :arith-eq-adapter        1488
;  :arith-fixed-eqs         648
;  :arith-offset-eqs        172
;  :arith-pivots            416
;  :binary-propagations     16
;  :conflicts               450
;  :datatype-accessor-ax    517
;  :datatype-constructor-ax 5429
;  :datatype-occurs-check   1248
;  :datatype-splits         3163
;  :decisions               5684
;  :del-clause              5275
;  :final-checks            310
;  :interface-eqs           54
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          138
;  :mk-bool-var             10312
;  :mk-clause               5402
;  :num-allocs              6362201
;  :num-checks              407
;  :propagations            3869
;  :quant-instantiations    1293
;  :rlimit-count            369453)
(push) ; 8
; [then-branch: 108 | First:(Second:(Second:(Second:($t@84@04))))[0] == 0 | live]
; [else-branch: 108 | First:(Second:(Second:(Second:($t@84@04))))[0] != 0 | live]
(push) ; 9
; [then-branch: 108 | First:(Second:(Second:(Second:($t@84@04))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 108 | First:(Second:(Second:(Second:($t@84@04))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               23422
;  :arith-add-rows          480
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2132
;  :arith-assert-upper      1422
;  :arith-bound-prop        198
;  :arith-conflicts         16
;  :arith-eq-adapter        1488
;  :arith-fixed-eqs         648
;  :arith-offset-eqs        172
;  :arith-pivots            416
;  :binary-propagations     16
;  :conflicts               450
;  :datatype-accessor-ax    517
;  :datatype-constructor-ax 5429
;  :datatype-occurs-check   1248
;  :datatype-splits         3163
;  :decisions               5684
;  :del-clause              5275
;  :final-checks            310
;  :interface-eqs           54
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          138
;  :mk-bool-var             10316
;  :mk-clause               5407
;  :num-allocs              6362201
;  :num-checks              408
;  :propagations            3869
;  :quant-instantiations    1294
;  :rlimit-count            369621)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               24241
;  :arith-add-rows          523
;  :arith-assert-diseq      1285
;  :arith-assert-lower      2256
;  :arith-assert-upper      1474
;  :arith-bound-prop        201
;  :arith-conflicts         19
;  :arith-eq-adapter        1558
;  :arith-fixed-eqs         679
;  :arith-offset-eqs        186
;  :arith-pivots            445
;  :binary-propagations     16
;  :conflicts               462
;  :datatype-accessor-ax    532
;  :datatype-constructor-ax 5595
;  :datatype-occurs-check   1304
;  :datatype-splits         3287
;  :decisions               5870
;  :del-clause              5533
;  :final-checks            321
;  :interface-eqs           57
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          150
;  :mk-bool-var             10730
;  :mk-clause               5660
;  :num-allocs              6362201
;  :num-checks              409
;  :propagations            4048
;  :quant-instantiations    1350
;  :rlimit-count            375565
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25383
;  :arith-add-rows          583
;  :arith-assert-diseq      1348
;  :arith-assert-lower      2392
;  :arith-assert-upper      1525
;  :arith-bound-prop        214
;  :arith-conflicts         22
;  :arith-eq-adapter        1636
;  :arith-fixed-eqs         752
;  :arith-offset-eqs        233
;  :arith-pivots            465
;  :binary-propagations     16
;  :conflicts               486
;  :datatype-accessor-ax    553
;  :datatype-constructor-ax 5798
;  :datatype-occurs-check   1367
;  :datatype-splits         3421
;  :decisions               6094
;  :del-clause              5814
;  :final-checks            333
;  :interface-eqs           60
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          166
;  :mk-bool-var             11226
;  :mk-clause               5941
;  :num-allocs              6362201
;  :num-checks              410
;  :propagations            4298
;  :quant-instantiations    1420
;  :rlimit-count            382964
;  :time                    0.01)
; [then-branch: 109 | !(First:(Second:(Second:(Second:($t@84@04))))[0] == 0 || First:(Second:(Second:(Second:($t@84@04))))[0] == -1) | live]
; [else-branch: 109 | First:(Second:(Second:(Second:($t@84@04))))[0] == 0 || First:(Second:(Second:(Second:($t@84@04))))[0] == -1 | live]
(push) ; 9
; [then-branch: 109 | !(First:(Second:(Second:(Second:($t@84@04))))[0] == 0 || First:(Second:(Second:(Second:($t@84@04))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25384
;  :arith-add-rows          584
;  :arith-assert-diseq      1348
;  :arith-assert-lower      2392
;  :arith-assert-upper      1525
;  :arith-bound-prop        214
;  :arith-conflicts         22
;  :arith-eq-adapter        1636
;  :arith-fixed-eqs         752
;  :arith-offset-eqs        233
;  :arith-pivots            465
;  :binary-propagations     16
;  :conflicts               486
;  :datatype-accessor-ax    553
;  :datatype-constructor-ax 5798
;  :datatype-occurs-check   1367
;  :datatype-splits         3421
;  :decisions               6094
;  :del-clause              5814
;  :final-checks            333
;  :interface-eqs           60
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          166
;  :mk-bool-var             11230
;  :mk-clause               5946
;  :num-allocs              6362201
;  :num-checks              411
;  :propagations            4299
;  :quant-instantiations    1421
;  :rlimit-count            383154)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25384
;  :arith-add-rows          584
;  :arith-assert-diseq      1348
;  :arith-assert-lower      2392
;  :arith-assert-upper      1525
;  :arith-bound-prop        214
;  :arith-conflicts         22
;  :arith-eq-adapter        1636
;  :arith-fixed-eqs         752
;  :arith-offset-eqs        233
;  :arith-pivots            465
;  :binary-propagations     16
;  :conflicts               486
;  :datatype-accessor-ax    553
;  :datatype-constructor-ax 5798
;  :datatype-occurs-check   1367
;  :datatype-splits         3421
;  :decisions               6094
;  :del-clause              5814
;  :final-checks            333
;  :interface-eqs           60
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          166
;  :mk-bool-var             11230
;  :mk-clause               5946
;  :num-allocs              6362201
;  :num-checks              412
;  :propagations            4299
;  :quant-instantiations    1421
;  :rlimit-count            383169)
(pop) ; 9
(push) ; 9
; [else-branch: 109 | First:(Second:(Second:(Second:($t@84@04))))[0] == 0 || First:(Second:(Second:(Second:($t@84@04))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@87@04))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1)
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25391
;  :arith-add-rows          584
;  :arith-assert-diseq      1348
;  :arith-assert-lower      2392
;  :arith-assert-upper      1525
;  :arith-bound-prop        214
;  :arith-conflicts         22
;  :arith-eq-adapter        1636
;  :arith-fixed-eqs         752
;  :arith-offset-eqs        233
;  :arith-pivots            465
;  :binary-propagations     16
;  :conflicts               486
;  :datatype-accessor-ax    553
;  :datatype-constructor-ax 5798
;  :datatype-occurs-check   1367
;  :datatype-splits         3421
;  :decisions               6094
;  :del-clause              5819
;  :final-checks            333
;  :interface-eqs           60
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          166
;  :mk-bool-var             11232
;  :mk-clause               5947
;  :num-allocs              6362201
;  :num-checks              413
;  :propagations            4299
;  :quant-instantiations    1421
;  :rlimit-count            383521)
(push) ; 8
; [then-branch: 110 | First:(Second:(Second:(Second:($t@84@04))))[1] == 0 | live]
; [else-branch: 110 | First:(Second:(Second:(Second:($t@84@04))))[1] != 0 | live]
(push) ; 9
; [then-branch: 110 | First:(Second:(Second:(Second:($t@84@04))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 110 | First:(Second:(Second:(Second:($t@84@04))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               25392
;  :arith-add-rows          585
;  :arith-assert-diseq      1348
;  :arith-assert-lower      2392
;  :arith-assert-upper      1525
;  :arith-bound-prop        214
;  :arith-conflicts         22
;  :arith-eq-adapter        1636
;  :arith-fixed-eqs         752
;  :arith-offset-eqs        233
;  :arith-pivots            465
;  :binary-propagations     16
;  :conflicts               486
;  :datatype-accessor-ax    553
;  :datatype-constructor-ax 5798
;  :datatype-occurs-check   1367
;  :datatype-splits         3421
;  :decisions               6094
;  :del-clause              5819
;  :final-checks            333
;  :interface-eqs           60
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          166
;  :mk-bool-var             11236
;  :mk-clause               5952
;  :num-allocs              6362201
;  :num-checks              414
;  :propagations            4299
;  :quant-instantiations    1422
;  :rlimit-count            383690)
; [eval] -1
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               26307
;  :arith-add-rows          656
;  :arith-assert-diseq      1447
;  :arith-assert-lower      2586
;  :arith-assert-upper      1599
;  :arith-bound-prop        231
;  :arith-conflicts         26
;  :arith-eq-adapter        1752
;  :arith-fixed-eqs         805
;  :arith-offset-eqs        258
;  :arith-pivots            507
;  :binary-propagations     16
;  :conflicts               504
;  :datatype-accessor-ax    568
;  :datatype-constructor-ax 5962
;  :datatype-occurs-check   1423
;  :datatype-splits         3542
;  :decisions               6282
;  :del-clause              6211
;  :final-checks            344
;  :interface-eqs           63
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          173
;  :mk-bool-var             11794
;  :mk-clause               6339
;  :num-allocs              6362201
;  :num-checks              415
;  :propagations            4566
;  :quant-instantiations    1500
;  :rlimit-count            390898
;  :time                    0.01)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27117
;  :arith-add-rows          693
;  :arith-assert-diseq      1512
;  :arith-assert-lower      2713
;  :arith-assert-upper      1648
;  :arith-bound-prop        240
;  :arith-conflicts         28
;  :arith-eq-adapter        1826
;  :arith-fixed-eqs         835
;  :arith-offset-eqs        277
;  :arith-pivots            539
;  :binary-propagations     16
;  :conflicts               516
;  :datatype-accessor-ax    583
;  :datatype-constructor-ax 6126
;  :datatype-occurs-check   1479
;  :datatype-splits         3663
;  :decisions               6467
;  :del-clause              6474
;  :final-checks            355
;  :interface-eqs           66
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          175
;  :mk-bool-var             12217
;  :mk-clause               6602
;  :num-allocs              6362201
;  :num-checks              416
;  :propagations            4754
;  :quant-instantiations    1557
;  :rlimit-count            396851
;  :time                    0.01)
; [then-branch: 111 | !(First:(Second:(Second:(Second:($t@84@04))))[1] == 0 || First:(Second:(Second:(Second:($t@84@04))))[1] == -1) | live]
; [else-branch: 111 | First:(Second:(Second:(Second:($t@84@04))))[1] == 0 || First:(Second:(Second:(Second:($t@84@04))))[1] == -1 | live]
(push) ; 9
; [then-branch: 111 | !(First:(Second:(Second:(Second:($t@84@04))))[1] == 0 || First:(Second:(Second:(Second:($t@84@04))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27118
;  :arith-add-rows          694
;  :arith-assert-diseq      1512
;  :arith-assert-lower      2713
;  :arith-assert-upper      1648
;  :arith-bound-prop        240
;  :arith-conflicts         28
;  :arith-eq-adapter        1826
;  :arith-fixed-eqs         835
;  :arith-offset-eqs        277
;  :arith-pivots            539
;  :binary-propagations     16
;  :conflicts               516
;  :datatype-accessor-ax    583
;  :datatype-constructor-ax 6126
;  :datatype-occurs-check   1479
;  :datatype-splits         3663
;  :decisions               6467
;  :del-clause              6474
;  :final-checks            355
;  :interface-eqs           66
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          175
;  :mk-bool-var             12221
;  :mk-clause               6607
;  :num-allocs              6362201
;  :num-checks              417
;  :propagations            4755
;  :quant-instantiations    1558
;  :rlimit-count            397041)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27118
;  :arith-add-rows          694
;  :arith-assert-diseq      1512
;  :arith-assert-lower      2713
;  :arith-assert-upper      1648
;  :arith-bound-prop        240
;  :arith-conflicts         28
;  :arith-eq-adapter        1826
;  :arith-fixed-eqs         835
;  :arith-offset-eqs        277
;  :arith-pivots            539
;  :binary-propagations     16
;  :conflicts               516
;  :datatype-accessor-ax    583
;  :datatype-constructor-ax 6126
;  :datatype-occurs-check   1479
;  :datatype-splits         3663
;  :decisions               6467
;  :del-clause              6474
;  :final-checks            355
;  :interface-eqs           66
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          175
;  :mk-bool-var             12221
;  :mk-clause               6607
;  :num-allocs              6362201
;  :num-checks              418
;  :propagations            4755
;  :quant-instantiations    1558
;  :rlimit-count            397056)
(pop) ; 9
(push) ; 9
; [else-branch: 111 | First:(Second:(Second:(Second:($t@84@04))))[1] == 0 || First:(Second:(Second:(Second:($t@84@04))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1)
    (- 0 1))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@84@04)))))
      1))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@89@04 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 112 | 0 <= i@89@04 | live]
; [else-branch: 112 | !(0 <= i@89@04) | live]
(push) ; 10
; [then-branch: 112 | 0 <= i@89@04]
(assert (<= 0 i@89@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 112 | !(0 <= i@89@04)]
(assert (not (<= 0 i@89@04)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 113 | i@89@04 < |First:(Second:($t@87@04))| && 0 <= i@89@04 | live]
; [else-branch: 113 | !(i@89@04 < |First:(Second:($t@87@04))| && 0 <= i@89@04) | live]
(push) ; 10
; [then-branch: 113 | i@89@04 < |First:(Second:($t@87@04))| && 0 <= i@89@04]
(assert (and
  (<
    i@89@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))))
  (<= 0 i@89@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@89@04 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27930
;  :arith-add-rows          725
;  :arith-assert-diseq      1577
;  :arith-assert-lower      2841
;  :arith-assert-upper      1698
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1900
;  :arith-fixed-eqs         865
;  :arith-offset-eqs        297
;  :arith-pivots            567
;  :binary-propagations     16
;  :conflicts               527
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6739
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12647
;  :mk-clause               6880
;  :num-allocs              6362201
;  :num-checks              420
;  :propagations            4944
;  :quant-instantiations    1615
;  :rlimit-count            403017)
; [eval] -1
(push) ; 11
; [then-branch: 114 | First:(Second:($t@87@04))[i@89@04] == -1 | live]
; [else-branch: 114 | First:(Second:($t@87@04))[i@89@04] != -1 | live]
(push) ; 12
; [then-branch: 114 | First:(Second:($t@87@04))[i@89@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
    i@89@04)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 114 | First:(Second:($t@87@04))[i@89@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
      i@89@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@89@04 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27941
;  :arith-add-rows          728
;  :arith-assert-diseq      1580
;  :arith-assert-lower      2849
;  :arith-assert-upper      1702
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1904
;  :arith-fixed-eqs         867
;  :arith-offset-eqs        297
;  :arith-pivots            567
;  :binary-propagations     16
;  :conflicts               527
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6739
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12669
;  :mk-clause               6895
;  :num-allocs              6362201
;  :num-checks              421
;  :propagations            4954
;  :quant-instantiations    1619
;  :rlimit-count            403251)
(push) ; 13
; [then-branch: 115 | 0 <= First:(Second:($t@87@04))[i@89@04] | live]
; [else-branch: 115 | !(0 <= First:(Second:($t@87@04))[i@89@04]) | live]
(push) ; 14
; [then-branch: 115 | 0 <= First:(Second:($t@87@04))[i@89@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
    i@89@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@89@04 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1580
;  :arith-assert-lower      2851
;  :arith-assert-upper      1703
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1905
;  :arith-fixed-eqs         868
;  :arith-offset-eqs        297
;  :arith-pivots            568
;  :binary-propagations     16
;  :conflicts               527
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6739
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12673
;  :mk-clause               6895
;  :num-allocs              6362201
;  :num-checks              422
;  :propagations            4954
;  :quant-instantiations    1619
;  :rlimit-count            403368)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 115 | !(0 <= First:(Second:($t@87@04))[i@89@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
      i@89@04))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [else-branch: 113 | !(i@89@04 < |First:(Second:($t@87@04))| && 0 <= i@89@04)]
(assert (not
  (and
    (<
      i@89@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))))
    (<= 0 i@89@04))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 8
(assert (not (forall ((i@89@04 Int)) (!
  (implies
    (and
      (<
        i@89@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))))
      (<= 0 i@89@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
          i@89@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
            i@89@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
            i@89@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
    i@89@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1581
;  :arith-assert-lower      2852
;  :arith-assert-upper      1704
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1907
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            569
;  :binary-propagations     16
;  :conflicts               528
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12687
;  :mk-clause               6920
;  :num-allocs              6362201
;  :num-checks              423
;  :propagations            4956
;  :quant-instantiations    1622
;  :rlimit-count            403860)
(assert (forall ((i@89@04 Int)) (!
  (implies
    (and
      (<
        i@89@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))))
      (<= 0 i@89@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
          i@89@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
            i@89@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
            i@89@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@87@04)))
    i@89@04))
  :qid |prog.l<no position>|)))
(declare-const $k@90@04 $Perm)
(assert ($Perm.isReadVar $k@90@04 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@90@04 $Perm.No) (< $Perm.No $k@90@04))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2854
;  :arith-assert-upper      1705
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            569
;  :binary-propagations     16
;  :conflicts               529
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12692
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              424
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404384)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@58@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2854
;  :arith-assert-upper      1705
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            569
;  :binary-propagations     16
;  :conflicts               529
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12692
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              425
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404395)
(assert (< $k@90@04 $k@58@04))
(assert (<= $Perm.No (- $k@58@04 $k@90@04)))
(assert (<= (- $k@58@04 $k@90@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@58@04 $k@90@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_alu != null
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               530
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              426
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404609)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               531
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              427
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404657)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               532
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              428
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404705)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               533
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              429
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404753)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               534
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              430
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404801)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               535
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              431
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404849)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               536
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              432
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404897)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               537
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              433
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404945)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               538
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              434
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            404993)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               539
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              435
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            405041)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               540
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              436
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            405089)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               541
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              437
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            405137)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               542
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              438
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            405185)
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1582
;  :arith-assert-lower      2856
;  :arith-assert-upper      1706
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1908
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               543
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12695
;  :mk-clause               6922
;  :num-allocs              6362201
;  :num-checks              439
;  :propagations            4957
;  :quant-instantiations    1622
;  :rlimit-count            405233)
(declare-const $k@91@04 $Perm)
(assert ($Perm.isReadVar $k@91@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@91@04 $Perm.No) (< $Perm.No $k@91@04))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1583
;  :arith-assert-lower      2858
;  :arith-assert-upper      1707
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1909
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               544
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12699
;  :mk-clause               6924
;  :num-allocs              6362201
;  :num-checks              440
;  :propagations            4958
;  :quant-instantiations    1622
;  :rlimit-count            405431)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@59@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1583
;  :arith-assert-lower      2858
;  :arith-assert-upper      1707
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1909
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            570
;  :binary-propagations     16
;  :conflicts               544
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12699
;  :mk-clause               6924
;  :num-allocs              6362201
;  :num-checks              441
;  :propagations            4958
;  :quant-instantiations    1622
;  :rlimit-count            405442)
(assert (< $k@91@04 $k@59@04))
(assert (<= $Perm.No (- $k@59@04 $k@91@04)))
(assert (<= (- $k@59@04 $k@91@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@59@04 $k@91@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_dr != null
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1583
;  :arith-assert-lower      2860
;  :arith-assert-upper      1708
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1909
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               545
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12702
;  :mk-clause               6924
;  :num-allocs              6362201
;  :num-checks              442
;  :propagations            4958
;  :quant-instantiations    1622
;  :rlimit-count            405656)
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1583
;  :arith-assert-lower      2860
;  :arith-assert-upper      1708
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1909
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               546
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12702
;  :mk-clause               6924
;  :num-allocs              6362201
;  :num-checks              443
;  :propagations            4958
;  :quant-instantiations    1622
;  :rlimit-count            405704)
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1583
;  :arith-assert-lower      2860
;  :arith-assert-upper      1708
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1909
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               547
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12702
;  :mk-clause               6924
;  :num-allocs              6362201
;  :num-checks              444
;  :propagations            4958
;  :quant-instantiations    1622
;  :rlimit-count            405752)
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1583
;  :arith-assert-lower      2860
;  :arith-assert-upper      1708
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1909
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               548
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12702
;  :mk-clause               6924
;  :num-allocs              6362201
;  :num-checks              445
;  :propagations            4958
;  :quant-instantiations    1622
;  :rlimit-count            405800)
(push) ; 8
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1583
;  :arith-assert-lower      2860
;  :arith-assert-upper      1708
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1909
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               549
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12702
;  :mk-clause               6924
;  :num-allocs              6362201
;  :num-checks              446
;  :propagations            4958
;  :quant-instantiations    1622
;  :rlimit-count            405848
;  :time                    0.00)
(declare-const $k@92@04 $Perm)
(assert ($Perm.isReadVar $k@92@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@92@04 $Perm.No) (< $Perm.No $k@92@04))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1584
;  :arith-assert-lower      2862
;  :arith-assert-upper      1709
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1910
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               550
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12706
;  :mk-clause               6926
;  :num-allocs              6362201
;  :num-checks              447
;  :propagations            4959
;  :quant-instantiations    1622
;  :rlimit-count            406047)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@60@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1584
;  :arith-assert-lower      2862
;  :arith-assert-upper      1709
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1910
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               550
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12706
;  :mk-clause               6926
;  :num-allocs              6362201
;  :num-checks              448
;  :propagations            4959
;  :quant-instantiations    1622
;  :rlimit-count            406058)
(assert (< $k@92@04 $k@60@04))
(assert (<= $Perm.No (- $k@60@04 $k@92@04)))
(assert (<= (- $k@60@04 $k@92@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@60@04 $k@92@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_mon != null
(push) ; 8
(assert (not (< $Perm.No $k@60@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1584
;  :arith-assert-lower      2864
;  :arith-assert-upper      1710
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1910
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               551
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12709
;  :mk-clause               6926
;  :num-allocs              6362201
;  :num-checks              449
;  :propagations            4959
;  :quant-instantiations    1622
;  :rlimit-count            406266)
(declare-const $k@93@04 $Perm)
(assert ($Perm.isReadVar $k@93@04 $Perm.Write))
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1585
;  :arith-assert-lower      2866
;  :arith-assert-upper      1711
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1911
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               552
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12713
;  :mk-clause               6928
;  :num-allocs              6362201
;  :num-checks              450
;  :propagations            4960
;  :quant-instantiations    1622
;  :rlimit-count            406462)
(set-option :timeout 0)
(push) ; 8
(assert (not (or (= $k@93@04 $Perm.No) (< $Perm.No $k@93@04))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1585
;  :arith-assert-lower      2866
;  :arith-assert-upper      1711
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1911
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               553
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12713
;  :mk-clause               6928
;  :num-allocs              6362201
;  :num-checks              451
;  :propagations            4960
;  :quant-instantiations    1622
;  :rlimit-count            406512)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@61@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1585
;  :arith-assert-lower      2866
;  :arith-assert-upper      1711
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1911
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            571
;  :binary-propagations     16
;  :conflicts               553
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12713
;  :mk-clause               6928
;  :num-allocs              6362201
;  :num-checks              452
;  :propagations            4960
;  :quant-instantiations    1622
;  :rlimit-count            406523)
(assert (< $k@93@04 $k@61@04))
(assert (<= $Perm.No (- $k@61@04 $k@93@04)))
(assert (<= (- $k@61@04 $k@93@04) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@61@04 $k@93@04))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))
      $Ref.null))))
; [eval] diz.Main_alu.ALU_m == diz
(push) ; 8
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1585
;  :arith-assert-lower      2868
;  :arith-assert-upper      1712
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1911
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            572
;  :binary-propagations     16
;  :conflicts               554
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12716
;  :mk-clause               6928
;  :num-allocs              6362201
;  :num-checks              453
;  :propagations            4960
;  :quant-instantiations    1622
;  :rlimit-count            406737)
(push) ; 8
(assert (not (< $Perm.No $k@61@04)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          729
;  :arith-assert-diseq      1585
;  :arith-assert-lower      2868
;  :arith-assert-upper      1712
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1911
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            572
;  :binary-propagations     16
;  :conflicts               555
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6779
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12716
;  :mk-clause               6928
;  :num-allocs              6362201
;  :num-checks              454
;  :propagations            4960
;  :quant-instantiations    1622
;  :rlimit-count            406785)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@87@04))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@87@04))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))
                                  ($Snap.combine
                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))
                                    ($Snap.combine
                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))
                                      ($Snap.combine
                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))
                                        ($Snap.combine
                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))
                                          ($Snap.combine
                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))
                                            ($Snap.combine
                                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))
                                              ($Snap.combine
                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))
                                                ($Snap.combine
                                                  $Snap.unit
                                                  ($Snap.combine
                                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))
                                                    ($Snap.combine
                                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))
                                                      ($Snap.combine
                                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))
                                                        ($Snap.combine
                                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))
                                                          ($Snap.combine
                                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))
                                                            ($Snap.combine
                                                              $Snap.unit
                                                              ($Snap.combine
                                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))))
                                                                $Snap.unit)))))))))))))))))))))))))))))))) diz@35@04 globals@36@04))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 79 | min_advance__91@69@04 == -1]
(assert (= min_advance__91@69@04 (- 0 1)))
(pop) ; 7
(pop) ; 6
(push) ; 6
; [else-branch: 41 | First:(Second:($t@67@04))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (- 0 1)))
(pop) ; 6
; [eval] !(diz.Main_process_state[0] != -1)
; [eval] diz.Main_process_state[0] != -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               27943
;  :arith-add-rows          732
;  :arith-assert-diseq      1585
;  :arith-assert-lower      2868
;  :arith-assert-upper      1712
;  :arith-bound-prop        249
;  :arith-conflicts         30
;  :arith-eq-adapter        1911
;  :arith-fixed-eqs         869
;  :arith-offset-eqs        297
;  :arith-pivots            581
;  :binary-propagations     16
;  :conflicts               555
;  :datatype-accessor-ax    598
;  :datatype-constructor-ax 6290
;  :datatype-occurs-check   1535
;  :datatype-splits         3784
;  :decisions               6651
;  :del-clause              6900
;  :final-checks            366
;  :interface-eqs           69
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          181
;  :mk-bool-var             12716
;  :mk-clause               6928
;  :num-allocs              6362201
;  :num-checks              455
;  :propagations            4960
;  :quant-instantiations    1622
;  :rlimit-count            407086)
; [eval] -1
(set-option :timeout 10)
(push) ; 6
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28261
;  :arith-add-rows          733
;  :arith-assert-diseq      1590
;  :arith-assert-lower      2880
;  :arith-assert-upper      1717
;  :arith-bound-prop        253
;  :arith-conflicts         30
;  :arith-eq-adapter        1919
;  :arith-fixed-eqs         873
;  :arith-offset-eqs        297
;  :arith-pivots            584
;  :binary-propagations     16
;  :conflicts               560
;  :datatype-accessor-ax    605
;  :datatype-constructor-ax 6379
;  :datatype-occurs-check   1560
;  :datatype-splits         3824
;  :decisions               6737
;  :del-clause              6937
;  :final-checks            372
;  :interface-eqs           70
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12807
;  :mk-clause               6965
;  :num-allocs              6362201
;  :num-checks              456
;  :propagations            4979
;  :quant-instantiations    1626
;  :rlimit-count            409231
;  :time                    0.00)
(push) ; 6
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28455
;  :arith-add-rows          736
;  :arith-assert-diseq      1594
;  :arith-assert-lower      2895
;  :arith-assert-upper      1725
;  :arith-bound-prop        253
;  :arith-conflicts         30
;  :arith-eq-adapter        1927
;  :arith-fixed-eqs         876
;  :arith-offset-eqs        297
;  :arith-pivots            588
;  :binary-propagations     16
;  :conflicts               561
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6969
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12867
;  :mk-clause               6997
;  :num-allocs              6362201
;  :num-checks              457
;  :propagations            5004
;  :quant-instantiations    1633
;  :rlimit-count            410998
;  :time                    0.00)
; [then-branch: 116 | First:(Second:($t@67@04))[0] == -1 | live]
; [else-branch: 116 | First:(Second:($t@67@04))[0] != -1 | live]
(push) ; 6
; [then-branch: 116 | First:(Second:($t@67@04))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    0)
  (- 0 1)))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@94@04 Int)
(push) ; 7
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 8
; [then-branch: 117 | 0 <= i@94@04 | live]
; [else-branch: 117 | !(0 <= i@94@04) | live]
(push) ; 9
; [then-branch: 117 | 0 <= i@94@04]
(assert (<= 0 i@94@04))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 117 | !(0 <= i@94@04)]
(assert (not (<= 0 i@94@04)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 118 | i@94@04 < |First:(Second:($t@67@04))| && 0 <= i@94@04 | live]
; [else-branch: 118 | !(i@94@04 < |First:(Second:($t@67@04))| && 0 <= i@94@04) | live]
(push) ; 9
; [then-branch: 118 | i@94@04 < |First:(Second:($t@67@04))| && 0 <= i@94@04]
(assert (and
  (<
    i@94@04
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
  (<= 0 i@94@04)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i@94@04 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28461
;  :arith-add-rows          737
;  :arith-assert-diseq      1594
;  :arith-assert-lower      2898
;  :arith-assert-upper      1728
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1928
;  :arith-fixed-eqs         878
;  :arith-offset-eqs        297
;  :arith-pivots            589
;  :binary-propagations     16
;  :conflicts               561
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6969
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12872
;  :mk-clause               7002
;  :num-allocs              6362201
;  :num-checks              458
;  :propagations            5007
;  :quant-instantiations    1633
;  :rlimit-count            411272)
; [eval] -1
(push) ; 10
; [then-branch: 119 | First:(Second:($t@67@04))[i@94@04] == -1 | live]
; [else-branch: 119 | First:(Second:($t@67@04))[i@94@04] != -1 | live]
(push) ; 11
; [then-branch: 119 | First:(Second:($t@67@04))[i@94@04] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@94@04)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 119 | First:(Second:($t@67@04))[i@94@04] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      i@94@04)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 12
(assert (not (>= i@94@04 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1594
;  :arith-assert-lower      2898
;  :arith-assert-upper      1728
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1928
;  :arith-fixed-eqs         878
;  :arith-offset-eqs        297
;  :arith-pivots            589
;  :binary-propagations     16
;  :conflicts               562
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6969
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12873
;  :mk-clause               7002
;  :num-allocs              6362201
;  :num-checks              459
;  :propagations            5007
;  :quant-instantiations    1633
;  :rlimit-count            411416)
(push) ; 12
; [then-branch: 120 | 0 <= First:(Second:($t@67@04))[i@94@04] | live]
; [else-branch: 120 | !(0 <= First:(Second:($t@67@04))[i@94@04]) | live]
(push) ; 13
; [then-branch: 120 | 0 <= First:(Second:($t@67@04))[i@94@04]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@94@04)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@94@04 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1594
;  :arith-assert-lower      2898
;  :arith-assert-upper      1728
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1928
;  :arith-fixed-eqs         878
;  :arith-offset-eqs        297
;  :arith-pivots            589
;  :binary-propagations     16
;  :conflicts               562
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6969
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12874
;  :mk-clause               7002
;  :num-allocs              6362201
;  :num-checks              460
;  :propagations            5007
;  :quant-instantiations    1633
;  :rlimit-count            411501)
; [eval] |diz.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 120 | !(0 <= First:(Second:($t@67@04))[i@94@04])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      i@94@04))))
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
; [else-branch: 118 | !(i@94@04 < |First:(Second:($t@67@04))| && 0 <= i@94@04)]
(assert (not
  (and
    (<
      i@94@04
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
    (<= 0 i@94@04))))
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
(assert (not (forall ((i@94@04 Int)) (!
  (implies
    (and
      (<
        i@94@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
      (<= 0 i@94@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          i@94@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@94@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@94@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@94@04))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1596
;  :arith-assert-lower      2899
;  :arith-assert-upper      1729
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1930
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            589
;  :binary-propagations     16
;  :conflicts               563
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12888
;  :mk-clause               7029
;  :num-allocs              6362201
;  :num-checks              461
;  :propagations            5009
;  :quant-instantiations    1636
;  :rlimit-count            411986)
(assert (forall ((i@94@04 Int)) (!
  (implies
    (and
      (<
        i@94@04
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))))
      (<= 0 i@94@04))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
          i@94@04)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@94@04)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
            i@94@04)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
    i@94@04))
  :qid |prog.l<no position>|)))
(declare-const $k@95@04 $Perm)
(assert ($Perm.isReadVar $k@95@04 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@95@04 $Perm.No) (< $Perm.No $k@95@04))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2901
;  :arith-assert-upper      1730
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            589
;  :binary-propagations     16
;  :conflicts               564
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12893
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              462
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            412512)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@58@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2901
;  :arith-assert-upper      1730
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            589
;  :binary-propagations     16
;  :conflicts               564
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12893
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              463
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            412523)
(assert (< $k@95@04 $k@58@04))
(assert (<= $Perm.No (- $k@58@04 $k@95@04)))
(assert (<= (- $k@58@04 $k@95@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@58@04 $k@95@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_alu != null
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               565
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              464
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            412743)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               566
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              465
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            412791)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               567
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              466
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            412839)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               568
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              467
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            412887)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               569
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              468
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            412935)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               570
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              469
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            412983)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               571
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              470
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            413031)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               572
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              471
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            413079)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               573
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              472
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            413127)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               574
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              473
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            413175)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               575
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              474
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            413223)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               576
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              475
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            413271)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               577
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              476
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            413319)
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1597
;  :arith-assert-lower      2903
;  :arith-assert-upper      1731
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1931
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               578
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12896
;  :mk-clause               7031
;  :num-allocs              6362201
;  :num-checks              477
;  :propagations            5010
;  :quant-instantiations    1636
;  :rlimit-count            413367)
(declare-const $k@96@04 $Perm)
(assert ($Perm.isReadVar $k@96@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@96@04 $Perm.No) (< $Perm.No $k@96@04))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1598
;  :arith-assert-lower      2905
;  :arith-assert-upper      1732
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1932
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               579
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12900
;  :mk-clause               7033
;  :num-allocs              6362201
;  :num-checks              478
;  :propagations            5011
;  :quant-instantiations    1636
;  :rlimit-count            413566)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@59@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1598
;  :arith-assert-lower      2905
;  :arith-assert-upper      1732
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1932
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               579
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12900
;  :mk-clause               7033
;  :num-allocs              6362201
;  :num-checks              479
;  :propagations            5011
;  :quant-instantiations    1636
;  :rlimit-count            413577)
(assert (< $k@96@04 $k@59@04))
(assert (<= $Perm.No (- $k@59@04 $k@96@04)))
(assert (<= (- $k@59@04 $k@96@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@59@04 $k@96@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_dr != null
(push) ; 7
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1598
;  :arith-assert-lower      2907
;  :arith-assert-upper      1733
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1932
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               580
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12903
;  :mk-clause               7033
;  :num-allocs              6362201
;  :num-checks              480
;  :propagations            5011
;  :quant-instantiations    1636
;  :rlimit-count            413785)
(push) ; 7
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1598
;  :arith-assert-lower      2907
;  :arith-assert-upper      1733
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1932
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               581
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12903
;  :mk-clause               7033
;  :num-allocs              6362201
;  :num-checks              481
;  :propagations            5011
;  :quant-instantiations    1636
;  :rlimit-count            413833)
(push) ; 7
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1598
;  :arith-assert-lower      2907
;  :arith-assert-upper      1733
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1932
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               582
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12903
;  :mk-clause               7033
;  :num-allocs              6362201
;  :num-checks              482
;  :propagations            5011
;  :quant-instantiations    1636
;  :rlimit-count            413881)
(push) ; 7
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1598
;  :arith-assert-lower      2907
;  :arith-assert-upper      1733
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1932
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               583
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12903
;  :mk-clause               7033
;  :num-allocs              6362201
;  :num-checks              483
;  :propagations            5011
;  :quant-instantiations    1636
;  :rlimit-count            413929)
(push) ; 7
(assert (not (< $Perm.No $k@59@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1598
;  :arith-assert-lower      2907
;  :arith-assert-upper      1733
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1932
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               584
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12903
;  :mk-clause               7033
;  :num-allocs              6362201
;  :num-checks              484
;  :propagations            5011
;  :quant-instantiations    1636
;  :rlimit-count            413977)
(declare-const $k@97@04 $Perm)
(assert ($Perm.isReadVar $k@97@04 $Perm.Write))
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@97@04 $Perm.No) (< $Perm.No $k@97@04))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1599
;  :arith-assert-lower      2909
;  :arith-assert-upper      1734
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1933
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               585
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12907
;  :mk-clause               7035
;  :num-allocs              6362201
;  :num-checks              485
;  :propagations            5012
;  :quant-instantiations    1636
;  :rlimit-count            414176)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@60@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1599
;  :arith-assert-lower      2909
;  :arith-assert-upper      1734
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1933
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               585
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12907
;  :mk-clause               7035
;  :num-allocs              6362201
;  :num-checks              486
;  :propagations            5012
;  :quant-instantiations    1636
;  :rlimit-count            414187)
(assert (< $k@97@04 $k@60@04))
(assert (<= $Perm.No (- $k@60@04 $k@97@04)))
(assert (<= (- $k@60@04 $k@97@04) $Perm.Write))
(assert (implies (< $Perm.No (- $k@60@04 $k@97@04)) (not (= diz@35@04 $Ref.null))))
; [eval] diz.Main_mon != null
(push) ; 7
(assert (not (< $Perm.No $k@60@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1599
;  :arith-assert-lower      2911
;  :arith-assert-upper      1735
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1933
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               586
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12910
;  :mk-clause               7035
;  :num-allocs              6362201
;  :num-checks              487
;  :propagations            5012
;  :quant-instantiations    1636
;  :rlimit-count            414395)
(declare-const $k@98@04 $Perm)
(assert ($Perm.isReadVar $k@98@04 $Perm.Write))
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1600
;  :arith-assert-lower      2913
;  :arith-assert-upper      1736
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1934
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               587
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12914
;  :mk-clause               7037
;  :num-allocs              6362201
;  :num-checks              488
;  :propagations            5013
;  :quant-instantiations    1636
;  :rlimit-count            414592)
(set-option :timeout 0)
(push) ; 7
(assert (not (or (= $k@98@04 $Perm.No) (< $Perm.No $k@98@04))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1600
;  :arith-assert-lower      2913
;  :arith-assert-upper      1736
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1934
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               588
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12914
;  :mk-clause               7037
;  :num-allocs              6362201
;  :num-checks              489
;  :propagations            5013
;  :quant-instantiations    1636
;  :rlimit-count            414642)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@61@04 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1600
;  :arith-assert-lower      2913
;  :arith-assert-upper      1736
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1934
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               588
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12914
;  :mk-clause               7037
;  :num-allocs              6362201
;  :num-checks              490
;  :propagations            5013
;  :quant-instantiations    1636
;  :rlimit-count            414653)
(assert (< $k@98@04 $k@61@04))
(assert (<= $Perm.No (- $k@61@04 $k@98@04)))
(assert (<= (- $k@61@04 $k@98@04) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@61@04 $k@98@04))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))
      $Ref.null))))
; [eval] diz.Main_alu.ALU_m == diz
(push) ; 7
(assert (not (< $Perm.No $k@58@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1600
;  :arith-assert-lower      2915
;  :arith-assert-upper      1737
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1934
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               589
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12917
;  :mk-clause               7037
;  :num-allocs              6362201
;  :num-checks              491
;  :propagations            5013
;  :quant-instantiations    1636
;  :rlimit-count            414861)
(push) ; 7
(assert (not (< $Perm.No $k@61@04)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               28462
;  :arith-add-rows          737
;  :arith-assert-diseq      1600
;  :arith-assert-lower      2915
;  :arith-assert-upper      1737
;  :arith-bound-prop        255
;  :arith-conflicts         30
;  :arith-eq-adapter        1934
;  :arith-fixed-eqs         879
;  :arith-offset-eqs        297
;  :arith-pivots            591
;  :binary-propagations     16
;  :conflicts               590
;  :datatype-accessor-ax    608
;  :datatype-constructor-ax 6434
;  :datatype-occurs-check   1574
;  :datatype-splits         3856
;  :decisions               6793
;  :del-clause              6996
;  :final-checks            376
;  :interface-eqs           71
;  :max-generation          3
;  :max-memory              5.08
;  :memory                  5.08
;  :minimized-lits          182
;  :mk-bool-var             12917
;  :mk-clause               7037
;  :num-allocs              6362201
;  :num-checks              492
;  :propagations            5013
;  :quant-instantiations    1636
;  :rlimit-count            414909)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@67@04))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@67@04))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))
                                  ($Snap.combine
                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))
                                    ($Snap.combine
                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))
                                      ($Snap.combine
                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))
                                        ($Snap.combine
                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))
                                          ($Snap.combine
                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))
                                            ($Snap.combine
                                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))
                                              ($Snap.combine
                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))
                                                ($Snap.combine
                                                  $Snap.unit
                                                  ($Snap.combine
                                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))
                                                    ($Snap.combine
                                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))
                                                      ($Snap.combine
                                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))
                                                        ($Snap.combine
                                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04)))))))))))))))))))))))))))))
                                                          ($Snap.combine
                                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))
                                                            ($Snap.combine
                                                              $Snap.unit
                                                              ($Snap.combine
                                                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@56@04))))))))))))))))))))))))))))))))
                                                                $Snap.unit)))))))))))))))))))))))))))))))) diz@35@04 globals@36@04))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 6
(push) ; 6
; [else-branch: 116 | First:(Second:($t@67@04))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@67@04)))
      0)
    (- 0 1))))
(pop) ; 6
(pop) ; 5
; [eval] !true
; [then-branch: 121 | False | dead]
; [else-branch: 121 | True | live]
(push) ; 5
; [else-branch: 121 | True]
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
