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
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@07))))))))))))))))
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
; diz__1 := new(ALU_m, ALU_OPCODE, ALU_OP1, ALU_OP2, ALU_CARRY, ALU_ZERO, ALU_RESULT, ALU_data1, ALU_data2, ALU_result, ALU_i, ALU_bit, ALU_divisor, ALU_current_bit)
(declare-const diz__1@8@07 $Ref)
(assert (not (= diz__1@8@07 $Ref.null)))
(declare-const ALU_m@9@07 $Ref)
(declare-const ALU_OPCODE@10@07 Int)
(declare-const ALU_OP1@11@07 Int)
(declare-const ALU_OP2@12@07 Int)
(declare-const ALU_CARRY@13@07 Bool)
(declare-const ALU_ZERO@14@07 Bool)
(declare-const ALU_RESULT@15@07 Int)
(declare-const ALU_data1@16@07 Int)
(declare-const ALU_data2@17@07 Int)
(declare-const ALU_result@18@07 Int)
(declare-const ALU_i@19@07 Int)
(declare-const ALU_bit@20@07 Int)
(declare-const ALU_divisor@21@07 Int)
(declare-const ALU_current_bit@22@07 Int)
(assert (not (= diz__1@8@07 globals@3@07)))
(assert (not (= diz__1@8@07 diz__1@7@07)))
(assert (not (= diz__1@8@07 m_param@4@07)))
(assert (not (= diz__1@8@07 sys__result@5@07)))
; [exec]
; inhale type_of(diz__1) == class_ALU()
(declare-const $t@23@07 $Snap)
(assert (= $t@23@07 $Snap.unit))
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
; sys__result := diz__1
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_ALU() && acc(sys__result.ALU_m, write) && acc(sys__result.ALU_OPCODE, write) && acc(sys__result.ALU_OP1, write) && acc(sys__result.ALU_OP2, write) && acc(sys__result.ALU_CARRY, write) && acc(sys__result.ALU_ZERO, write) && acc(sys__result.ALU_RESULT, write) && acc(sys__result.ALU_data1, write) && acc(sys__result.ALU_data2, write) && acc(sys__result.ALU_result, write) && acc(sys__result.ALU_i, write) && acc(sys__result.ALU_bit, write) && acc(sys__result.ALU_divisor, write) && acc(sys__result.ALU_current_bit, write) && sys__result.ALU_m == m_param
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_ALU()
; [eval] type_of(sys__result)
; [eval] class_ALU()
; [eval] sys__result.ALU_m == m_param
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Driver_forkOperator_EncodedGlobalVariables ----------
(declare-const diz@24@07 $Ref)
(declare-const globals@25@07 $Ref)
(declare-const diz@26@07 $Ref)
(declare-const globals@27@07 $Ref)
(push) ; 1
(declare-const $t@28@07 $Snap)
(assert (= $t@28@07 ($Snap.combine ($Snap.first $t@28@07) ($Snap.second $t@28@07))))
(assert (= ($Snap.first $t@28@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@26@07 $Ref.null)))
(assert (=
  ($Snap.second $t@28@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@28@07))
    ($Snap.second ($Snap.second $t@28@07)))))
(declare-const $k@29@07 $Perm)
(assert ($Perm.isReadVar $k@29@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@29@07 $Perm.No) (< $Perm.No $k@29@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             19
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             1
;  :datatype-accessor-ax  4
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           271
;  :mk-clause             3
;  :num-allocs            3554378
;  :num-checks            3
;  :propagations          17
;  :quant-instantiations  1
;  :rlimit-count          112815)
(assert (<= $Perm.No $k@29@07))
(assert (<= $k@29@07 $Perm.Write))
(assert (implies (< $Perm.No $k@29@07) (not (= diz@26@07 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@28@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@28@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@28@07))) $Snap.unit))
; [eval] diz.Driver_m != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             25
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             2
;  :datatype-accessor-ax  5
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           274
;  :mk-clause             3
;  :num-allocs            3554378
;  :num-checks            4
;  :propagations          17
;  :quant-instantiations  1
;  :rlimit-count          113068)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@28@07))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@28@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             31
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             3
;  :datatype-accessor-ax  6
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           277
;  :mk-clause             3
;  :num-allocs            3554378
;  :num-checks            5
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113352)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             36
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             4
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           278
;  :mk-clause             3
;  :num-allocs            3554378
;  :num-checks            6
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113539)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_process_state| == 1
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             42
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   16
;  :conflicts             5
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.78
;  :mk-bool-var           280
;  :mk-clause             3
;  :num-allocs            3554378
;  :num-checks            7
;  :propagations          17
;  :quant-instantiations  2
;  :rlimit-count          113768)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             49
;  :arith-assert-diseq    2
;  :arith-assert-lower    6
;  :arith-assert-upper    4
;  :arith-eq-adapter      4
;  :binary-propagations   16
;  :conflicts             6
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           289
;  :mk-clause             6
;  :num-allocs            3672956
;  :num-checks            8
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          114129)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
  $Snap.unit))
; [eval] |diz.Driver_m.Main_event_state| == 2
; [eval] |diz.Driver_m.Main_event_state|
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             55
;  :arith-assert-diseq    2
;  :arith-assert-lower    6
;  :arith-assert-upper    4
;  :arith-eq-adapter      4
;  :binary-propagations   16
;  :conflicts             7
;  :datatype-accessor-ax  10
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           291
;  :mk-clause             6
;  :num-allocs            3672956
;  :num-checks            9
;  :propagations          18
;  :quant-instantiations  5
;  :rlimit-count          114378)
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Driver_m.Main_process_state[i] } 0 <= i && i < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i] == -1 || 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|)
(declare-const i@30@07 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Driver_m.Main_process_state| ==> diz.Driver_m.Main_process_state[i] == -1 || 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= i && i < |diz.Driver_m.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 0 | 0 <= i@30@07 | live]
; [else-branch: 0 | !(0 <= i@30@07) | live]
(push) ; 4
; [then-branch: 0 | 0 <= i@30@07]
(assert (<= 0 i@30@07))
; [eval] i < |diz.Driver_m.Main_process_state|
; [eval] |diz.Driver_m.Main_process_state|
(push) ; 5
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             63
;  :arith-assert-diseq    3
;  :arith-assert-lower    10
;  :arith-assert-upper    5
;  :arith-eq-adapter      6
;  :binary-propagations   16
;  :conflicts             8
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           302
;  :mk-clause             9
;  :num-allocs            3672956
;  :num-checks            10
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          114850
;  :time                  0.00)
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= i@30@07)]
(assert (not (<= 0 i@30@07)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 1 | i@30@07 < |First:(Second:(Second:(Second:(Second:($t@28@07)))))| && 0 <= i@30@07 | live]
; [else-branch: 1 | !(i@30@07 < |First:(Second:(Second:(Second:(Second:($t@28@07)))))| && 0 <= i@30@07) | live]
(push) ; 4
; [then-branch: 1 | i@30@07 < |First:(Second:(Second:(Second:(Second:($t@28@07)))))| && 0 <= i@30@07]
(assert (and
  (<
    i@30@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
  (<= 0 i@30@07)))
; [eval] diz.Driver_m.Main_process_state[i] == -1 || 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i] == -1
; [eval] diz.Driver_m.Main_process_state[i]
(push) ; 5
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             64
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             9
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           304
;  :mk-clause             9
;  :num-allocs            3672956
;  :num-checks            11
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115011)
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@30@07 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             64
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             9
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           304
;  :mk-clause             9
;  :num-allocs            3672956
;  :num-checks            12
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115020)
; [eval] -1
(push) ; 5
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@28@07)))))[i@30@07] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@28@07)))))[i@30@07] != -1 | live]
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@28@07)))))[i@30@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
    i@30@07)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@28@07)))))[i@30@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
      i@30@07)
    (- 0 1))))
; [eval] 0 <= diz.Driver_m.Main_process_state[i] && diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] 0 <= diz.Driver_m.Main_process_state[i]
; [eval] diz.Driver_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             64
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             10
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           305
;  :mk-clause             9
;  :num-allocs            3672956
;  :num-checks            13
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115246)
(set-option :timeout 0)
(push) ; 7
(assert (not (>= i@30@07 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             64
;  :arith-assert-diseq    3
;  :arith-assert-lower    11
;  :arith-assert-upper    6
;  :arith-eq-adapter      6
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             10
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           305
;  :mk-clause             9
;  :num-allocs            3672956
;  :num-checks            14
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115255)
(push) ; 7
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@28@07)))))[i@30@07] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@28@07)))))[i@30@07]) | live]
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@28@07)))))[i@30@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
    i@30@07)))
