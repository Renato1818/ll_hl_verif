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
; ---------- ALU___contract_unsatisfiable__get_bit_EncodedGlobalVariables_Integer_Integer ----------
(declare-const diz@0@06 $Ref)
(declare-const globals@1@06 $Ref)
(declare-const value@2@06 Int)
(declare-const pos@3@06 Int)
(declare-const sys__result@4@06 Int)
(declare-const diz@5@06 $Ref)
(declare-const globals@6@06 $Ref)
(declare-const value@7@06 Int)
(declare-const pos@8@06 Int)
(declare-const sys__result@9@06 Int)
(push) ; 1
(declare-const $t@10@06 $Snap)
(assert (= $t@10@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@5@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.ALU_m, wildcard) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && (true && (true && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__2: Int :: { diz.ALU_m.Main_process_state[i__2] } 0 <= i__2 && i__2 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__2] == -1 || 0 <= diz.ALU_m.Main_process_state[i__2] && diz.ALU_m.Main_process_state[i__2] < |diz.ALU_m.Main_event_state|)) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && acc(diz.ALU_m.Main_alu.ALU_data1, write) && acc(diz.ALU_m.Main_alu.ALU_data2, write) && acc(diz.ALU_m.Main_alu.ALU_result, write) && acc(diz.ALU_m.Main_alu.ALU_i, write) && acc(diz.ALU_m.Main_alu.ALU_bit, write) && acc(diz.ALU_m.Main_alu.ALU_divisor, write) && acc(diz.ALU_m.Main_alu.ALU_current_bit, write) && acc(diz.ALU_m.Main_dr, wildcard) && diz.ALU_m.Main_dr != null && acc(diz.ALU_m.Main_dr.Driver_z, write) && acc(diz.ALU_m.Main_dr.Driver_x, write) && acc(diz.ALU_m.Main_dr.Driver_y, write) && acc(diz.ALU_m.Main_dr.Driver_a, write) && acc(diz.ALU_m.Main_mon, wildcard) && diz.ALU_m.Main_mon != null && acc(diz.ALU_m.Main_alu.ALU_m, wildcard) && diz.ALU_m.Main_alu.ALU_m == diz.ALU_m) && diz.ALU_m.Main_alu == diz)
(declare-const $t@11@06 $Snap)
(assert (= $t@11@06 ($Snap.combine ($Snap.first $t@11@06) ($Snap.second $t@11@06))))
(assert (= ($Snap.first $t@11@06) $Snap.unit))
(assert (=
  ($Snap.second $t@11@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@11@06))
    ($Snap.second ($Snap.second $t@11@06)))))
(declare-const $k@12@06 $Perm)
(assert ($Perm.isReadVar $k@12@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@12@06 $Perm.No) (< $Perm.No $k@12@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.03s
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
(assert (<= $Perm.No $k@12@06))
(assert (<= $k@12@06 $Perm.Write))
(assert (implies (< $Perm.No $k@12@06) (not (= diz@5@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@11@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@11@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@11@06))) $Snap.unit))
; [eval] diz.ALU_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@11@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@11@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :memory                3.87
;  :mk-bool-var           278
;  :mk-clause             3
;  :num-allocs            3672376
;  :num-checks            6
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113279)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            7
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          113664
;  :time                  0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            8
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          113933
;  :time                  0.00)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
  $Snap.unit))
; [eval] (forall i__2: Int :: { diz.ALU_m.Main_process_state[i__2] } 0 <= i__2 && i__2 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__2] == -1 || 0 <= diz.ALU_m.Main_process_state[i__2] && diz.ALU_m.Main_process_state[i__2] < |diz.ALU_m.Main_event_state|)
(declare-const i__2@13@06 Int)
(push) ; 3
; [eval] 0 <= i__2 && i__2 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__2] == -1 || 0 <= diz.ALU_m.Main_process_state[i__2] && diz.ALU_m.Main_process_state[i__2] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__2 && i__2 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__2
(push) ; 4
; [then-branch: 0 | 0 <= i__2@13@06 | live]
; [else-branch: 0 | !(0 <= i__2@13@06) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i__2@13@06]
(assert (<= 0 i__2@13@06))
; [eval] i__2 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            9
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114425)
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i__2@13@06)]
(assert (not (<= 0 i__2@13@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i__2@13@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))| && 0 <= i__2@13@06 | live]
; [else-branch: 1 | !(i__2@13@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))| && 0 <= i__2@13@06) | live]
(push) ; 5
; [then-branch: 1 | i__2@13@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))| && 0 <= i__2@13@06]
(assert (and
  (<
    i__2@13@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
  (<= 0 i__2@13@06)))
; [eval] diz.ALU_m.Main_process_state[i__2] == -1 || 0 <= diz.ALU_m.Main_process_state[i__2] && diz.ALU_m.Main_process_state[i__2] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__2] == -1
; [eval] diz.ALU_m.Main_process_state[i__2]
(push) ; 6
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            10
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114586)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__2@13@06 0)))
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
;  :num-allocs            3672376
;  :num-checks            11
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114595)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
    i__2@13@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
      i__2@13@06)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__2] && diz.ALU_m.Main_process_state[i__2] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__2]
; [eval] diz.ALU_m.Main_process_state[i__2]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            12
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114845)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__2@13@06 0)))
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
;  :num-allocs            3672376
;  :num-checks            13
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114854)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
    i__2@13@06)))
