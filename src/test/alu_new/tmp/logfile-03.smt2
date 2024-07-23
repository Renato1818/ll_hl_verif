(get-info :version)
; (:version "4.8.6")
; Started: 2024-07-13 19:17:56
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
(declare-fun zfrac_val<Perm> (zfrac) $Perm)
(declare-const class_ALU<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
(declare-const class_Main<TYPE> TYPE)
(declare-const class_EncodedGlobalVariables<TYPE> TYPE)
(declare-fun directSuperclass<TYPE> (TYPE) TYPE)
(declare-fun type_of<TYPE> ($Ref) TYPE)
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
(declare-fun ALU_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun ALU_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_ALU<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_Main<TYPE> class_EncodedGlobalVariables<TYPE>))
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
(assert (forall ((a zfrac) (b zfrac)) (!
  (= (= (zfrac_val<Perm> a) (zfrac_val<Perm> b)) (= a b))
  :pattern ((zfrac_val<Perm> a) (zfrac_val<Perm> b))
  :qid |prog.zfrac_eq|)))
(assert (forall ((a zfrac)) (!
  (and (<= $Perm.No (zfrac_val<Perm> a)) (<= (zfrac_val<Perm> a) $Perm.Write))
  :pattern ((zfrac_val<Perm> a))
  :qid |prog.zfrac_bound|)))
(assert (=
  (directSuperclass<TYPE> (as class_ALU<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_Main<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
(assert (=
  (directSuperclass<TYPE> (as class_EncodedGlobalVariables<TYPE>  TYPE))
  (as class_java_DOT_lang_DOT_Object<TYPE>  TYPE)))
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
; ---------- ALU_set_bit_EncodedGlobalVariables_Integer_Integer_Integer ----------
(declare-const diz@0@03 $Ref)
(declare-const globals@1@03 $Ref)
(declare-const value@2@03 Int)
(declare-const pos@3@03 Int)
(declare-const bit@4@03 Int)
(declare-const sys__result@5@03 Int)
(declare-const diz@6@03 $Ref)
(declare-const globals@7@03 $Ref)
(declare-const value@8@03 Int)
(declare-const pos@9@03 Int)
(declare-const bit@10@03 Int)
(declare-const sys__result@11@03 Int)
(push) ; 1
(declare-const $t@12@03 $Snap)
(assert (= $t@12@03 ($Snap.combine ($Snap.first $t@12@03) ($Snap.second $t@12@03))))
(assert (= ($Snap.first $t@12@03) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@6@03 $Ref.null)))
(assert (=
  ($Snap.second $t@12@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@12@03))
    ($Snap.second ($Snap.second $t@12@03)))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            15
;  :arith-assert-lower   1
;  :arith-assert-upper   1
;  :arith-eq-adapter     1
;  :binary-propagations  7
;  :datatype-accessor-ax 3
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.69
;  :mk-bool-var          243
;  :mk-clause            1
;  :num-allocs           3383166
;  :num-checks           1
;  :propagations         7
;  :quant-instantiations 1
;  :rlimit-count         108265)
(assert (=
  ($Snap.second ($Snap.second $t@12@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@12@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@12@03))) $Snap.unit))
; [eval] diz.ALU_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@03))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@12@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@12@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.ALU_m.Main_process_state[i] } 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|)
(declare-const i@13@03 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 0 | 0 <= i@13@03 | live]
; [else-branch: 0 | !(0 <= i@13@03) | live]
(push) ; 4
; [then-branch: 0 | 0 <= i@13@03]
(assert (<= 0 i@13@03))
; [eval] i < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= i@13@03)]
(assert (not (<= 0 i@13@03)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 1 | i@13@03 < |First:(Second:(Second:(Second:(Second:($t@12@03)))))| && 0 <= i@13@03 | live]
; [else-branch: 1 | !(i@13@03 < |First:(Second:(Second:(Second:(Second:($t@12@03)))))| && 0 <= i@13@03) | live]
(push) ; 4
; [then-branch: 1 | i@13@03 < |First:(Second:(Second:(Second:(Second:($t@12@03)))))| && 0 <= i@13@03]
(assert (and
  (<
    i@13@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
  (<= 0 i@13@03)))
; [eval] diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i] == -1
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 5
(assert (not (>= i@13@03 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            60
;  :arith-assert-diseq   2
;  :arith-assert-lower   8
;  :arith-assert-upper   4
;  :arith-eq-adapter     5
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.69
;  :mk-bool-var          274
;  :mk-clause            7
;  :num-allocs           3383166
;  :num-checks           2
;  :propagations         9
;  :quant-instantiations 8
;  :rlimit-count         109603)
; [eval] -1
(push) ; 5
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@13@03] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@13@03] != -1 | live]
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@13@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
    i@13@03)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@13@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
      i@13@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i]
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 7
(assert (not (>= i@13@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            60
;  :arith-assert-diseq   2
;  :arith-assert-lower   8
;  :arith-assert-upper   4
;  :arith-eq-adapter     5
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.69
;  :mk-bool-var          275
;  :mk-clause            7
;  :num-allocs           3383166
;  :num-checks           3
;  :propagations         9
;  :quant-instantiations 8
;  :rlimit-count         109790)
(push) ; 7
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@13@03] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@13@03]) | live]
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@13@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
    i@13@03)))
; [eval] diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 9
(assert (not (>= i@13@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            60
;  :arith-assert-diseq   3
;  :arith-assert-lower   11
;  :arith-assert-upper   4
;  :arith-eq-adapter     6
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :datatype-accessor-ax 10
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.69
;  :mk-bool-var          278
;  :mk-clause            8
;  :num-allocs           3383166
;  :num-checks           4
;  :propagations         9
;  :quant-instantiations 8
;  :rlimit-count         109924)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@13@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
      i@13@03))))
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
; [else-branch: 1 | !(i@13@03 < |First:(Second:(Second:(Second:(Second:($t@12@03)))))| && 0 <= i@13@03)]
(assert (not
  (and
    (<
      i@13@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
    (<= 0 i@13@03))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@13@03 Int)) (!
  (implies
    (and
      (<
        i@13@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
      (<= 0 i@13@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
          i@13@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
            i@13@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
            i@13@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
    i@13@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))
(declare-const $k@14@03 $Perm)
(assert ($Perm.isReadVar $k@14@03 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@14@03 $Perm.No) (< $Perm.No $k@14@03))))
(check-sat)
; unsat
(pop) ; 2
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            65
;  :arith-assert-diseq   4
;  :arith-assert-lower   13
;  :arith-assert-upper   5
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            1
;  :datatype-accessor-ax 11
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.69
;  :mk-bool-var          284
;  :mk-clause            10
;  :num-allocs           3383166
;  :num-checks           5
;  :propagations         10
;  :quant-instantiations 8
;  :rlimit-count         110723)
(assert (<= $Perm.No $k@14@03))
(assert (<= $k@14@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@14@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            71
;  :arith-assert-diseq   4
;  :arith-assert-lower   13
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            2
;  :datatype-accessor-ax 12
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.69
;  :mk-bool-var          287
;  :mk-clause            10
;  :num-allocs           3383166
;  :num-checks           6
;  :propagations         10
;  :quant-instantiations 8
;  :rlimit-count         111056)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            77
;  :arith-assert-diseq   4
;  :arith-assert-lower   13
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            3
;  :datatype-accessor-ax 13
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.78
;  :mk-bool-var          290
;  :mk-clause            10
;  :num-allocs           3499319
;  :num-checks           7
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         111422)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            82
;  :arith-assert-diseq   4
;  :arith-assert-lower   13
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            4
;  :datatype-accessor-ax 14
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.78
;  :mk-bool-var          291
;  :mk-clause            10
;  :num-allocs           3499319
;  :num-checks           8
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         111689)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            87
;  :arith-assert-diseq   4
;  :arith-assert-lower   13
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            5
;  :datatype-accessor-ax 15
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          292
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           9
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         111966)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            92
;  :arith-assert-diseq   4
;  :arith-assert-lower   13
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            6
;  :datatype-accessor-ax 16
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          293
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           10
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         112253)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            97
;  :arith-assert-diseq   4
;  :arith-assert-lower   13
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            7
;  :datatype-accessor-ax 17
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          294
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           11
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         112550)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            102
;  :arith-assert-diseq   4
;  :arith-assert-lower   13
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            8
;  :datatype-accessor-ax 18
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          295
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           12
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         112857)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            108
;  :arith-assert-diseq   4
;  :arith-assert-lower   13
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            9
;  :datatype-accessor-ax 19
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          297
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           13
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         113206)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            115
;  :arith-assert-diseq   4
;  :arith-assert-lower   14
;  :arith-assert-upper   6
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            10
;  :datatype-accessor-ax 20
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          301
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           14
;  :propagations         10
;  :quant-instantiations 10
;  :rlimit-count         113664)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            120
;  :arith-assert-diseq   4
;  :arith-assert-lower   14
;  :arith-assert-upper   7
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            11
;  :datatype-accessor-ax 21
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          303
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           15
;  :propagations         10
;  :quant-instantiations 10
;  :rlimit-count         114047)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            120
;  :arith-assert-diseq   4
;  :arith-assert-lower   14
;  :arith-assert-upper   7
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            11
;  :datatype-accessor-ax 21
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          303
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           16
;  :propagations         10
;  :quant-instantiations 10
;  :rlimit-count         114060)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            126
;  :arith-assert-diseq   4
;  :arith-assert-lower   14
;  :arith-assert-upper   7
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            12
;  :datatype-accessor-ax 22
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          305
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           17
;  :propagations         10
;  :quant-instantiations 10
;  :rlimit-count         114439)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))
  diz@6@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.03s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            133
;  :arith-assert-diseq   4
;  :arith-assert-lower   14
;  :arith-assert-upper   7
;  :arith-eq-adapter     7
;  :arith-fixed-eqs      1
;  :binary-propagations  7
;  :conflicts            12
;  :datatype-accessor-ax 23
;  :del-clause           1
;  :max-generation       1
;  :max-memory           3.96
;  :memory               3.93
;  :mk-bool-var          307
;  :mk-clause            10
;  :num-allocs           3615703
;  :num-checks           18
;  :propagations         10
;  :quant-instantiations 10
;  :rlimit-count         114812)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@15@03 $Snap)
(assert (= $t@15@03 ($Snap.combine ($Snap.first $t@15@03) ($Snap.second $t@15@03))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               184
;  :arith-assert-diseq      4
;  :arith-assert-lower      14
;  :arith-assert-upper      7
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              9
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             329
;  :mk-clause               11
;  :num-allocs              3615703
;  :num-checks              20
;  :propagations            10
;  :quant-instantiations    13
;  :rlimit-count            115890)
(assert (=
  ($Snap.second $t@15@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@15@03))
    ($Snap.second ($Snap.second $t@15@03)))))
(assert (= ($Snap.first ($Snap.second $t@15@03)) $Snap.unit))
; [eval] diz.ALU_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@15@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@15@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@15@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@15@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.ALU_m.Main_process_state[i] } 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|)
(declare-const i@16@03 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@16@03 | live]
; [else-branch: 4 | !(0 <= i@16@03) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@16@03]
(assert (<= 0 i@16@03))
; [eval] i < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@16@03)]
(assert (not (<= 0 i@16@03)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@16@03 < |First:(Second:(Second:(Second:($t@15@03))))| && 0 <= i@16@03 | live]
; [else-branch: 5 | !(i@16@03 < |First:(Second:(Second:(Second:($t@15@03))))| && 0 <= i@16@03) | live]
(push) ; 5
; [then-branch: 5 | i@16@03 < |First:(Second:(Second:(Second:($t@15@03))))| && 0 <= i@16@03]
(assert (and
  (<
    i@16@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))
  (<= 0 i@16@03)))
; [eval] diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i] == -1
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 6
(assert (not (>= i@16@03 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               229
;  :arith-assert-diseq      4
;  :arith-assert-lower      19
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              9
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             354
;  :mk-clause               11
;  :num-allocs              3615703
;  :num-checks              21
;  :propagations            10
;  :quant-instantiations    18
;  :rlimit-count            117173)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@15@03))))[i@16@03] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@15@03))))[i@16@03] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@15@03))))[i@16@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
    i@16@03)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@15@03))))[i@16@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
      i@16@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i]
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 8
(assert (not (>= i@16@03 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               229
;  :arith-assert-diseq      4
;  :arith-assert-lower      19
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              9
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             355
;  :mk-clause               11
;  :num-allocs              3615703
;  :num-checks              22
;  :propagations            10
;  :quant-instantiations    18
;  :rlimit-count            117348)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@15@03))))[i@16@03] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@15@03))))[i@16@03]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@15@03))))[i@16@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
    i@16@03)))
; [eval] diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 10
(assert (not (>= i@16@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               229
;  :arith-assert-diseq      5
;  :arith-assert-lower      22
;  :arith-assert-upper      10
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              9
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             358
;  :mk-clause               12
;  :num-allocs              3615703
;  :num-checks              23
;  :propagations            10
;  :quant-instantiations    18
;  :rlimit-count            117472)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@15@03))))[i@16@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
      i@16@03))))
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
; [else-branch: 5 | !(i@16@03 < |First:(Second:(Second:(Second:($t@15@03))))| && 0 <= i@16@03)]
(assert (not
  (and
    (<
      i@16@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))
    (<= 0 i@16@03))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@16@03 Int)) (!
  (implies
    (and
      (<
        i@16@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))
      (<= 0 i@16@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
          i@16@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
            i@16@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
            i@16@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))
    i@16@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))