; [eval] diz.Driver_m.Main_process_state[i] < |diz.Driver_m.Main_event_state|
; [eval] diz.Driver_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             64
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             11
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           308
;  :mk-clause             10
;  :num-allocs            3672956
;  :num-checks            15
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115428)
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@30@07 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             64
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             11
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           308
;  :mk-clause             10
;  :num-allocs            3672956
;  :num-checks            16
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115437)
; [eval] |diz.Driver_m.Main_event_state|
(set-option :timeout 10)
(push) ; 9
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             64
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             12
;  :datatype-accessor-ax  11
;  :datatype-occurs-check 1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           308
;  :mk-clause             10
;  :num-allocs            3672956
;  :num-checks            17
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          115485)
(pop) ; 8
(push) ; 8
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@28@07)))))[i@30@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
      i@30@07))))
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
; [else-branch: 1 | !(i@30@07 < |First:(Second:(Second:(Second:(Second:($t@28@07)))))| && 0 <= i@30@07)]
(assert (not
  (and
    (<
      i@30@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
    (<= 0 i@30@07))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@30@07 Int)) (!
  (implies
    (and
      (<
        i@30@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))
      (<= 0 i@30@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
          i@30@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
            i@30@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
            i@30@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))
    i@30@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             69
;  :arith-assert-diseq    4
;  :arith-assert-lower    14
;  :arith-assert-upper    6
;  :arith-eq-adapter      7
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             13
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           310
;  :mk-clause             10
;  :num-allocs            3672956
;  :num-checks            18
;  :propagations          19
;  :quant-instantiations  8
;  :rlimit-count          116140)
(declare-const $k@31@07 $Perm)
(assert ($Perm.isReadVar $k@31@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@31@07 $Perm.No) (< $Perm.No $k@31@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             69
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    7
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             14
;  :datatype-accessor-ax  12
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           314
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            19
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116338)
(assert (<= $Perm.No $k@31@07))
(assert (<= $k@31@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@31@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@28@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             15
;  :datatype-accessor-ax  13
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           317
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            20
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116671)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             75
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             16
;  :datatype-accessor-ax  13
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           317
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            21
;  :propagations          20
;  :quant-instantiations  8
;  :rlimit-count          116719)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             81
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             17
;  :datatype-accessor-ax  14
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           320
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            22
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117085)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             81
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             18
;  :datatype-accessor-ax  14
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           320
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            23
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117133)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
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
;  :conflicts             19
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           321
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            24
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117400)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
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
;  :conflicts             20
;  :datatype-accessor-ax  15
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           321
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            25
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117448)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             91
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             21
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           322
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            26
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117725)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             91
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             22
;  :datatype-accessor-ax  16
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           322
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            27
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          117773)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             96
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             23
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           323
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            28
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118060)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             96
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             24
;  :datatype-accessor-ax  17
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           323
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            29
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118108)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             101
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             25
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           324
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            30
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118405
;  :time                  0.00)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             101
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             26
;  :datatype-accessor-ax  18
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           324
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            31
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118453)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             106
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             27
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            32
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118760)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             106
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             28
;  :datatype-accessor-ax  19
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           325
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            33
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          118808)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             111
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             29
;  :datatype-accessor-ax  20
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           326
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            34
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119125)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             111
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             30
;  :datatype-accessor-ax  20
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           326
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            35
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119173
;  :time                  0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             116
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             31
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           327
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            36
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119500
;  :time                  0.00)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             116
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             32
;  :datatype-accessor-ax  21
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           327
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            37
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119548)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             121
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             33
;  :datatype-accessor-ax  22
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           328
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            38
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119885)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             121
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             34
;  :datatype-accessor-ax  22
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           328
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            39
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          119933)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             126
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             35
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            40
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120280)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             126
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             36
;  :datatype-accessor-ax  23
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           329
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            41
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120328)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             131
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             37
;  :datatype-accessor-ax  24
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           330
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            42
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120685)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             131
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             38
;  :datatype-accessor-ax  24
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.87
;  :mk-bool-var           330
;  :mk-clause             12
;  :num-allocs            3672956
;  :num-checks            43
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          120733)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             136
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             39
;  :datatype-accessor-ax  25
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           331
;  :mk-clause             12
;  :num-allocs            3797104
;  :num-checks            44
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121100
;  :time                  0.00)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             136
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             40
;  :datatype-accessor-ax  25
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           331
;  :mk-clause             12
;  :num-allocs            3797104
;  :num-checks            45
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121148)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             141
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             41
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           332
;  :mk-clause             12
;  :num-allocs            3797104
;  :num-checks            46
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121525)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             141
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             42
;  :datatype-accessor-ax  26
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           332
;  :mk-clause             12
;  :num-allocs            3797104
;  :num-checks            47
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121573)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             146
;  :arith-assert-diseq    5
;  :arith-assert-lower    16
;  :arith-assert-upper    8
;  :arith-eq-adapter      8
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             43
;  :datatype-accessor-ax  27
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           333
;  :mk-clause             12
;  :num-allocs            3797104
;  :num-checks            48
;  :propagations          20
;  :quant-instantiations  9
;  :rlimit-count          121960)
(declare-const $k@32@07 $Perm)
(assert ($Perm.isReadVar $k@32@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@32@07 $Perm.No) (< $Perm.No $k@32@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             146
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    9
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             44
;  :datatype-accessor-ax  27
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           337
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            49
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122159)
(assert (<= $Perm.No $k@32@07))
(assert (<= $k@32@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@32@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@28@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             152
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             45
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           340
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            50
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122642)
(push) ; 2
(assert (not (< $Perm.No $k@32@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             152
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             46
;  :datatype-accessor-ax  28
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           340
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            51
;  :propagations          21
;  :quant-instantiations  9
;  :rlimit-count          122690)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             158
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             47
;  :datatype-accessor-ax  29
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           343
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            52
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123230)
(push) ; 2
(assert (not (< $Perm.No $k@32@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             158
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             48
;  :datatype-accessor-ax  29
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           343
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            53
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123278)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
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
;  :conflicts             49
;  :datatype-accessor-ax  30
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           344
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            54
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123695)
(push) ; 2
(assert (not (< $Perm.No $k@32@07)))
(check-sat)
; unsat
(pop) ; 2
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
;  :conflicts             50
;  :datatype-accessor-ax  30
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           344
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            55
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          123743)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             168
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             51
;  :datatype-accessor-ax  31
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           345
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            56
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124170)
(push) ; 2
(assert (not (< $Perm.No $k@32@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             168
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             52
;  :datatype-accessor-ax  31
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           345
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            57
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124218)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             173
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             53
;  :datatype-accessor-ax  32
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           346
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            58
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124655)
(push) ; 2
(assert (not (< $Perm.No $k@32@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             173
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             54
;  :datatype-accessor-ax  32
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           346
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            59
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          124703)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             178
;  :arith-assert-diseq    6
;  :arith-assert-lower    18
;  :arith-assert-upper    10
;  :arith-eq-adapter      9
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             55
;  :datatype-accessor-ax  33
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           347
;  :mk-clause             14
;  :num-allocs            3797104
;  :num-checks            60
;  :propagations          21
;  :quant-instantiations  10
;  :rlimit-count          125150)
(declare-const $k@33@07 $Perm)
(assert ($Perm.isReadVar $k@33@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@33@07 $Perm.No) (< $Perm.No $k@33@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             178
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    11
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             56
;  :datatype-accessor-ax  33
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           351
;  :mk-clause             16
;  :num-allocs            3797104
;  :num-checks            61
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          125349)
(assert (<= $Perm.No $k@33@07))
(assert (<= $k@33@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@33@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@28@07)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_mon != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             184
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             57
;  :datatype-accessor-ax  34
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           354
;  :mk-clause             16
;  :num-allocs            3797104
;  :num-checks            62
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          125892)
(push) ; 2
(assert (not (< $Perm.No $k@33@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             184
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             58
;  :datatype-accessor-ax  34
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           354
;  :mk-clause             16
;  :num-allocs            3797104
;  :num-checks            63
;  :propagations          22
;  :quant-instantiations  10
;  :rlimit-count          125940)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             190
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             59
;  :datatype-accessor-ax  35
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           357
;  :mk-clause             16
;  :num-allocs            3797104
;  :num-checks            64
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          126522)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             190
;  :arith-assert-diseq    7
;  :arith-assert-lower    20
;  :arith-assert-upper    12
;  :arith-eq-adapter      10
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             60
;  :datatype-accessor-ax  35
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           357
;  :mk-clause             16
;  :num-allocs            3797104
;  :num-checks            65
;  :propagations          22
;  :quant-instantiations  11
;  :rlimit-count          126570)
(declare-const $k@34@07 $Perm)
(assert ($Perm.isReadVar $k@34@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@34@07 $Perm.No) (< $Perm.No $k@34@07))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             190
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    13
;  :arith-eq-adapter      11
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             61
;  :datatype-accessor-ax  35
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           361
;  :mk-clause             18
;  :num-allocs            3797104
;  :num-checks            66
;  :propagations          23
;  :quant-instantiations  11
;  :rlimit-count          126768)
(assert (<= $Perm.No $k@34@07))
(assert (<= $k@34@07 $Perm.Write))
(assert (implies
  (< $Perm.No $k@34@07)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_alu.ALU_m == diz.Driver_m
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             196
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             62
;  :datatype-accessor-ax  36
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           364
;  :mk-clause             18
;  :num-allocs            3797104
;  :num-checks            67
;  :propagations          23
;  :quant-instantiations  11
;  :rlimit-count          127331)
(push) ; 2
(assert (not (< $Perm.No $k@31@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             196
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             63
;  :datatype-accessor-ax  36
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           364
;  :mk-clause             18
;  :num-allocs            3797104
;  :num-checks            68
;  :propagations          23
;  :quant-instantiations  11
;  :rlimit-count          127379)
(push) ; 2
(assert (not (< $Perm.No $k@34@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             196
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             64
;  :datatype-accessor-ax  36
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           364
;  :mk-clause             18
;  :num-allocs            3797104
;  :num-checks            69
;  :propagations          23
;  :quant-instantiations  11
;  :rlimit-count          127427)
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             196
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             65
;  :datatype-accessor-ax  36
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           364
;  :mk-clause             18
;  :num-allocs            3797104
;  :num-checks            70
;  :propagations          23
;  :quant-instantiations  11
;  :rlimit-count          127475)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@28@07)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07)))))))))))))))))))))))))))))))))))
  $Snap.unit))