; [eval] diz.ALU_m.Main_process_state[i__2] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__2]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            14
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115047)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__2@13@06 0)))
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
;  :num-allocs            3672376
;  :num-checks            15
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115056)
; [eval] |diz.ALU_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            16
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115104)
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))[i__2@13@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
      i__2@13@06))))
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
; [else-branch: 1 | !(i__2@13@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@11@06)))))))| && 0 <= i__2@13@06)]
(assert (not
  (and
    (<
      i__2@13@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
    (<= 0 i__2@13@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__2@13@06 Int)) (!
  (implies
    (and
      (<
        i__2@13@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))
      (<= 0 i__2@13@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
          i__2@13@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
            i__2@13@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
            i__2@13@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))
    i__2@13@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            17
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115819)
(declare-const $k@14@06 $Perm)
(assert ($Perm.isReadVar $k@14@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@14@06 $Perm.No) (< $Perm.No $k@14@06))))
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
;  :num-allocs            3672376
;  :num-checks            18
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116017)
(assert (<= $Perm.No $k@14@06))
(assert (<= $k@14@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@14@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            19
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116370)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            20
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116418)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            21
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          116804)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            22
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          116852)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            23
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117139)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            24
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117187)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            25
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117484)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            26
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117532)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            27
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117839)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            28
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117887)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            29
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118204)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            30
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118252)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            31
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118579)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            32
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118627)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            33
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118964)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            34
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119012)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            35
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119359)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            36
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119407)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            37
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119764)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            38
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119812)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            39
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120179)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            40
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120227)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            41
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120604)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            42
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120652)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            43
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121039)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :memory                3.87
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3672376
;  :num-checks            44
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121087)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3672376
;  :num-checks            45
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121484)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3672376
;  :num-checks            46
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121532)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3796634
;  :num-checks            47
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121939
;  :time                  0.00)
(declare-const $k@15@06 $Perm)
(assert ($Perm.isReadVar $k@15@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@15@06 $Perm.No) (< $Perm.No $k@15@06))))
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
;  :num-allocs            3796634
;  :num-checks            48
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122138)
(assert (<= $Perm.No $k@15@06))
(assert (<= $k@15@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@15@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3796634
;  :num-checks            49
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122641)
(push) ; 3
(assert (not (< $Perm.No $k@15@06)))
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
;  :num-allocs            3796634
;  :num-checks            50
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122689)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3796634
;  :num-checks            51
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123249)
(push) ; 3
(assert (not (< $Perm.No $k@15@06)))
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
;  :num-allocs            3796634
;  :num-checks            52
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123297)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3796634
;  :num-checks            53
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123734)
(push) ; 3
(assert (not (< $Perm.No $k@15@06)))
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
;  :num-allocs            3796634
;  :num-checks            54
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123782)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3796634
;  :num-checks            55
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124229)
(push) ; 3
(assert (not (< $Perm.No $k@15@06)))
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
;  :num-allocs            3796634
;  :num-checks            56
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124277)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3796634
;  :num-checks            57
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124734)
(push) ; 3
(assert (not (< $Perm.No $k@15@06)))
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
;  :num-allocs            3796634
;  :num-checks            58
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124782)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3796634
;  :num-checks            59
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          125249)
(declare-const $k@16@06 $Perm)
(assert ($Perm.isReadVar $k@16@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@16@06 $Perm.No) (< $Perm.No $k@16@06))))
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
;  :num-allocs            3796634
;  :num-checks            60
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          125448)
(assert (<= $Perm.No $k@16@06))
(assert (<= $k@16@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@16@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3796634
;  :num-checks            61
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          126011
;  :time                  0.00)
(push) ; 3
(assert (not (< $Perm.No $k@16@06)))
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
;  :num-allocs            3796634
;  :num-checks            62
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          126059)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs            3796634
;  :num-checks            63
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          126661)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs            3796634
;  :num-checks            64
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          126709)
(declare-const $k@17@06 $Perm)
(assert ($Perm.isReadVar $k@17@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@17@06 $Perm.No) (< $Perm.No $k@17@06))))
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
;  :num-allocs            3796634
;  :num-checks            65
;  :propagations          23
;  :quant-instantiations  11
;  :rlimit-count          126907)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@5@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))
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
;  :num-allocs              3796634
;  :num-checks              66
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            127815
;  :time                    0.00)
(assert (<= $Perm.No $k@17@06))
(assert (<= $k@17@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@17@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_m == diz.ALU_m
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs              3796634
;  :num-checks              67
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128398)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs              3796634
;  :num-checks              68
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128446)
(push) ; 3
(assert (not (< $Perm.No $k@17@06)))
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
;  :num-allocs              3796634
;  :num-checks              69
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128494)
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs              3796634
;  :num-checks              70
;  :propagations            23
;  :quant-instantiations    11
;  :rlimit-count            128542)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 3
(assert (not (< $Perm.No $k@12@06)))
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
;  :num-allocs              3796634
;  :num-checks              71
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            129103)
(push) ; 3
(assert (not (< $Perm.No $k@14@06)))
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
;  :num-allocs              3796634
;  :num-checks              72
;  :propagations            23
;  :quant-instantiations    12
;  :rlimit-count            129151)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06)))))))))))))
  diz@5@06))
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
  diz@5@06
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))
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
;  :num-allocs              3926316
;  :num-checks              76
;  :propagations            25
;  :quant-instantiations    12
;  :rlimit-count            131351)
(declare-const $t@18@06 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@12@06)
    (=
      $t@18@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@11@06)))))
  (implies
    (< $Perm.No $k@17@06)
    (=
      $t@18@06
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@11@06))))))))))))))))))))))))))))))))))))))))
(assert (<= $Perm.No (+ $k@12@06 $k@17@06)))
(assert (<= (+ $k@12@06 $k@17@06) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@12@06 $k@17@06)) (not (= diz@5@06 $Ref.null))))
(check-sat)
; unknown
(pop) ; 2
(pop) ; 1
; ---------- Driver___contract_unsatisfiable__run_EncodedGlobalVariables ----------
(declare-const diz@19@06 $Ref)
(declare-const globals@20@06 $Ref)
(declare-const diz@21@06 $Ref)
(declare-const globals@22@06 $Ref)
(push) ; 1
(declare-const $t@23@06 $Snap)
(assert (= $t@23@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@21@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Driver_m, wildcard) && diz.Driver_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.Driver_m, globals), write) && (true && (true && acc(diz.Driver_m.Main_process_state, write) && |diz.Driver_m.Main_process_state| == 1 && acc(diz.Driver_m.Main_event_state, write) && |diz.Driver_m.Main_event_state| == 2 && (forall i__58: Int :: { diz.Driver_m.Main_process_state[i__58] } 0 <= i__58 && i__58 < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i__58] == -1 || 0 <= diz.Driver_m.Main_process_state[i__58] && diz.Driver_m.Main_process_state[i__58] < |diz.Driver_m.Main_event_state|)) && acc(diz.Driver_m.Main_alu, wildcard) && diz.Driver_m.Main_alu != null && acc(diz.Driver_m.Main_alu.ALU_OPCODE, write) && acc(diz.Driver_m.Main_alu.ALU_OP1, write) && acc(diz.Driver_m.Main_alu.ALU_OP2, write) && acc(diz.Driver_m.Main_alu.ALU_CARRY, write) && acc(diz.Driver_m.Main_alu.ALU_ZERO, write) && acc(diz.Driver_m.Main_alu.ALU_RESULT, write) && acc(diz.Driver_m.Main_alu.ALU_data1, write) && acc(diz.Driver_m.Main_alu.ALU_data2, write) && acc(diz.Driver_m.Main_alu.ALU_result, write) && acc(diz.Driver_m.Main_alu.ALU_i, write) && acc(diz.Driver_m.Main_alu.ALU_bit, write) && acc(diz.Driver_m.Main_alu.ALU_divisor, write) && acc(diz.Driver_m.Main_alu.ALU_current_bit, write) && acc(diz.Driver_m.Main_dr, wildcard) && diz.Driver_m.Main_dr != null && acc(diz.Driver_m.Main_dr.Driver_z, write) && acc(diz.Driver_m.Main_dr.Driver_x, write) && acc(diz.Driver_m.Main_dr.Driver_y, write) && acc(diz.Driver_m.Main_dr.Driver_a, write) && acc(diz.Driver_m.Main_mon, wildcard) && diz.Driver_m.Main_mon != null && acc(diz.Driver_m.Main_alu.ALU_m, wildcard) && diz.Driver_m.Main_alu.ALU_m == diz.Driver_m) && diz.Driver_m.Main_dr == diz)
(declare-const $t@24@06 $Snap)
(assert (= $t@24@06 ($Snap.combine ($Snap.first $t@24@06) ($Snap.second $t@24@06))))
(assert (= ($Snap.first $t@24@06) $Snap.unit))
(assert (=
  ($Snap.second $t@24@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@06))
    ($Snap.second ($Snap.second $t@24@06)))))