(declare-const $k@17@03 $Perm)
(assert ($Perm.isReadVar $k@17@03 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@17@03 $Perm.No) (< $Perm.No $k@17@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               234
;  :arith-assert-diseq      6
;  :arith-assert-lower      24
;  :arith-assert-upper      11
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               14
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             364
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              24
;  :propagations            11
;  :quant-instantiations    18
;  :rlimit-count            118241)
(assert (<= $Perm.No $k@17@03))
(assert (<= $k@17@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@17@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@15@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               240
;  :arith-assert-diseq      6
;  :arith-assert-lower      24
;  :arith-assert-upper      12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               15
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             367
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              25
;  :propagations            11
;  :quant-instantiations    18
;  :rlimit-count            118564)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               246
;  :arith-assert-diseq      6
;  :arith-assert-lower      24
;  :arith-assert-upper      12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               16
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             370
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              26
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            118920
;  :time                    0.00)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               251
;  :arith-assert-diseq      6
;  :arith-assert-lower      24
;  :arith-assert-upper      12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             371
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              27
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            119177)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               256
;  :arith-assert-diseq      6
;  :arith-assert-lower      24
;  :arith-assert-upper      12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               18
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             372
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              28
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            119444)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               261
;  :arith-assert-diseq      6
;  :arith-assert-lower      24
;  :arith-assert-upper      12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               19
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             373
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              29
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            119721)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-assert-diseq      6
;  :arith-assert-lower      24
;  :arith-assert-upper      12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               20
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             374
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              30
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            120008)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               271
;  :arith-assert-diseq      6
;  :arith-assert-lower      24
;  :arith-assert-upper      12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             375
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              31
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            120305)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               277
;  :arith-assert-diseq      6
;  :arith-assert-lower      24
;  :arith-assert-upper      12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               22
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             377
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              32
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            120644
;  :time                    0.01)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               284
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      12
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               23
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             381
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              33
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            121092)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               289
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               24
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             383
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              34
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            121465)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               289
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               24
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.93
;  :mk-bool-var             383
;  :mk-clause               14
;  :num-allocs              3615703
;  :num-checks              35
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            121478)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@17@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               295
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             385
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              36
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            121847
;  :time                    0.00)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))
  diz@6@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               303
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              10
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             387
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              37
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122211)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@15@03)))))))))))))))))))))
(pop) ; 2
(push) ; 2
; [exec]
; var sys__local__result__12: Int
(declare-const sys__local__result__12@18@03 Int)
; [exec]
; var i__13: Int
(declare-const i__13@19@03 Int)
; [exec]
; var divisor__14: Int
(declare-const divisor__14@20@03 Int)
; [exec]
; var current_bit__15: Int
(declare-const current_bit__15@21@03 Int)
; [exec]
; var __flatten_2__16: Ref
(declare-const __flatten_2__16@22@03 $Ref)
; [exec]
; var __flatten_4__17: Int
(declare-const __flatten_4__17@23@03 Int)
; [exec]
; __flatten_2__16 := diz.ALU_m
(declare-const __flatten_2__16@24@03 $Ref)
(assert (=
  __flatten_2__16@24@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@03)))))
; [exec]
; current_bit__15 := ALU_get_bit_EncodedGlobalVariables_Integer_Integer(__flatten_2__16.Main_alu, globals, value, pos)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@03)))
  __flatten_2__16@24@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              38
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122357)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              39
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122405)
; [eval] diz != null
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              40
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122418)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              41
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122429)
; [eval] diz.ALU_m != null
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              42
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122440)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              43
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122451)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              44
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122462)
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              45
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122473)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              46
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122484)
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             388
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              47
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122495)
; [eval] (forall i: Int :: { diz.ALU_m.Main_process_state[i] } 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|)
(declare-const i@25@03 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 8 | 0 <= i@25@03 | live]
; [else-branch: 8 | !(0 <= i@25@03) | live]
(push) ; 5
; [then-branch: 8 | 0 <= i@25@03]
(assert (<= 0 i@25@03))
; [eval] i < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(push) ; 6
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               304
;  :arith-assert-diseq      6
;  :arith-assert-lower      26
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             389
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              48
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122559)
(pop) ; 5
(push) ; 5
; [else-branch: 8 | !(0 <= i@25@03)]
(assert (not (<= 0 i@25@03)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 9 | i@25@03 < |First:(Second:(Second:(Second:(Second:($t@12@03)))))| && 0 <= i@25@03 | live]
; [else-branch: 9 | !(i@25@03 < |First:(Second:(Second:(Second:(Second:($t@12@03)))))| && 0 <= i@25@03) | live]
(push) ; 5
; [then-branch: 9 | i@25@03 < |First:(Second:(Second:(Second:(Second:($t@12@03)))))| && 0 <= i@25@03]
(assert (and
  (<
    i@25@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
  (<= 0 i@25@03)))
; [eval] diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i] == -1
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 6
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               305
;  :arith-assert-diseq      6
;  :arith-assert-lower      27
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             391
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              49
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122683)
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@25@03 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               305
;  :arith-assert-diseq      6
;  :arith-assert-lower      27
;  :arith-assert-upper      14
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             391
;  :mk-clause               14
;  :num-allocs              3738190
;  :num-checks              50
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122692)
; [eval] -1
(push) ; 6
; [then-branch: 10 | First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@25@03] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@25@03] != -1 | live]
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@25@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
    i@25@03)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 10 | First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@25@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
      i@25@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i]
; [eval] diz.ALU_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 8
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-assert-diseq      8
;  :arith-assert-lower      30
;  :arith-assert-upper      15
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             398
;  :mk-clause               26
;  :num-allocs              3738190
;  :num-checks              51
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            122942)
(set-option :timeout 0)
(push) ; 8
(assert (not (>= i@25@03 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               307
;  :arith-assert-diseq      8
;  :arith-assert-lower      30
;  :arith-assert-upper      15
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             398
;  :mk-clause               26
;  :num-allocs              3738190
;  :num-checks              52
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            122951)
(push) ; 8
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@25@03] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@25@03]) | live]
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@25@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
    i@25@03)))
; [eval] diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i]
(set-option :timeout 10)
(push) ; 10
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      8
;  :arith-assert-lower      32
;  :arith-assert-upper      16
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             402
;  :mk-clause               26
;  :num-allocs              3738190
;  :num-checks              53
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            123100)
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i@25@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      8
;  :arith-assert-lower      32
;  :arith-assert-upper      16
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             402
;  :mk-clause               26
;  :num-allocs              3738190
;  :num-checks              54
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            123109)
; [eval] |diz.ALU_m.Main_event_state|
(set-option :timeout 10)
(push) ; 10
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      8
;  :arith-assert-lower      32
;  :arith-assert-upper      16
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         4
;  :arith-pivots            1
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             402
;  :mk-clause               26
;  :num-allocs              3738190
;  :num-checks              55
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            123120)
(pop) ; 9
(push) ; 9
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:(Second:($t@12@03)))))[i@25@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
      i@25@03))))
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
; [else-branch: 9 | !(i@25@03 < |First:(Second:(Second:(Second:(Second:($t@12@03)))))| && 0 <= i@25@03)]
(assert (not
  (and
    (<
      i@25@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
    (<= 0 i@25@03))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(set-option :timeout 0)
(push) ; 3
(assert (not (forall ((i@25@03 Int)) (!
  (implies
    (and
      (<
        i@25@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
      (<= 0 i@25@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
          i@25@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
            i@25@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
            i@25@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
    i@25@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      9
;  :arith-assert-lower      33
;  :arith-assert-upper      17
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               27
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             410
;  :mk-clause               38
;  :num-allocs              3738190
;  :num-checks              56
;  :propagations            18
;  :quant-instantiations    22
;  :rlimit-count            123581)
(assert (forall ((i@25@03 Int)) (!
  (implies
    (and
      (<
        i@25@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))
      (<= 0 i@25@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
          i@25@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
            i@25@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
            i@25@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))
    i@25@03))
  :qid |prog.l<no position>|)))
(declare-const $k@26@03 $Perm)
(assert ($Perm.isReadVar $k@26@03 $Perm.Write))
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               27
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             415
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              57
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124121)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@26@03 $Perm.No) (< $Perm.No $k@26@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               28
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             415
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              58
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124171)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= $k@14@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               28
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             415
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              59
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124182)
(assert (< $k@26@03 $k@14@03))
(assert (<= $Perm.No (- $k@14@03 $k@26@03)))
(assert (<= (- $k@14@03 $k@26@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@14@03 $k@26@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@03)))
      $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               28
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              60
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124359)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               29
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              61
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124407)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               29
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              62
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124418)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               30
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              63
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124466)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               30
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              64
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124477)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               31
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              65
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124525)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               31
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              66
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124536)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               32
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              67
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124584)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               32
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              68
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124595)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               33
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              69
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124643)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               33
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              70
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124654)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              71
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124702)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              72
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124713)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               35
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              73
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124761)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               35
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              74
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124772)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               36
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              75
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124820)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               36
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              76
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124831)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              77
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124879)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              78
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124892)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              79
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124903)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               309
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              36
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             418
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              80
;  :propagations            19
;  :quant-instantiations    22
;  :rlimit-count            124951)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               343
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              36
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             421
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              81
;  :propagations            20
;  :quant-instantiations    22
;  :rlimit-count            125450)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 3
(assert (not (=
  diz@6@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03))))))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               343
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              36
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             421
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              82
;  :propagations            20
;  :quant-instantiations    22
;  :rlimit-count            125461)
(push) ; 3
(assert (not (< $Perm.No $k@14@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               343
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              36
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             421
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              83
;  :propagations            20
;  :quant-instantiations    22
;  :rlimit-count            125509)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               343
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              36
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             421
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              84
;  :propagations            20
;  :quant-instantiations    22
;  :rlimit-count            125522)
(declare-const sys__result@27@03 Int)
(declare-const $t@28@03 $Snap)
(assert (= $t@28@03 ($Snap.combine ($Snap.first $t@28@03) ($Snap.second $t@28@03))))
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               348
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         5
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    47
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              36
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             422
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              85
;  :propagations            20
;  :quant-instantiations    22
;  :rlimit-count            125630)
(assert (=
  ($Snap.second $t@28@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@28@03))
    ($Snap.second ($Snap.second $t@28@03)))))
(assert (= ($Snap.first ($Snap.second $t@28@03)) $Snap.unit))
; [eval] diz.ALU_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@28@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@28@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@28@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@28@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.ALU_m.Main_process_state[i] } 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|)
(declare-const i@29@03 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 12 | 0 <= i@29@03 | live]
; [else-branch: 12 | !(0 <= i@29@03) | live]
(push) ; 5
; [then-branch: 12 | 0 <= i@29@03]
(assert (<= 0 i@29@03))
; [eval] i < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 12 | !(0 <= i@29@03)]
(assert (not (<= 0 i@29@03)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 13 | i@29@03 < |First:(Second:(Second:(Second:($t@28@03))))| && 0 <= i@29@03 | live]
; [else-branch: 13 | !(i@29@03 < |First:(Second:(Second:(Second:($t@28@03))))| && 0 <= i@29@03) | live]
(push) ; 5
; [then-branch: 13 | i@29@03 < |First:(Second:(Second:(Second:($t@28@03))))| && 0 <= i@29@03]
(assert (and
  (<
    i@29@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
  (<= 0 i@29@03)))
; [eval] diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i] == -1
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 6
(assert (not (>= i@29@03 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               393
;  :arith-assert-diseq      10
;  :arith-assert-lower      42
;  :arith-assert-upper      22
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              36
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             447
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              86
;  :propagations            20
;  :quant-instantiations    27
;  :rlimit-count            126913)
; [eval] -1
(push) ; 6
; [then-branch: 14 | First:(Second:(Second:(Second:($t@28@03))))[i@29@03] == -1 | live]
; [else-branch: 14 | First:(Second:(Second:(Second:($t@28@03))))[i@29@03] != -1 | live]
(push) ; 7
; [then-branch: 14 | First:(Second:(Second:(Second:($t@28@03))))[i@29@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
    i@29@03)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 14 | First:(Second:(Second:(Second:($t@28@03))))[i@29@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
      i@29@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i]
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 8
(assert (not (>= i@29@03 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               393
;  :arith-assert-diseq      10
;  :arith-assert-lower      42
;  :arith-assert-upper      22
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              36
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             448
;  :mk-clause               40
;  :num-allocs              3738190
;  :num-checks              87
;  :propagations            20
;  :quant-instantiations    27
;  :rlimit-count            127088)
(push) ; 8
; [then-branch: 15 | 0 <= First:(Second:(Second:(Second:($t@28@03))))[i@29@03] | live]
; [else-branch: 15 | !(0 <= First:(Second:(Second:(Second:($t@28@03))))[i@29@03]) | live]
(push) ; 9
; [then-branch: 15 | 0 <= First:(Second:(Second:(Second:($t@28@03))))[i@29@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
    i@29@03)))
; [eval] diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 10
(assert (not (>= i@29@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               393
;  :arith-assert-diseq      11
;  :arith-assert-lower      45
;  :arith-assert-upper      22
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              36
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             451
;  :mk-clause               41
;  :num-allocs              3738190
;  :num-checks              88
;  :propagations            20
;  :quant-instantiations    27
;  :rlimit-count            127212)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 15 | !(0 <= First:(Second:(Second:(Second:($t@28@03))))[i@29@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
      i@29@03))))
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
; [else-branch: 13 | !(i@29@03 < |First:(Second:(Second:(Second:($t@28@03))))| && 0 <= i@29@03)]
(assert (not
  (and
    (<
      i@29@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
    (<= 0 i@29@03))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@29@03 Int)) (!
  (implies
    (and
      (<
        i@29@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
      (<= 0 i@29@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
          i@29@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
            i@29@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
            i@29@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
    i@29@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))
(declare-const $k@30@03 $Perm)
(assert ($Perm.isReadVar $k@30@03 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@30@03 $Perm.No) (< $Perm.No $k@30@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               398
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      23
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               40
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              37
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             457
;  :mk-clause               43
;  :num-allocs              3738190
;  :num-checks              89
;  :propagations            21
;  :quant-instantiations    27
;  :rlimit-count            127981)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@03)))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@28@03)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               522
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      23
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               42
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             493
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              90
;  :propagations            23
;  :quant-instantiations    27
;  :rlimit-count            129018)
(assert (<= $Perm.No $k@30@03))
(assert (<= $k@30@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@30@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@28@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               528
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             496
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              91
;  :propagations            23
;  :quant-instantiations    27
;  :rlimit-count            129341)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               534
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             499
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              92
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            129697)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               539
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             500
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              93
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            129954)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               544
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               46
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             501
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              94
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            130221)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               549
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             502
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              95
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            130498)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               554
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             503
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              96
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            130785)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               559
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               49
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             504
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              97
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            131082)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               565
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               50
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             506
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              98
;  :propagations            23
;  :quant-instantiations    28
;  :rlimit-count            131421)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               572
;  :arith-assert-diseq      12
;  :arith-assert-lower      48
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    68
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             510
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              99
;  :propagations            23
;  :quant-instantiations    29
;  :rlimit-count            131869)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               577
;  :arith-assert-diseq      12
;  :arith-assert-lower      48
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             512
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              100
;  :propagations            23
;  :quant-instantiations    29
;  :rlimit-count            132242)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               577
;  :arith-assert-diseq      12
;  :arith-assert-lower      48
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    69
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             512
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              101
;  :propagations            23
;  :quant-instantiations    29
;  :rlimit-count            132255)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               583
;  :arith-assert-diseq      12
;  :arith-assert-lower      48
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    70
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             514
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              102
;  :propagations            23
;  :quant-instantiations    29
;  :rlimit-count            132624)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@12@03)))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               591
;  :arith-assert-diseq      12
;  :arith-assert-lower      48
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 76
;  :datatype-occurs-check   13
;  :datatype-splits         43
;  :decisions               70
;  :del-clause              39
;  :final-checks            9
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             516
;  :mk-clause               45
;  :num-allocs              3738190
;  :num-checks              103
;  :propagations            23
;  :quant-instantiations    29
;  :rlimit-count            132988)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [exec]
; divisor__14 := 1
; [exec]
; i__13 := 0
(declare-const divisor__14@31@03 Int)
(declare-const __flatten_4__17@32@03 Int)
(declare-const i__13@33@03 Int)
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@34@03 $Snap)
(assert (= $t@34@03 ($Snap.combine ($Snap.first $t@34@03) ($Snap.second $t@34@03))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               724
;  :arith-assert-diseq      12
;  :arith-assert-lower      49
;  :arith-assert-upper      26
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         7
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              44
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             554
;  :mk-clause               47
;  :num-allocs              3738190
;  :num-checks              105
;  :propagations            24
;  :quant-instantiations    31
;  :rlimit-count            134424)
(assert (=
  ($Snap.second $t@34@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@34@03))
    ($Snap.second ($Snap.second $t@34@03)))))