; [eval] diz.Driver_m.Main_dr == diz
(push) ; 2
(assert (not (< $Perm.No $k@29@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             205
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             66
;  :datatype-accessor-ax  37
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           368
;  :mk-clause             18
;  :num-allocs            3797104
;  :num-checks            71
;  :propagations          23
;  :quant-instantiations  12
;  :rlimit-count          128111)
(push) ; 2
(assert (not (< $Perm.No $k@32@07)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             205
;  :arith-assert-diseq    8
;  :arith-assert-lower    22
;  :arith-assert-upper    14
;  :arith-eq-adapter      11
;  :arith-fixed-eqs       1
;  :binary-propagations   16
;  :conflicts             67
;  :datatype-accessor-ax  37
;  :datatype-occurs-check 1
;  :del-clause            1
;  :final-checks          2
;  :max-generation        1
;  :max-memory            4.12
;  :memory                3.97
;  :mk-bool-var           368
;  :mk-clause             18
;  :num-allocs            3797104
;  :num-checks            72
;  :propagations          23
;  :quant-instantiations  12
;  :rlimit-count          128159)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@07))))))))))))))))))))))))))
  diz@26@07))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@35@07 $Snap)
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_Main_EncodedGlobalVariables ----------
(declare-const globals@36@07 $Ref)
(declare-const sys__result@37@07 $Ref)
(declare-const globals@38@07 $Ref)
(declare-const sys__result@39@07 $Ref)
(push) ; 1
; State saturation: after contract
(check-sat)
; unknown
(push) ; 2
(declare-const $t@40@07 $Snap)
(assert (= $t@40@07 ($Snap.combine ($Snap.first $t@40@07) ($Snap.second $t@40@07))))
(assert (= ($Snap.first $t@40@07) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@39@07 $Ref.null)))
(assert (= ($Snap.second $t@40@07) $Snap.unit))
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
(assert (= (type_of<TYPE> sys__result@39@07) (as class_Main<TYPE>  TYPE)))
(pop) ; 2
(push) ; 2
; [exec]
; var __flatten_69__88: Ref
(declare-const __flatten_69__88@41@07 $Ref)
; [exec]
; var __flatten_67__87: Ref
(declare-const __flatten_67__87@42@07 $Ref)
; [exec]
; var __flatten_65__86: Ref
(declare-const __flatten_65__86@43@07 $Ref)
; [exec]
; var __flatten_64__85: Seq[Int]
(declare-const __flatten_64__85@44@07 Seq<Int>)
; [exec]
; var __flatten_63__84: Seq[Int]
(declare-const __flatten_63__84@45@07 Seq<Int>)
; [exec]
; var __flatten_62__83: Seq[Int]
(declare-const __flatten_62__83@46@07 Seq<Int>)
; [exec]
; var __flatten_61__82: Seq[Int]
(declare-const __flatten_61__82@47@07 Seq<Int>)
; [exec]
; var diz__81: Ref
(declare-const diz__81@48@07 $Ref)
; [exec]
; diz__81 := new(Main_process_state, Main_event_state, Main_alu, Main_dr, Main_mon)
(declare-const diz__81@49@07 $Ref)
(assert (not (= diz__81@49@07 $Ref.null)))
(declare-const Main_process_state@50@07 Seq<Int>)
(declare-const Main_event_state@51@07 Seq<Int>)
(declare-const Main_alu@52@07 $Ref)
(declare-const Main_dr@53@07 $Ref)
(declare-const Main_mon@54@07 $Ref)
(assert (not (= diz__81@49@07 diz__81@48@07)))
(assert (not (= diz__81@49@07 __flatten_65__86@43@07)))
(assert (not (= diz__81@49@07 sys__result@39@07)))
(assert (not (= diz__81@49@07 globals@38@07)))
(assert (not (= diz__81@49@07 __flatten_67__87@42@07)))
(assert (not (= diz__81@49@07 __flatten_69__88@41@07)))
; [exec]
; inhale type_of(diz__81) == class_Main()
(declare-const $t@55@07 $Snap)
(assert (= $t@55@07 $Snap.unit))
; [eval] type_of(diz__81) == class_Main()
; [eval] type_of(diz__81)
; [eval] class_Main()
(assert (= (type_of<TYPE> diz__81@49@07) (as class_Main<TYPE>  TYPE)))
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; __flatten_62__83 := Seq(-1)
; [eval] Seq(-1)
; [eval] -1
(assert (= (Seq_length (Seq_singleton (- 0 1))) 1))
(declare-const __flatten_62__83@56@07 Seq<Int>)
(assert (Seq_equal __flatten_62__83@56@07 (Seq_singleton (- 0 1))))
; [exec]
; __flatten_61__82 := __flatten_62__83
; [exec]
; diz__81.Main_process_state := __flatten_61__82
; [exec]
; __flatten_64__85 := Seq(-3, -3)
; [eval] Seq(-3, -3)
; [eval] -3
; [eval] -3
(assert (= (Seq_length (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))) 2))
(declare-const __flatten_64__85@57@07 Seq<Int>)
(assert (Seq_equal
  __flatten_64__85@57@07
  (Seq_append (Seq_singleton (- 0 3)) (Seq_singleton (- 0 3)))))
; [exec]
; __flatten_63__84 := __flatten_64__85
; [exec]
; diz__81.Main_event_state := __flatten_63__84
; [exec]
; __flatten_65__86 := ALU_ALU_EncodedGlobalVariables_Main(globals, diz__81)
(declare-const sys__result@58@07 $Ref)
(declare-const $t@59@07 $Snap)
(assert (= $t@59@07 ($Snap.combine ($Snap.first $t@59@07) ($Snap.second $t@59@07))))
(assert (= ($Snap.first $t@59@07) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@58@07 $Ref.null)))
(assert (=
  ($Snap.second $t@59@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@59@07))
    ($Snap.second ($Snap.second $t@59@07)))))
(assert (= ($Snap.first ($Snap.second $t@59@07)) $Snap.unit))
; [eval] type_of(sys__result) == class_ALU()
; [eval] type_of(sys__result)
; [eval] class_ALU()
(assert (= (type_of<TYPE> sys__result@58@07) (as class_ALU<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@59@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@59@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@59@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))))
  $Snap.unit))
; [eval] sys__result.ALU_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@59@07))))
  diz__81@49@07))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; diz__81.Main_alu := __flatten_65__86
; [exec]
; __flatten_67__87 := Driver_Driver_EncodedGlobalVariables_Main(globals, diz__81)
(declare-const sys__result@60@07 $Ref)
(declare-const $t@61@07 $Snap)
(assert (= $t@61@07 ($Snap.combine ($Snap.first $t@61@07) ($Snap.second $t@61@07))))
(assert (= ($Snap.first $t@61@07) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@60@07 $Ref.null)))
(assert (=
  ($Snap.second $t@61@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@61@07))
    ($Snap.second ($Snap.second $t@61@07)))))
(assert (= ($Snap.first ($Snap.second $t@61@07)) $Snap.unit))
; [eval] type_of(sys__result) == class_Driver()
; [eval] type_of(sys__result)
; [eval] class_Driver()
(assert (= (type_of<TYPE> sys__result@60@07) (as class_Driver<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@61@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@61@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@61@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@61@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))
  $Snap.unit))
; [eval] sys__result.Driver_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))
  diz__81@49@07))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__81.Main_dr := __flatten_67__87
; [exec]
; __flatten_69__88 := Monitor_Monitor_EncodedGlobalVariables_Main(globals, diz__81)
(declare-const sys__result@62@07 $Ref)
(declare-const $t@63@07 $Snap)
(assert (= $t@63@07 ($Snap.combine ($Snap.first $t@63@07) ($Snap.second $t@63@07))))
(assert (= ($Snap.first $t@63@07) $Snap.unit))
; [eval] sys__result != null
(assert (not (= sys__result@62@07 $Ref.null)))
(assert (=
  ($Snap.second $t@63@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@63@07))
    ($Snap.second ($Snap.second $t@63@07)))))