(declare-const $k@25@06 $Perm)
(assert ($Perm.isReadVar $k@25@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@25@06 $Perm.No) (< $Perm.No $k@25@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               548
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
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             444
;  :mk-clause               22
;  :num-allocs              3926316
;  :num-checks              79
;  :propagations            27
;  :quant-instantiations    12
;  :rlimit-count            133048)
(assert (<= $Perm.No $k@25@06))
(assert (<= $k@25@06 $Perm.Write))
(assert (implies (< $Perm.No $k@25@06) (not (= diz@21@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@24@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@24@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@24@06))) $Snap.unit))
; [eval] diz.Driver_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               554
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
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             447
;  :mk-clause               22
;  :num-allocs              3926316
;  :num-checks              80
;  :propagations            27
;  :quant-instantiations    12
;  :rlimit-count            133301)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@24@06))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@24@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               560
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
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             450
;  :mk-clause               22
;  :num-allocs              3926316
;  :num-checks              81
;  :propagations            27
;  :quant-instantiations    13
;  :rlimit-count            133585)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               577
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      17
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               73
;  :datatype-accessor-ax    50
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             455
;  :mk-clause               22
;  :num-allocs              3926316
;  :num-checks              82
;  :propagations            27
;  :quant-instantiations    13
;  :rlimit-count            134025)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_process_state| == 1
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               583
;  :arith-assert-diseq      9
;  :arith-assert-lower      25
;  :arith-assert-upper      17
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               74
;  :datatype-accessor-ax    51
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             457
;  :mk-clause               22
;  :num-allocs              3926316
;  :num-checks              83
;  :propagations            27
;  :quant-instantiations    13
;  :rlimit-count            134274
;  :time                    0.01)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-assert-diseq      10
;  :arith-assert-lower      28
;  :arith-assert-upper      18
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    52
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             466
;  :mk-clause               25
;  :num-allocs              3926316
;  :num-checks              84
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            134659)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_event_state| == 2
; [eval] |diz.Driver_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               596
;  :arith-assert-diseq      10
;  :arith-assert-lower      28
;  :arith-assert-upper      18
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             468
;  :mk-clause               25
;  :num-allocs              3926316
;  :num-checks              85
;  :propagations            28
;  :quant-instantiations    16
;  :rlimit-count            134928)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))
  $Snap.unit))
; [eval] (forall i__58: Int :: { diz.Driver_m.Main_process_state[i__58] } 0 <= i__58 && i__58 < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i__58] == -1 || 0 <= diz.Driver_m.Main_process_state[i__58] && diz.Driver_m.Main_process_state[i__58] < |diz.Driver_m.Main_event_state|)
(declare-const i__58@26@06 Int)
(push) ; 3
; [eval] 0 <= i__58 && i__58 < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i__58] == -1 || 0 <= diz.Driver_m.Main_process_state[i__58] && diz.Driver_m.Main_process_state[i__58] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= i__58 && i__58 < |diz.Driver_m.Main_process_state|
; [eval] 0 <= i__58
(push) ; 4
; [then-branch: 4 | 0 <= i__58@26@06 | live]
; [else-branch: 4 | !(0 <= i__58@26@06) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i__58@26@06]
(assert (<= 0 i__58@26@06))
; [eval] i__58 < |diz.Driver_m.Main_process_state|
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               604
;  :arith-assert-diseq      11
;  :arith-assert-lower      32
;  :arith-assert-upper      19
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         1
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             479
;  :mk-clause               28
;  :num-allocs              3926316
;  :num-checks              86
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135419)
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i__58@26@06)]
(assert (not (<= 0 i__58@26@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i__58@26@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))| && 0 <= i__58@26@06 | live]
; [else-branch: 5 | !(i__58@26@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))| && 0 <= i__58@26@06) | live]
(push) ; 5
; [then-branch: 5 | i__58@26@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))| && 0 <= i__58@26@06]
(assert (and
  (<
    i__58@26@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))
  (<= 0 i__58@26@06)))
; [eval] diz.Driver_m.Main_process_state[i__58] == -1 || 0 <= diz.Driver_m.Main_process_state[i__58] && diz.Driver_m.Main_process_state[i__58] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i__58] == -1
; [eval] diz.Driver_m.Main_process_state[i__58]
(push) ; 6
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      20
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             481
;  :mk-clause               28
;  :num-allocs              3926316
;  :num-checks              87
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135580)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__58@26@06 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      20
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             481
;  :mk-clause               28
;  :num-allocs              3926316
;  :num-checks              88
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135589)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))[i__58@26@06] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))[i__58@26@06] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))[i__58@26@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
    i__58@26@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))[i__58@26@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
      i__58@26@06)
    (- 0 1))))
; [eval] 0 <= diz.Driver_m.Main_process_state[i__58] && diz.Driver_m.Main_process_state[i__58] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= diz.Driver_m.Main_process_state[i__58]
; [eval] diz.Driver_m.Main_process_state[i__58]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      20
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             482
;  :mk-clause               28
;  :num-allocs              3926316
;  :num-checks              89
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135839)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__58@26@06 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      11
;  :arith-assert-lower      33
;  :arith-assert-upper      20
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             482
;  :mk-clause               28
;  :num-allocs              3926316
;  :num-checks              90
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            135848)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))[i__58@26@06] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))[i__58@26@06]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))[i__58@26@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
    i__58@26@06)))