(assert (= ($Snap.first ($Snap.second $t@34@03)) $Snap.unit))
; [eval] diz.ALU_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@34@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@34@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@34@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
  $Snap.unit))
; [eval] (forall i__18: Int :: { diz.ALU_m.Main_process_state[i__18] } 0 <= i__18 && i__18 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__18] == -1 || 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|)
(declare-const i__18@35@03 Int)
(push) ; 4
; [eval] 0 <= i__18 && i__18 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__18] == -1 || 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__18 && i__18 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__18
(push) ; 5
; [then-branch: 16 | 0 <= i__18@35@03 | live]
; [else-branch: 16 | !(0 <= i__18@35@03) | live]
(push) ; 6
; [then-branch: 16 | 0 <= i__18@35@03]
(assert (<= 0 i__18@35@03))
; [eval] i__18 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 16 | !(0 <= i__18@35@03)]
(assert (not (<= 0 i__18@35@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 17 | i__18@35@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__18@35@03 | live]
; [else-branch: 17 | !(i__18@35@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__18@35@03) | live]
(push) ; 6
; [then-branch: 17 | i__18@35@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__18@35@03]
(assert (and
  (<
    i__18@35@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  (<= 0 i__18@35@03)))
; [eval] diz.ALU_m.Main_process_state[i__18] == -1 || 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__18] == -1
; [eval] diz.ALU_m.Main_process_state[i__18]
(push) ; 7
(assert (not (>= i__18@35@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               769
;  :arith-assert-diseq      12
;  :arith-assert-lower      54
;  :arith-assert-upper      29
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              44
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             579
;  :mk-clause               47
;  :num-allocs              3738190
;  :num-checks              106
;  :propagations            24
;  :quant-instantiations    36
;  :rlimit-count            135706)
; [eval] -1
(push) ; 7
; [then-branch: 18 | First:(Second:(Second:(Second:($t@34@03))))[i__18@35@03] == -1 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:($t@34@03))))[i__18@35@03] != -1 | live]
(push) ; 8
; [then-branch: 18 | First:(Second:(Second:(Second:($t@34@03))))[i__18@35@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__18@35@03)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 18 | First:(Second:(Second:(Second:($t@34@03))))[i__18@35@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__18@35@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__18]
; [eval] diz.ALU_m.Main_process_state[i__18]
(push) ; 9
(assert (not (>= i__18@35@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               769
;  :arith-assert-diseq      12
;  :arith-assert-lower      54
;  :arith-assert-upper      29
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              44
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             580
;  :mk-clause               47
;  :num-allocs              3870208
;  :num-checks              107
;  :propagations            24
;  :quant-instantiations    36
;  :rlimit-count            135881)
(push) ; 9
; [then-branch: 19 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__18@35@03] | live]
; [else-branch: 19 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__18@35@03]) | live]
(push) ; 10
; [then-branch: 19 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__18@35@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__18@35@03)))
; [eval] diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__18]
(push) ; 11
(assert (not (>= i__18@35@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               769
;  :arith-assert-diseq      13
;  :arith-assert-lower      57
;  :arith-assert-upper      29
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              44
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             583
;  :mk-clause               48
;  :num-allocs              3870208
;  :num-checks              108
;  :propagations            24
;  :quant-instantiations    36
;  :rlimit-count            136004)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 19 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__18@35@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__18@35@03))))
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
; [else-branch: 17 | !(i__18@35@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__18@35@03)]
(assert (not
  (and
    (<
      i__18@35@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    (<= 0 i__18@35@03))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__18@35@03 Int)) (!
  (implies
    (and
      (<
        i__18@35@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__18@35@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__18@35@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__18@35@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__18@35@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__18@35@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))
(declare-const $k@36@03 $Perm)
(assert ($Perm.isReadVar $k@36@03 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@36@03 $Perm.No) (< $Perm.No $k@36@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               774
;  :arith-assert-diseq      14
;  :arith-assert-lower      59
;  :arith-assert-upper      30
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               55
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             589
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              109
;  :propagations            25
;  :quant-instantiations    36
;  :rlimit-count            136772)
(assert (<= $Perm.No $k@36@03))
(assert (<= $k@36@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@36@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               780
;  :arith-assert-diseq      14
;  :arith-assert-lower      59
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               56
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             592
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              110
;  :propagations            25
;  :quant-instantiations    36
;  :rlimit-count            137095)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               786
;  :arith-assert-diseq      14
;  :arith-assert-lower      59
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             595
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              111
;  :propagations            25
;  :quant-instantiations    37
;  :rlimit-count            137451)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               791
;  :arith-assert-diseq      14
;  :arith-assert-lower      59
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             596
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              112
;  :propagations            25
;  :quant-instantiations    37
;  :rlimit-count            137708)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               796
;  :arith-assert-diseq      14
;  :arith-assert-lower      59
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               59
;  :datatype-accessor-ax    86
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             597
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              113
;  :propagations            25
;  :quant-instantiations    37
;  :rlimit-count            137975)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               801
;  :arith-assert-diseq      14
;  :arith-assert-lower      59
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               60
;  :datatype-accessor-ax    87
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             598
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              114
;  :propagations            25
;  :quant-instantiations    37
;  :rlimit-count            138252)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               806
;  :arith-assert-diseq      14
;  :arith-assert-lower      59
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    88
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             599
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              115
;  :propagations            25
;  :quant-instantiations    37
;  :rlimit-count            138539)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               811
;  :arith-assert-diseq      14
;  :arith-assert-lower      59
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             600
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              116
;  :propagations            25
;  :quant-instantiations    37
;  :rlimit-count            138836)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               817
;  :arith-assert-diseq      14
;  :arith-assert-lower      59
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               63
;  :datatype-accessor-ax    90
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             602
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              117
;  :propagations            25
;  :quant-instantiations    37
;  :rlimit-count            139175)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               824
;  :arith-assert-diseq      14
;  :arith-assert-lower      60
;  :arith-assert-upper      31
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    91
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             606
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              118
;  :propagations            25
;  :quant-instantiations    38
;  :rlimit-count            139622)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               829
;  :arith-assert-diseq      14
;  :arith-assert-lower      60
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             608
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              119
;  :propagations            25
;  :quant-instantiations    38
;  :rlimit-count            139996)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               829
;  :arith-assert-diseq      14
;  :arith-assert-lower      60
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    92
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             608
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              120
;  :propagations            25
;  :quant-instantiations    38
;  :rlimit-count            140009)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               835
;  :arith-assert-diseq      14
;  :arith-assert-lower      60
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    93
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             610
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              121
;  :propagations            25
;  :quant-instantiations    38
;  :rlimit-count            140378)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
  diz@6@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               843
;  :arith-assert-diseq      14
;  :arith-assert-lower      60
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              45
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             612
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              122
;  :propagations            25
;  :quant-instantiations    38
;  :rlimit-count            140742)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
; [eval] i__13 < pos
(pop) ; 4
(push) ; 4
; [eval] !(i__13 < pos)
; [eval] i__13 < pos
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
; (:added-eqs               855
;  :arith-assert-diseq      14
;  :arith-assert-lower      60
;  :arith-assert-upper      32
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         8
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              47
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             617
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              123
;  :propagations            25
;  :quant-instantiations    40
;  :rlimit-count            141194)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__18: Int :: { diz.ALU_m.Main_process_state[i__18] } 0 <= i__18 && i__18 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__18] == -1 || 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|)
(declare-const i__18@37@03 Int)
(push) ; 4
; [eval] 0 <= i__18 && i__18 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__18] == -1 || 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__18 && i__18 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__18
(push) ; 5
; [then-branch: 20 | 0 <= i__18@37@03 | live]
; [else-branch: 20 | !(0 <= i__18@37@03) | live]
(push) ; 6
; [then-branch: 20 | 0 <= i__18@37@03]
(assert (<= 0 i__18@37@03))
; [eval] i__18 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 20 | !(0 <= i__18@37@03)]
(assert (not (<= 0 i__18@37@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 21 | i__18@37@03 < |First:(Second:(Second:(Second:($t@28@03))))| && 0 <= i__18@37@03 | live]
; [else-branch: 21 | !(i__18@37@03 < |First:(Second:(Second:(Second:($t@28@03))))| && 0 <= i__18@37@03) | live]
(push) ; 6
; [then-branch: 21 | i__18@37@03 < |First:(Second:(Second:(Second:($t@28@03))))| && 0 <= i__18@37@03]
(assert (and
  (<
    i__18@37@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
  (<= 0 i__18@37@03)))
; [eval] diz.ALU_m.Main_process_state[i__18] == -1 || 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__18] == -1
; [eval] diz.ALU_m.Main_process_state[i__18]
(push) ; 7
(assert (not (>= i__18@37@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               856
;  :arith-assert-diseq      14
;  :arith-assert-lower      61
;  :arith-assert-upper      33
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         9
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              47
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             619
;  :mk-clause               50
;  :num-allocs              3870208
;  :num-checks              124
;  :propagations            25
;  :quant-instantiations    40
;  :rlimit-count            141334)
; [eval] -1
(push) ; 7
; [then-branch: 22 | First:(Second:(Second:(Second:($t@28@03))))[i__18@37@03] == -1 | live]
; [else-branch: 22 | First:(Second:(Second:(Second:($t@28@03))))[i__18@37@03] != -1 | live]
(push) ; 8
; [then-branch: 22 | First:(Second:(Second:(Second:($t@28@03))))[i__18@37@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
    i__18@37@03)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 22 | First:(Second:(Second:(Second:($t@28@03))))[i__18@37@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
      i__18@37@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__18]
; [eval] diz.ALU_m.Main_process_state[i__18]
(push) ; 9
(assert (not (>= i__18@37@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               858
;  :arith-assert-diseq      16
;  :arith-assert-lower      64
;  :arith-assert-upper      34
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         9
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              47
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             626
;  :mk-clause               62
;  :num-allocs              3870208
;  :num-checks              125
;  :propagations            30
;  :quant-instantiations    41
;  :rlimit-count            141564)
(push) ; 9
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@28@03))))[i__18@37@03] | live]
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@28@03))))[i__18@37@03]) | live]
(push) ; 10
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@28@03))))[i__18@37@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
    i__18@37@03)))