(assert (= ($Snap.first ($Snap.second $t@63@07)) $Snap.unit))
; [eval] type_of(sys__result) == class_Monitor()
; [eval] type_of(sys__result)
; [eval] class_Monitor()
(assert (= (type_of<TYPE> sys__result@62@07) (as class_Monitor<TYPE>  TYPE)))
(assert (=
  ($Snap.second ($Snap.second $t@63@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@63@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@63@07))))))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@63@07))) $Snap.unit))
; [eval] sys__result.Monitor_m == m_param
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@63@07))))
  diz__81@49@07))
; State saturation: after contract
(check-sat)
; unknown
; [exec]
; diz__81.Main_mon := __flatten_69__88
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz__81, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(set-option :timeout 0)
(push) ; 3
(assert (not (= (Seq_length __flatten_62__83@56@07) 1)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               582
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      42
;  :arith-assert-upper      24
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               69
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              88
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             573
;  :mk-clause               94
;  :num-allocs              3926521
;  :num-checks              79
;  :propagations            52
;  :quant-instantiations    33
;  :rlimit-count            136195)
(assert (= (Seq_length __flatten_62__83@56@07) 1))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(push) ; 3
(assert (not (= (Seq_length __flatten_64__85@57@07) 2)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               583
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      43
;  :arith-assert-upper      25
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         6
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               70
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              88
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             579
;  :mk-clause               94
;  :num-allocs              3926521
;  :num-checks              80
;  :propagations            52
;  :quant-instantiations    33
;  :rlimit-count            136320)
(assert (= (Seq_length __flatten_64__85@57@07) 2))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@64@07 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@64@07 | live]
; [else-branch: 4 | !(0 <= i@64@07) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@64@07]
(assert (<= 0 i@64@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@64@07)]
(assert (not (<= 0 i@64@07)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@64@07 < |__flatten_62__83@56@07| && 0 <= i@64@07 | live]
; [else-branch: 5 | !(i@64@07 < |__flatten_62__83@56@07| && 0 <= i@64@07) | live]
(push) ; 5
; [then-branch: 5 | i@64@07 < |__flatten_62__83@56@07| && 0 <= i@64@07]
(assert (and (< i@64@07 (Seq_length __flatten_62__83@56@07)) (<= 0 i@64@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 6
(assert (not (>= i@64@07 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               585
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      45
;  :arith-assert-upper      27
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               70
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              88
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             584
;  :mk-clause               94
;  :num-allocs              3926521
;  :num-checks              81
;  :propagations            52
;  :quant-instantiations    33
;  :rlimit-count            136511)
; [eval] -1
(push) ; 6
; [then-branch: 6 | __flatten_62__83@56@07[i@64@07] == -1 | live]
; [else-branch: 6 | __flatten_62__83@56@07[i@64@07] != -1 | live]
(push) ; 7
; [then-branch: 6 | __flatten_62__83@56@07[i@64@07] == -1]
(assert (= (Seq_index __flatten_62__83@56@07 i@64@07) (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | __flatten_62__83@56@07[i@64@07] != -1]
(assert (not (= (Seq_index __flatten_62__83@56@07 i@64@07) (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@64@07 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               587
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      45
;  :arith-assert-upper      27
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               71
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              88
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             586
;  :mk-clause               94
;  :num-allocs              3926521
;  :num-checks              82
;  :propagations            52
;  :quant-instantiations    34
;  :rlimit-count            136638)
(push) ; 8
; [then-branch: 7 | 0 <= __flatten_62__83@56@07[i@64@07] | live]
; [else-branch: 7 | !(0 <= __flatten_62__83@56@07[i@64@07]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= __flatten_62__83@56@07[i@64@07]]
(assert (<= 0 (Seq_index __flatten_62__83@56@07 i@64@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@64@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               587
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      45
;  :arith-assert-upper      27
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         7
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               71
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              88
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             587
;  :mk-clause               94
;  :num-allocs              3926521
;  :num-checks              83
;  :propagations            52
;  :quant-instantiations    34
;  :rlimit-count            136693)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= __flatten_62__83@56@07[i@64@07])]
(assert (not (<= 0 (Seq_index __flatten_62__83@56@07 i@64@07))))
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
; [else-branch: 5 | !(i@64@07 < |__flatten_62__83@56@07| && 0 <= i@64@07)]
(assert (not (and (< i@64@07 (Seq_length __flatten_62__83@56@07)) (<= 0 i@64@07))))
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
(assert (not (forall ((i@64@07 Int)) (!
  (implies
    (and (< i@64@07 (Seq_length __flatten_62__83@56@07)) (<= 0 i@64@07))
    (or
      (= (Seq_index __flatten_62__83@56@07 i@64@07) (- 0 1))
      (and
        (<
          (Seq_index __flatten_62__83@56@07 i@64@07)
          (Seq_length __flatten_64__85@57@07))
        (<= 0 (Seq_index __flatten_62__83@56@07 i@64@07)))))
  :pattern ((Seq_index __flatten_62__83@56@07 i@64@07))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      28
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               72
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              99
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             595
;  :mk-clause               105
;  :num-allocs              3926521
;  :num-checks              84
;  :propagations            52
;  :quant-instantiations    35
;  :rlimit-count            137051)
(assert (forall ((i@64@07 Int)) (!
  (implies
    (and (< i@64@07 (Seq_length __flatten_62__83@56@07)) (<= 0 i@64@07))
    (or
      (= (Seq_index __flatten_62__83@56@07 i@64@07) (- 0 1))
      (and
        (<
          (Seq_index __flatten_62__83@56@07 i@64@07)
          (Seq_length __flatten_64__85@57@07))
        (<= 0 (Seq_index __flatten_62__83@56@07 i@64@07)))))
  :pattern ((Seq_index __flatten_62__83@56@07 i@64@07))
  :qid |prog.l<no position>|)))
(declare-const $k@65@07 $Perm)
(assert ($Perm.isReadVar $k@65@07 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@65@07 $Perm.No) (< $Perm.No $k@65@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      48
;  :arith-assert-upper      29
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               73
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              99
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             600
;  :mk-clause               107
;  :num-allocs              3926521
;  :num-checks              85
;  :propagations            53
;  :quant-instantiations    35
;  :rlimit-count            137521)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-add-rows          2
;  :arith-assert-diseq      16
;  :arith-assert-lower      48
;  :arith-assert-upper      29
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               73
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              99
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             600
;  :mk-clause               107
;  :num-allocs              3926521
;  :num-checks              86
;  :propagations            53
;  :quant-instantiations    35
;  :rlimit-count            137534)
(assert (< $k@65@07 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@65@07)))
(assert (<= (- $Perm.Write $k@65@07) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@65@07)) (not (= diz__81@49@07 $Ref.null))))
; [eval] diz.Main_alu != null
(declare-const $k@66@07 $Perm)
(assert ($Perm.isReadVar $k@66@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@66@07 $Perm.No) (< $Perm.No $k@66@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-add-rows          2
;  :arith-assert-diseq      17
;  :arith-assert-lower      50
;  :arith-assert-upper      31
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               74
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              99
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             605
;  :mk-clause               109
;  :num-allocs              3926521
;  :num-checks              87
;  :propagations            54
;  :quant-instantiations    35
;  :rlimit-count            137823)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-add-rows          2
;  :arith-assert-diseq      17
;  :arith-assert-lower      50
;  :arith-assert-upper      31
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               74
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              99
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             605
;  :mk-clause               109
;  :num-allocs              3926521
;  :num-checks              88
;  :propagations            54
;  :quant-instantiations    35
;  :rlimit-count            137836)
(assert (< $k@66@07 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@66@07)))
(assert (<= (- $Perm.Write $k@66@07) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@66@07)) (not (= diz__81@49@07 $Ref.null))))
; [eval] diz.Main_dr != null
(declare-const $k@67@07 $Perm)
(assert ($Perm.isReadVar $k@67@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@67@07 $Perm.No) (< $Perm.No $k@67@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-add-rows          2
;  :arith-assert-diseq      18
;  :arith-assert-lower      52
;  :arith-assert-upper      33
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              99
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             610
;  :mk-clause               111
;  :num-allocs              3926521
;  :num-checks              89
;  :propagations            55
;  :quant-instantiations    35
;  :rlimit-count            138125
;  :time                    0.00)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-add-rows          2
;  :arith-assert-diseq      18
;  :arith-assert-lower      52
;  :arith-assert-upper      33
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               75
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              99
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             610
;  :mk-clause               111
;  :num-allocs              3926521
;  :num-checks              90
;  :propagations            55
;  :quant-instantiations    35
;  :rlimit-count            138138)
(assert (< $k@67@07 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@67@07)))
(assert (<= (- $Perm.Write $k@67@07) $Perm.Write))
(assert (implies (< $Perm.No (- $Perm.Write $k@67@07)) (not (= diz__81@49@07 $Ref.null))))
; [eval] diz.Main_mon != null
(declare-const $k@68@07 $Perm)
(assert ($Perm.isReadVar $k@68@07 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@68@07 $Perm.No) (< $Perm.No $k@68@07))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      54
;  :arith-assert-upper      35
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              99
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             615
;  :mk-clause               113
;  :num-allocs              3926521
;  :num-checks              91
;  :propagations            56
;  :quant-instantiations    35
;  :rlimit-count            138426)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $Perm.Write $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               590
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      54
;  :arith-assert-upper      35
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         8
;  :arith-offset-eqs        3
;  :arith-pivots            3
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              99
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             615
;  :mk-clause               113
;  :num-allocs              3926521
;  :num-checks              92
;  :propagations            56
;  :quant-instantiations    35
;  :rlimit-count            138439)
(assert (< $k@68@07 $Perm.Write))
(assert (<= $Perm.No (- $Perm.Write $k@68@07)))
(assert (<= (- $Perm.Write $k@68@07) $Perm.Write))
(assert (implies
  (< $Perm.No (- $Perm.Write $k@68@07))
  (not (= sys__result@58@07 $Ref.null))))
; [eval] diz.Main_alu.ALU_m == diz
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($SortWrappers.Seq<Int>To$Snap __flatten_62__83@56@07)
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($SortWrappers.Seq<Int>To$Snap __flatten_64__85@57@07)
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap sys__result@58@07)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@07))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))
                                ($Snap.combine
                                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))
                                  ($Snap.combine
                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))
                                    ($Snap.combine
                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))
                                      ($Snap.combine
                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))
                                        ($Snap.combine
                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))
                                          ($Snap.combine
                                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07)))))))))))))))
                                            ($Snap.combine
                                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@07))))))))))))))))
                                              ($Snap.combine
                                                ($SortWrappers.$RefTo$Snap sys__result@60@07)
                                                ($Snap.combine
                                                  $Snap.unit
                                                  ($Snap.combine
                                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))
                                                    ($Snap.combine
                                                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))
                                                      ($Snap.combine
                                                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07)))))))
                                                        ($Snap.combine
                                                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@61@07))))))))
                                                          ($Snap.combine
                                                            ($SortWrappers.$RefTo$Snap sys__result@62@07)
                                                            ($Snap.combine
                                                              $Snap.unit
                                                              ($Snap.combine
                                                                ($Snap.first ($Snap.second ($Snap.second $t@59@07)))
                                                                $Snap.unit)))))))))))))))))))))))))))))))) diz__81@49@07 globals@38@07))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz__81, globals), write)