; [eval] diz.Driver_m.Main_process_state[i__58] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i__58]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             485
;  :mk-clause               29
;  :num-allocs              3926316
;  :num-checks              91
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            136041)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__58@26@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             485
;  :mk-clause               29
;  :num-allocs              3926316
;  :num-checks              92
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            136050)
; [eval] |diz.Driver_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               605
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              19
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             485
;  :mk-clause               29
;  :num-allocs              3926316
;  :num-checks              93
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            136098)
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))[i__58@26@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
      i__58@26@06))))
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
; [else-branch: 5 | !(i__58@26@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@24@06)))))))| && 0 <= i__58@26@06)]
(assert (not
  (and
    (<
      i__58@26@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))
    (<= 0 i__58@26@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__58@26@06 Int)) (!
  (implies
    (and
      (<
        i__58@26@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))
      (<= 0 i__58@26@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
          i__58@26@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
            i__58@26@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
            i__58@26@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))
    i__58@26@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               610
;  :arith-assert-diseq      12
;  :arith-assert-lower      36
;  :arith-assert-upper      20
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             487
;  :mk-clause               29
;  :num-allocs              3926316
;  :num-checks              94
;  :propagations            29
;  :quant-instantiations    19
;  :rlimit-count            136813)
(declare-const $k@27@06 $Perm)
(assert ($Perm.isReadVar $k@27@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@27@06 $Perm.No) (< $Perm.No $k@27@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               610
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      21
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               83
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             491
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              95
;  :propagations            30
;  :quant-instantiations    19
;  :rlimit-count            137011)
(assert (<= $Perm.No $k@27@06))
(assert (<= $k@27@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@27@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@24@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               616
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             494
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              96
;  :propagations            30
;  :quant-instantiations    19
;  :rlimit-count            137364)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               616
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             494
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              97
;  :propagations            30
;  :quant-instantiations    19
;  :rlimit-count            137412)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               622
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               86
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             497
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              98
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            137798)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               622
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             497
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              99
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            137846)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               627
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             498
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              100
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138133)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               627
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               89
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             498
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              101
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138181)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               632
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             499
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              102
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138478)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               632
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               91
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             499
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              103
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138526)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               637
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             500
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              104
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138833
;  :time                    0.00)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               637
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               93
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             500
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              105
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            138881)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               642
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               94
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             501
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              106
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139198)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               642
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               95
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             501
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              107
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139246)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               647
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             502
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              108
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139573)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               647
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             502
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              109
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139621)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               652
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               98
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             503
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              110
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            139958)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               652
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               99
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             503
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              111
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            140006)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               657
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             504
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              112
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            140353)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               657
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               101
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             504
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              113
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            140401)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               662
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               102
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             505
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              114
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            140758)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               662
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               103
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             505
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              115
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            140806)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               667
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               104
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             506
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              116
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            141173)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               667
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               105
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             506
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              117
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            141221)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               672
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               106
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             507
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              118
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            141598)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               672
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               107
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             507
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              119
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            141646)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               677
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               108
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             508
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              120
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            142033)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               677
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               109
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             508
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              121
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            142081)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               682
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               110
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             509
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              122
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            142478)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               682
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               111
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             509
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              123
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            142526)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               687
;  :arith-assert-diseq      13
;  :arith-assert-lower      38
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               112
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             510
;  :mk-clause               31
;  :num-allocs              3926316
;  :num-checks              124
;  :propagations            30
;  :quant-instantiations    20
;  :rlimit-count            142933)
(declare-const $k@28@06 $Perm)
(assert ($Perm.isReadVar $k@28@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@28@06 $Perm.No) (< $Perm.No $k@28@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               687
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      23
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               113
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             514
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              125
;  :propagations            31
;  :quant-instantiations    20
;  :rlimit-count            143132)
(assert (<= $Perm.No $k@28@06))
(assert (<= $k@28@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@28@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@24@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               693
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               114
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             517
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              126
;  :propagations            31
;  :quant-instantiations    20
;  :rlimit-count            143635)
(push) ; 3
(assert (not (< $Perm.No $k@28@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               693
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               115
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             517
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              127
;  :propagations            31
;  :quant-instantiations    20
;  :rlimit-count            143683)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               699
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               116
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             520
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              128
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            144243)
(push) ; 3
(assert (not (< $Perm.No $k@28@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               699
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               117
;  :datatype-accessor-ax    72
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             520
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              129
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            144291)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               704
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               118
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             521
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              130
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            144728)
(push) ; 3
(assert (not (< $Perm.No $k@28@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               704
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               119
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             521
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              131
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            144776)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               709
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               120
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             522
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              132
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            145223)
(push) ; 3
(assert (not (< $Perm.No $k@28@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               709
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               121
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             522
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              133
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            145271)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               714
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               122
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             523
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              134
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            145728)
(push) ; 3
(assert (not (< $Perm.No $k@28@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               714
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               123
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             523
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              135
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            145776)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               719
;  :arith-assert-diseq      14
;  :arith-assert-lower      40
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               124
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             524
;  :mk-clause               33
;  :num-allocs              3926316
;  :num-checks              136
;  :propagations            31
;  :quant-instantiations    21
;  :rlimit-count            146243)
(declare-const $k@29@06 $Perm)
(assert ($Perm.isReadVar $k@29@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@29@06 $Perm.No) (< $Perm.No $k@29@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               719
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      25
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               125
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             528
;  :mk-clause               35
;  :num-allocs              3926316
;  :num-checks              137
;  :propagations            32
;  :quant-instantiations    21
;  :rlimit-count            146442)
(assert (<= $Perm.No $k@29@06))
(assert (<= $k@29@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@29@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@24@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               725
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               126
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             531
;  :mk-clause               35
;  :num-allocs              3926316
;  :num-checks              138
;  :propagations            32
;  :quant-instantiations    21
;  :rlimit-count            147005)
(push) ; 3
(assert (not (< $Perm.No $k@29@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               725
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               127
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             531
;  :mk-clause               35
;  :num-allocs              3926316
;  :num-checks              139
;  :propagations            32
;  :quant-instantiations    21
;  :rlimit-count            147053)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               731
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               128
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             534
;  :mk-clause               35
;  :num-allocs              3926316
;  :num-checks              140
;  :propagations            32
;  :quant-instantiations    22
;  :rlimit-count            147655)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               731
;  :arith-assert-diseq      15
;  :arith-assert-lower      42
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               129
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             534
;  :mk-clause               35
;  :num-allocs              3926316
;  :num-checks              141
;  :propagations            32
;  :quant-instantiations    22
;  :rlimit-count            147703)
(declare-const $k@30@06 $Perm)
(assert ($Perm.isReadVar $k@30@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@30@06 $Perm.No) (< $Perm.No $k@30@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               731
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      27
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               130
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             538
;  :mk-clause               37
;  :num-allocs              3926316
;  :num-checks              142
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            147902)
(assert (<= $Perm.No $k@30@06))
(assert (<= $k@30@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@30@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06)))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu.ALU_m == diz.Driver_m
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               737
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               131
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             541
;  :mk-clause               37
;  :num-allocs              3926316
;  :num-checks              143
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            148485)
(push) ; 3
(assert (not (< $Perm.No $k@27@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               737
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               132
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             541
;  :mk-clause               37
;  :num-allocs              3926316
;  :num-checks              144
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            148533)
(push) ; 3
(assert (not (< $Perm.No $k@30@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               737
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               133
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             541
;  :mk-clause               37
;  :num-allocs              3926316
;  :num-checks              145
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            148581)
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               737
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               134
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             541
;  :mk-clause               37
;  :num-allocs              3926316
;  :num-checks              146
;  :propagations            33
;  :quant-instantiations    22
;  :rlimit-count            148629)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@24@06)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr == diz
(push) ; 3
(assert (not (< $Perm.No $k@25@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               741
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               135
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             544
;  :mk-clause               37
;  :num-allocs              3926316
;  :num-checks              147
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            149190)
(push) ; 3
(assert (not (< $Perm.No $k@28@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               741
;  :arith-assert-diseq      16
;  :arith-assert-lower      44
;  :arith-assert-upper      28
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               136
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   26
;  :datatype-splits         60
;  :decisions               129
;  :del-clause              20
;  :final-checks            14
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             544
;  :mk-clause               37
;  :num-allocs              3926316
;  :num-checks              148
;  :propagations            33
;  :quant-instantiations    23
;  :rlimit-count            149238)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@06))))))))))))))))))))))))))))
  diz@21@06))
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
(declare-const diz@31@06 $Ref)
(declare-const globals@32@06 $Ref)
(declare-const m_param@33@06 $Ref)
(declare-const diz@34@06 $Ref)
(declare-const globals@35@06 $Ref)
(declare-const m_param@36@06 $Ref)
(push) ; 1
(declare-const $t@37@06 $Snap)
(assert (= $t@37@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@34@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@38@06 $Snap)
(assert (= $t@38@06 ($Snap.combine ($Snap.first $t@38@06) ($Snap.second $t@38@06))))
(assert (= ($Snap.first $t@38@06) $Snap.unit))
(assert (= ($Snap.second $t@38@06) $Snap.unit))
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
(declare-const globals@39@06 $Ref)
(declare-const m_param@40@06 $Ref)
(declare-const sys__result@41@06 $Ref)
(declare-const globals@42@06 $Ref)
(declare-const m_param@43@06 $Ref)
(declare-const sys__result@44@06 $Ref)
(push) ; 1
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@45@06 $Snap)
(assert (= $t@45@06 ($Snap.combine ($Snap.first $t@45@06) ($Snap.second $t@45@06))))
(assert (= ($Snap.first $t@45@06) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@44@06 $Ref.null)))
(assert (=
  ($Snap.second $t@45@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@45@06))
    ($Snap.second ($Snap.second $t@45@06)))))