; [eval] diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__18]
(push) ; 11
(assert (not (>= i__18@37@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      16
;  :arith-assert-lower      66
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         10
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              47
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             630
;  :mk-clause               62
;  :num-allocs              3870208
;  :num-checks              126
;  :propagations            30
;  :quant-instantiations    41
;  :rlimit-count            141701)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@28@03))))[i__18@37@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
      i__18@37@03))))
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
; [else-branch: 21 | !(i__18@37@03 < |First:(Second:(Second:(Second:($t@28@03))))| && 0 <= i__18@37@03)]
(assert (not
  (and
    (<
      i__18@37@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
    (<= 0 i__18@37@03))))
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
(assert (not (forall ((i__18@37@03 Int)) (!
  (implies
    (and
      (<
        i__18@37@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
      (<= 0 i__18@37@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
          i__18@37@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
            i__18@37@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
            i__18@37@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
    i__18@37@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      17
;  :arith-assert-lower      67
;  :arith-assert-upper      36
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         11
;  :arith-pivots            7
;  :binary-propagations     7
;  :conflicts               67
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             638
;  :mk-clause               74
;  :num-allocs              3870208
;  :num-checks              127
;  :propagations            32
;  :quant-instantiations    42
;  :rlimit-count            142150)
(assert (forall ((i__18@37@03 Int)) (!
  (implies
    (and
      (<
        i__18@37@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))
      (<= 0 i__18@37@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
          i__18@37@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
            i__18@37@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
            i__18@37@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@28@03)))))
    i__18@37@03))
  :qid |prog.l<no position>|)))
(declare-const $k@38@03 $Perm)
(assert ($Perm.isReadVar $k@38@03 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@38@03 $Perm.No) (< $Perm.No $k@38@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      69
;  :arith-assert-upper      37
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            7
;  :binary-propagations     7
;  :conflicts               68
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             643
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              128
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            142711)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@30@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      69
;  :arith-assert-upper      37
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            7
;  :binary-propagations     7
;  :conflicts               68
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             643
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              129
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            142722)
(assert (< $k@38@03 $k@30@03))
(assert (<= $Perm.No (- $k@30@03 $k@38@03)))
(assert (<= (- $k@30@03 $k@38@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@30@03 $k@38@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@28@03)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               69
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              130
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            142936)
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               70
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              131
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            142984)
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               71
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              132
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            143032)
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              133
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            143080)
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               73
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              134
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            143128)
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               74
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              135
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            143176)
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               75
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              136
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            143224)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               76
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              137
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            143272)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               77
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              138
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            143320)
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
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               77
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              139
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            143333)
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               860
;  :arith-assert-diseq      18
;  :arith-assert-lower      71
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               78
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 114
;  :datatype-occurs-check   18
;  :datatype-splits         68
;  :decisions               106
;  :del-clause              71
;  :final-checks            12
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             646
;  :mk-clause               76
;  :num-allocs              3870208
;  :num-checks              140
;  :propagations            33
;  :quant-instantiations    42
;  :rlimit-count            143381)
(push) ; 4
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               946
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      40
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               78
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 140
;  :datatype-occurs-check   23
;  :datatype-splits         82
;  :decisions               131
;  :del-clause              74
;  :final-checks            16
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             666
;  :mk-clause               79
;  :num-allocs              3870208
;  :num-checks              141
;  :propagations            36
;  :quant-instantiations    42
;  :rlimit-count            144151
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 4
(assert (not (< $Perm.No $k@30@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               946
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      40
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               79
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 140
;  :datatype-occurs-check   23
;  :datatype-splits         82
;  :decisions               131
;  :del-clause              74
;  :final-checks            16
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             666
;  :mk-clause               79
;  :num-allocs              3870208
;  :num-checks              142
;  :propagations            36
;  :quant-instantiations    42
;  :rlimit-count            144199)
(set-option :timeout 0)
(push) ; 4
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))
  diz@6@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               946
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      40
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               79
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 140
;  :datatype-occurs-check   23
;  :datatype-splits         82
;  :decisions               131
;  :del-clause              74
;  :final-checks            16
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             666
;  :mk-clause               79
;  :num-allocs              3870208
;  :num-checks              143
;  :propagations            36
;  :quant-instantiations    42
;  :rlimit-count            144210)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@28@03))))))))))
  diz@6@03))
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               946
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      40
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         11
;  :arith-offset-eqs        1
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               79
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 140
;  :datatype-occurs-check   23
;  :datatype-splits         82
;  :decisions               131
;  :del-clause              74
;  :final-checks            16
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.15
;  :memory                  4.15
;  :mk-bool-var             666
;  :mk-clause               79
;  :num-allocs              3870208
;  :num-checks              144
;  :propagations            36
;  :quant-instantiations    42
;  :rlimit-count            144226)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert ($Perm.isReadVar $k@36@03 $Perm.Write))
(assert (= $t@34@03 ($Snap.combine ($Snap.first $t@34@03) ($Snap.second $t@34@03))))
(assert (=
  ($Snap.second $t@34@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@34@03))
    ($Snap.second ($Snap.second $t@34@03)))))
(assert (= ($Snap.first ($Snap.second $t@34@03)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@34@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@34@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@34@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
  $Snap.unit))
(assert (forall ((i__18@35@03 Int)) (!
  (implies
    (and
      (<
        i__18@35@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__18@35@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__18@35@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__18@35@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__18@35@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__18@35@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))
(assert (<= $Perm.No $k@36@03))
(assert (<= $k@36@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@36@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
  $Snap.unit))
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))
  $Snap.unit))
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))
  diz@6@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