; [exec]
; sys__result := diz__81
; [exec]
; // assert
; assert sys__result != null && type_of(sys__result) == class_Main()
; [eval] sys__result != null
; [eval] type_of(sys__result) == class_Main()
; [eval] type_of(sys__result)
; [eval] class_Main()
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_reset_events_no_delta_EncodedGlobalVariables ----------
(declare-const diz@69@07 $Ref)
(declare-const globals@70@07 $Ref)
(declare-const diz@71@07 $Ref)
(declare-const globals@72@07 $Ref)
(push) ; 1
(declare-const $t@73@07 $Snap)
(assert (= $t@73@07 ($Snap.combine ($Snap.first $t@73@07) ($Snap.second $t@73@07))))
(assert (= ($Snap.first $t@73@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@71@07 $Ref.null)))
(assert (=
  ($Snap.second $t@73@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@73@07))
    ($Snap.second ($Snap.second $t@73@07)))))
(assert (=
  ($Snap.second ($Snap.second $t@73@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@73@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@73@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@73@07))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07)))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07)))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@74@07 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 8 | 0 <= i@74@07 | live]
; [else-branch: 8 | !(0 <= i@74@07) | live]
(push) ; 4
; [then-branch: 8 | 0 <= i@74@07]
(assert (<= 0 i@74@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 8 | !(0 <= i@74@07)]
(assert (not (<= 0 i@74@07)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 9 | i@74@07 < |First:(Second:(Second:($t@73@07)))| && 0 <= i@74@07 | live]
; [else-branch: 9 | !(i@74@07 < |First:(Second:(Second:($t@73@07)))| && 0 <= i@74@07) | live]
(push) ; 4
; [then-branch: 9 | i@74@07 < |First:(Second:(Second:($t@73@07)))| && 0 <= i@74@07]
(assert (and
  (<
    i@74@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))))
  (<= 0 i@74@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 5
(assert (not (>= i@74@07 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               629
;  :arith-add-rows          4
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      38
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              112
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             644
;  :mk-clause               119
;  :num-allocs              3926521
;  :num-checks              93
;  :propagations            58
;  :quant-instantiations    41
;  :rlimit-count            139824)
; [eval] -1
(push) ; 5
; [then-branch: 10 | First:(Second:(Second:($t@73@07)))[i@74@07] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:($t@73@07)))[i@74@07] != -1 | live]
(push) ; 6
; [then-branch: 10 | First:(Second:(Second:($t@73@07)))[i@74@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))
    i@74@07)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 10 | First:(Second:(Second:($t@73@07)))[i@74@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))
      i@74@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@74@07 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               629
;  :arith-add-rows          4
;  :arith-assert-diseq      21
;  :arith-assert-lower      61
;  :arith-assert-upper      38
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              112
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             645
;  :mk-clause               119
;  :num-allocs              3926521
;  :num-checks              94
;  :propagations            58
;  :quant-instantiations    41
;  :rlimit-count            139987)
(push) ; 7
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@73@07)))[i@74@07] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@73@07)))[i@74@07]) | live]
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:(Second:($t@73@07)))[i@74@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))
    i@74@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@74@07 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               629
;  :arith-add-rows          4
;  :arith-assert-diseq      22
;  :arith-assert-lower      64
;  :arith-assert-upper      38
;  :arith-eq-adapter        38
;  :arith-fixed-eqs         9
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               76
;  :datatype-accessor-ax    73
;  :datatype-constructor-ax 80
;  :datatype-occurs-check   20
;  :datatype-splits         79
;  :decisions               82
;  :del-clause              112
;  :final-checks            13
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             648
;  :mk-clause               120
;  :num-allocs              3926521
;  :num-checks              95
;  :propagations            58
;  :quant-instantiations    41
;  :rlimit-count            140100)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 11 | !(0 <= First:(Second:(Second:($t@73@07)))[i@74@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))
      i@74@07))))
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
; [else-branch: 9 | !(i@74@07 < |First:(Second:(Second:($t@73@07)))| && 0 <= i@74@07)]
(assert (not
  (and
    (<
      i@74@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))))
    (<= 0 i@74@07))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@74@07 Int)) (!
  (implies
    (and
      (<
        i@74@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))))
      (<= 0 i@74@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))
          i@74@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))
            i@74@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))
            i@74@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))
    i@74@07))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@75@07 $Snap)
(assert (= $t@75@07 ($Snap.combine ($Snap.first $t@75@07) ($Snap.second $t@75@07))))
(assert (=
  ($Snap.second $t@75@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@75@07))
    ($Snap.second ($Snap.second $t@75@07)))))
(assert (=
  ($Snap.second ($Snap.second $t@75@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@75@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@75@07))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@75@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@76@07 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 12 | 0 <= i@76@07 | live]
; [else-branch: 12 | !(0 <= i@76@07) | live]
(push) ; 5
; [then-branch: 12 | 0 <= i@76@07]
(assert (<= 0 i@76@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 12 | !(0 <= i@76@07)]
(assert (not (<= 0 i@76@07)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 13 | i@76@07 < |First:(Second:($t@75@07))| && 0 <= i@76@07 | live]
; [else-branch: 13 | !(i@76@07 < |First:(Second:($t@75@07))| && 0 <= i@76@07) | live]
(push) ; 5
; [then-branch: 13 | i@76@07 < |First:(Second:($t@75@07))| && 0 <= i@76@07]
(assert (and
  (<
    i@76@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))))
  (<= 0 i@76@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@76@07 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               685
;  :arith-add-rows          4
;  :arith-assert-diseq      22
;  :arith-assert-lower      69
;  :arith-assert-upper      41
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 86
;  :datatype-occurs-check   23
;  :datatype-splits         84
;  :decisions               87
;  :del-clause              119
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             676
;  :mk-clause               121
;  :num-allocs              3926521
;  :num-checks              97
;  :propagations            58
;  :quant-instantiations    45
;  :rlimit-count            141896)
; [eval] -1
(push) ; 6
; [then-branch: 14 | First:(Second:($t@75@07))[i@76@07] == -1 | live]
; [else-branch: 14 | First:(Second:($t@75@07))[i@76@07] != -1 | live]
(push) ; 7
; [then-branch: 14 | First:(Second:($t@75@07))[i@76@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))
    i@76@07)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 14 | First:(Second:($t@75@07))[i@76@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))
      i@76@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@76@07 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               685