(assert (= ($Snap.first ($Snap.second $t@45@06)) $Snap.unit))
; [eval] type_of(sys__result) == class_Monitor()
; [eval] type_of(sys__result)
; [eval] class_Monitor()
(assert (= (type_of<TYPE> sys__result@44@06) (as class_Monitor<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@45@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@45@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@45@06))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@45@06))) $Snap.unit))
; [eval] sys__result.Monitor_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@45@06))))
  m_param@43@06))
(pop) ; 2
(push) ; 2
; [exec]
; var diz__92: Ref
(declare-const diz__92@46@06 $Ref)
; [exec]
; diz__92 := new(Monitor_m)
(declare-const diz__92@47@06 $Ref)
(assert (not (= diz__92@47@06 $Ref.null)))
(declare-const Monitor_m@48@06 $Ref)
(assert (not (= diz__92@47@06 diz__92@46@06)))
(assert (not (= diz__92@47@06 globals@42@06)))
(assert (not (= diz__92@47@06 m_param@43@06)))
(assert (not (= diz__92@47@06 sys__result@44@06)))
; [exec]
; inhale type_of(diz__92) == class_Monitor()
(declare-const $t@49@06 $Snap)
(assert (= $t@49@06 $Snap.unit))
; [eval] type_of(diz__92) == class_Monitor()
; [eval] type_of(diz__92)
; [eval] class_Monitor()
(assert (= (type_of<TYPE> diz__92@47@06) (as class_Monitor<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; diz__92.Monitor_m := m_param
; [exec]
; sys__result := diz__92
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Monitor() && acc(sys__result.Monitor_m, write) && sys__result.Monitor_m == m_param
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Monitor()
; [eval] type_of(sys__result)
; [eval] class_Monitor()
; [eval] sys__result.Monitor_m == m_param
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Monitor___contract_unsatisfiable__main_method_EncodedGlobalVariables_Integer ----------
(declare-const diz@50@06 $Ref)
(declare-const globals@51@06 $Ref)
(declare-const process_id@52@06 Int)
(declare-const diz@53@06 $Ref)
(declare-const globals@54@06 $Ref)
(declare-const process_id@55@06 Int)
(push) ; 1
(declare-const $t@56@06 $Snap)
(assert (= $t@56@06 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@53@06 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.Monitor_m, wildcard) && diz.Monitor_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.Monitor_m, globals), write) && (true && (true && acc(diz.Monitor_m.Main_process_state, write) && |diz.Monitor_m.Main_process_state| == 1 && acc(diz.Monitor_m.Main_event_state, write) && |diz.Monitor_m.Main_event_state| == 2 && (forall i__93: Int :: { diz.Monitor_m.Main_process_state[i__93] } 0 <= i__93 && i__93 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__93] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__93] && diz.Monitor_m.Main_process_state[i__93] < |diz.Monitor_m.Main_event_state|)) && acc(diz.Monitor_m.Main_alu, wildcard) && diz.Monitor_m.Main_alu != null && acc(diz.Monitor_m.Main_alu.ALU_OPCODE, write) && acc(diz.Monitor_m.Main_alu.ALU_OP1, write) && acc(diz.Monitor_m.Main_alu.ALU_OP2, write) && acc(diz.Monitor_m.Main_alu.ALU_CARRY, write) && acc(diz.Monitor_m.Main_alu.ALU_ZERO, write) && acc(diz.Monitor_m.Main_alu.ALU_RESULT, write) && acc(diz.Monitor_m.Main_alu.ALU_data1, write) && acc(diz.Monitor_m.Main_alu.ALU_data2, write) && acc(diz.Monitor_m.Main_alu.ALU_result, write) && acc(diz.Monitor_m.Main_alu.ALU_i, write) && acc(diz.Monitor_m.Main_alu.ALU_bit, write) && acc(diz.Monitor_m.Main_alu.ALU_divisor, write) && acc(diz.Monitor_m.Main_alu.ALU_current_bit, write) && acc(diz.Monitor_m.Main_dr, wildcard) && diz.Monitor_m.Main_dr != null && acc(diz.Monitor_m.Main_dr.Driver_z, write) && acc(diz.Monitor_m.Main_dr.Driver_x, write) && acc(diz.Monitor_m.Main_dr.Driver_y, write) && acc(diz.Monitor_m.Main_dr.Driver_a, write) && acc(diz.Monitor_m.Main_mon, wildcard) && diz.Monitor_m.Main_mon != null && acc(diz.Monitor_m.Main_alu.ALU_m, wildcard) && diz.Monitor_m.Main_alu.ALU_m == diz.Monitor_m) && diz.Monitor_m.Main_mon == diz && (0 <= process_id && process_id < |diz.Monitor_m.Main_process_state|))
(declare-const $t@57@06 $Snap)
(assert (= $t@57@06 ($Snap.combine ($Snap.first $t@57@06) ($Snap.second $t@57@06))))
(assert (= ($Snap.first $t@57@06) $Snap.unit))
(assert (=
  ($Snap.second $t@57@06)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@57@06))
    ($Snap.second ($Snap.second $t@57@06)))))