; [eval] i__13 < pos
(push) ; 5
(assert (not (not (< i__13@33@03 pos@9@03))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1560
;  :arith-add-rows          1
;  :arith-assert-diseq      19
;  :arith-assert-lower      87
;  :arith-assert-upper      54
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         19
;  :arith-offset-eqs        1
;  :arith-pivots            24
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 275
;  :datatype-occurs-check   46
;  :datatype-splits         179
;  :decisions               258
;  :del-clause              92
;  :final-checks            28
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             851
;  :mk-clause               98
;  :num-allocs              4009379
;  :num-checks              147
;  :propagations            49
;  :quant-instantiations    51
;  :rlimit-count            150784
;  :time                    0.00)
(push) ; 5
(assert (not (< i__13@33@03 pos@9@03)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1696
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      90
;  :arith-assert-upper      56
;  :arith-eq-adapter        43
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        1
;  :arith-pivots            28
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              94
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             885
;  :mk-clause               100
;  :num-allocs              4009379
;  :num-checks              148
;  :propagations            52
;  :quant-instantiations    51
;  :rlimit-count            151841
;  :time                    0.00)
; [then-branch: 24 | i__13@33@03 < pos@9@03 | live]
; [else-branch: 24 | !(i__13@33@03 < pos@9@03) | live]
(push) ; 5
; [then-branch: 24 | i__13@33@03 < pos@9@03]
(assert (< i__13@33@03 pos@9@03))
; [exec]
; divisor__14 := divisor__14 * 2
; [eval] divisor__14 * 2
(declare-const divisor__14@39@03 Int)
(assert (= divisor__14@39@03 (* divisor__14@31@03 2)))
; [exec]
; __flatten_4__17 := i__13
; [exec]
; i__13 := i__13 + 1
; [eval] i__13 + 1
(declare-const i__13@40@03 Int)
(assert (= i__13@40@03 (+ i__13@33@03 1)))
; Loop head block: Re-establish invariant
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1698
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      92
;  :arith-assert-upper      59
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         21
;  :arith-offset-eqs        1
;  :arith-pivots            30
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              94
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             892
;  :mk-clause               106
;  :num-allocs              4009379
;  :num-checks              149
;  :propagations            56
;  :quant-instantiations    51
;  :rlimit-count            152096)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__18: Int :: { diz.ALU_m.Main_process_state[i__18] } 0 <= i__18 && i__18 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__18] == -1 || 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|)
(declare-const i__18@41@03 Int)
(push) ; 6
; [eval] 0 <= i__18 && i__18 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__18] == -1 || 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__18 && i__18 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__18
(push) ; 7
; [then-branch: 25 | 0 <= i__18@41@03 | live]
; [else-branch: 25 | !(0 <= i__18@41@03) | live]
(push) ; 8
; [then-branch: 25 | 0 <= i__18@41@03]
(assert (<= 0 i__18@41@03))
; [eval] i__18 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 25 | !(0 <= i__18@41@03)]
(assert (not (<= 0 i__18@41@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 26 | i__18@41@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__18@41@03 | live]
; [else-branch: 26 | !(i__18@41@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__18@41@03) | live]
(push) ; 8
; [then-branch: 26 | i__18@41@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__18@41@03]
(assert (and
  (<
    i__18@41@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  (<= 0 i__18@41@03)))
; [eval] diz.ALU_m.Main_process_state[i__18] == -1 || 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__18] == -1
; [eval] diz.ALU_m.Main_process_state[i__18]
(push) ; 9
(assert (not (>= i__18@41@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1699
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      93
;  :arith-assert-upper      60
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        1
;  :arith-pivots            30
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              94
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             894
;  :mk-clause               106
;  :num-allocs              4009379
;  :num-checks              150
;  :propagations            56
;  :quant-instantiations    51
;  :rlimit-count            152236)
; [eval] -1
(push) ; 9
; [then-branch: 27 | First:(Second:(Second:(Second:($t@34@03))))[i__18@41@03] == -1 | live]
; [else-branch: 27 | First:(Second:(Second:(Second:($t@34@03))))[i__18@41@03] != -1 | live]
(push) ; 10
; [then-branch: 27 | First:(Second:(Second:(Second:($t@34@03))))[i__18@41@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__18@41@03)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 27 | First:(Second:(Second:(Second:($t@34@03))))[i__18@41@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__18@41@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__18] && diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__18]
; [eval] diz.ALU_m.Main_process_state[i__18]
(push) ; 11
(assert (not (>= i__18@41@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1701
;  :arith-add-rows          2
;  :arith-assert-diseq      21
;  :arith-assert-lower      96
;  :arith-assert-upper      61
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        1
;  :arith-pivots            30
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              94
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             901
;  :mk-clause               118
;  :num-allocs              4009379
;  :num-checks              151
;  :propagations            61
;  :quant-instantiations    52
;  :rlimit-count            152467)
(push) ; 11
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__18@41@03] | live]
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__18@41@03]) | live]
(push) ; 12
; [then-branch: 28 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__18@41@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__18@41@03)))
; [eval] diz.ALU_m.Main_process_state[i__18] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__18]
(push) ; 13
(assert (not (>= i__18@41@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      21
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        1
;  :arith-pivots            32
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              94
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             905
;  :mk-clause               118
;  :num-allocs              4009379
;  :num-checks              152
;  :propagations            61
;  :quant-instantiations    52
;  :rlimit-count            152608)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 28 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__18@41@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__18@41@03))))
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
; [else-branch: 26 | !(i__18@41@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__18@41@03)]
(assert (not
  (and
    (<
      i__18@41@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    (<= 0 i__18@41@03))))
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
(assert (not (forall ((i__18@41@03 Int)) (!
  (implies
    (and
      (<
        i__18@41@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__18@41@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__18@41@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__18@41@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__18@41@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__18@41@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      99
;  :arith-assert-upper      63
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             913
;  :mk-clause               132
;  :num-allocs              4009379
;  :num-checks              153
;  :propagations            63
;  :quant-instantiations    53
;  :rlimit-count            153057)
(assert (forall ((i__18@41@03 Int)) (!
  (implies
    (and
      (<
        i__18@41@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__18@41@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__18@41@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__18@41@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__18@41@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__18@41@03))
  :qid |prog.l<no position>|)))
(declare-const $k@42@03 $Perm)
(assert ($Perm.isReadVar $k@42@03 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@42@03 $Perm.No) (< $Perm.No $k@42@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      101
;  :arith-assert-upper      64
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               82
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             918
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              154
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            153617)
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= $k@36@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      101
;  :arith-assert-upper      64
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               82
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             918
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              155
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            153628)
(assert (< $k@42@03 $k@36@03))
(assert (<= $Perm.No (- $k@36@03 $k@42@03)))
(assert (<= (- $k@36@03 $k@42@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@36@03 $k@42@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              156
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            153848)
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               84
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              157
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            153896)
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               85
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              158
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            153944)
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               86
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              159
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            153992)
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               87
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              160
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            154040)
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               88
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              161
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            154088)
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               89
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              162
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            154136)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               90
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              163
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            154184)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              164
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            154232)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              165
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            154245)
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1703
;  :arith-add-rows          2
;  :arith-assert-diseq      24
;  :arith-assert-lower      103
;  :arith-assert-upper      65
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 313
;  :datatype-occurs-check   53
;  :datatype-splits         205
;  :decisions               293
;  :del-clause              120
;  :final-checks            31
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             921
;  :mk-clause               134
;  :num-allocs              4009379
;  :num-checks              166
;  :propagations            64
;  :quant-instantiations    53
;  :rlimit-count            154293)
(push) ; 6
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1839
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      105
;  :arith-assert-upper      67
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        1
;  :arith-pivots            39
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 351
;  :datatype-occurs-check   60
;  :datatype-splits         231
;  :decisions               328
;  :del-clause              122
;  :final-checks            34
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             954
;  :mk-clause               136
;  :num-allocs              4154823
;  :num-checks              167
;  :propagations            67
;  :quant-instantiations    53
;  :rlimit-count            155295
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 6
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1839
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      105
;  :arith-assert-upper      67
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        1
;  :arith-pivots            39
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 351
;  :datatype-occurs-check   60
;  :datatype-splits         231
;  :decisions               328
;  :del-clause              122
;  :final-checks            34
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             954
;  :mk-clause               136
;  :num-allocs              4154823
;  :num-checks              168
;  :propagations            67
;  :quant-instantiations    53
;  :rlimit-count            155343)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1839
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      105
;  :arith-assert-upper      67
;  :arith-eq-adapter        51
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        1
;  :arith-pivots            39
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 351
;  :datatype-occurs-check   60
;  :datatype-splits         231
;  :decisions               328
;  :del-clause              122
;  :final-checks            34
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             954
;  :mk-clause               136
;  :num-allocs              4154823
;  :num-checks              169
;  :propagations            67
;  :quant-instantiations    53
;  :rlimit-count            155356)
(pop) ; 5
(push) ; 5
; [else-branch: 24 | !(i__13@33@03 < pos@9@03)]
(assert (not (< i__13@33@03 pos@9@03)))
(pop) ; 5
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@28@03)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2011
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      108
;  :arith-assert-upper      70
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         29
;  :arith-offset-eqs        1
;  :arith-pivots            48
;  :binary-propagations     7
;  :conflicts               94
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 399
;  :datatype-occurs-check   68
;  :datatype-splits         258
;  :decisions               373
;  :del-clause              137
;  :final-checks            38
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             995
;  :mk-clause               143
;  :num-allocs              4154823
;  :num-checks              170
;  :propagations            72
;  :quant-instantiations    53
;  :rlimit-count            156617
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@28@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@03))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2192
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      110
;  :arith-assert-upper      72
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        1
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               95
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 453
;  :datatype-occurs-check   79
;  :datatype-splits         307
;  :decisions               420
;  :del-clause              140
;  :final-checks            42
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1056
;  :mk-clause               146
;  :num-allocs              4154823
;  :num-checks              171
;  :propagations            78
;  :quant-instantiations    53
;  :rlimit-count            157868
;  :time                    0.00)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@12@03))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2411
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      114
;  :arith-assert-upper      76
;  :arith-eq-adapter        60
;  :arith-fixed-eqs         35
;  :arith-offset-eqs        1
;  :arith-pivots            58
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 516
;  :datatype-occurs-check   90
;  :datatype-splits         355
;  :decisions               477
;  :del-clause              148
;  :final-checks            47
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1122
;  :mk-clause               154
;  :num-allocs              4154823
;  :num-checks              172
;  :propagations            86
;  :quant-instantiations    53
;  :rlimit-count            159300
;  :time                    0.00)
; [eval] !(i__13 < pos)
; [eval] i__13 < pos
(push) ; 5
(assert (not (< i__13@33@03 pos@9@03)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2549
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      117
;  :arith-assert-upper      79
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        3
;  :arith-pivots            62
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    154
;  :datatype-constructor-ax 554
;  :datatype-occurs-check   97
;  :datatype-splits         381
;  :decisions               513
;  :del-clause              152
;  :final-checks            51
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1158
;  :mk-clause               158
;  :num-allocs              4154823
;  :num-checks              173
;  :propagations            90
;  :quant-instantiations    53
;  :rlimit-count            160396
;  :time                    0.00)
(push) ; 5
(assert (not (not (< i__13@33@03 pos@9@03))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2685
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      119
;  :arith-assert-upper      82
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        3
;  :arith-pivots            66
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    157
;  :datatype-constructor-ax 592
;  :datatype-occurs-check   104
;  :datatype-splits         407
;  :decisions               548
;  :del-clause              154
;  :final-checks            54
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1192
;  :mk-clause               160
;  :num-allocs              4154823
;  :num-checks              174
;  :propagations            93
;  :quant-instantiations    53
;  :rlimit-count            161469
;  :time                    0.00)
; [then-branch: 29 | !(i__13@33@03 < pos@9@03) | live]
; [else-branch: 29 | i__13@33@03 < pos@9@03 | live]
(push) ; 5
; [then-branch: 29 | !(i__13@33@03 < pos@9@03)]
(assert (not (< i__13@33@03 pos@9@03)))
; [eval] current_bit__15 == bit
(push) ; 6
(assert (not (not (= sys__result@27@03 bit@10@03))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2822
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      122
;  :arith-assert-upper      84
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         40
;  :arith-offset-eqs        3
;  :arith-pivots            70
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    160
;  :datatype-constructor-ax 630
;  :datatype-occurs-check   111
;  :datatype-splits         433
;  :decisions               583
;  :del-clause              156
;  :final-checks            57
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1227
;  :mk-clause               162
;  :num-allocs              4154823
;  :num-checks              175
;  :propagations            96
;  :quant-instantiations    53
;  :rlimit-count            162570
;  :time                    0.00)
(push) ; 6
(assert (not (= sys__result@27@03 bit@10@03)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2958
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      124
;  :arith-assert-upper      86
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        3
;  :arith-pivots            74
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              158
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1261
;  :mk-clause               164
;  :num-allocs              4154823
;  :num-checks              176
;  :propagations            99
;  :quant-instantiations    53
;  :rlimit-count            163605
;  :time                    0.00)
; [then-branch: 30 | sys__result@27@03 == bit@10@03 | live]
; [else-branch: 30 | sys__result@27@03 != bit@10@03 | live]
(push) ; 6
; [then-branch: 30 | sys__result@27@03 == bit@10@03]
(assert (= sys__result@27@03 bit@10@03))
; [exec]
; sys__local__result__12 := value
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && (true && (true && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__19: Int :: { diz.ALU_m.Main_process_state[i__19] } 0 <= i__19 && i__19 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__19] == -1 || 0 <= diz.ALU_m.Main_process_state[i__19] && diz.ALU_m.Main_process_state[i__19] < |diz.ALU_m.Main_event_state|)) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2)) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2959
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      124
;  :arith-assert-upper      86
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        3
;  :arith-pivots            74
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              158
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1262
;  :mk-clause               164
;  :num-allocs              4154823
;  :num-checks              177
;  :propagations            99
;  :quant-instantiations    53
;  :rlimit-count            163660)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__19: Int :: { diz.ALU_m.Main_process_state[i__19] } 0 <= i__19 && i__19 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__19] == -1 || 0 <= diz.ALU_m.Main_process_state[i__19] && diz.ALU_m.Main_process_state[i__19] < |diz.ALU_m.Main_event_state|)
(declare-const i__19@43@03 Int)
(push) ; 7
; [eval] 0 <= i__19 && i__19 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__19] == -1 || 0 <= diz.ALU_m.Main_process_state[i__19] && diz.ALU_m.Main_process_state[i__19] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__19 && i__19 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__19
(push) ; 8
; [then-branch: 31 | 0 <= i__19@43@03 | live]
; [else-branch: 31 | !(0 <= i__19@43@03) | live]
(push) ; 9
; [then-branch: 31 | 0 <= i__19@43@03]
(assert (<= 0 i__19@43@03))
; [eval] i__19 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 31 | !(0 <= i__19@43@03)]
(assert (not (<= 0 i__19@43@03)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 32 | i__19@43@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__19@43@03 | live]
; [else-branch: 32 | !(i__19@43@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__19@43@03) | live]
(push) ; 9
; [then-branch: 32 | i__19@43@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__19@43@03]
(assert (and
  (<
    i__19@43@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  (<= 0 i__19@43@03)))
; [eval] diz.ALU_m.Main_process_state[i__19] == -1 || 0 <= diz.ALU_m.Main_process_state[i__19] && diz.ALU_m.Main_process_state[i__19] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__19] == -1
; [eval] diz.ALU_m.Main_process_state[i__19]
(push) ; 10
(assert (not (>= i__19@43@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2960
;  :arith-add-rows          5
;  :arith-assert-diseq      24
;  :arith-assert-lower      125
;  :arith-assert-upper      87
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         43
;  :arith-offset-eqs        3
;  :arith-pivots            74
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              158
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1264
;  :mk-clause               164
;  :num-allocs              4154823
;  :num-checks              178
;  :propagations            99
;  :quant-instantiations    53
;  :rlimit-count            163800)
; [eval] -1
(push) ; 10
; [then-branch: 33 | First:(Second:(Second:(Second:($t@34@03))))[i__19@43@03] == -1 | live]
; [else-branch: 33 | First:(Second:(Second:(Second:($t@34@03))))[i__19@43@03] != -1 | live]
(push) ; 11
; [then-branch: 33 | First:(Second:(Second:(Second:($t@34@03))))[i__19@43@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__19@43@03)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 33 | First:(Second:(Second:(Second:($t@34@03))))[i__19@43@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__19@43@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__19] && diz.ALU_m.Main_process_state[i__19] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__19]
; [eval] diz.ALU_m.Main_process_state[i__19]
(push) ; 12
(assert (not (>= i__19@43@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2962
;  :arith-add-rows          5
;  :arith-assert-diseq      26
;  :arith-assert-lower      128
;  :arith-assert-upper      88
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         43
;  :arith-offset-eqs        3
;  :arith-pivots            74
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              158
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1271
;  :mk-clause               176
;  :num-allocs              4154823
;  :num-checks              179
;  :propagations            104
;  :quant-instantiations    54
;  :rlimit-count            164017)
(push) ; 12
; [then-branch: 34 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__19@43@03] | live]
; [else-branch: 34 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__19@43@03]) | live]
(push) ; 13
; [then-branch: 34 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__19@43@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__19@43@03)))
; [eval] diz.ALU_m.Main_process_state[i__19] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__19]
(push) ; 14
(assert (not (>= i__19@43@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      26
;  :arith-assert-lower      130
;  :arith-assert-upper      89
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         44
;  :arith-offset-eqs        3
;  :arith-pivots            74
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              158
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1275
;  :mk-clause               176
;  :num-allocs              4154823
;  :num-checks              180
;  :propagations            104
;  :quant-instantiations    54
;  :rlimit-count            164148)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 34 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__19@43@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__19@43@03))))
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
; [else-branch: 32 | !(i__19@43@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__19@43@03)]
(assert (not
  (and
    (<
      i__19@43@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    (<= 0 i__19@43@03))))
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
(assert (not (forall ((i__19@43@03 Int)) (!
  (implies
    (and
      (<
        i__19@43@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__19@43@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__19@43@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__19@43@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__19@43@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__19@43@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      28
;  :arith-assert-lower      131
;  :arith-assert-upper      90
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            74
;  :binary-propagations     7
;  :conflicts               97
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1283
;  :mk-clause               190
;  :num-allocs              4154823
;  :num-checks              181
;  :propagations            106
;  :quant-instantiations    55
;  :rlimit-count            164594)
(assert (forall ((i__19@43@03 Int)) (!
  (implies
    (and
      (<
        i__19@43@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__19@43@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__19@43@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__19@43@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__19@43@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__19@43@03))
  :qid |prog.l<no position>|)))
(declare-const $k@44@03 $Perm)
(assert ($Perm.isReadVar $k@44@03 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@44@03 $Perm.No) (< $Perm.No $k@44@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      133
;  :arith-assert-upper      91
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            74
;  :binary-propagations     7
;  :conflicts               98
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1288
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              182
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165154)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@36@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      133
;  :arith-assert-upper      91
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            74
;  :binary-propagations     7
;  :conflicts               98
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1288
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              183
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165165)
(assert (< $k@44@03 $k@36@03))
(assert (<= $Perm.No (- $k@36@03 $k@44@03)))
(assert (<= (- $k@36@03 $k@44@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@36@03 $k@44@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               99
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              184
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165379)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               100
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              185
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165427)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               101
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              186
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165475)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               102
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              187
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165523)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               103
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              188
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165571)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               104
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              189
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165619)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               105
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              190
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165667)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               106
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              191
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165715)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               107
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              192
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165763)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               107
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              193
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165776)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2964
;  :arith-add-rows          5
;  :arith-assert-diseq      29
;  :arith-assert-lower      135
;  :arith-assert-upper      92
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         45
;  :arith-offset-eqs        3
;  :arith-pivots            75
;  :binary-propagations     7
;  :conflicts               108
;  :datatype-accessor-ax    163
;  :datatype-constructor-ax 668
;  :datatype-occurs-check   118
;  :datatype-splits         459
;  :decisions               618
;  :del-clause              184
;  :final-checks            60
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1291
;  :mk-clause               192
;  :num-allocs              4154823
;  :num-checks              194
;  :propagations            107
;  :quant-instantiations    55
;  :rlimit-count            165824)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3100
;  :arith-add-rows          6
;  :arith-assert-diseq      29
;  :arith-assert-lower      137
;  :arith-assert-upper      94
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         47
;  :arith-offset-eqs        3
;  :arith-pivots            79
;  :binary-propagations     7
;  :conflicts               108
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              186
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1324
;  :mk-clause               194
;  :num-allocs              4154823
;  :num-checks              195
;  :propagations            110
;  :quant-instantiations    55
;  :rlimit-count            166825
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3100
;  :arith-add-rows          6
;  :arith-assert-diseq      29
;  :arith-assert-lower      137
;  :arith-assert-upper      94
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         47
;  :arith-offset-eqs        3
;  :arith-pivots            79
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              186
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1324
;  :mk-clause               194
;  :num-allocs              4154823
;  :num-checks              196
;  :propagations            110
;  :quant-instantiations    55
;  :rlimit-count            166873)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3100
;  :arith-add-rows          6
;  :arith-assert-diseq      29
;  :arith-assert-lower      137
;  :arith-assert-upper      94
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         47
;  :arith-offset-eqs        3
;  :arith-pivots            79
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              186
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1324
;  :mk-clause               194
;  :num-allocs              4154823
;  :num-checks              197
;  :propagations            110
;  :quant-instantiations    55
;  :rlimit-count            166886)
; [exec]
; label __return_set_bit
; [exec]
; sys__result := sys__local__result__12
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__22: Int :: { diz.ALU_m.Main_process_state[i__22] } 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3100
;  :arith-add-rows          6
;  :arith-assert-diseq      29
;  :arith-assert-lower      137
;  :arith-assert-upper      94
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         47
;  :arith-offset-eqs        3
;  :arith-pivots            79
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              186
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1324
;  :mk-clause               194
;  :num-allocs              4154823
;  :num-checks              198
;  :propagations            110
;  :quant-instantiations    55
;  :rlimit-count            166899)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__22: Int :: { diz.ALU_m.Main_process_state[i__22] } 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|)
(declare-const i__22@45@03 Int)
(push) ; 7
; [eval] 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__22
(push) ; 8
; [then-branch: 35 | 0 <= i__22@45@03 | live]
; [else-branch: 35 | !(0 <= i__22@45@03) | live]
(push) ; 9
; [then-branch: 35 | 0 <= i__22@45@03]
(assert (<= 0 i__22@45@03))
; [eval] i__22 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 35 | !(0 <= i__22@45@03)]
(assert (not (<= 0 i__22@45@03)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 36 | i__22@45@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@45@03 | live]
; [else-branch: 36 | !(i__22@45@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@45@03) | live]
(push) ; 9
; [then-branch: 36 | i__22@45@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@45@03]
(assert (and
  (<
    i__22@45@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  (<= 0 i__22@45@03)))
; [eval] diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__22] == -1
; [eval] diz.ALU_m.Main_process_state[i__22]
(push) ; 10
(assert (not (>= i__22@45@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3101
;  :arith-add-rows          6
;  :arith-assert-diseq      29
;  :arith-assert-lower      138
;  :arith-assert-upper      95
;  :arith-eq-adapter        75
;  :arith-fixed-eqs         48
;  :arith-offset-eqs        3
;  :arith-pivots            79
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              186
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1326
;  :mk-clause               194
;  :num-allocs              4154823
;  :num-checks              199
;  :propagations            110
;  :quant-instantiations    55
;  :rlimit-count            167039)
; [eval] -1
(push) ; 10
; [then-branch: 37 | First:(Second:(Second:(Second:($t@34@03))))[i__22@45@03] == -1 | live]
; [else-branch: 37 | First:(Second:(Second:(Second:($t@34@03))))[i__22@45@03] != -1 | live]
(push) ; 11
; [then-branch: 37 | First:(Second:(Second:(Second:($t@34@03))))[i__22@45@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@45@03)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 37 | First:(Second:(Second:(Second:($t@34@03))))[i__22@45@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__22@45@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__22]
; [eval] diz.ALU_m.Main_process_state[i__22]
(push) ; 12
(assert (not (>= i__22@45@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3103
;  :arith-add-rows          6
;  :arith-assert-diseq      31
;  :arith-assert-lower      141
;  :arith-assert-upper      96
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         48
;  :arith-offset-eqs        3
;  :arith-pivots            79
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              186
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1333
;  :mk-clause               207
;  :num-allocs              4154823
;  :num-checks              200
;  :propagations            115
;  :quant-instantiations    57
;  :rlimit-count            167281)
(push) ; 12
; [then-branch: 38 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@45@03] | live]
; [else-branch: 38 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@45@03]) | live]
(push) ; 13
; [then-branch: 38 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@45@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@45@03)))
; [eval] diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__22]
(push) ; 14
(assert (not (>= i__22@45@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      31
;  :arith-assert-lower      143
;  :arith-assert-upper      97
;  :arith-eq-adapter        77
;  :arith-fixed-eqs         49
;  :arith-offset-eqs        3
;  :arith-pivots            80
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              186
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1337
;  :mk-clause               207
;  :num-allocs              4154823
;  :num-checks              201
;  :propagations            115
;  :quant-instantiations    57
;  :rlimit-count            167416)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 38 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@45@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__22@45@03))))
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
; [else-branch: 36 | !(i__22@45@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@45@03)]
(assert (not
  (and
    (<
      i__22@45@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    (<= 0 i__22@45@03))))
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
(assert (not (forall ((i__22@45@03 Int)) (!
  (implies
    (and
      (<
        i__22@45@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__22@45@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__22@45@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@45@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@45@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@45@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      32
;  :arith-assert-lower      144
;  :arith-assert-upper      98
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            81
;  :binary-propagations     7
;  :conflicts               110
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1345
;  :mk-clause               219
;  :num-allocs              4154823
;  :num-checks              202
;  :propagations            117
;  :quant-instantiations    59
;  :rlimit-count            167890)
(assert (forall ((i__22@45@03 Int)) (!
  (implies
    (and
      (<
        i__22@45@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__22@45@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__22@45@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@45@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@45@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@45@03))
  :qid |prog.l<no position>|)))
(declare-const $k@46@03 $Perm)
(assert ($Perm.isReadVar $k@46@03 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@46@03 $Perm.No) (< $Perm.No $k@46@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      146
;  :arith-assert-upper      99
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            81
;  :binary-propagations     7
;  :conflicts               111
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1350
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              203
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            168450)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@36@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      146
;  :arith-assert-upper      99
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            81
;  :binary-propagations     7
;  :conflicts               111
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1350
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              204
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            168461)
(assert (< $k@46@03 $k@36@03))
(assert (<= $Perm.No (- $k@36@03 $k@46@03)))
(assert (<= (- $k@36@03 $k@46@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@36@03 $k@46@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               112
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              205
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            168675)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               113
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              206
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            168723)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               114
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              207
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            168771)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               115
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              208
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            168819)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               116
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              209
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            168867)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               117
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              210
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            168915)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               118
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              211
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            168963)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               119
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              212
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            169011)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               120
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              213
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            169059)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               120
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              214
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            169072)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3105
;  :arith-add-rows          6
;  :arith-assert-diseq      33
;  :arith-assert-lower      147
;  :arith-assert-upper      101
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        3
;  :arith-pivots            82
;  :binary-propagations     7
;  :conflicts               121
;  :datatype-accessor-ax    166
;  :datatype-constructor-ax 706
;  :datatype-occurs-check   125
;  :datatype-splits         485
;  :decisions               653
;  :del-clause              211
;  :final-checks            63
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1353
;  :mk-clause               221
;  :num-allocs              4154823
;  :num-checks              215
;  :propagations            118
;  :quant-instantiations    59
;  :rlimit-count            169120)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3241
;  :arith-add-rows          7
;  :arith-assert-diseq      33
;  :arith-assert-lower      149
;  :arith-assert-upper      103
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         52
;  :arith-offset-eqs        3
;  :arith-pivots            86
;  :binary-propagations     7
;  :conflicts               121
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 744
;  :datatype-occurs-check   132
;  :datatype-splits         511
;  :decisions               688
;  :del-clause              213
;  :final-checks            66
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1386
;  :mk-clause               223
;  :num-allocs              4154823
;  :num-checks              216
;  :propagations            121
;  :quant-instantiations    59
;  :rlimit-count            170128
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 7
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3241
;  :arith-add-rows          7
;  :arith-assert-diseq      33
;  :arith-assert-lower      149
;  :arith-assert-upper      103
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         52
;  :arith-offset-eqs        3
;  :arith-pivots            86
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 744
;  :datatype-occurs-check   132
;  :datatype-splits         511
;  :decisions               688
;  :del-clause              213
;  :final-checks            66
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1386
;  :mk-clause               223
;  :num-allocs              4154823
;  :num-checks              217
;  :propagations            121
;  :quant-instantiations    59
;  :rlimit-count            170176)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3241
;  :arith-add-rows          7
;  :arith-assert-diseq      33
;  :arith-assert-lower      149
;  :arith-assert-upper      103
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         52
;  :arith-offset-eqs        3
;  :arith-pivots            86
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    169
;  :datatype-constructor-ax 744
;  :datatype-occurs-check   132
;  :datatype-splits         511
;  :decisions               688
;  :del-clause              213
;  :final-checks            66
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1386
;  :mk-clause               223
;  :num-allocs              4154823
;  :num-checks              218
;  :propagations            121
;  :quant-instantiations    59
;  :rlimit-count            170189)
; [exec]
; inhale false
(pop) ; 6
(push) ; 6
; [else-branch: 30 | sys__result@27@03 != bit@10@03]
(assert (not (= sys__result@27@03 bit@10@03)))
(pop) ; 6
; [eval] !(current_bit__15 == bit)
; [eval] current_bit__15 == bit
(set-option :timeout 10)
(push) ; 6
(assert (not (= sys__result@27@03 bit@10@03)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3377
;  :arith-add-rows          8
;  :arith-assert-diseq      33
;  :arith-assert-lower      151
;  :arith-assert-upper      105
;  :arith-eq-adapter        83
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        3
;  :arith-pivots            92
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    172
;  :datatype-constructor-ax 782
;  :datatype-occurs-check   139
;  :datatype-splits         537
;  :decisions               723
;  :del-clause              219
;  :final-checks            69
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1420
;  :mk-clause               225
;  :num-allocs              4154823
;  :num-checks              219
;  :propagations            124
;  :quant-instantiations    59
;  :rlimit-count            171243
;  :time                    0.00)
(push) ; 6
(assert (not (not (= sys__result@27@03 bit@10@03))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3514
;  :arith-add-rows          9
;  :arith-assert-diseq      33
;  :arith-assert-lower      153
;  :arith-assert-upper      107
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        3
;  :arith-pivots            96
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    175
;  :datatype-constructor-ax 820
;  :datatype-occurs-check   146
;  :datatype-splits         563
;  :decisions               758
;  :del-clause              221
;  :final-checks            72
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1454
;  :mk-clause               227
;  :num-allocs              4154823
;  :num-checks              220
;  :propagations            127
;  :quant-instantiations    59
;  :rlimit-count            172267
;  :time                    0.00)
; [then-branch: 39 | sys__result@27@03 != bit@10@03 | live]
; [else-branch: 39 | sys__result@27@03 == bit@10@03 | live]
(push) ; 6
; [then-branch: 39 | sys__result@27@03 != bit@10@03]
(assert (not (= sys__result@27@03 bit@10@03)))
; [eval] bit == 1
(push) ; 7
(assert (not (not (= bit@10@03 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3651
;  :arith-add-rows          9
;  :arith-assert-diseq      33
;  :arith-assert-lower      155
;  :arith-assert-upper      109
;  :arith-eq-adapter        87
;  :arith-fixed-eqs         58
;  :arith-offset-eqs        3
;  :arith-pivots            100
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    178
;  :datatype-constructor-ax 858
;  :datatype-occurs-check   153
;  :datatype-splits         589
;  :decisions               793
;  :del-clause              223
;  :final-checks            75
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1489
;  :mk-clause               229
;  :num-allocs              4154823
;  :num-checks              221
;  :propagations            130
;  :quant-instantiations    59
;  :rlimit-count            173349
;  :time                    0.00)
(push) ; 7
(assert (not (= bit@10@03 1)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3787
;  :arith-add-rows          10
;  :arith-assert-diseq      33
;  :arith-assert-lower      157
;  :arith-assert-upper      111
;  :arith-eq-adapter        89
;  :arith-fixed-eqs         60
;  :arith-offset-eqs        3
;  :arith-pivots            104
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              225
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1523
;  :mk-clause               231
;  :num-allocs              4154823
;  :num-checks              222
;  :propagations            133
;  :quant-instantiations    59
;  :rlimit-count            174388
;  :time                    0.00)
; [then-branch: 40 | bit@10@03 == 1 | live]
; [else-branch: 40 | bit@10@03 != 1 | live]
(push) ; 7
; [then-branch: 40 | bit@10@03 == 1]
(assert (= bit@10@03 1))
; [exec]
; sys__local__result__12 := value + divisor__14
; [eval] value + divisor__14
(declare-const sys__local__result__12@47@03 Int)
(assert (= sys__local__result__12@47@03 (+ value@8@03 divisor__14@31@03)))
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && (true && (true && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__20: Int :: { diz.ALU_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__20] == -1 || 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|)) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2)) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3789
;  :arith-add-rows          10
;  :arith-assert-diseq      33
;  :arith-assert-lower      158
;  :arith-assert-upper      112
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         60
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              225
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1527
;  :mk-clause               234
;  :num-allocs              4154823
;  :num-checks              223
;  :propagations            135
;  :quant-instantiations    59
;  :rlimit-count            174532)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__20: Int :: { diz.ALU_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__20] == -1 || 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|)
(declare-const i__20@48@03 Int)
(push) ; 8
; [eval] 0 <= i__20 && i__20 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__20] == -1 || 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 9
; [then-branch: 41 | 0 <= i__20@48@03 | live]
; [else-branch: 41 | !(0 <= i__20@48@03) | live]
(push) ; 10
; [then-branch: 41 | 0 <= i__20@48@03]
(assert (<= 0 i__20@48@03))
; [eval] i__20 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 41 | !(0 <= i__20@48@03)]
(assert (not (<= 0 i__20@48@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 42 | i__20@48@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__20@48@03 | live]
; [else-branch: 42 | !(i__20@48@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__20@48@03) | live]
(push) ; 10
; [then-branch: 42 | i__20@48@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__20@48@03]
(assert (and
  (<
    i__20@48@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  (<= 0 i__20@48@03)))
; [eval] diz.ALU_m.Main_process_state[i__20] == -1 || 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__20] == -1
; [eval] diz.ALU_m.Main_process_state[i__20]
(push) ; 11
(assert (not (>= i__20@48@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3790
;  :arith-add-rows          10
;  :arith-assert-diseq      33
;  :arith-assert-lower      159
;  :arith-assert-upper      113
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         61
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              225
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1529
;  :mk-clause               234
;  :num-allocs              4154823
;  :num-checks              224
;  :propagations            135
;  :quant-instantiations    59
;  :rlimit-count            174672)
; [eval] -1
(push) ; 11
; [then-branch: 43 | First:(Second:(Second:(Second:($t@34@03))))[i__20@48@03] == -1 | live]
; [else-branch: 43 | First:(Second:(Second:(Second:($t@34@03))))[i__20@48@03] != -1 | live]
(push) ; 12
; [then-branch: 43 | First:(Second:(Second:(Second:($t@34@03))))[i__20@48@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__20@48@03)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 43 | First:(Second:(Second:(Second:($t@34@03))))[i__20@48@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__20@48@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__20] && diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__20]
; [eval] diz.ALU_m.Main_process_state[i__20]
(push) ; 13
(assert (not (>= i__20@48@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3792
;  :arith-add-rows          10
;  :arith-assert-diseq      35
;  :arith-assert-lower      162
;  :arith-assert-upper      114
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         61
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              225
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1536
;  :mk-clause               246
;  :num-allocs              4154823
;  :num-checks              225
;  :propagations            140
;  :quant-instantiations    60
;  :rlimit-count            174889)
(push) ; 13
; [then-branch: 44 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__20@48@03] | live]
; [else-branch: 44 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__20@48@03]) | live]
(push) ; 14
; [then-branch: 44 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__20@48@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__20@48@03)))
; [eval] diz.ALU_m.Main_process_state[i__20] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__20]
(push) ; 15
(assert (not (>= i__20@48@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      35
;  :arith-assert-lower      164
;  :arith-assert-upper      115
;  :arith-eq-adapter        92
;  :arith-fixed-eqs         62
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              225
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1540
;  :mk-clause               246
;  :num-allocs              4154823
;  :num-checks              226
;  :propagations            140
;  :quant-instantiations    60
;  :rlimit-count            175020)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 44 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__20@48@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__20@48@03))))
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
; [else-branch: 42 | !(i__20@48@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__20@48@03)]
(assert (not
  (and
    (<
      i__20@48@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    (<= 0 i__20@48@03))))
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
(assert (not (forall ((i__20@48@03 Int)) (!
  (implies
    (and
      (<
        i__20@48@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__20@48@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__20@48@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__20@48@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__20@48@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__20@48@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      37
;  :arith-assert-lower      165
;  :arith-assert-upper      116
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               123
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1548
;  :mk-clause               260
;  :num-allocs              4154823
;  :num-checks              227
;  :propagations            142
;  :quant-instantiations    61
;  :rlimit-count            175466)
(assert (forall ((i__20@48@03 Int)) (!
  (implies
    (and
      (<
        i__20@48@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__20@48@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__20@48@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__20@48@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__20@48@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__20@48@03))
  :qid |prog.l<no position>|)))
(declare-const $k@49@03 $Perm)
(assert ($Perm.isReadVar $k@49@03 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@49@03 $Perm.No) (< $Perm.No $k@49@03))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      167
;  :arith-assert-upper      117
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               124
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1553
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              228
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176027)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@36@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      167
;  :arith-assert-upper      117
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               124
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1553
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              229
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176038)
(assert (< $k@49@03 $k@36@03))
(assert (<= $Perm.No (- $k@36@03 $k@49@03)))
(assert (<= (- $k@36@03 $k@49@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@36@03 $k@49@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               125
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              230
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176246)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               126
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              231
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176294)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               127
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              232
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176342)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               128
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              233
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176390)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               129
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              234
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176438)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               130
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              235
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176486)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               131
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              236
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176534)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               132
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              237
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176582)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               133
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              238
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176630)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               133
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              239
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176643)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3794
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      169
;  :arith-assert-upper      118
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         63
;  :arith-offset-eqs        3
;  :arith-pivots            105
;  :binary-propagations     7
;  :conflicts               134
;  :datatype-accessor-ax    181
;  :datatype-constructor-ax 896
;  :datatype-occurs-check   160
;  :datatype-splits         615
;  :decisions               828
;  :del-clause              251
;  :final-checks            78
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1556
;  :mk-clause               262
;  :num-allocs              4154823
;  :num-checks              240
;  :propagations            143
;  :quant-instantiations    61
;  :rlimit-count            176691
;  :time                    0.00)
(push) ; 8
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3930
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      171
;  :arith-assert-upper      120
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         65
;  :arith-offset-eqs        3
;  :arith-pivots            109
;  :binary-propagations     7
;  :conflicts               134
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              253
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1589
;  :mk-clause               264
;  :num-allocs              4154823
;  :num-checks              241
;  :propagations            146
;  :quant-instantiations    61
;  :rlimit-count            177691
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3930
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      171
;  :arith-assert-upper      120
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         65
;  :arith-offset-eqs        3
;  :arith-pivots            109
;  :binary-propagations     7
;  :conflicts               135
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              253
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1589
;  :mk-clause               264
;  :num-allocs              4154823
;  :num-checks              242
;  :propagations            146
;  :quant-instantiations    61
;  :rlimit-count            177739)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3930
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      171
;  :arith-assert-upper      120
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         65
;  :arith-offset-eqs        3
;  :arith-pivots            109
;  :binary-propagations     7
;  :conflicts               135
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              253
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1589
;  :mk-clause               264
;  :num-allocs              4154823
;  :num-checks              243
;  :propagations            146
;  :quant-instantiations    61
;  :rlimit-count            177752)
; [exec]
; label __return_set_bit
; [exec]
; sys__result := sys__local__result__12
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__22: Int :: { diz.ALU_m.Main_process_state[i__22] } 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3930
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      171
;  :arith-assert-upper      120
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         65
;  :arith-offset-eqs        3
;  :arith-pivots            109
;  :binary-propagations     7
;  :conflicts               135
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              253
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1589
;  :mk-clause               264
;  :num-allocs              4154823
;  :num-checks              244
;  :propagations            146
;  :quant-instantiations    61
;  :rlimit-count            177765)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__22: Int :: { diz.ALU_m.Main_process_state[i__22] } 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|)
(declare-const i__22@50@03 Int)
(push) ; 8
; [eval] 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__22
(push) ; 9
; [then-branch: 45 | 0 <= i__22@50@03 | live]
; [else-branch: 45 | !(0 <= i__22@50@03) | live]
(push) ; 10
; [then-branch: 45 | 0 <= i__22@50@03]
(assert (<= 0 i__22@50@03))
; [eval] i__22 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 45 | !(0 <= i__22@50@03)]
(assert (not (<= 0 i__22@50@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 46 | i__22@50@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@50@03 | live]
; [else-branch: 46 | !(i__22@50@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@50@03) | live]
(push) ; 10
; [then-branch: 46 | i__22@50@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@50@03]
(assert (and
  (<
    i__22@50@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  (<= 0 i__22@50@03)))
; [eval] diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__22] == -1
; [eval] diz.ALU_m.Main_process_state[i__22]
(push) ; 11
(assert (not (>= i__22@50@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3931
;  :arith-add-rows          10
;  :arith-assert-diseq      38
;  :arith-assert-lower      172
;  :arith-assert-upper      121
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         66
;  :arith-offset-eqs        3
;  :arith-pivots            109
;  :binary-propagations     7
;  :conflicts               135
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              253
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1591
;  :mk-clause               264
;  :num-allocs              4154823
;  :num-checks              245
;  :propagations            146
;  :quant-instantiations    61
;  :rlimit-count            177905)
; [eval] -1
(push) ; 11
; [then-branch: 47 | First:(Second:(Second:(Second:($t@34@03))))[i__22@50@03] == -1 | live]
; [else-branch: 47 | First:(Second:(Second:(Second:($t@34@03))))[i__22@50@03] != -1 | live]
(push) ; 12
; [then-branch: 47 | First:(Second:(Second:(Second:($t@34@03))))[i__22@50@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@50@03)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 47 | First:(Second:(Second:(Second:($t@34@03))))[i__22@50@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__22@50@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__22]
; [eval] diz.ALU_m.Main_process_state[i__22]
(push) ; 13
(assert (not (>= i__22@50@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3933
;  :arith-add-rows          10
;  :arith-assert-diseq      40
;  :arith-assert-lower      175
;  :arith-assert-upper      122
;  :arith-eq-adapter        97
;  :arith-fixed-eqs         66
;  :arith-offset-eqs        3
;  :arith-pivots            109
;  :binary-propagations     7
;  :conflicts               135
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              253
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1598
;  :mk-clause               277
;  :num-allocs              4154823
;  :num-checks              246
;  :propagations            151
;  :quant-instantiations    63
;  :rlimit-count            178146)
(push) ; 13
; [then-branch: 48 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@50@03] | live]
; [else-branch: 48 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@50@03]) | live]
(push) ; 14
; [then-branch: 48 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@50@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@50@03)))
; [eval] diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__22]
(push) ; 15
(assert (not (>= i__22@50@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      40
;  :arith-assert-lower      177
;  :arith-assert-upper      123
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         67
;  :arith-offset-eqs        3
;  :arith-pivots            110
;  :binary-propagations     7
;  :conflicts               135
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              253
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1602
;  :mk-clause               277
;  :num-allocs              4154823
;  :num-checks              247
;  :propagations            151
;  :quant-instantiations    63
;  :rlimit-count            178283)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 48 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@50@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__22@50@03))))
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
; [else-branch: 46 | !(i__22@50@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@50@03)]
(assert (not
  (and
    (<
      i__22@50@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    (<= 0 i__22@50@03))))
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
(assert (not (forall ((i__22@50@03 Int)) (!
  (implies
    (and
      (<
        i__22@50@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__22@50@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__22@50@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@50@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@50@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@50@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      42
;  :arith-assert-lower      178
;  :arith-assert-upper      124
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               136
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1610
;  :mk-clause               291
;  :num-allocs              4154823
;  :num-checks              248
;  :propagations            153
;  :quant-instantiations    65
;  :rlimit-count            178757)
(assert (forall ((i__22@50@03 Int)) (!
  (implies
    (and
      (<
        i__22@50@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__22@50@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__22@50@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@50@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@50@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@50@03))
  :qid |prog.l<no position>|)))
(declare-const $k@51@03 $Perm)
(assert ($Perm.isReadVar $k@51@03 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@51@03 $Perm.No) (< $Perm.No $k@51@03))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      180
;  :arith-assert-upper      125
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               137
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1615
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              249
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179318)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@36@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      180
;  :arith-assert-upper      125
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               137
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1615
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              250
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179329)
(assert (< $k@51@03 $k@36@03))
(assert (<= $Perm.No (- $k@36@03 $k@51@03)))
(assert (<= (- $k@36@03 $k@51@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@36@03 $k@51@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               138
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              251
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179537)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               139
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              252
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179585)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               140
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              253
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179633)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               141
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              254
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179681)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               142
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              255
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179729)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               143
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              256
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179777)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               144
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              257
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179825)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               145
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              258
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179873)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               146
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              259
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179921)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               146
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              260
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179934)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3935
;  :arith-add-rows          10
;  :arith-assert-diseq      43
;  :arith-assert-lower      182
;  :arith-assert-upper      126
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            111
;  :binary-propagations     7
;  :conflicts               147
;  :datatype-accessor-ax    184
;  :datatype-constructor-ax 934
;  :datatype-occurs-check   167
;  :datatype-splits         641
;  :decisions               863
;  :del-clause              280
;  :final-checks            81
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1618
;  :mk-clause               293
;  :num-allocs              4154823
;  :num-checks              261
;  :propagations            154
;  :quant-instantiations    65
;  :rlimit-count            179982)
(push) ; 8
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4071
;  :arith-add-rows          11
;  :arith-assert-diseq      43
;  :arith-assert-lower      184
;  :arith-assert-upper      128
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        3
;  :arith-pivots            115
;  :binary-propagations     7
;  :conflicts               147
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 972
;  :datatype-occurs-check   174
;  :datatype-splits         667
;  :decisions               898
;  :del-clause              282
;  :final-checks            84
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1651
;  :mk-clause               295
;  :num-allocs              4154823
;  :num-checks              262
;  :propagations            157
;  :quant-instantiations    65
;  :rlimit-count            180992
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4071
;  :arith-add-rows          11
;  :arith-assert-diseq      43
;  :arith-assert-lower      184
;  :arith-assert-upper      128
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        3
;  :arith-pivots            115
;  :binary-propagations     7
;  :conflicts               148
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 972
;  :datatype-occurs-check   174
;  :datatype-splits         667
;  :decisions               898
;  :del-clause              282
;  :final-checks            84
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1651
;  :mk-clause               295
;  :num-allocs              4154823
;  :num-checks              263
;  :propagations            157
;  :quant-instantiations    65
;  :rlimit-count            181040)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4071
;  :arith-add-rows          11
;  :arith-assert-diseq      43
;  :arith-assert-lower      184
;  :arith-assert-upper      128
;  :arith-eq-adapter        102
;  :arith-fixed-eqs         70
;  :arith-offset-eqs        3
;  :arith-pivots            115
;  :binary-propagations     7
;  :conflicts               148
;  :datatype-accessor-ax    187
;  :datatype-constructor-ax 972
;  :datatype-occurs-check   174
;  :datatype-splits         667
;  :decisions               898
;  :del-clause              282
;  :final-checks            84
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1651
;  :mk-clause               295
;  :num-allocs              4154823
;  :num-checks              264
;  :propagations            157
;  :quant-instantiations    65
;  :rlimit-count            181053)
; [exec]
; inhale false
(pop) ; 7
(push) ; 7
; [else-branch: 40 | bit@10@03 != 1]
(assert (not (= bit@10@03 1)))
(pop) ; 7
; [eval] !(bit == 1)
; [eval] bit == 1
(set-option :timeout 10)
(push) ; 7
(assert (not (= bit@10@03 1)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4207
;  :arith-add-rows          12
;  :arith-assert-diseq      43
;  :arith-assert-lower      186
;  :arith-assert-upper      130
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         72
;  :arith-offset-eqs        3
;  :arith-pivots            120
;  :binary-propagations     7
;  :conflicts               148
;  :datatype-accessor-ax    190
;  :datatype-constructor-ax 1010
;  :datatype-occurs-check   181
;  :datatype-splits         693
;  :decisions               933
;  :del-clause              291
;  :final-checks            87
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1685
;  :mk-clause               297
;  :num-allocs              4154823
;  :num-checks              265
;  :propagations            160
;  :quant-instantiations    65
;  :rlimit-count            182106
;  :time                    0.00)
(push) ; 7
(assert (not (not (= bit@10@03 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4342
;  :arith-add-rows          12
;  :arith-assert-diseq      43
;  :arith-assert-lower      188
;  :arith-assert-upper      132
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         74
;  :arith-offset-eqs        3
;  :arith-pivots            124
;  :binary-propagations     7
;  :conflicts               148
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              296
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1718
;  :mk-clause               302
;  :num-allocs              4154823
;  :num-checks              266
;  :propagations            165
;  :quant-instantiations    65
;  :rlimit-count            183123
;  :time                    0.00)
; [then-branch: 49 | bit@10@03 != 1 | live]
; [else-branch: 49 | bit@10@03 == 1 | live]
(push) ; 7
; [then-branch: 49 | bit@10@03 != 1]
(assert (not (= bit@10@03 1)))
; [exec]
; sys__local__result__12 := value - divisor__14
; [eval] value - divisor__14
(declare-const sys__local__result__12@52@03 Int)
(assert (= sys__local__result__12@52@03 (- value@8@03 divisor__14@31@03)))
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && (true && (true && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__21: Int :: { diz.ALU_m.Main_process_state[i__21] } 0 <= i__21 && i__21 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__21] == -1 || 0 <= diz.ALU_m.Main_process_state[i__21] && diz.ALU_m.Main_process_state[i__21] < |diz.ALU_m.Main_event_state|)) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2)) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4343
;  :arith-add-rows          12
;  :arith-assert-diseq      43
;  :arith-assert-lower      189
;  :arith-assert-upper      133
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         74
;  :arith-offset-eqs        3
;  :arith-pivots            125
;  :binary-propagations     7
;  :conflicts               148
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              296
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1722
;  :mk-clause               305
;  :num-allocs              4154823
;  :num-checks              267
;  :propagations            167
;  :quant-instantiations    65
;  :rlimit-count            183275)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__21: Int :: { diz.ALU_m.Main_process_state[i__21] } 0 <= i__21 && i__21 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__21] == -1 || 0 <= diz.ALU_m.Main_process_state[i__21] && diz.ALU_m.Main_process_state[i__21] < |diz.ALU_m.Main_event_state|)
(declare-const i__21@53@03 Int)
(push) ; 8
; [eval] 0 <= i__21 && i__21 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__21] == -1 || 0 <= diz.ALU_m.Main_process_state[i__21] && diz.ALU_m.Main_process_state[i__21] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__21 && i__21 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__21
(push) ; 9
; [then-branch: 50 | 0 <= i__21@53@03 | live]
; [else-branch: 50 | !(0 <= i__21@53@03) | live]
(push) ; 10
; [then-branch: 50 | 0 <= i__21@53@03]
(assert (<= 0 i__21@53@03))
; [eval] i__21 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 50 | !(0 <= i__21@53@03)]
(assert (not (<= 0 i__21@53@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 51 | i__21@53@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__21@53@03 | live]
; [else-branch: 51 | !(i__21@53@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__21@53@03) | live]
(push) ; 10
; [then-branch: 51 | i__21@53@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__21@53@03]
(assert (and
  (<
    i__21@53@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  (<= 0 i__21@53@03)))
; [eval] diz.ALU_m.Main_process_state[i__21] == -1 || 0 <= diz.ALU_m.Main_process_state[i__21] && diz.ALU_m.Main_process_state[i__21] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__21] == -1
; [eval] diz.ALU_m.Main_process_state[i__21]
(push) ; 11
(assert (not (>= i__21@53@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4344
;  :arith-add-rows          12
;  :arith-assert-diseq      43
;  :arith-assert-lower      190
;  :arith-assert-upper      134
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         75
;  :arith-offset-eqs        3
;  :arith-pivots            125
;  :binary-propagations     7
;  :conflicts               148
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              296
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1724
;  :mk-clause               305
;  :num-allocs              4154823
;  :num-checks              268
;  :propagations            167
;  :quant-instantiations    65
;  :rlimit-count            183415)
; [eval] -1
(push) ; 11
; [then-branch: 52 | First:(Second:(Second:(Second:($t@34@03))))[i__21@53@03] == -1 | live]
; [else-branch: 52 | First:(Second:(Second:(Second:($t@34@03))))[i__21@53@03] != -1 | live]
(push) ; 12
; [then-branch: 52 | First:(Second:(Second:(Second:($t@34@03))))[i__21@53@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__21@53@03)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 52 | First:(Second:(Second:(Second:($t@34@03))))[i__21@53@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__21@53@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__21] && diz.ALU_m.Main_process_state[i__21] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__21]
; [eval] diz.ALU_m.Main_process_state[i__21]
(push) ; 13
(assert (not (>= i__21@53@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4346
;  :arith-add-rows          12
;  :arith-assert-diseq      45
;  :arith-assert-lower      193
;  :arith-assert-upper      135
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         75
;  :arith-offset-eqs        3
;  :arith-pivots            125
;  :binary-propagations     7
;  :conflicts               148
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              296
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1731
;  :mk-clause               317
;  :num-allocs              4154823
;  :num-checks              269
;  :propagations            172
;  :quant-instantiations    66
;  :rlimit-count            183632)
(push) ; 13
; [then-branch: 53 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__21@53@03] | live]
; [else-branch: 53 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__21@53@03]) | live]
(push) ; 14
; [then-branch: 53 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__21@53@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__21@53@03)))
; [eval] diz.ALU_m.Main_process_state[i__21] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__21]
(push) ; 15
(assert (not (>= i__21@53@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      45
;  :arith-assert-lower      195
;  :arith-assert-upper      136
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         76
;  :arith-offset-eqs        3
;  :arith-pivots            126
;  :binary-propagations     7
;  :conflicts               148
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              296
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1735
;  :mk-clause               317
;  :num-allocs              4154823
;  :num-checks              270
;  :propagations            172
;  :quant-instantiations    66
;  :rlimit-count            183767)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 53 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__21@53@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__21@53@03))))
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
; [else-branch: 51 | !(i__21@53@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__21@53@03)]
(assert (not
  (and
    (<
      i__21@53@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    (<= 0 i__21@53@03))))
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
(assert (not (forall ((i__21@53@03 Int)) (!
  (implies
    (and
      (<
        i__21@53@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__21@53@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__21@53@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__21@53@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__21@53@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__21@53@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      47
;  :arith-assert-lower      196
;  :arith-assert-upper      137
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            127
;  :binary-propagations     7
;  :conflicts               149
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1743
;  :mk-clause               331
;  :num-allocs              4154823
;  :num-checks              271
;  :propagations            174
;  :quant-instantiations    67
;  :rlimit-count            184216)
(assert (forall ((i__21@53@03 Int)) (!
  (implies
    (and
      (<
        i__21@53@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__21@53@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__21@53@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__21@53@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__21@53@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__21@53@03))
  :qid |prog.l<no position>|)))
(declare-const $k@54@03 $Perm)
(assert ($Perm.isReadVar $k@54@03 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@54@03 $Perm.No) (< $Perm.No $k@54@03))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      198
;  :arith-assert-upper      138
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            127
;  :binary-propagations     7
;  :conflicts               150
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1748
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              272
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            184776)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@36@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      198
;  :arith-assert-upper      138
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            127
;  :binary-propagations     7
;  :conflicts               150
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1748
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              273
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            184787)
(assert (< $k@54@03 $k@36@03))
(assert (<= $Perm.No (- $k@36@03 $k@54@03)))
(assert (<= (- $k@36@03 $k@54@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@36@03 $k@54@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               151
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              274
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185007)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               152
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              275
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185055)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               153
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              276
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185103)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               154
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              277
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185151)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               155
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              278
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185199)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               156
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              279
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185247)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               157
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              280
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185295)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               158
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              281
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185343)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               159
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              282
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185391)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               159
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              283
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185404)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4348
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      200
;  :arith-assert-upper      139
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         77
;  :arith-offset-eqs        3
;  :arith-pivots            129
;  :binary-propagations     7
;  :conflicts               160
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1047
;  :datatype-occurs-check   188
;  :datatype-splits         718
;  :decisions               968
;  :del-clause              322
;  :final-checks            91
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1751
;  :mk-clause               333
;  :num-allocs              4154823
;  :num-checks              284
;  :propagations            175
;  :quant-instantiations    67
;  :rlimit-count            185452)
(push) ; 8
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4484
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      202
;  :arith-assert-upper      141
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         79
;  :arith-offset-eqs        3
;  :arith-pivots            133
;  :binary-propagations     7
;  :conflicts               160
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              324
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1784
;  :mk-clause               335
;  :num-allocs              4154823
;  :num-checks              285
;  :propagations            178
;  :quant-instantiations    67
;  :rlimit-count            186452
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4484
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      202
;  :arith-assert-upper      141
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         79
;  :arith-offset-eqs        3
;  :arith-pivots            133
;  :binary-propagations     7
;  :conflicts               161
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              324
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1784
;  :mk-clause               335
;  :num-allocs              4154823
;  :num-checks              286
;  :propagations            178
;  :quant-instantiations    67
;  :rlimit-count            186500)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4484
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      202
;  :arith-assert-upper      141
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         79
;  :arith-offset-eqs        3
;  :arith-pivots            133
;  :binary-propagations     7
;  :conflicts               161
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              324
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1784
;  :mk-clause               335
;  :num-allocs              4154823
;  :num-checks              287
;  :propagations            178
;  :quant-instantiations    67
;  :rlimit-count            186513)
; [exec]
; label __return_set_bit
; [exec]
; sys__result := sys__local__result__12
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__22: Int :: { diz.ALU_m.Main_process_state[i__22] } 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4484
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      202
;  :arith-assert-upper      141
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         79
;  :arith-offset-eqs        3
;  :arith-pivots            133
;  :binary-propagations     7
;  :conflicts               161
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              324
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1784
;  :mk-clause               335
;  :num-allocs              4154823
;  :num-checks              288
;  :propagations            178
;  :quant-instantiations    67
;  :rlimit-count            186526)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__22: Int :: { diz.ALU_m.Main_process_state[i__22] } 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|)
(declare-const i__22@55@03 Int)
(push) ; 8
; [eval] 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__22 && i__22 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__22
(push) ; 9
; [then-branch: 54 | 0 <= i__22@55@03 | live]
; [else-branch: 54 | !(0 <= i__22@55@03) | live]
(push) ; 10
; [then-branch: 54 | 0 <= i__22@55@03]
(assert (<= 0 i__22@55@03))
; [eval] i__22 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 54 | !(0 <= i__22@55@03)]
(assert (not (<= 0 i__22@55@03)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 55 | i__22@55@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@55@03 | live]
; [else-branch: 55 | !(i__22@55@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@55@03) | live]
(push) ; 10
; [then-branch: 55 | i__22@55@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@55@03]
(assert (and
  (<
    i__22@55@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
  (<= 0 i__22@55@03)))
; [eval] diz.ALU_m.Main_process_state[i__22] == -1 || 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__22] == -1
; [eval] diz.ALU_m.Main_process_state[i__22]
(push) ; 11
(assert (not (>= i__22@55@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4485
;  :arith-add-rows          12
;  :arith-assert-diseq      48
;  :arith-assert-lower      203
;  :arith-assert-upper      142
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         80
;  :arith-offset-eqs        3
;  :arith-pivots            133
;  :binary-propagations     7
;  :conflicts               161
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              324
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1786
;  :mk-clause               335
;  :num-allocs              4154823
;  :num-checks              289
;  :propagations            178
;  :quant-instantiations    67
;  :rlimit-count            186666)
; [eval] -1
(push) ; 11
; [then-branch: 56 | First:(Second:(Second:(Second:($t@34@03))))[i__22@55@03] == -1 | live]
; [else-branch: 56 | First:(Second:(Second:(Second:($t@34@03))))[i__22@55@03] != -1 | live]
(push) ; 12
; [then-branch: 56 | First:(Second:(Second:(Second:($t@34@03))))[i__22@55@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@55@03)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 56 | First:(Second:(Second:(Second:($t@34@03))))[i__22@55@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__22@55@03)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__22] && diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__22]
; [eval] diz.ALU_m.Main_process_state[i__22]
(push) ; 13
(assert (not (>= i__22@55@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4487
;  :arith-add-rows          12
;  :arith-assert-diseq      50
;  :arith-assert-lower      206
;  :arith-assert-upper      143
;  :arith-eq-adapter        114
;  :arith-fixed-eqs         80
;  :arith-offset-eqs        3
;  :arith-pivots            133
;  :binary-propagations     7
;  :conflicts               161
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              324
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1793
;  :mk-clause               348
;  :num-allocs              4154823
;  :num-checks              290
;  :propagations            183
;  :quant-instantiations    69
;  :rlimit-count            186908)
(push) ; 13
; [then-branch: 57 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@55@03] | live]
; [else-branch: 57 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@55@03]) | live]
(push) ; 14
; [then-branch: 57 | 0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@55@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@55@03)))
; [eval] diz.ALU_m.Main_process_state[i__22] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__22]
(push) ; 15
(assert (not (>= i__22@55@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      50
;  :arith-assert-lower      208
;  :arith-assert-upper      144
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         81
;  :arith-offset-eqs        3
;  :arith-pivots            134
;  :binary-propagations     7
;  :conflicts               161
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              324
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1797
;  :mk-clause               348
;  :num-allocs              4154823
;  :num-checks              291
;  :propagations            183
;  :quant-instantiations    69
;  :rlimit-count            187043)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 57 | !(0 <= First:(Second:(Second:(Second:($t@34@03))))[i__22@55@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
      i__22@55@03))))
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
; [else-branch: 55 | !(i__22@55@03 < |First:(Second:(Second:(Second:($t@34@03))))| && 0 <= i__22@55@03)]
(assert (not
  (and
    (<
      i__22@55@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
    (<= 0 i__22@55@03))))
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
(assert (not (forall ((i__22@55@03 Int)) (!
  (implies
    (and
      (<
        i__22@55@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__22@55@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__22@55@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@55@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@55@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@55@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      52
;  :arith-assert-lower      209
;  :arith-assert-upper      145
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               162
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1805
;  :mk-clause               362
;  :num-allocs              4154823
;  :num-checks              292
;  :propagations            185
;  :quant-instantiations    71
;  :rlimit-count            187517)
(assert (forall ((i__22@55@03 Int)) (!
  (implies
    (and
      (<
        i__22@55@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))
      (<= 0 i__22@55@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
          i__22@55@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@55@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
            i__22@55@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@34@03)))))
    i__22@55@03))
  :qid |prog.l<no position>|)))
(declare-const $k@56@03 $Perm)
(assert ($Perm.isReadVar $k@56@03 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@56@03 $Perm.No) (< $Perm.No $k@56@03))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      211
;  :arith-assert-upper      146
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               163
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1810
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              293
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188077)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@36@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      211
;  :arith-assert-upper      146
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               163
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1810
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              294
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188088)
(assert (< $k@56@03 $k@36@03))
(assert (<= $Perm.No (- $k@36@03 $k@56@03)))
(assert (<= (- $k@36@03 $k@56@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@36@03 $k@56@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@34@03)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               164
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              295
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188302)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               165
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              296
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188350)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               166
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              297
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188398)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               167
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              298
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188446)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               168
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              299
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188494)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               169
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              300
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188542)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               170
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              301
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188590)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               171
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              302
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188638)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               172
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              303
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188686)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               172
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              304
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188699)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4489
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      213
;  :arith-assert-upper      147
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            136
;  :binary-propagations     7
;  :conflicts               173
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 1085
;  :datatype-occurs-check   195
;  :datatype-splits         744
;  :decisions               1003
;  :del-clause              351
;  :final-checks            94
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1813
;  :mk-clause               364
;  :num-allocs              4154823
;  :num-checks              305
;  :propagations            186
;  :quant-instantiations    71
;  :rlimit-count            188747)
(push) ; 8
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4625
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      215
;  :arith-assert-upper      149
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        3
;  :arith-pivots            140
;  :binary-propagations     7
;  :conflicts               173
;  :datatype-accessor-ax    199
;  :datatype-constructor-ax 1123
;  :datatype-occurs-check   202
;  :datatype-splits         770
;  :decisions               1038
;  :del-clause              353
;  :final-checks            97
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1846
;  :mk-clause               366
;  :num-allocs              4154823
;  :num-checks              306
;  :propagations            189
;  :quant-instantiations    71
;  :rlimit-count            189754
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 8
(assert (not (< $Perm.No $k@36@03)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4625
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      215
;  :arith-assert-upper      149
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        3
;  :arith-pivots            140
;  :binary-propagations     7
;  :conflicts               174
;  :datatype-accessor-ax    199
;  :datatype-constructor-ax 1123
;  :datatype-occurs-check   202
;  :datatype-splits         770
;  :decisions               1038
;  :del-clause              353
;  :final-checks            97
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1846
;  :mk-clause               366
;  :num-allocs              4154823
;  :num-checks              307
;  :propagations            189
;  :quant-instantiations    71
;  :rlimit-count            189802)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4625
;  :arith-add-rows          12
;  :arith-assert-diseq      53
;  :arith-assert-lower      215
;  :arith-assert-upper      149
;  :arith-eq-adapter        119
;  :arith-fixed-eqs         84
;  :arith-offset-eqs        3
;  :arith-pivots            140
;  :binary-propagations     7
;  :conflicts               174
;  :datatype-accessor-ax    199
;  :datatype-constructor-ax 1123
;  :datatype-occurs-check   202
;  :datatype-splits         770
;  :decisions               1038
;  :del-clause              353
;  :final-checks            97
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.35
;  :memory                  4.35
;  :mk-bool-var             1846
;  :mk-clause               366
;  :num-allocs              4154823
;  :num-checks              308
;  :propagations            189
;  :quant-instantiations    71
;  :rlimit-count            189815)
; [exec]
; inhale false
(pop) ; 7
(push) ; 7
; [else-branch: 49 | bit@10@03 == 1]
(assert (= bit@10@03 1))
(pop) ; 7
(pop) ; 6
(push) ; 6
; [else-branch: 39 | sys__result@27@03 == bit@10@03]
(assert (= sys__result@27@03 bit@10@03))
(pop) ; 6
(pop) ; 5
(push) ; 5
; [else-branch: 29 | i__13@33@03 < pos@9@03]
(assert (< i__13@33@03 pos@9@03))
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