;  :arith-add-rows          4
;  :arith-assert-diseq      22
;  :arith-assert-lower      69
;  :arith-assert-upper      41
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 86
;  :datatype-occurs-check   23
;  :datatype-splits         84
;  :decisions               87
;  :del-clause              119
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             677
;  :mk-clause               121
;  :num-allocs              3926521
;  :num-checks              98
;  :propagations            58
;  :quant-instantiations    45
;  :rlimit-count            142047)
(push) ; 8
; [then-branch: 15 | 0 <= First:(Second:($t@75@07))[i@76@07] | live]
; [else-branch: 15 | !(0 <= First:(Second:($t@75@07))[i@76@07]) | live]
(push) ; 9
; [then-branch: 15 | 0 <= First:(Second:($t@75@07))[i@76@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))
    i@76@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@76@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               685
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      72
;  :arith-assert-upper      41
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         10
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 86
;  :datatype-occurs-check   23
;  :datatype-splits         84
;  :decisions               87
;  :del-clause              119
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             680
;  :mk-clause               122
;  :num-allocs              3926521
;  :num-checks              99
;  :propagations            58
;  :quant-instantiations    45
;  :rlimit-count            142151)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 15 | !(0 <= First:(Second:($t@75@07))[i@76@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))
      i@76@07))))
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
; [else-branch: 13 | !(i@76@07 < |First:(Second:($t@75@07))| && 0 <= i@76@07)]
(assert (not
  (and
    (<
      i@76@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))))
    (<= 0 i@76@07))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@76@07 Int)) (!
  (implies
    (and
      (<
        i@76@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))))
      (<= 0 i@76@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))
          i@76@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))
            i@76@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))
            i@76@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))
    i@76@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@75@07)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@73@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               702
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               77
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 86
;  :datatype-occurs-check   23
;  :datatype-splits         84
;  :decisions               87
;  :del-clause              120
;  :final-checks            16
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             699
;  :mk-clause               132
;  :num-allocs              3926521
;  :num-checks              100
;  :propagations            62
;  :quant-instantiations    47
;  :rlimit-count            143176)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               739
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               78
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 98
;  :datatype-occurs-check   29
;  :datatype-splits         91
;  :decisions               97
;  :del-clause              121
;  :final-checks            19
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             710
;  :mk-clause               133
;  :num-allocs              3926521
;  :num-checks              101
;  :propagations            63
;  :quant-instantiations    47
;  :rlimit-count            143776)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               775
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   35
;  :datatype-splits         98
;  :decisions               107
;  :del-clause              122
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             721
;  :mk-clause               134
;  :num-allocs              3926521
;  :num-checks              102
;  :propagations            64
;  :quant-instantiations    47
;  :rlimit-count            144381)
; [then-branch: 16 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[0] == 0 | live]
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[0] != 0 | live]
(push) ; 4
; [then-branch: 16 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
    0)
  0))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               776
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   35
;  :datatype-splits         98
;  :decisions               107
;  :del-clause              122
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             722
;  :mk-clause               134
;  :num-allocs              3926521
;  :num-checks              103
;  :propagations            64
;  :quant-instantiations    47
;  :rlimit-count            144517)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 16 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      0)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               782
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               79
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 110
;  :datatype-occurs-check   35
;  :datatype-splits         98
;  :decisions               107
;  :del-clause              122
;  :final-checks            22
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             726
;  :mk-clause               135
;  :num-allocs              3926521
;  :num-checks              104
;  :propagations            64
;  :quant-instantiations    47
;  :rlimit-count            144964)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               820
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               80
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 122
;  :datatype-occurs-check   41
;  :datatype-splits         109
;  :decisions               119
;  :del-clause              123
;  :final-checks            25
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             742
;  :mk-clause               136
;  :num-allocs              3926521
;  :num-checks              105
;  :propagations            65
;  :quant-instantiations    47
;  :rlimit-count            145590)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               857
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   47
;  :datatype-splits         120
;  :decisions               131
;  :del-clause              124
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             758
;  :mk-clause               137
;  :num-allocs              3926521
;  :num-checks              106
;  :propagations            66
;  :quant-instantiations    47
;  :rlimit-count            146225
;  :time                    0.00)
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[1] == 0 | live]
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[1] != 0 | live]
(push) ; 4
; [then-branch: 17 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
    1)
  0))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               858
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   47
;  :datatype-splits         120
;  :decisions               131
;  :del-clause              124
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             759
;  :mk-clause               137
;  :num-allocs              3926521
;  :num-checks              107
;  :propagations            66
;  :quant-instantiations    47
;  :rlimit-count            146361)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 17 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      1)
    0)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0)
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               864
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               81
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 134
;  :datatype-occurs-check   47
;  :datatype-splits         120
;  :decisions               131
;  :del-clause              124
;  :final-checks            28
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             763
;  :mk-clause               138
;  :num-allocs              3926521
;  :num-checks              108
;  :propagations            66
;  :quant-instantiations    47
;  :rlimit-count            146814)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               902
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               82
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 146
;  :datatype-occurs-check   53
;  :datatype-splits         131
;  :decisions               143
;  :del-clause              125
;  :final-checks            31
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             778
;  :mk-clause               139
;  :num-allocs              3926521
;  :num-checks              109
;  :propagations            67
;  :quant-instantiations    47
;  :rlimit-count            147442)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               952
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   61
;  :datatype-splits         144
;  :decisions               157
;  :del-clause              127
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             802
;  :mk-clause               141
;  :num-allocs              3926521
;  :num-checks              110
;  :propagations            69
;  :quant-instantiations    47
;  :rlimit-count            148122)
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[0] != 0 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[0] == 0 | live]
(push) ; 4
; [then-branch: 18 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      0)
    0)))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               952
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   61
;  :datatype-splits         144
;  :decisions               157
;  :del-clause              127
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             802
;  :mk-clause               141
;  :num-allocs              3926521
;  :num-checks              111
;  :propagations            69
;  :quant-instantiations    47
;  :rlimit-count            148260)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               952
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   61
;  :datatype-splits         144
;  :decisions               157
;  :del-clause              127
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             802
;  :mk-clause               141
;  :num-allocs              3926521
;  :num-checks              112
;  :propagations            69
;  :quant-instantiations    47
;  :rlimit-count            148275)
(pop) ; 4
(push) ; 4
; [else-branch: 18 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
    0)
  0))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
        0)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@75@07))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0)
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               954
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               84
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 161
;  :datatype-occurs-check   61
;  :datatype-splits         144
;  :decisions               157
;  :del-clause              127
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             804
;  :mk-clause               142
;  :num-allocs              3926521
;  :num-checks              113
;  :propagations            69
;  :quant-instantiations    47
;  :rlimit-count            148604)
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               85
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 172
;  :datatype-occurs-check   67
;  :datatype-splits         153
;  :decisions               168
;  :del-clause              128
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             817
;  :mk-clause               143
;  :num-allocs              3926521
;  :num-checks              114
;  :propagations            72
;  :quant-instantiations    47
;  :rlimit-count            149231)
(push) ; 4
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1039
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 186
;  :datatype-occurs-check   75
;  :datatype-splits         164
;  :decisions               181
;  :del-clause              130
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             839
;  :mk-clause               145
;  :num-allocs              3926521
;  :num-checks              115
;  :propagations            76
;  :quant-instantiations    47
;  :rlimit-count            149908)
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[1] != 0 | live]
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[1] == 0 | live]
(push) ; 4
; [then-branch: 19 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      1)
    0)))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1039
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 186
;  :datatype-occurs-check   75
;  :datatype-splits         164
;  :decisions               181
;  :del-clause              130
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             839
;  :mk-clause               145
;  :num-allocs              3926521
;  :num-checks              116
;  :propagations            76
;  :quant-instantiations    47
;  :rlimit-count            150046)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1039
;  :arith-add-rows          4
;  :arith-assert-diseq      23
;  :arith-assert-lower      73
;  :arith-assert-upper      42
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    102
;  :datatype-constructor-ax 186
;  :datatype-occurs-check   75
;  :datatype-splits         164
;  :decisions               181
;  :del-clause              130
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             839
;  :mk-clause               145
;  :num-allocs              3926521
;  :num-checks              117
;  :propagations            76
;  :quant-instantiations    47
;  :rlimit-count            150061)
(pop) ; 4
(push) ; 4
; [else-branch: 19 | First:(Second:(Second:(Second:(Second:($t@73@07)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
    1)
  0))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
        1)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@75@07)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@73@07))))))
      1))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
; ---------- Main_reset_all_events_EncodedGlobalVariables ----------
(declare-const diz@77@07 $Ref)
(declare-const globals@78@07 $Ref)
(declare-const diz@79@07 $Ref)
(declare-const globals@80@07 $Ref)
(push) ; 1
(declare-const $t@81@07 $Snap)
(assert (= $t@81@07 ($Snap.combine ($Snap.first $t@81@07) ($Snap.second $t@81@07))))
(assert (= ($Snap.first $t@81@07) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@79@07 $Ref.null)))
(assert (=
  ($Snap.second $t@81@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@81@07))
    ($Snap.second ($Snap.second $t@81@07)))))
(assert (=
  ($Snap.second ($Snap.second $t@81@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@81@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@81@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@07))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07)))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07)))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@82@07 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 20 | 0 <= i@82@07 | live]