(declare-const $k@58@06 $Perm)
(assert ($Perm.isReadVar $k@58@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@58@06 $Perm.No) (< $Perm.No $k@58@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1017
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      29
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               138
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             602
;  :mk-clause               40
;  :num-allocs              3926316
;  :num-checks              161
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            155495)
(assert (<= $Perm.No $k@58@06))
(assert (<= $k@58@06 $Perm.Write))
(assert (implies (< $Perm.No $k@58@06) (not (= diz@53@06 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@57@06))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@57@06)))
    ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@57@06))) $Snap.unit))
; [eval] diz.Monitor_m != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1023
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               139
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             605
;  :mk-clause               40
;  :num-allocs              3926316
;  :num-checks              162
;  :propagations            37
;  :quant-instantiations    23
;  :rlimit-count            155748)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@57@06))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@57@06)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@57@06))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1029
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               140
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             608
;  :mk-clause               40
;  :num-allocs              3926316
;  :num-checks              163
;  :propagations            37
;  :quant-instantiations    24
;  :rlimit-count            156032)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1046
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               141
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             613
;  :mk-clause               40
;  :num-allocs              3926316
;  :num-checks              164
;  :propagations            37
;  :quant-instantiations    24
;  :rlimit-count            156472)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
  $Snap.unit))
; [eval] |diz.Monitor_m.Main_process_state| == 1
; [eval] |diz.Monitor_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1052
;  :arith-assert-diseq      17
;  :arith-assert-lower      46
;  :arith-assert-upper      30
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               142
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             615
;  :mk-clause               40
;  :num-allocs              3926316
;  :num-checks              165
;  :propagations            37
;  :quant-instantiations    24
;  :rlimit-count            156721)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1059
;  :arith-assert-diseq      18
;  :arith-assert-lower      49
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               143
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             624
;  :mk-clause               43
;  :num-allocs              3926316
;  :num-checks              166
;  :propagations            38
;  :quant-instantiations    27
;  :rlimit-count            157106)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))
  $Snap.unit))
; [eval] |diz.Monitor_m.Main_event_state| == 2
; [eval] |diz.Monitor_m.Main_event_state|
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1065
;  :arith-assert-diseq      18
;  :arith-assert-lower      49
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               144
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             626
;  :mk-clause               43
;  :num-allocs              3926316
;  :num-checks              167
;  :propagations            38
;  :quant-instantiations    27
;  :rlimit-count            157375)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))
  $Snap.unit))
; [eval] (forall i__93: Int :: { diz.Monitor_m.Main_process_state[i__93] } 0 <= i__93 && i__93 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__93] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__93] && diz.Monitor_m.Main_process_state[i__93] < |diz.Monitor_m.Main_event_state|)
(declare-const i__93@59@06 Int)
(push) ; 3
; [eval] 0 <= i__93 && i__93 < |diz.Monitor_m.Main_process_state| ==> diz.Monitor_m.Main_process_state[i__93] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__93] && diz.Monitor_m.Main_process_state[i__93] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= i__93 && i__93 < |diz.Monitor_m.Main_process_state|
; [eval] 0 <= i__93
(push) ; 4
; [then-branch: 8 | 0 <= i__93@59@06 | live]
; [else-branch: 8 | !(0 <= i__93@59@06) | live]
(push) ; 5
; [then-branch: 8 | 0 <= i__93@59@06]
(assert (<= 0 i__93@59@06))
; [eval] i__93 < |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_process_state|
(push) ; 6
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1073
;  :arith-assert-diseq      19
;  :arith-assert-lower      53
;  :arith-assert-upper      32
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               145
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             637
;  :mk-clause               46
;  :num-allocs              3926316
;  :num-checks              168
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            157867)
(pop) ; 5
(push) ; 5
; [else-branch: 8 | !(0 <= i__93@59@06)]
(assert (not (<= 0 i__93@59@06)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 9 | i__93@59@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))| && 0 <= i__93@59@06 | live]
; [else-branch: 9 | !(i__93@59@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))| && 0 <= i__93@59@06) | live]
(push) ; 5
; [then-branch: 9 | i__93@59@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))| && 0 <= i__93@59@06]
(assert (and
  (<
    i__93@59@06
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))
  (<= 0 i__93@59@06)))
; [eval] diz.Monitor_m.Main_process_state[i__93] == -1 || 0 <= diz.Monitor_m.Main_process_state[i__93] && diz.Monitor_m.Main_process_state[i__93] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__93] == -1
; [eval] diz.Monitor_m.Main_process_state[i__93]
(push) ; 6
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1074
;  :arith-assert-diseq      19
;  :arith-assert-lower      54
;  :arith-assert-upper      33
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               146
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             639
;  :mk-clause               46
;  :num-allocs              3926316
;  :num-checks              169
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            158028)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i__93@59@06 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1074
;  :arith-assert-diseq      19
;  :arith-assert-lower      54
;  :arith-assert-upper      33
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               146
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             639
;  :mk-clause               46
;  :num-allocs              3926316
;  :num-checks              170
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            158037)
; [eval] -1
(push) ; 6
; [then-branch: 10 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))[i__93@59@06] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))[i__93@59@06] != -1 | live]
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))[i__93@59@06] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
    i__93@59@06)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 10 | First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))[i__93@59@06] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
      i__93@59@06)
    (- 0 1))))
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__93] && diz.Monitor_m.Main_process_state[i__93] < |diz.Monitor_m.Main_event_state|
; [eval] 0 <= diz.Monitor_m.Main_process_state[i__93]
; [eval] diz.Monitor_m.Main_process_state[i__93]
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1074
;  :arith-assert-diseq      19
;  :arith-assert-lower      54
;  :arith-assert-upper      33
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               147
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             640
;  :mk-clause               46
;  :num-allocs              3926316
;  :num-checks              171
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            158287)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i__93@59@06 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1074
;  :arith-assert-diseq      19
;  :arith-assert-lower      54
;  :arith-assert-upper      33
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               147
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             640
;  :mk-clause               46
;  :num-allocs              3926316
;  :num-checks              172
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            158296)
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))[i__93@59@06] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))[i__93@59@06]) | live]
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))[i__93@59@06]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
    i__93@59@06)))
; [eval] diz.Monitor_m.Main_process_state[i__93] < |diz.Monitor_m.Main_event_state|
; [eval] diz.Monitor_m.Main_process_state[i__93]
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1074
;  :arith-assert-diseq      20
;  :arith-assert-lower      57
;  :arith-assert-upper      33
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             643
;  :mk-clause               47
;  :num-allocs              3926316
;  :num-checks              173
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            158489)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i__93@59@06 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1074
;  :arith-assert-diseq      20
;  :arith-assert-lower      57
;  :arith-assert-upper      33
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               148
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             643
;  :mk-clause               47
;  :num-allocs              3926316
;  :num-checks              174
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            158498)
; [eval] |diz.Monitor_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1074
;  :arith-assert-diseq      20
;  :arith-assert-lower      57
;  :arith-assert-upper      33
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               149
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              37
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             643
;  :mk-clause               47
;  :num-allocs              3926316
;  :num-checks              175
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            158546)
(pop) ; 9
(push) ; 9
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))[i__93@59@06])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
      i__93@59@06))))
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
; [else-branch: 9 | !(i__93@59@06 < |First:(Second:(Second:(Second:(Second:(Second:(Second:($t@57@06)))))))| && 0 <= i__93@59@06)]
(assert (not
  (and
    (<
      i__93@59@06
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))
    (<= 0 i__93@59@06))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__93@59@06 Int)) (!
  (implies
    (and
      (<
        i__93@59@06
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))
      (<= 0 i__93@59@06))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
          i__93@59@06)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
            i__93@59@06)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
            i__93@59@06)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))
    i__93@59@06))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1079