; [else-branch: 20 | !(0 <= i@82@07) | live]
(push) ; 4
; [then-branch: 20 | 0 <= i@82@07]
(assert (<= 0 i@82@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 20 | !(0 <= i@82@07)]
(assert (not (<= 0 i@82@07)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 21 | i@82@07 < |First:(Second:(Second:($t@81@07)))| && 0 <= i@82@07 | live]
; [else-branch: 21 | !(i@82@07 < |First:(Second:(Second:($t@81@07)))| && 0 <= i@82@07) | live]
(push) ; 4
; [then-branch: 21 | i@82@07 < |First:(Second:(Second:($t@81@07)))| && 0 <= i@82@07]
(assert (and
  (<
    i@82@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))))
  (<= 0 i@82@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 5
(assert (not (>= i@82@07 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1078
;  :arith-add-rows          4
;  :arith-assert-diseq      25
;  :arith-assert-lower      80
;  :arith-assert-upper      45
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 186
;  :datatype-occurs-check   75
;  :datatype-splits         164
;  :decisions               181
;  :del-clause              144
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             868
;  :mk-clause               151
;  :num-allocs              3926521
;  :num-checks              118
;  :propagations            78
;  :quant-instantiations    53
;  :rlimit-count            151282)
; [eval] -1
(push) ; 5
; [then-branch: 22 | First:(Second:(Second:($t@81@07)))[i@82@07] == -1 | live]
; [else-branch: 22 | First:(Second:(Second:($t@81@07)))[i@82@07] != -1 | live]
(push) ; 6
; [then-branch: 22 | First:(Second:(Second:($t@81@07)))[i@82@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))
    i@82@07)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 22 | First:(Second:(Second:($t@81@07)))[i@82@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))
      i@82@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 7
(assert (not (>= i@82@07 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1078
;  :arith-add-rows          4
;  :arith-assert-diseq      25
;  :arith-assert-lower      80
;  :arith-assert-upper      45
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 186
;  :datatype-occurs-check   75
;  :datatype-splits         164
;  :decisions               181
;  :del-clause              144
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             869
;  :mk-clause               151
;  :num-allocs              3926521
;  :num-checks              119
;  :propagations            78
;  :quant-instantiations    53
;  :rlimit-count            151445)
(push) ; 7
; [then-branch: 23 | 0 <= First:(Second:(Second:($t@81@07)))[i@82@07] | live]
; [else-branch: 23 | !(0 <= First:(Second:(Second:($t@81@07)))[i@82@07]) | live]
(push) ; 8
; [then-branch: 23 | 0 <= First:(Second:(Second:($t@81@07)))[i@82@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))
    i@82@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@82@07 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1078
;  :arith-add-rows          4
;  :arith-assert-diseq      26
;  :arith-assert-lower      83
;  :arith-assert-upper      45
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         12
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               87
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 186
;  :datatype-occurs-check   75
;  :datatype-splits         164
;  :decisions               181
;  :del-clause              144
;  :final-checks            42
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             872
;  :mk-clause               152
;  :num-allocs              3926521
;  :num-checks              120
;  :propagations            78
;  :quant-instantiations    53
;  :rlimit-count            151558)
; [eval] |diz.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 23 | !(0 <= First:(Second:(Second:($t@81@07)))[i@82@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))
      i@82@07))))
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
; [else-branch: 21 | !(i@82@07 < |First:(Second:(Second:($t@81@07)))| && 0 <= i@82@07)]
(assert (not
  (and
    (<
      i@82@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))))
    (<= 0 i@82@07))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@82@07 Int)) (!
  (implies
    (and
      (<
        i@82@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))))
      (<= 0 i@82@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))
          i@82@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))
            i@82@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))
            i@82@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))
    i@82@07))
  :qid |prog.l<no position>|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@83@07 $Snap)
(assert (= $t@83@07 ($Snap.combine ($Snap.first $t@83@07) ($Snap.second $t@83@07))))
(assert (=
  ($Snap.second $t@83@07)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@83@07))
    ($Snap.second ($Snap.second $t@83@07)))))
(assert (=
  ($Snap.second ($Snap.second $t@83@07))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@83@07)))
    ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@83@07))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@83@07)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@84@07 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 24 | 0 <= i@84@07 | live]
; [else-branch: 24 | !(0 <= i@84@07) | live]
(push) ; 5
; [then-branch: 24 | 0 <= i@84@07]
(assert (<= 0 i@84@07))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 24 | !(0 <= i@84@07)]
(assert (not (<= 0 i@84@07)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 25 | i@84@07 < |First:(Second:($t@83@07))| && 0 <= i@84@07 | live]
; [else-branch: 25 | !(i@84@07 < |First:(Second:($t@83@07))| && 0 <= i@84@07) | live]
(push) ; 5
; [then-branch: 25 | i@84@07 < |First:(Second:($t@83@07))| && 0 <= i@84@07]
(assert (and
  (<
    i@84@07
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))))
  (<= 0 i@84@07)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@84@07 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1134
;  :arith-add-rows          4
;  :arith-assert-diseq      26
;  :arith-assert-lower      88
;  :arith-assert-upper      48
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 192
;  :datatype-occurs-check   78
;  :datatype-splits         169
;  :decisions               186
;  :del-clause              151
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             900
;  :mk-clause               153
;  :num-allocs              3926521
;  :num-checks              122
;  :propagations            78
;  :quant-instantiations    57
;  :rlimit-count            153356)
; [eval] -1
(push) ; 6
; [then-branch: 26 | First:(Second:($t@83@07))[i@84@07] == -1 | live]
; [else-branch: 26 | First:(Second:($t@83@07))[i@84@07] != -1 | live]
(push) ; 7
; [then-branch: 26 | First:(Second:($t@83@07))[i@84@07] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))
    i@84@07)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 26 | First:(Second:($t@83@07))[i@84@07] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))
      i@84@07)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@84@07 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1134
;  :arith-add-rows          4
;  :arith-assert-diseq      26
;  :arith-assert-lower      88
;  :arith-assert-upper      48
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 192
;  :datatype-occurs-check   78
;  :datatype-splits         169
;  :decisions               186
;  :del-clause              151
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             901
;  :mk-clause               153
;  :num-allocs              3926521
;  :num-checks              123
;  :propagations            78
;  :quant-instantiations    57
;  :rlimit-count            153507)
(push) ; 8
; [then-branch: 27 | 0 <= First:(Second:($t@83@07))[i@84@07] | live]
; [else-branch: 27 | !(0 <= First:(Second:($t@83@07))[i@84@07]) | live]
(push) ; 9
; [then-branch: 27 | 0 <= First:(Second:($t@83@07))[i@84@07]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))
    i@84@07)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@84@07 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1134
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      91
;  :arith-assert-upper      48
;  :arith-eq-adapter        50
;  :arith-fixed-eqs         13
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    116
;  :datatype-constructor-ax 192
;  :datatype-occurs-check   78
;  :datatype-splits         169
;  :decisions               186
;  :del-clause              151
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             904
;  :mk-clause               154
;  :num-allocs              3926521
;  :num-checks              124
;  :propagations            78
;  :quant-instantiations    57
;  :rlimit-count            153611)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 27 | !(0 <= First:(Second:($t@83@07))[i@84@07])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))
      i@84@07))))
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
; [else-branch: 25 | !(i@84@07 < |First:(Second:($t@83@07))| && 0 <= i@84@07)]
(assert (not
  (and
    (<
      i@84@07
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))))
    (<= 0 i@84@07))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@84@07 Int)) (!
  (implies
    (and
      (<
        i@84@07
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))))
      (<= 0 i@84@07))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))
          i@84@07)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))
            i@84@07)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))
            i@84@07)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))
    i@84@07))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@83@07)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second $t@81@07))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1152
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 192
;  :datatype-occurs-check   78
;  :datatype-splits         169
;  :decisions               186
;  :del-clause              152
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             924
;  :mk-clause               165
;  :num-allocs              3926521
;  :num-checks              125
;  :propagations            82
;  :quant-instantiations    59
;  :rlimit-count            154638)
(push) ; 3
; [then-branch: 28 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 | live]
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] != 0 | live]
(push) ; 4
; [then-branch: 28 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
    0)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 28 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1152
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               88
;  :datatype-accessor-ax    118
;  :datatype-constructor-ax 192
;  :datatype-occurs-check   78
;  :datatype-splits         169
;  :decisions               186
;  :del-clause              152
;  :final-checks            45
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             925
;  :mk-clause               165
;  :num-allocs              3926521
;  :num-checks              126
;  :propagations            82
;  :quant-instantiations    59
;  :rlimit-count            154823)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1190
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               89
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 204
;  :datatype-occurs-check   84
;  :datatype-splits         180
;  :decisions               198
;  :del-clause              154
;  :final-checks            48
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             942
;  :mk-clause               167
;  :num-allocs              3926521
;  :num-checks              127
;  :propagations            83
;  :quant-instantiations    59
;  :rlimit-count            155475
;  :time                    0.00)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1226
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 216
;  :datatype-occurs-check   90
;  :datatype-splits         187
;  :decisions               208
;  :del-clause              155
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             954
;  :mk-clause               168
;  :num-allocs              3926521
;  :num-checks              128
;  :propagations            84
;  :quant-instantiations    59
;  :rlimit-count            156118
;  :time                    0.00)
; [then-branch: 29 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == -1 | live]
; [else-branch: 29 | !(First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == -1) | live]
(push) ; 4
; [then-branch: 29 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1226
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    122
;  :datatype-constructor-ax 216
;  :datatype-occurs-check   90
;  :datatype-splits         187
;  :decisions               208
;  :del-clause              155
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             956
;  :mk-clause               169
;  :num-allocs              3926521
;  :num-checks              129
;  :propagations            84
;  :quant-instantiations    59
;  :rlimit-count            156277)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 29 | !(First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      (- 0 1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1232
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 216
;  :datatype-occurs-check   90
;  :datatype-splits         187
;  :decisions               208
;  :del-clause              156
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             962
;  :mk-clause               173
;  :num-allocs              3926521
;  :num-checks              130
;  :propagations            84
;  :quant-instantiations    59
;  :rlimit-count            156772)
(push) ; 3
; [then-branch: 30 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 | live]
; [else-branch: 30 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] != 0 | live]
(push) ; 4
; [then-branch: 30 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
    1)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 30 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1232
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               90
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 216
;  :datatype-occurs-check   90
;  :datatype-splits         187
;  :decisions               208
;  :del-clause              156
;  :final-checks            51
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             963
;  :mk-clause               173
;  :num-allocs              3926521
;  :num-checks              131
;  :propagations            84
;  :quant-instantiations    59
;  :rlimit-count            156953)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1271
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               91
;  :datatype-accessor-ax    125
;  :datatype-constructor-ax 228
;  :datatype-occurs-check   96
;  :datatype-splits         198
;  :decisions               222
;  :del-clause              158
;  :final-checks            54
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             980
;  :mk-clause               175
;  :num-allocs              3926521
;  :num-checks              132
;  :propagations            89
;  :quant-instantiations    59
;  :rlimit-count            157641
;  :time                    0.00)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1308
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 240
;  :datatype-occurs-check   102
;  :datatype-splits         209
;  :decisions               234
;  :del-clause              159
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             997
;  :mk-clause               176
;  :num-allocs              3926521
;  :num-checks              133
;  :propagations            94
;  :quant-instantiations    59
;  :rlimit-count            158320)
; [then-branch: 31 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == -1 | live]
; [else-branch: 31 | !(First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == -1) | live]
(push) ; 4
; [then-branch: 31 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1308
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 240
;  :datatype-occurs-check   102
;  :datatype-splits         209
;  :decisions               234
;  :del-clause              159
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             999
;  :mk-clause               177
;  :num-allocs              3926521
;  :num-checks              134
;  :propagations            94
;  :quant-instantiations    59
;  :rlimit-count            158479)
; [eval] -2
(pop) ; 4
(push) ; 4
; [else-branch: 31 | !(First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      (- 0 1)))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1) ==> diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] !(old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1)
; [eval] old(diz.Main_event_state[0]) == 0 || old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1314
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    128
;  :datatype-constructor-ax 240
;  :datatype-occurs-check   102
;  :datatype-splits         209
;  :decisions               234
;  :del-clause              160
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1005
;  :mk-clause               181
;  :num-allocs              3926521
;  :num-checks              135
;  :propagations            94
;  :quant-instantiations    59
;  :rlimit-count            158980)
(push) ; 3
; [then-branch: 32 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 | live]
; [else-branch: 32 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] != 0 | live]
(push) ; 4
; [then-branch: 32 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
    0)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 32 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1314
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               92
;  :datatype-accessor-ax    128
;  :datatype-constructor-ax 240
;  :datatype-occurs-check   102
;  :datatype-splits         209
;  :decisions               234
;  :del-clause              160
;  :final-checks            57
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1005
;  :mk-clause               181
;  :num-allocs              3926521
;  :num-checks              136
;  :propagations            94
;  :quant-instantiations    59
;  :rlimit-count            159145)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1352
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               93
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 252
;  :datatype-occurs-check   108
;  :datatype-splits         220
;  :decisions               246
;  :del-clause              161
;  :final-checks            60
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1020
;  :mk-clause               182
;  :num-allocs              3926521
;  :num-checks              137
;  :propagations            100
;  :quant-instantiations    59
;  :rlimit-count            159830
;  :time                    0.00)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1403
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 267
;  :datatype-occurs-check   116
;  :datatype-splits         233
;  :decisions               263
;  :del-clause              164
;  :final-checks            64
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1044
;  :mk-clause               185
;  :num-allocs              3926521
;  :num-checks              138
;  :propagations            108
;  :quant-instantiations    59
;  :rlimit-count            160575
;  :time                    0.00)
; [then-branch: 33 | !(First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == -1) | live]
; [else-branch: 33 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == -1 | live]
(push) ; 4
; [then-branch: 33 | !(First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1403
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 267
;  :datatype-occurs-check   116
;  :datatype-splits         233
;  :decisions               263
;  :del-clause              164
;  :final-checks            64
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1044
;  :mk-clause               185
;  :num-allocs              3926521
;  :num-checks              139
;  :propagations            109
;  :quant-instantiations    59
;  :rlimit-count            160759)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1403
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 267
;  :datatype-occurs-check   116
;  :datatype-splits         233
;  :decisions               263
;  :del-clause              164
;  :final-checks            64
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1044
;  :mk-clause               185
;  :num-allocs              3926521
;  :num-checks              140
;  :propagations            109
;  :quant-instantiations    59
;  :rlimit-count            160774)
(pop) ; 4
(push) ; 4
; [else-branch: 33 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0)
    (- 0 1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@83@07))))))))))
  $Snap.unit))
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1) ==> diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] !(old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1)
; [eval] old(diz.Main_event_state[1]) == 0 || old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 3
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1405
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 267
;  :datatype-occurs-check   116
;  :datatype-splits         233
;  :decisions               263
;  :del-clause              164
;  :final-checks            64
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1046
;  :mk-clause               186
;  :num-allocs              3926521
;  :num-checks              141
;  :propagations            109
;  :quant-instantiations    59
;  :rlimit-count            161133)
(push) ; 3
; [then-branch: 34 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 | live]
; [else-branch: 34 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] != 0 | live]
(push) ; 4
; [then-branch: 34 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
    1)
  0))
(pop) ; 4
(push) ; 4
; [else-branch: 34 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1405
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               96
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 267
;  :datatype-occurs-check   116
;  :datatype-splits         233
;  :decisions               263
;  :del-clause              164
;  :final-checks            64
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1046
;  :mk-clause               186
;  :num-allocs              3926521
;  :num-checks              142
;  :propagations            109
;  :quant-instantiations    59
;  :rlimit-count            161298)
; [eval] -1
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
(set-option :timeout 10)
(push) ; 4
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1441
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               97
;  :datatype-accessor-ax    135
;  :datatype-constructor-ax 278
;  :datatype-occurs-check   122
;  :datatype-splits         242
;  :decisions               274
;  :del-clause              165
;  :final-checks            67
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1059
;  :mk-clause               187
;  :num-allocs              3926521
;  :num-checks              143
;  :propagations            117
;  :quant-instantiations    59
;  :rlimit-count            161982)
(push) ; 4
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 292
;  :datatype-occurs-check   130
;  :datatype-splits         253
;  :decisions               290
;  :del-clause              168
;  :final-checks            71
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1081
;  :mk-clause               190
;  :num-allocs              3926521
;  :num-checks              144
;  :propagations            128
;  :quant-instantiations    59
;  :rlimit-count            162729
;  :time                    0.00)
; [then-branch: 35 | !(First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == -1) | live]
; [else-branch: 35 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == -1 | live]
(push) ; 4
; [then-branch: 35 | !(First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 292
;  :datatype-occurs-check   130
;  :datatype-splits         253
;  :decisions               290
;  :del-clause              168
;  :final-checks            71
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1081
;  :mk-clause               190
;  :num-allocs              3926521
;  :num-checks              145
;  :propagations            129
;  :quant-instantiations    59
;  :rlimit-count            162913)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 5
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          4
;  :arith-assert-diseq      27
;  :arith-assert-lower      92
;  :arith-assert-upper      49
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         14
;  :arith-offset-eqs        3
;  :arith-pivots            6
;  :binary-propagations     16
;  :conflicts               100
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 292
;  :datatype-occurs-check   130
;  :datatype-splits         253
;  :decisions               290
;  :del-clause              168
;  :final-checks            71
;  :max-generation          2
;  :max-memory              4.12
;  :memory                  4.07
;  :mk-bool-var             1081
;  :mk-clause               190
;  :num-allocs              3926521
;  :num-checks              146
;  :propagations            129
;  :quant-instantiations    59
;  :rlimit-count            162928)
(pop) ; 4
(push) ; 4
; [else-branch: 35 | First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == 0 || First:(Second:(Second:(Second:(Second:($t@81@07)))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1)
    (- 0 1))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(assert (implies
  (not
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@83@07)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@07))))))
      1))))
(pop) ; 2
(push) ; 2
; [exec]
; inhale false
(pop) ; 2
(pop) ; 1