;  :arith-assert-diseq      20
;  :arith-assert-lower      57
;  :arith-assert-upper      33
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               150
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             645
;  :mk-clause               47
;  :num-allocs              3926316
;  :num-checks              176
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            159261)
(declare-const $k@60@06 $Perm)
(assert ($Perm.isReadVar $k@60@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@60@06 $Perm.No) (< $Perm.No $k@60@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1079
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      34
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               151
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             649
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              177
;  :propagations            40
;  :quant-instantiations    30
;  :rlimit-count            159460)
(assert (<= $Perm.No $k@60@06))
(assert (<= $k@60@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@60@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@57@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1085
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               152
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             652
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              178
;  :propagations            40
;  :quant-instantiations    30
;  :rlimit-count            159813)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1085
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               153
;  :datatype-accessor-ax    100
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             652
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              179
;  :propagations            40
;  :quant-instantiations    30
;  :rlimit-count            159861)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1091
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               154
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             655
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              180
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            160247)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1091
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               155
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             655
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              181
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            160295)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1096
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               156
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             656
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              182
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            160582)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1096
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               157
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             656
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              183
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            160630)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1101
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               158
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             657
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              184
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            160927)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1101
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               159
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             657
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              185
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            160975)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               160
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             658
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              186
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            161282)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1106
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               161
;  :datatype-accessor-ax    104
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             658
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              187
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            161330)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1111
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               162
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             659
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              188
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            161647)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1111
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               163
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             659
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              189
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            161695)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1116
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               164
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             660
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              190
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            162022)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1116
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               165
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             660
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              191
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            162070)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1121
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               166
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             661
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              192
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            162407)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1121
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               167
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             661
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              193
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            162455)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1126
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               168
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             662
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              194
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            162802)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1126
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               169
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             662
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              195
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            162850)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1131
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               170
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             663
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              196
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            163207)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1131
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               171
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             663
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              197
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            163255)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1136
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               172
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             664
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              198
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            163622)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1136
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               173
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             664
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              199
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            163670)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1141
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               174
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              200
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            164047)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1141
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               175
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             665
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              201
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            164095)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1146
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               176
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             666
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              202
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            164482)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1146
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               177
;  :datatype-accessor-ax    112
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             666
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              203
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            164530)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1151
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               178
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             667
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              204
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            164927)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1151
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               179
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             667
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              205
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            164975)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1156
;  :arith-assert-diseq      21
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               180
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             668
;  :mk-clause               49
;  :num-allocs              3926316
;  :num-checks              206
;  :propagations            40
;  :quant-instantiations    31
;  :rlimit-count            165382)
(declare-const $k@61@06 $Perm)
(assert ($Perm.isReadVar $k@61@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@61@06 $Perm.No) (< $Perm.No $k@61@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1156
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      36
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               181
;  :datatype-accessor-ax    114
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             672
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              207
;  :propagations            41
;  :quant-instantiations    31
;  :rlimit-count            165580)
(assert (<= $Perm.No $k@61@06))
(assert (<= $k@61@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@61@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@57@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_dr != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1162
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               182
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             675
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              208
;  :propagations            41
;  :quant-instantiations    31
;  :rlimit-count            166083)
(push) ; 3
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1162
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               183
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             675
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              209
;  :propagations            41
;  :quant-instantiations    31
;  :rlimit-count            166131)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1168
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               184
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             678
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              210
;  :propagations            41
;  :quant-instantiations    32
;  :rlimit-count            166691)
(push) ; 3
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1168
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               185
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             678
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              211
;  :propagations            41
;  :quant-instantiations    32
;  :rlimit-count            166739)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1173
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               186
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             679
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              212
;  :propagations            41
;  :quant-instantiations    32
;  :rlimit-count            167176)
(push) ; 3
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1173
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               187
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             679
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              213
;  :propagations            41
;  :quant-instantiations    32
;  :rlimit-count            167224)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1178
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               188
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             680
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              214
;  :propagations            41
;  :quant-instantiations    32
;  :rlimit-count            167671)
(push) ; 3
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1178
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               189
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             680
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              215
;  :propagations            41
;  :quant-instantiations    32
;  :rlimit-count            167719)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1183
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               190
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             681
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              216
;  :propagations            41
;  :quant-instantiations    32
;  :rlimit-count            168176)
(push) ; 3
(assert (not (< $Perm.No $k@61@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1183
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               191
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             681
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              217
;  :propagations            41
;  :quant-instantiations    32
;  :rlimit-count            168224)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-assert-diseq      22
;  :arith-assert-lower      61
;  :arith-assert-upper      37
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               192
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             682
;  :mk-clause               51
;  :num-allocs              3926316
;  :num-checks              218
;  :propagations            41
;  :quant-instantiations    32
;  :rlimit-count            168691)
(declare-const $k@62@06 $Perm)
(assert ($Perm.isReadVar $k@62@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@62@06 $Perm.No) (< $Perm.No $k@62@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1188
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      38
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               193
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             686
;  :mk-clause               53
;  :num-allocs              3926316
;  :num-checks              219
;  :propagations            42
;  :quant-instantiations    32
;  :rlimit-count            168889)
(assert (<= $Perm.No $k@62@06))
(assert (<= $k@62@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@62@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@57@06)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1194
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      39
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               194
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             689
;  :mk-clause               53
;  :num-allocs              3926316
;  :num-checks              220
;  :propagations            42
;  :quant-instantiations    32
;  :rlimit-count            169452)
(push) ; 3
(assert (not (< $Perm.No $k@62@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1194
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      39
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               195
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             689
;  :mk-clause               53
;  :num-allocs              3926316
;  :num-checks              221
;  :propagations            42
;  :quant-instantiations    32
;  :rlimit-count            169500)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1200
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      39
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               196
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             692
;  :mk-clause               53
;  :num-allocs              3926316
;  :num-checks              222
;  :propagations            42
;  :quant-instantiations    33
;  :rlimit-count            170102)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1200
;  :arith-assert-diseq      23
;  :arith-assert-lower      63
;  :arith-assert-upper      39
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               197
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             692
;  :mk-clause               53
;  :num-allocs              3926316
;  :num-checks              223
;  :propagations            42
;  :quant-instantiations    33
;  :rlimit-count            170150)
(declare-const $k@63@06 $Perm)
(assert ($Perm.isReadVar $k@63@06 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@63@06 $Perm.No) (< $Perm.No $k@63@06))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1200
;  :arith-assert-diseq      24
;  :arith-assert-lower      65
;  :arith-assert-upper      40
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               198
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             696
;  :mk-clause               55
;  :num-allocs              3926316
;  :num-checks              224
;  :propagations            43
;  :quant-instantiations    33
;  :rlimit-count            170349)
(assert (<= $Perm.No $k@63@06))
(assert (<= $k@63@06 $Perm.Write))
(assert (implies
  (< $Perm.No $k@63@06)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_alu.ALU_m == diz.Monitor_m
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1206
;  :arith-assert-diseq      24
;  :arith-assert-lower      65
;  :arith-assert-upper      41
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               199
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             699
;  :mk-clause               55
;  :num-allocs              3926316
;  :num-checks              225
;  :propagations            43
;  :quant-instantiations    33
;  :rlimit-count            170932)
(push) ; 3
(assert (not (< $Perm.No $k@60@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1206
;  :arith-assert-diseq      24
;  :arith-assert-lower      65
;  :arith-assert-upper      41
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               200
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             699
;  :mk-clause               55
;  :num-allocs              3926316
;  :num-checks              226
;  :propagations            43
;  :quant-instantiations    33
;  :rlimit-count            170980)
(push) ; 3
(assert (not (< $Perm.No $k@63@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1206
;  :arith-assert-diseq      24
;  :arith-assert-lower      65
;  :arith-assert-upper      41
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               201
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             699
;  :mk-clause               55
;  :num-allocs              3926316
;  :num-checks              227
;  :propagations            43
;  :quant-instantiations    33
;  :rlimit-count            171028)
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1206
;  :arith-assert-diseq      24
;  :arith-assert-lower      65
;  :arith-assert-upper      41
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               202
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             699
;  :mk-clause               55
;  :num-allocs              3926316
;  :num-checks              228
;  :propagations            43
;  :quant-instantiations    33
;  :rlimit-count            171076)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@57@06)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Monitor_m.Main_mon == diz
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1215
;  :arith-assert-diseq      24
;  :arith-assert-lower      65
;  :arith-assert-upper      41
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               203
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             703
;  :mk-clause               55
;  :num-allocs              3926316
;  :num-checks              229
;  :propagations            43
;  :quant-instantiations    34
;  :rlimit-count            171732)
(push) ; 3
(assert (not (< $Perm.No $k@62@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1215
;  :arith-assert-diseq      24
;  :arith-assert-lower      65
;  :arith-assert-upper      41
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               204
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             703
;  :mk-clause               55
;  :num-allocs              3926316
;  :num-checks              230
;  :propagations            43
;  :quant-instantiations    34
;  :rlimit-count            171780)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))
  diz@53@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] 0 <= process_id
(assert (<= 0 process_id@55@06))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06))))))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] process_id < |diz.Monitor_m.Main_process_state|
; [eval] |diz.Monitor_m.Main_process_state|
(push) ; 3
(assert (not (< $Perm.No $k@58@06)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1224
;  :arith-assert-diseq      24
;  :arith-assert-lower      66
;  :arith-assert-upper      41
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     16
;  :conflicts               205
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 239
;  :datatype-occurs-check   55
;  :datatype-splits         92
;  :decisions               230
;  :del-clause              38
;  :final-checks            31
;  :max-generation          1
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             708
;  :mk-clause               55
;  :num-allocs              3926316
;  :num-checks              231
;  :propagations            43
;  :quant-instantiations    34
;  :rlimit-count            172452)
(assert (<
  process_id@55@06
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@57@06)))))))))))
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
