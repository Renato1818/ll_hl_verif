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
; ---------- ALU_get_bit_EncodedGlobalVariables_Integer_Integer ----------
(declare-const diz@0@05 $Ref)
(declare-const globals@1@05 $Ref)
(declare-const value@2@05 Int)
(declare-const pos@3@05 Int)
(declare-const sys__result@4@05 Int)
(declare-const diz@5@05 $Ref)
(declare-const globals@6@05 $Ref)
(declare-const value@7@05 Int)
(declare-const pos@8@05 Int)
(declare-const sys__result@9@05 Int)
(push) ; 1
(declare-const $t@10@05 $Snap)
(assert (= $t@10@05 ($Snap.combine ($Snap.first $t@10@05) ($Snap.second $t@10@05))))
(assert (= ($Snap.first $t@10@05) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@5@05 $Ref.null)))
(assert (=
  ($Snap.second $t@10@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@10@05))
    ($Snap.second ($Snap.second $t@10@05)))))
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
;  :memory               3.68
;  :mk-bool-var          243
;  :mk-clause            1
;  :num-allocs           3383233
;  :num-checks           1
;  :propagations         7
;  :quant-instantiations 1
;  :rlimit-count         108265)
(assert (=
  ($Snap.second ($Snap.second $t@10@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@10@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@10@05))) $Snap.unit))
; [eval] diz.ALU_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@10@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@10@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.ALU_m.Main_process_state[i] } 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|)
(declare-const i@11@05 Int)
(push) ; 2
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i
(push) ; 3
; [then-branch: 0 | 0 <= i@11@05 | live]
; [else-branch: 0 | !(0 <= i@11@05) | live]
(push) ; 4
; [then-branch: 0 | 0 <= i@11@05]
(assert (<= 0 i@11@05))
; [eval] i < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= i@11@05)]
(assert (not (<= 0 i@11@05)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 1 | i@11@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i@11@05 | live]
; [else-branch: 1 | !(i@11@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i@11@05) | live]
(push) ; 4
; [then-branch: 1 | i@11@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i@11@05]
(assert (and
  (<
    i@11@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
  (<= 0 i@11@05)))
; [eval] diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i] == -1
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 5
(assert (not (>= i@11@05 0)))
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
;  :memory               3.68
;  :mk-bool-var          274
;  :mk-clause            7
;  :num-allocs           3383233
;  :num-checks           2
;  :propagations         9
;  :quant-instantiations 8
;  :rlimit-count         109603)
; [eval] -1
(push) ; 5
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@11@05] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@11@05] != -1 | live]
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@11@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i@11@05)
  (- 0 1)))
(pop) ; 6
(push) ; 6
; [else-branch: 2 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@11@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
      i@11@05)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i]
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 7
(assert (not (>= i@11@05 0)))
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
;  :memory               3.68
;  :mk-bool-var          275
;  :mk-clause            7
;  :num-allocs           3383233
;  :num-checks           3
;  :propagations         9
;  :quant-instantiations 8
;  :rlimit-count         109790)
(push) ; 7
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@11@05] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@11@05]) | live]
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@11@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i@11@05)))
; [eval] diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 9
(assert (not (>= i@11@05 0)))
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
;  :memory               3.68
;  :mk-bool-var          278
;  :mk-clause            8
;  :num-allocs           3383233
;  :num-checks           4
;  :propagations         9
;  :quant-instantiations 8
;  :rlimit-count         109924)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 8
(push) ; 8
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i@11@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
      i@11@05))))
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
; [else-branch: 1 | !(i@11@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i@11@05)]
(assert (not
  (and
    (<
      i@11@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
    (<= 0 i@11@05))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@11@05 Int)) (!
  (implies
    (and
      (<
        i@11@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
      (<= 0 i@11@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
          i@11@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i@11@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i@11@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i@11@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))
(declare-const $k@12@05 $Perm)
(assert ($Perm.isReadVar $k@12@05 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@12@05 $Perm.No) (< $Perm.No $k@12@05))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
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
;  :memory               3.68
;  :mk-bool-var          284
;  :mk-clause            10
;  :num-allocs           3383233
;  :num-checks           5
;  :propagations         10
;  :quant-instantiations 8
;  :rlimit-count         110723)
(assert (<= $Perm.No $k@12@05))
(assert (<= $k@12@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@12@05)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :memory               3.68
;  :mk-bool-var          287
;  :mk-clause            10
;  :num-allocs           3383233
;  :num-checks           6
;  :propagations         10
;  :quant-instantiations 8
;  :rlimit-count         111056)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :num-allocs           3499364
;  :num-checks           7
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         111422)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :num-allocs           3499364
;  :num-checks           8
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         111689)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :memory               3.94
;  :mk-bool-var          292
;  :mk-clause            10
;  :num-allocs           3615847
;  :num-checks           9
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         111966)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :memory               3.94
;  :mk-bool-var          293
;  :mk-clause            10
;  :num-allocs           3615847
;  :num-checks           10
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         112253)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :memory               3.94
;  :mk-bool-var          294
;  :mk-clause            10
;  :num-allocs           3615847
;  :num-checks           11
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         112550)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :memory               3.94
;  :mk-bool-var          295
;  :mk-clause            10
;  :num-allocs           3615847
;  :num-checks           12
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         112857)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :memory               3.94
;  :mk-bool-var          297
;  :mk-clause            10
;  :num-allocs           3615847
;  :num-checks           13
;  :propagations         10
;  :quant-instantiations 9
;  :rlimit-count         113206)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :memory               3.94
;  :mk-bool-var          301
;  :mk-clause            10
;  :num-allocs           3615847
;  :num-checks           14
;  :propagations         10
;  :quant-instantiations 10
;  :rlimit-count         113664)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :memory               3.94
;  :mk-bool-var          303
;  :mk-clause            10
;  :num-allocs           3615847
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
;  :memory               3.94
;  :mk-bool-var          303
;  :mk-clause            10
;  :num-allocs           3615847
;  :num-checks           16
;  :propagations         10
;  :quant-instantiations 10
;  :rlimit-count         114060)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@12@05)))
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
;  :memory               3.94
;  :mk-bool-var          305
;  :mk-clause            10
;  :num-allocs           3615847
;  :num-checks           17
;  :propagations         10
;  :quant-instantiations 10
;  :rlimit-count         114439)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))
  diz@5@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
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
;  :memory               3.94
;  :mk-bool-var          307
;  :mk-clause            10
;  :num-allocs           3615847
;  :num-checks           18
;  :propagations         10
;  :quant-instantiations 10
;  :rlimit-count         114812)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05)))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@13@05 $Snap)
(assert (= $t@13@05 ($Snap.combine ($Snap.first $t@13@05) ($Snap.second $t@13@05))))
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
;  :memory                  3.94
;  :mk-bool-var             329
;  :mk-clause               11
;  :num-allocs              3615847
;  :num-checks              20
;  :propagations            10
;  :quant-instantiations    13
;  :rlimit-count            115890)
(assert (=
  ($Snap.second $t@13@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@13@05))
    ($Snap.second ($Snap.second $t@13@05)))))
(assert (= ($Snap.first ($Snap.second $t@13@05)) $Snap.unit))
; [eval] diz.ALU_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@13@05)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@13@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@13@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@13@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.ALU_m.Main_process_state[i] } 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|)
(declare-const i@14@05 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i && i < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@14@05 | live]
; [else-branch: 4 | !(0 <= i@14@05) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@14@05]
(assert (<= 0 i@14@05))
; [eval] i < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@14@05)]
(assert (not (<= 0 i@14@05)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@14@05 < |First:(Second:(Second:(Second:($t@13@05))))| && 0 <= i@14@05 | live]
; [else-branch: 5 | !(i@14@05 < |First:(Second:(Second:(Second:($t@13@05))))| && 0 <= i@14@05) | live]
(push) ; 5
; [then-branch: 5 | i@14@05 < |First:(Second:(Second:(Second:($t@13@05))))| && 0 <= i@14@05]
(assert (and
  (<
    i@14@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))
  (<= 0 i@14@05)))
; [eval] diz.ALU_m.Main_process_state[i] == -1 || 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i] == -1
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 6
(assert (not (>= i@14@05 0)))
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
;  :memory                  3.94
;  :mk-bool-var             354
;  :mk-clause               11
;  :num-allocs              3615847
;  :num-checks              21
;  :propagations            10
;  :quant-instantiations    18
;  :rlimit-count            117173)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@13@05))))[i@14@05] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@13@05))))[i@14@05] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@13@05))))[i@14@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
    i@14@05)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@13@05))))[i@14@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
      i@14@05)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i] && diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i]
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 8
(assert (not (>= i@14@05 0)))
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
;  :memory                  3.94
;  :mk-bool-var             355
;  :mk-clause               11
;  :num-allocs              3615847
;  :num-checks              22
;  :propagations            10
;  :quant-instantiations    18
;  :rlimit-count            117348)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@13@05))))[i@14@05] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@13@05))))[i@14@05]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@13@05))))[i@14@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
    i@14@05)))
; [eval] diz.ALU_m.Main_process_state[i] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i]
(push) ; 10
(assert (not (>= i@14@05 0)))
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
;  :memory                  3.94
;  :mk-bool-var             358
;  :mk-clause               12
;  :num-allocs              3615847
;  :num-checks              23
;  :propagations            10
;  :quant-instantiations    18
;  :rlimit-count            117472)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@13@05))))[i@14@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
      i@14@05))))
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
; [else-branch: 5 | !(i@14@05 < |First:(Second:(Second:(Second:($t@13@05))))| && 0 <= i@14@05)]
(assert (not
  (and
    (<
      i@14@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))
    (<= 0 i@14@05))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@14@05 Int)) (!
  (implies
    (and
      (<
        i@14@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))
      (<= 0 i@14@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
          i@14@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
            i@14@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
            i@14@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))
    i@14@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))
(declare-const $k@15@05 $Perm)
(assert ($Perm.isReadVar $k@15@05 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@15@05 $Perm.No) (< $Perm.No $k@15@05))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
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
;  :memory                  3.94
;  :mk-bool-var             364
;  :mk-clause               14
;  :num-allocs              3615847
;  :num-checks              24
;  :propagations            11
;  :quant-instantiations    18
;  :rlimit-count            118241)
(assert (<= $Perm.No $k@15@05))
(assert (<= $k@15@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@15@05)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@13@05)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
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
;  :memory                  3.94
;  :mk-bool-var             367
;  :mk-clause               14
;  :num-allocs              3615847
;  :num-checks              25
;  :propagations            11
;  :quant-instantiations    18
;  :rlimit-count            118564)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
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
;  :memory                  3.94
;  :mk-bool-var             370
;  :mk-clause               14
;  :num-allocs              3615847
;  :num-checks              26
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            118920)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
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
;  :memory                  3.94
;  :mk-bool-var             371
;  :mk-clause               14
;  :num-allocs              3615847
;  :num-checks              27
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            119177)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
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
;  :memory                  3.94
;  :mk-bool-var             372
;  :mk-clause               14
;  :num-allocs              3615847
;  :num-checks              28
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            119444)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
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
;  :memory                  3.94
;  :mk-bool-var             373
;  :mk-clause               14
;  :num-allocs              3615847
;  :num-checks              29
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            119721)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
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
;  :memory                  3.94
;  :mk-bool-var             374
;  :mk-clause               14
;  :num-allocs              3615847
;  :num-checks              30
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            120008)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
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
;  :memory                  3.94
;  :mk-bool-var             375
;  :mk-clause               14
;  :num-allocs              3615847
;  :num-checks              31
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            120305)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
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
;  :memory                  3.94
;  :mk-bool-var             377
;  :mk-clause               14
;  :num-allocs              3615847
;  :num-checks              32
;  :propagations            11
;  :quant-instantiations    19
;  :rlimit-count            120644)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
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
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             381
;  :mk-clause               14
;  :num-allocs              3737889
;  :num-checks              33
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            121092)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
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
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             383
;  :mk-clause               14
;  :num-allocs              3737889
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
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             383
;  :mk-clause               14
;  :num-allocs              3737889
;  :num-checks              35
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            121478)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@15@05)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
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
;  :num-allocs              3737889
;  :num-checks              36
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            121847)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))
  diz@5@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))))))))
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
;  :num-allocs              3737889
;  :num-checks              37
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122211)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@05)))))))))))))))))))))
(pop) ; 2
(push) ; 2
; [exec]
; var sys__local__result__3: Int
(declare-const sys__local__result__3@16@05 Int)
; [exec]
; var i__4: Int
(declare-const i__4@17@05 Int)
; [exec]
; var divisor__5: Int
(declare-const divisor__5@18@05 Int)
; [exec]
; var __flatten_1__6: Int
(declare-const __flatten_1__6@19@05 Int)
; [exec]
; divisor__5 := 1
; [exec]
; i__4 := 0
(declare-const divisor__5@20@05 Int)
(declare-const __flatten_1__6@21@05 Int)
(declare-const i__4@22@05 Int)
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@23@05 $Snap)
(assert (= $t@23@05 ($Snap.combine ($Snap.first $t@23@05) ($Snap.second $t@23@05))))
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               308
;  :arith-assert-diseq      6
;  :arith-assert-lower      25
;  :arith-assert-upper      13
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    46
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
;  :num-allocs              3737889
;  :num-checks              38
;  :propagations            11
;  :quant-instantiations    20
;  :rlimit-count            122388)
(assert (=
  ($Snap.second $t@23@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@23@05))
    ($Snap.second ($Snap.second $t@23@05)))))
(assert (= ($Snap.first ($Snap.second $t@23@05)) $Snap.unit))
; [eval] diz.ALU_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@23@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@23@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@23@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  $Snap.unit))
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
  $Snap.unit))
; [eval] (forall i__7: Int :: { diz.ALU_m.Main_process_state[i__7] } 0 <= i__7 && i__7 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__7] == -1 || 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|)
(declare-const i__7@24@05 Int)
(push) ; 4
; [eval] 0 <= i__7 && i__7 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__7] == -1 || 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__7 && i__7 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__7
(push) ; 5
; [then-branch: 8 | 0 <= i__7@24@05 | live]
; [else-branch: 8 | !(0 <= i__7@24@05) | live]
(push) ; 6
; [then-branch: 8 | 0 <= i__7@24@05]
(assert (<= 0 i__7@24@05))
; [eval] i__7 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 8 | !(0 <= i__7@24@05)]
(assert (not (<= 0 i__7@24@05)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 9 | i__7@24@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__7@24@05 | live]
; [else-branch: 9 | !(i__7@24@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__7@24@05) | live]
(push) ; 6
; [then-branch: 9 | i__7@24@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__7@24@05]
(assert (and
  (<
    i__7@24@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  (<= 0 i__7@24@05)))
; [eval] diz.ALU_m.Main_process_state[i__7] == -1 || 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__7] == -1
; [eval] diz.ALU_m.Main_process_state[i__7]
(push) ; 7
(assert (not (>= i__7@24@05 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               353
;  :arith-assert-diseq      6
;  :arith-assert-lower      30
;  :arith-assert-upper      16
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             413
;  :mk-clause               14
;  :num-allocs              3737889
;  :num-checks              39
;  :propagations            11
;  :quant-instantiations    25
;  :rlimit-count            123670)
; [eval] -1
(push) ; 7
; [then-branch: 10 | First:(Second:(Second:(Second:($t@23@05))))[i__7@24@05] == -1 | live]
; [else-branch: 10 | First:(Second:(Second:(Second:($t@23@05))))[i__7@24@05] != -1 | live]
(push) ; 8
; [then-branch: 10 | First:(Second:(Second:(Second:($t@23@05))))[i__7@24@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__7@24@05)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 10 | First:(Second:(Second:(Second:($t@23@05))))[i__7@24@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__7@24@05)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__7]
; [eval] diz.ALU_m.Main_process_state[i__7]
(push) ; 9
(assert (not (>= i__7@24@05 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               353
;  :arith-assert-diseq      6
;  :arith-assert-lower      30
;  :arith-assert-upper      16
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             414
;  :mk-clause               14
;  :num-allocs              3737889
;  :num-checks              40
;  :propagations            11
;  :quant-instantiations    25
;  :rlimit-count            123845)
(push) ; 9
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__7@24@05] | live]
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__7@24@05]) | live]
(push) ; 10
; [then-branch: 11 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__7@24@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__7@24@05)))
; [eval] diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__7]
(push) ; 11
(assert (not (>= i__7@24@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               353
;  :arith-assert-diseq      7
;  :arith-assert-lower      33
;  :arith-assert-upper      16
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    53
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              12
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             417
;  :mk-clause               15
;  :num-allocs              3737889
;  :num-checks              41
;  :propagations            11
;  :quant-instantiations    25
;  :rlimit-count            123969)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 11 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__7@24@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__7@24@05))))
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
; [else-branch: 9 | !(i__7@24@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__7@24@05)]
(assert (not
  (and
    (<
      i__7@24@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
    (<= 0 i__7@24@05))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__7@24@05 Int)) (!
  (implies
    (and
      (<
        i__7@24@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__7@24@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__7@24@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__7@24@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__7@24@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__7@24@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))
(declare-const $k@25@05 $Perm)
(assert ($Perm.isReadVar $k@25@05 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@25@05 $Perm.No) (< $Perm.No $k@25@05))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               358
;  :arith-assert-diseq      8
;  :arith-assert-lower      35
;  :arith-assert-upper      17
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    54
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             423
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              42
;  :propagations            12
;  :quant-instantiations    25
;  :rlimit-count            124737)
(assert (<= $Perm.No $k@25@05))
(assert (<= $k@25@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@25@05)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               364
;  :arith-assert-diseq      8
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               27
;  :datatype-accessor-ax    55
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             426
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              43
;  :propagations            12
;  :quant-instantiations    25
;  :rlimit-count            125060)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               370
;  :arith-assert-diseq      8
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               28
;  :datatype-accessor-ax    56
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             429
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              44
;  :propagations            12
;  :quant-instantiations    26
;  :rlimit-count            125416)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               375
;  :arith-assert-diseq      8
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               29
;  :datatype-accessor-ax    57
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             430
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              45
;  :propagations            12
;  :quant-instantiations    26
;  :rlimit-count            125673)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               380
;  :arith-assert-diseq      8
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               30
;  :datatype-accessor-ax    58
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             431
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              46
;  :propagations            12
;  :quant-instantiations    26
;  :rlimit-count            125940)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               385
;  :arith-assert-diseq      8
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               31
;  :datatype-accessor-ax    59
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             432
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              47
;  :propagations            12
;  :quant-instantiations    26
;  :rlimit-count            126217)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               390
;  :arith-assert-diseq      8
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               32
;  :datatype-accessor-ax    60
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             433
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              48
;  :propagations            12
;  :quant-instantiations    26
;  :rlimit-count            126504)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               395
;  :arith-assert-diseq      8
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               33
;  :datatype-accessor-ax    61
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             434
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              49
;  :propagations            12
;  :quant-instantiations    26
;  :rlimit-count            126801)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               401
;  :arith-assert-diseq      8
;  :arith-assert-lower      35
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    62
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             436
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              50
;  :propagations            12
;  :quant-instantiations    26
;  :rlimit-count            127140)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               408
;  :arith-assert-diseq      8
;  :arith-assert-lower      36
;  :arith-assert-upper      18
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               35
;  :datatype-accessor-ax    63
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             440
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              51
;  :propagations            12
;  :quant-instantiations    27
;  :rlimit-count            127588)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               413
;  :arith-assert-diseq      8
;  :arith-assert-lower      36
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               36
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             442
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              52
;  :propagations            12
;  :quant-instantiations    27
;  :rlimit-count            127961)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               413
;  :arith-assert-diseq      8
;  :arith-assert-lower      36
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               36
;  :datatype-accessor-ax    64
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             442
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              53
;  :propagations            12
;  :quant-instantiations    27
;  :rlimit-count            127974)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               419
;  :arith-assert-diseq      8
;  :arith-assert-lower      36
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    65
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             444
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              54
;  :propagations            12
;  :quant-instantiations    27
;  :rlimit-count            128343)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
  diz@5@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               427
;  :arith-assert-diseq      8
;  :arith-assert-lower      36
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              13
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             446
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              55
;  :propagations            12
;  :quant-instantiations    27
;  :rlimit-count            128707)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
; [eval] i__4 < pos
(pop) ; 4
(push) ; 4
; [eval] !(i__4 < pos)
; [eval] i__4 < pos
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
; (:added-eqs               439
;  :arith-assert-diseq      8
;  :arith-assert-lower      36
;  :arith-assert-upper      19
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              15
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             451
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              56
;  :propagations            12
;  :quant-instantiations    29
;  :rlimit-count            129159)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__7: Int :: { diz.ALU_m.Main_process_state[i__7] } 0 <= i__7 && i__7 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__7] == -1 || 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|)
(declare-const i__7@26@05 Int)
(push) ; 4
; [eval] 0 <= i__7 && i__7 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__7] == -1 || 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__7 && i__7 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__7
(push) ; 5
; [then-branch: 12 | 0 <= i__7@26@05 | live]
; [else-branch: 12 | !(0 <= i__7@26@05) | live]
(push) ; 6
; [then-branch: 12 | 0 <= i__7@26@05]
(assert (<= 0 i__7@26@05))
; [eval] i__7 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 12 | !(0 <= i__7@26@05)]
(assert (not (<= 0 i__7@26@05)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 13 | i__7@26@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i__7@26@05 | live]
; [else-branch: 13 | !(i__7@26@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i__7@26@05) | live]
(push) ; 6
; [then-branch: 13 | i__7@26@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i__7@26@05]
(assert (and
  (<
    i__7@26@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
  (<= 0 i__7@26@05)))
; [eval] diz.ALU_m.Main_process_state[i__7] == -1 || 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__7] == -1
; [eval] diz.ALU_m.Main_process_state[i__7]
(push) ; 7
(assert (not (>= i__7@26@05 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               440
;  :arith-assert-diseq      8
;  :arith-assert-lower      37
;  :arith-assert-upper      20
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         4
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              15
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             453
;  :mk-clause               17
;  :num-allocs              3737889
;  :num-checks              57
;  :propagations            12
;  :quant-instantiations    29
;  :rlimit-count            129299)
; [eval] -1
(push) ; 7
; [then-branch: 14 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__7@26@05] == -1 | live]
; [else-branch: 14 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__7@26@05] != -1 | live]
(push) ; 8
; [then-branch: 14 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__7@26@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i__7@26@05)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 14 | First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__7@26@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
      i__7@26@05)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__7]
; [eval] diz.ALU_m.Main_process_state[i__7]
(push) ; 9
(assert (not (>= i__7@26@05 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               442
;  :arith-assert-diseq      10
;  :arith-assert-lower      40
;  :arith-assert-upper      21
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         4
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              15
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             460
;  :mk-clause               29
;  :num-allocs              3737889
;  :num-checks              58
;  :propagations            17
;  :quant-instantiations    30
;  :rlimit-count            129548)
(push) ; 9
; [then-branch: 15 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__7@26@05] | live]
; [else-branch: 15 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__7@26@05]) | live]
(push) ; 10
; [then-branch: 15 | 0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__7@26@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i__7@26@05)))
; [eval] diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__7]
(push) ; 11
(assert (not (>= i__7@26@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      10
;  :arith-assert-lower      42
;  :arith-assert-upper      22
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         5
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              15
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             464
;  :mk-clause               29
;  :num-allocs              3737889
;  :num-checks              59
;  :propagations            17
;  :quant-instantiations    30
;  :rlimit-count            129689)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 15 | !(0 <= First:(Second:(Second:(Second:(Second:($t@10@05)))))[i__7@26@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
      i__7@26@05))))
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
; [else-branch: 13 | !(i__7@26@05 < |First:(Second:(Second:(Second:(Second:($t@10@05)))))| && 0 <= i__7@26@05)]
(assert (not
  (and
    (<
      i__7@26@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
    (<= 0 i__7@26@05))))
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
(assert (not (forall ((i__7@26@05 Int)) (!
  (implies
    (and
      (<
        i__7@26@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
      (<= 0 i__7@26@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
          i__7@26@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i__7@26@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i__7@26@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i__7@26@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      11
;  :arith-assert-lower      43
;  :arith-assert-upper      23
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         6
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             472
;  :mk-clause               41
;  :num-allocs              3737889
;  :num-checks              60
;  :propagations            19
;  :quant-instantiations    31
;  :rlimit-count            130147)
(assert (forall ((i__7@26@05 Int)) (!
  (implies
    (and
      (<
        i__7@26@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))
      (<= 0 i__7@26@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
          i__7@26@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i__7@26@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
            i__7@26@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@10@05))))))
    i__7@26@05))
  :qid |prog.l<no position>|)))
(declare-const $k@27@05 $Perm)
(assert ($Perm.isReadVar $k@27@05 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@27@05 $Perm.No) (< $Perm.No $k@27@05))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      45
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             477
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              61
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            130725)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= $k@12@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      45
;  :arith-assert-upper      24
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             477
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              62
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            130736)
(assert (< $k@27@05 $k@12@05))
(assert (<= $Perm.No (- $k@12@05 $k@27@05)))
(assert (<= (- $k@12@05 $k@27@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@12@05 $k@27@05))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05)))
      $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               40
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              63
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            130956)
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               41
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              64
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131004)
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               42
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              65
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131052)
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              66
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131100)
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              67
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131148)
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              68
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131196)
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               46
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              69
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131244)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              70
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131292)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              71
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131340)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              72
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131353)
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               444
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               49
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 15
;  :datatype-occurs-check   3
;  :datatype-splits         14
;  :decisions               14
;  :del-clause              39
;  :final-checks            3
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             480
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              73
;  :propagations            20
;  :quant-instantiations    31
;  :rlimit-count            131401)
(push) ; 4
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               478
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               49
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              39
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             483
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              74
;  :propagations            21
;  :quant-instantiations    31
;  :rlimit-count            131899)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 4
(assert (not (< $Perm.No $k@12@05)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               478
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               50
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              39
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             483
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              75
;  :propagations            21
;  :quant-instantiations    31
;  :rlimit-count            131947)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               478
;  :arith-assert-diseq      12
;  :arith-assert-lower      47
;  :arith-assert-upper      25
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               50
;  :datatype-accessor-ax    67
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   5
;  :datatype-splits         16
;  :decisions               27
;  :del-clause              39
;  :final-checks            5
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             483
;  :mk-clause               43
;  :num-allocs              3737889
;  :num-checks              76
;  :propagations            21
;  :quant-instantiations    31
;  :rlimit-count            131960)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert ($Perm.isReadVar $k@25@05 $Perm.Write))
(assert (= $t@23@05 ($Snap.combine ($Snap.first $t@23@05) ($Snap.second $t@23@05))))
(assert (=
  ($Snap.second $t@23@05)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@23@05))
    ($Snap.second ($Snap.second $t@23@05)))))
(assert (= ($Snap.first ($Snap.second $t@23@05)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@23@05))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@23@05)))
    ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@23@05)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
  $Snap.unit))
(assert (forall ((i__7@24@05 Int)) (!
  (implies
    (and
      (<
        i__7@24@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__7@24@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__7@24@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__7@24@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__7@24@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__7@24@05))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))
(assert (<= $Perm.No $k@25@05))
(assert (<= $k@25@05 $Perm.Write))
(assert (implies
  (< $Perm.No $k@25@05)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
  $Snap.unit))
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))
  $Snap.unit))
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))
  16))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))
  diz@5@05))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05))))))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
; [eval] i__4 < pos
(push) ; 5
(assert (not (not (< i__4@22@05 pos@8@05))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               898
;  :arith-assert-diseq      13
;  :arith-assert-lower      57
;  :arith-assert-upper      34
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         9
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    94
;  :datatype-constructor-ax 119
;  :datatype-occurs-check   20
;  :datatype-splits         69
;  :decisions               111
;  :del-clause              46
;  :final-checks            14
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             609
;  :mk-clause               51
;  :num-allocs              3737889
;  :num-checks              79
;  :propagations            27
;  :quant-instantiations    40
;  :rlimit-count            137596)
(push) ; 5
(assert (not (< i__4@22@05 pos@8@05)))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               983
;  :arith-assert-diseq      13
;  :arith-assert-lower      59
;  :arith-assert-upper      35
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         10
;  :arith-pivots            14
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              47
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             628
;  :mk-clause               52
;  :num-allocs              3737889
;  :num-checks              80
;  :propagations            29
;  :quant-instantiations    40
;  :rlimit-count            138419
;  :time                    0.00)
; [then-branch: 16 | i__4@22@05 < pos@8@05 | live]
; [else-branch: 16 | !(i__4@22@05 < pos@8@05) | live]
(push) ; 5
; [then-branch: 16 | i__4@22@05 < pos@8@05]
(assert (< i__4@22@05 pos@8@05))
; [exec]
; divisor__5 := divisor__5 * 2
; [eval] divisor__5 * 2
(declare-const divisor__5@28@05 Int)
(assert (= divisor__5@28@05 (* divisor__5@20@05 2)))
; [exec]
; __flatten_1__6 := i__4
; [exec]
; i__4 := i__4 + 1
; [eval] i__4 + 1
(declare-const i__4@29@05 Int)
(assert (= i__4@29@05 (+ i__4@22@05 1)))
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
; (:added-eqs               985
;  :arith-assert-diseq      13
;  :arith-assert-lower      61
;  :arith-assert-upper      38
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         10
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              47
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             635
;  :mk-clause               58
;  :num-allocs              3737889
;  :num-checks              81
;  :propagations            33
;  :quant-instantiations    40
;  :rlimit-count            138674)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__7: Int :: { diz.ALU_m.Main_process_state[i__7] } 0 <= i__7 && i__7 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__7] == -1 || 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|)
(declare-const i__7@30@05 Int)
(push) ; 6
; [eval] 0 <= i__7 && i__7 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__7] == -1 || 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__7 && i__7 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__7
(push) ; 7
; [then-branch: 17 | 0 <= i__7@30@05 | live]
; [else-branch: 17 | !(0 <= i__7@30@05) | live]
(push) ; 8
; [then-branch: 17 | 0 <= i__7@30@05]
(assert (<= 0 i__7@30@05))
; [eval] i__7 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 17 | !(0 <= i__7@30@05)]
(assert (not (<= 0 i__7@30@05)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 18 | i__7@30@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__7@30@05 | live]
; [else-branch: 18 | !(i__7@30@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__7@30@05) | live]
(push) ; 8
; [then-branch: 18 | i__7@30@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__7@30@05]
(assert (and
  (<
    i__7@30@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  (<= 0 i__7@30@05)))
; [eval] diz.ALU_m.Main_process_state[i__7] == -1 || 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__7] == -1
; [eval] diz.ALU_m.Main_process_state[i__7]
(push) ; 9
(assert (not (>= i__7@30@05 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               986
;  :arith-assert-diseq      13
;  :arith-assert-lower      62
;  :arith-assert-upper      39
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         11
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              47
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             637
;  :mk-clause               58
;  :num-allocs              3737889
;  :num-checks              82
;  :propagations            33
;  :quant-instantiations    40
;  :rlimit-count            138814)
; [eval] -1
(push) ; 9
; [then-branch: 19 | First:(Second:(Second:(Second:($t@23@05))))[i__7@30@05] == -1 | live]
; [else-branch: 19 | First:(Second:(Second:(Second:($t@23@05))))[i__7@30@05] != -1 | live]
(push) ; 10
; [then-branch: 19 | First:(Second:(Second:(Second:($t@23@05))))[i__7@30@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__7@30@05)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 19 | First:(Second:(Second:(Second:($t@23@05))))[i__7@30@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__7@30@05)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__7] && diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__7]
; [eval] diz.ALU_m.Main_process_state[i__7]
(push) ; 11
(assert (not (>= i__7@30@05 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               988
;  :arith-assert-diseq      15
;  :arith-assert-lower      65
;  :arith-assert-upper      40
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         11
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              47
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             644
;  :mk-clause               70
;  :num-allocs              3737889
;  :num-checks              83
;  :propagations            38
;  :quant-instantiations    41
;  :rlimit-count            139045)
(push) ; 11
; [then-branch: 20 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__7@30@05] | live]
; [else-branch: 20 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__7@30@05]) | live]
(push) ; 12
; [then-branch: 20 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__7@30@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__7@30@05)))
; [eval] diz.ALU_m.Main_process_state[i__7] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__7]
(push) ; 13
(assert (not (>= i__7@30@05 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      15
;  :arith-assert-lower      67
;  :arith-assert-upper      41
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         12
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              47
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             648
;  :mk-clause               70
;  :num-allocs              3871624
;  :num-checks              84
;  :propagations            38
;  :quant-instantiations    41
;  :rlimit-count            139176)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 20 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__7@30@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__7@30@05))))
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
; [else-branch: 18 | !(i__7@30@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__7@30@05)]
(assert (not
  (and
    (<
      i__7@30@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
    (<= 0 i__7@30@05))))
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
(assert (not (forall ((i__7@30@05 Int)) (!
  (implies
    (and
      (<
        i__7@30@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__7@30@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__7@30@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__7@30@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__7@30@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__7@30@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      17
;  :arith-assert-lower      68
;  :arith-assert-upper      42
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         13
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             656
;  :mk-clause               84
;  :num-allocs              3871624
;  :num-checks              85
;  :propagations            40
;  :quant-instantiations    42
;  :rlimit-count            139622)
(assert (forall ((i__7@30@05 Int)) (!
  (implies
    (and
      (<
        i__7@30@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__7@30@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__7@30@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__7@30@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__7@30@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__7@30@05))
  :qid |prog.l<no position>|)))
(declare-const $k@31@05 $Perm)
(assert ($Perm.isReadVar $k@31@05 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@31@05 $Perm.No) (< $Perm.No $k@31@05))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      70
;  :arith-assert-upper      43
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             661
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              86
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140182)
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= $k@25@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      70
;  :arith-assert-upper      43
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             661
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              87
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140193)
(assert (< $k@31@05 $k@25@05))
(assert (<= $Perm.No (- $k@25@05 $k@31@05)))
(assert (<= (- $k@25@05 $k@31@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@25@05 $k@31@05))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              88
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140413)
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               55
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              89
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140461)
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               56
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              90
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140509)
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              91
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140557)
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              92
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140605)
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               59
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              93
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140653)
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               60
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              94
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140701)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              95
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140749)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              96
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140797)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              97
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140810)
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               990
;  :arith-assert-diseq      18
;  :arith-assert-lower      72
;  :arith-assert-upper      44
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         13
;  :arith-pivots            18
;  :binary-propagations     7
;  :conflicts               63
;  :datatype-accessor-ax    96
;  :datatype-constructor-ax 145
;  :datatype-occurs-check   25
;  :datatype-splits         83
;  :decisions               135
;  :del-clause              73
;  :final-checks            17
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             664
;  :mk-clause               86
;  :num-allocs              3871624
;  :num-checks              98
;  :propagations            41
;  :quant-instantiations    42
;  :rlimit-count            140858)
(push) ; 6
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1075
;  :arith-assert-diseq      18
;  :arith-assert-lower      73
;  :arith-assert-upper      45
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         14
;  :arith-pivots            20
;  :binary-propagations     7
;  :conflicts               63
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 171
;  :datatype-occurs-check   30
;  :datatype-splits         97
;  :decisions               159
;  :del-clause              74
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             682
;  :mk-clause               87
;  :num-allocs              3871624
;  :num-checks              99
;  :propagations            43
;  :quant-instantiations    42
;  :rlimit-count            141617)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 6
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1075
;  :arith-assert-diseq      18
;  :arith-assert-lower      73
;  :arith-assert-upper      45
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         14
;  :arith-pivots            20
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 171
;  :datatype-occurs-check   30
;  :datatype-splits         97
;  :decisions               159
;  :del-clause              74
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             682
;  :mk-clause               87
;  :num-allocs              3871624
;  :num-checks              100
;  :propagations            43
;  :quant-instantiations    42
;  :rlimit-count            141665)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1075
;  :arith-assert-diseq      18
;  :arith-assert-lower      73
;  :arith-assert-upper      45
;  :arith-eq-adapter        33
;  :arith-fixed-eqs         14
;  :arith-pivots            20
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    98
;  :datatype-constructor-ax 171
;  :datatype-occurs-check   30
;  :datatype-splits         97
;  :decisions               159
;  :del-clause              74
;  :final-checks            20
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             682
;  :mk-clause               87
;  :num-allocs              3871624
;  :num-checks              101
;  :propagations            43
;  :quant-instantiations    42
;  :rlimit-count            141678)
(pop) ; 5
(push) ; 5
; [else-branch: 16 | !(i__4@22@05 < pos@8@05)]
(assert (not (< i__4@22@05 pos@8@05)))
(pop) ; 5
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@10@05))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1204
;  :arith-assert-diseq      18
;  :arith-assert-lower      75
;  :arith-assert-upper      47
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         16
;  :arith-pivots            25
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 212
;  :datatype-occurs-check   38
;  :datatype-splits         123
;  :decisions               196
;  :del-clause              88
;  :final-checks            25
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             720
;  :mk-clause               93
;  :num-allocs              3871624
;  :num-checks              102
;  :propagations            49
;  :quant-instantiations    42
;  :rlimit-count            142770
;  :time                    0.00)
; [eval] !(i__4 < pos)
; [eval] i__4 < pos
(push) ; 5
(assert (not (< i__4@22@05 pos@8@05)))
(check-sat)
; unknown
(pop) ; 5
; 0.14s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1289
;  :arith-assert-diseq      18
;  :arith-assert-lower      77
;  :arith-assert-upper      48
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         17
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 238
;  :datatype-occurs-check   43
;  :datatype-splits         137
;  :decisions               220
;  :del-clause              89
;  :final-checks            28
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             739
;  :mk-clause               94
;  :num-allocs              3871624
;  :num-checks              103
;  :propagations            51
;  :quant-instantiations    42
;  :rlimit-count            143593)
(push) ; 5
(assert (not (not (< i__4@22@05 pos@8@05))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1374
;  :arith-assert-diseq      18
;  :arith-assert-lower      78
;  :arith-assert-upper      50
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         18
;  :arith-pivots            31
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 264
;  :datatype-occurs-check   48
;  :datatype-splits         151
;  :decisions               244
;  :del-clause              90
;  :final-checks            31
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             758
;  :mk-clause               95
;  :num-allocs              3871624
;  :num-checks              104
;  :propagations            53
;  :quant-instantiations    42
;  :rlimit-count            144425)
; [then-branch: 21 | !(i__4@22@05 < pos@8@05) | live]
; [else-branch: 21 | i__4@22@05 < pos@8@05 | live]
(push) ; 5
; [then-branch: 21 | !(i__4@22@05 < pos@8@05)]
(assert (not (< i__4@22@05 pos@8@05)))
; [eval] divisor__5 != 0
(push) ; 6
(assert (not (= divisor__5@20@05 0)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1459
;  :arith-assert-diseq      18
;  :arith-assert-lower      80
;  :arith-assert-upper      51
;  :arith-eq-adapter        38
;  :arith-fixed-eqs         19
;  :arith-pivots            34
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 290
;  :datatype-occurs-check   53
;  :datatype-splits         165
;  :decisions               268
;  :del-clause              91
;  :final-checks            34
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             778
;  :mk-clause               96
;  :num-allocs              3871624
;  :num-checks              105
;  :propagations            55
;  :quant-instantiations    42
;  :rlimit-count            145306)
(push) ; 6
(assert (not (not (= divisor__5@20@05 0))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1545
;  :arith-assert-diseq      18
;  :arith-assert-lower      81
;  :arith-assert-upper      52
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         20
;  :arith-pivots            36
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              92
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             797
;  :mk-clause               97
;  :num-allocs              3871624
;  :num-checks              106
;  :propagations            57
;  :quant-instantiations    42
;  :rlimit-count            146087
;  :time                    0.00)
; [then-branch: 22 | divisor__5@20@05 != 0 | live]
; [else-branch: 22 | divisor__5@20@05 == 0 | live]
(push) ; 6
; [then-branch: 22 | divisor__5@20@05 != 0]
(assert (not (= divisor__5@20@05 0)))
; [exec]
; sys__local__result__3 := value / divisor__5 % 2
; [eval] value / divisor__5 % 2
; [eval] value / divisor__5
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1545
;  :arith-assert-diseq      18
;  :arith-assert-lower      81
;  :arith-assert-upper      52
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         20
;  :arith-pivots            36
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              92
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             798
;  :mk-clause               97
;  :num-allocs              3871624
;  :num-checks              107
;  :propagations            57
;  :quant-instantiations    42
;  :rlimit-count            146160)
(declare-const sys__local__result__3@32@05 Int)
(assert (= sys__local__result__3@32@05 (mod (div value@7@05 divisor__5@20@05) 2)))
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && (true && (true && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__8: Int :: { diz.ALU_m.Main_process_state[i__8] } 0 <= i__8 && i__8 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__8] == -1 || 0 <= diz.ALU_m.Main_process_state[i__8] && diz.ALU_m.Main_process_state[i__8] < |diz.ALU_m.Main_event_state|)) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2)) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1561
;  :arith-add-rows          3
;  :arith-assert-diseq      19
;  :arith-assert-lower      87
;  :arith-assert-upper      56
;  :arith-eq-adapter        43
;  :arith-fixed-eqs         22
;  :arith-offset-eqs        1
;  :arith-pivots            40
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              92
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             818
;  :mk-clause               109
;  :num-allocs              3871624
;  :num-checks              108
;  :propagations            61
;  :quant-instantiations    42
;  :rlimit-count            146444)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__8: Int :: { diz.ALU_m.Main_process_state[i__8] } 0 <= i__8 && i__8 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__8] == -1 || 0 <= diz.ALU_m.Main_process_state[i__8] && diz.ALU_m.Main_process_state[i__8] < |diz.ALU_m.Main_event_state|)
(declare-const i__8@33@05 Int)
(push) ; 7
; [eval] 0 <= i__8 && i__8 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__8] == -1 || 0 <= diz.ALU_m.Main_process_state[i__8] && diz.ALU_m.Main_process_state[i__8] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__8 && i__8 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__8
(push) ; 8
; [then-branch: 23 | 0 <= i__8@33@05 | live]
; [else-branch: 23 | !(0 <= i__8@33@05) | live]
(push) ; 9
; [then-branch: 23 | 0 <= i__8@33@05]
(assert (<= 0 i__8@33@05))
; [eval] i__8 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 23 | !(0 <= i__8@33@05)]
(assert (not (<= 0 i__8@33@05)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 24 | i__8@33@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__8@33@05 | live]
; [else-branch: 24 | !(i__8@33@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__8@33@05) | live]
(push) ; 9
; [then-branch: 24 | i__8@33@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__8@33@05]
(assert (and
  (<
    i__8@33@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  (<= 0 i__8@33@05)))
; [eval] diz.ALU_m.Main_process_state[i__8] == -1 || 0 <= diz.ALU_m.Main_process_state[i__8] && diz.ALU_m.Main_process_state[i__8] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__8] == -1
; [eval] diz.ALU_m.Main_process_state[i__8]
(push) ; 10
(assert (not (>= i__8@33@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1562
;  :arith-add-rows          3
;  :arith-assert-diseq      19
;  :arith-assert-lower      88
;  :arith-assert-upper      57
;  :arith-eq-adapter        43
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        1
;  :arith-pivots            40
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              92
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             820
;  :mk-clause               109
;  :num-allocs              3871624
;  :num-checks              109
;  :propagations            61
;  :quant-instantiations    42
;  :rlimit-count            146584)
; [eval] -1
(push) ; 10
; [then-branch: 25 | First:(Second:(Second:(Second:($t@23@05))))[i__8@33@05] == -1 | live]
; [else-branch: 25 | First:(Second:(Second:(Second:($t@23@05))))[i__8@33@05] != -1 | live]
(push) ; 11
; [then-branch: 25 | First:(Second:(Second:(Second:($t@23@05))))[i__8@33@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__8@33@05)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 25 | First:(Second:(Second:(Second:($t@23@05))))[i__8@33@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__8@33@05)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__8] && diz.ALU_m.Main_process_state[i__8] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__8]
; [eval] diz.ALU_m.Main_process_state[i__8]
(push) ; 12
(assert (not (>= i__8@33@05 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1564
;  :arith-add-rows          3
;  :arith-assert-diseq      21
;  :arith-assert-lower      91
;  :arith-assert-upper      58
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         23
;  :arith-offset-eqs        1
;  :arith-pivots            40
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              92
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             827
;  :mk-clause               121
;  :num-allocs              3871624
;  :num-checks              110
;  :propagations            66
;  :quant-instantiations    43
;  :rlimit-count            146801)
(push) ; 12
; [then-branch: 26 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__8@33@05] | live]
; [else-branch: 26 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__8@33@05]) | live]
(push) ; 13
; [then-branch: 26 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__8@33@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__8@33@05)))
; [eval] diz.ALU_m.Main_process_state[i__8] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__8]
(push) ; 14
(assert (not (>= i__8@33@05 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      21
;  :arith-assert-lower      93
;  :arith-assert-upper      59
;  :arith-eq-adapter        45
;  :arith-fixed-eqs         24
;  :arith-offset-eqs        1
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              92
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             831
;  :mk-clause               121
;  :num-allocs              3871624
;  :num-checks              111
;  :propagations            66
;  :quant-instantiations    43
;  :rlimit-count            146942)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 26 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__8@33@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__8@33@05))))
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
; [else-branch: 24 | !(i__8@33@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__8@33@05)]
(assert (not
  (and
    (<
      i__8@33@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
    (<= 0 i__8@33@05))))
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
(assert (not (forall ((i__8@33@05 Int)) (!
  (implies
    (and
      (<
        i__8@33@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__8@33@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__8@33@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__8@33@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__8@33@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__8@33@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      23
;  :arith-assert-lower      94
;  :arith-assert-upper      60
;  :arith-eq-adapter        46
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            43
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             839
;  :mk-clause               135
;  :num-allocs              3871624
;  :num-checks              112
;  :propagations            68
;  :quant-instantiations    44
;  :rlimit-count            147391)
(assert (forall ((i__8@33@05 Int)) (!
  (implies
    (and
      (<
        i__8@33@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__8@33@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__8@33@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__8@33@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__8@33@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__8@33@05))
  :qid |prog.l<no position>|)))
(declare-const $k@34@05 $Perm)
(assert ($Perm.isReadVar $k@34@05 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@34@05 $Perm.No) (< $Perm.No $k@34@05))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      96
;  :arith-assert-upper      61
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            43
;  :binary-propagations     7
;  :conflicts               67
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             844
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              113
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            147951)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@25@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      96
;  :arith-assert-upper      61
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            43
;  :binary-propagations     7
;  :conflicts               67
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             844
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              114
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            147962)
(assert (< $k@34@05 $k@25@05))
(assert (<= $Perm.No (- $k@25@05 $k@34@05)))
(assert (<= (- $k@25@05 $k@34@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@25@05 $k@34@05))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               68
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              115
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148182)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               69
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              116
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148230)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               70
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              117
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148278)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               71
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              118
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148326)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              119
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148374)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               73
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              120
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148422)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               74
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              121
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148470)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               75
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              122
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148518)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               76
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              123
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148566)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               76
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              124
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148579)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1566
;  :arith-add-rows          3
;  :arith-assert-diseq      24
;  :arith-assert-lower      98
;  :arith-assert-upper      62
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         25
;  :arith-offset-eqs        1
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               77
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   58
;  :datatype-splits         179
;  :decisions               292
;  :del-clause              118
;  :final-checks            37
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             847
;  :mk-clause               137
;  :num-allocs              3871624
;  :num-checks              125
;  :propagations            69
;  :quant-instantiations    44
;  :rlimit-count            148627)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1675
;  :arith-add-rows          41
;  :arith-assert-diseq      24
;  :arith-assert-lower      107
;  :arith-assert-upper      70
;  :arith-bound-prop        1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         35
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               77
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              131
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             878
;  :mk-clause               150
;  :num-allocs              3871624
;  :num-checks              126
;  :propagations            78
;  :quant-instantiations    44
;  :rlimit-count            150685
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1675
;  :arith-add-rows          41
;  :arith-assert-diseq      24
;  :arith-assert-lower      107
;  :arith-assert-upper      70
;  :arith-bound-prop        1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         35
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               78
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              131
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             878
;  :mk-clause               150
;  :num-allocs              3871624
;  :num-checks              127
;  :propagations            78
;  :quant-instantiations    44
;  :rlimit-count            150733)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1675
;  :arith-add-rows          41
;  :arith-assert-diseq      24
;  :arith-assert-lower      107
;  :arith-assert-upper      70
;  :arith-bound-prop        1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         35
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               78
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              131
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             878
;  :mk-clause               150
;  :num-allocs              3871624
;  :num-checks              128
;  :propagations            78
;  :quant-instantiations    44
;  :rlimit-count            150746)
; [exec]
; label __return_get_bit
; [exec]
; sys__result := sys__local__result__3
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__10: Int :: { diz.ALU_m.Main_process_state[i__10] } 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1675
;  :arith-add-rows          41
;  :arith-assert-diseq      24
;  :arith-assert-lower      107
;  :arith-assert-upper      70
;  :arith-bound-prop        1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         35
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               78
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              131
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             878
;  :mk-clause               150
;  :num-allocs              3871624
;  :num-checks              129
;  :propagations            78
;  :quant-instantiations    44
;  :rlimit-count            150759)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__10: Int :: { diz.ALU_m.Main_process_state[i__10] } 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|)
(declare-const i__10@35@05 Int)
(push) ; 7
; [eval] 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__10
(push) ; 8
; [then-branch: 27 | 0 <= i__10@35@05 | live]
; [else-branch: 27 | !(0 <= i__10@35@05) | live]
(push) ; 9
; [then-branch: 27 | 0 <= i__10@35@05]
(assert (<= 0 i__10@35@05))
; [eval] i__10 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 27 | !(0 <= i__10@35@05)]
(assert (not (<= 0 i__10@35@05)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 28 | i__10@35@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__10@35@05 | live]
; [else-branch: 28 | !(i__10@35@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__10@35@05) | live]
(push) ; 9
; [then-branch: 28 | i__10@35@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__10@35@05]
(assert (and
  (<
    i__10@35@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  (<= 0 i__10@35@05)))
; [eval] diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__10] == -1
; [eval] diz.ALU_m.Main_process_state[i__10]
(push) ; 10
(assert (not (>= i__10@35@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1676
;  :arith-add-rows          41
;  :arith-assert-diseq      24
;  :arith-assert-lower      108
;  :arith-assert-upper      71
;  :arith-bound-prop        1
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         36
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               78
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              131
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             880
;  :mk-clause               150
;  :num-allocs              3871624
;  :num-checks              130
;  :propagations            78
;  :quant-instantiations    44
;  :rlimit-count            150899)
; [eval] -1
(push) ; 10
; [then-branch: 29 | First:(Second:(Second:(Second:($t@23@05))))[i__10@35@05] == -1 | live]
; [else-branch: 29 | First:(Second:(Second:(Second:($t@23@05))))[i__10@35@05] != -1 | live]
(push) ; 11
; [then-branch: 29 | First:(Second:(Second:(Second:($t@23@05))))[i__10@35@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__10@35@05)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 29 | First:(Second:(Second:(Second:($t@23@05))))[i__10@35@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__10@35@05)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__10]
; [eval] diz.ALU_m.Main_process_state[i__10]
(push) ; 12
(assert (not (>= i__10@35@05 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1678
;  :arith-add-rows          41
;  :arith-assert-diseq      26
;  :arith-assert-lower      111
;  :arith-assert-upper      72
;  :arith-bound-prop        1
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         36
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               78
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              131
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             887
;  :mk-clause               163
;  :num-allocs              3871624
;  :num-checks              131
;  :propagations            83
;  :quant-instantiations    46
;  :rlimit-count            151141)
(push) ; 12
; [then-branch: 30 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__10@35@05] | live]
; [else-branch: 30 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__10@35@05]) | live]
(push) ; 13
; [then-branch: 30 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__10@35@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__10@35@05)))
; [eval] diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__10]
(push) ; 14
(assert (not (>= i__10@35@05 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      26
;  :arith-assert-lower      113
;  :arith-assert-upper      73
;  :arith-bound-prop        1
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         37
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               78
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              131
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             891
;  :mk-clause               163
;  :num-allocs              3871624
;  :num-checks              132
;  :propagations            83
;  :quant-instantiations    46
;  :rlimit-count            151272)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 30 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__10@35@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__10@35@05))))
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
; [else-branch: 28 | !(i__10@35@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__10@35@05)]
(assert (not
  (and
    (<
      i__10@35@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
    (<= 0 i__10@35@05))))
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
(assert (not (forall ((i__10@35@05 Int)) (!
  (implies
    (and
      (<
        i__10@35@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__10@35@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__10@35@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__10@35@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__10@35@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__10@35@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      28
;  :arith-assert-lower      114
;  :arith-assert-upper      74
;  :arith-bound-prop        1
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               79
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             899
;  :mk-clause               177
;  :num-allocs              3871624
;  :num-checks              133
;  :propagations            85
;  :quant-instantiations    48
;  :rlimit-count            151743)
(assert (forall ((i__10@35@05 Int)) (!
  (implies
    (and
      (<
        i__10@35@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__10@35@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__10@35@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__10@35@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__10@35@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__10@35@05))
  :qid |prog.l<no position>|)))
(declare-const $k@36@05 $Perm)
(assert ($Perm.isReadVar $k@36@05 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@36@05 $Perm.No) (< $Perm.No $k@36@05))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      116
;  :arith-assert-upper      75
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             904
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              134
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152304)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@25@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      116
;  :arith-assert-upper      75
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             904
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              135
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152315)
(assert (< $k@36@05 $k@25@05))
(assert (<= $Perm.No (- $k@25@05 $k@36@05)))
(assert (<= (- $k@25@05 $k@36@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@25@05 $k@36@05))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              136
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152523)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               82
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              137
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152571)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              138
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152619)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               84
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              139
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152667)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               85
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              140
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152715)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               86
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              141
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152763)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               87
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              142
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152811)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               88
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              143
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152859)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               89
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              144
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152907)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               89
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              145
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152920)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1680
;  :arith-add-rows          41
;  :arith-assert-diseq      29
;  :arith-assert-lower      118
;  :arith-assert-upper      76
;  :arith-bound-prop        1
;  :arith-eq-adapter        56
;  :arith-fixed-eqs         38
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           7
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        9
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            58
;  :arith-pseudo-nonlinear  2
;  :binary-propagations     7
;  :conflicts               90
;  :datatype-accessor-ax    113
;  :datatype-constructor-ax 342
;  :datatype-occurs-check   65
;  :datatype-splits         193
;  :decisions               321
;  :del-clause              158
;  :final-checks            45
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.13
;  :memory                  4.13
;  :mk-bool-var             907
;  :mk-clause               179
;  :num-allocs              3871624
;  :num-checks              146
;  :propagations            86
;  :quant-instantiations    48
;  :rlimit-count            152968)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1780
;  :arith-add-rows          45
;  :arith-assert-diseq      29
;  :arith-assert-lower      127
;  :arith-assert-upper      85
;  :arith-bound-prop        1
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         44
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            64
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               90
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   72
;  :datatype-splits         207
;  :decisions               349
;  :del-clause              170
;  :final-checks            53
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             935
;  :mk-clause               191
;  :num-allocs              4018172
;  :num-checks              147
;  :propagations            96
;  :quant-instantiations    48
;  :rlimit-count            153969
;  :time                    0.00)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1780
;  :arith-add-rows          45
;  :arith-assert-diseq      29
;  :arith-assert-lower      127
;  :arith-assert-upper      85
;  :arith-bound-prop        1
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         44
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            64
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   72
;  :datatype-splits         207
;  :decisions               349
;  :del-clause              170
;  :final-checks            53
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             935
;  :mk-clause               191
;  :num-allocs              4018172
;  :num-checks              148
;  :propagations            96
;  :quant-instantiations    48
;  :rlimit-count            154017)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1780
;  :arith-add-rows          45
;  :arith-assert-diseq      29
;  :arith-assert-lower      127
;  :arith-assert-upper      85
;  :arith-bound-prop        1
;  :arith-eq-adapter        61
;  :arith-fixed-eqs         44
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            64
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 368
;  :datatype-occurs-check   72
;  :datatype-splits         207
;  :decisions               349
;  :del-clause              170
;  :final-checks            53
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             935
;  :mk-clause               191
;  :num-allocs              4018172
;  :num-checks              149
;  :propagations            96
;  :quant-instantiations    48
;  :rlimit-count            154030)
; [exec]
; inhale false
(pop) ; 6
(push) ; 6
; [else-branch: 22 | divisor__5@20@05 == 0]
(assert (= divisor__5@20@05 0))
(pop) ; 6
; [eval] !(divisor__5 != 0)
; [eval] divisor__5 != 0
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= divisor__5@20@05 0))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1866
;  :arith-add-rows          47
;  :arith-assert-diseq      29
;  :arith-assert-lower      128
;  :arith-assert-upper      86
;  :arith-bound-prop        1
;  :arith-eq-adapter        62
;  :arith-fixed-eqs         45
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            73
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 394
;  :datatype-occurs-check   77
;  :datatype-splits         221
;  :decisions               373
;  :del-clause              187
;  :final-checks            56
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             954
;  :mk-clause               192
;  :num-allocs              4018172
;  :num-checks              150
;  :propagations            98
;  :quant-instantiations    48
;  :rlimit-count            154872)
(push) ; 6
(assert (not (= divisor__5@20@05 0)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1951
;  :arith-add-rows          47
;  :arith-assert-diseq      29
;  :arith-assert-lower      129
;  :arith-assert-upper      87
;  :arith-bound-prop        1
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         46
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            75
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              188
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             973
;  :mk-clause               193
;  :num-allocs              4018172
;  :num-checks              151
;  :propagations            100
;  :quant-instantiations    48
;  :rlimit-count            155667)
; [then-branch: 31 | divisor__5@20@05 == 0 | live]
; [else-branch: 31 | divisor__5@20@05 != 0 | live]
(push) ; 6
; [then-branch: 31 | divisor__5@20@05 == 0]
(assert (= divisor__5@20@05 0))
; [exec]
; sys__local__result__3 := 0
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && (true && (true && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__9: Int :: { diz.ALU_m.Main_process_state[i__9] } 0 <= i__9 && i__9 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__9] == -1 || 0 <= diz.ALU_m.Main_process_state[i__9] && diz.ALU_m.Main_process_state[i__9] < |diz.ALU_m.Main_event_state|)) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2)) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1952
;  :arith-add-rows          47
;  :arith-assert-diseq      29
;  :arith-assert-lower      129
;  :arith-assert-upper      87
;  :arith-bound-prop        1
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         46
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            75
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              188
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             974
;  :mk-clause               193
;  :num-allocs              4018172
;  :num-checks              152
;  :propagations            100
;  :quant-instantiations    48
;  :rlimit-count            155722)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__9: Int :: { diz.ALU_m.Main_process_state[i__9] } 0 <= i__9 && i__9 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__9] == -1 || 0 <= diz.ALU_m.Main_process_state[i__9] && diz.ALU_m.Main_process_state[i__9] < |diz.ALU_m.Main_event_state|)
(declare-const i__9@37@05 Int)
(push) ; 7
; [eval] 0 <= i__9 && i__9 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__9] == -1 || 0 <= diz.ALU_m.Main_process_state[i__9] && diz.ALU_m.Main_process_state[i__9] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__9 && i__9 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__9
(push) ; 8
; [then-branch: 32 | 0 <= i__9@37@05 | live]
; [else-branch: 32 | !(0 <= i__9@37@05) | live]
(push) ; 9
; [then-branch: 32 | 0 <= i__9@37@05]
(assert (<= 0 i__9@37@05))
; [eval] i__9 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 32 | !(0 <= i__9@37@05)]
(assert (not (<= 0 i__9@37@05)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 33 | i__9@37@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__9@37@05 | live]
; [else-branch: 33 | !(i__9@37@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__9@37@05) | live]
(push) ; 9
; [then-branch: 33 | i__9@37@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__9@37@05]
(assert (and
  (<
    i__9@37@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  (<= 0 i__9@37@05)))
; [eval] diz.ALU_m.Main_process_state[i__9] == -1 || 0 <= diz.ALU_m.Main_process_state[i__9] && diz.ALU_m.Main_process_state[i__9] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__9] == -1
; [eval] diz.ALU_m.Main_process_state[i__9]
(push) ; 10
(assert (not (>= i__9@37@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1953
;  :arith-add-rows          47
;  :arith-assert-diseq      29
;  :arith-assert-lower      130
;  :arith-assert-upper      88
;  :arith-bound-prop        1
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         47
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            75
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              188
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             976
;  :mk-clause               193
;  :num-allocs              4018172
;  :num-checks              153
;  :propagations            100
;  :quant-instantiations    48
;  :rlimit-count            155862)
; [eval] -1
(push) ; 10
; [then-branch: 34 | First:(Second:(Second:(Second:($t@23@05))))[i__9@37@05] == -1 | live]
; [else-branch: 34 | First:(Second:(Second:(Second:($t@23@05))))[i__9@37@05] != -1 | live]
(push) ; 11
; [then-branch: 34 | First:(Second:(Second:(Second:($t@23@05))))[i__9@37@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__9@37@05)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 34 | First:(Second:(Second:(Second:($t@23@05))))[i__9@37@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__9@37@05)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__9] && diz.ALU_m.Main_process_state[i__9] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__9]
; [eval] diz.ALU_m.Main_process_state[i__9]
(push) ; 12
(assert (not (>= i__9@37@05 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1955
;  :arith-add-rows          47
;  :arith-assert-diseq      31
;  :arith-assert-lower      133
;  :arith-assert-upper      89
;  :arith-bound-prop        1
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         47
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            75
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              188
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             983
;  :mk-clause               205
;  :num-allocs              4018172
;  :num-checks              154
;  :propagations            105
;  :quant-instantiations    49
;  :rlimit-count            156079)
(push) ; 12
; [then-branch: 35 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__9@37@05] | live]
; [else-branch: 35 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__9@37@05]) | live]
(push) ; 13
; [then-branch: 35 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__9@37@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__9@37@05)))
; [eval] diz.ALU_m.Main_process_state[i__9] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__9]
(push) ; 14
(assert (not (>= i__9@37@05 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      31
;  :arith-assert-lower      135
;  :arith-assert-upper      90
;  :arith-bound-prop        1
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         48
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            77
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              188
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             987
;  :mk-clause               205
;  :num-allocs              4018172
;  :num-checks              155
;  :propagations            105
;  :quant-instantiations    49
;  :rlimit-count            156220)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 35 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__9@37@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__9@37@05))))
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
; [else-branch: 33 | !(i__9@37@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__9@37@05)]
(assert (not
  (and
    (<
      i__9@37@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
    (<= 0 i__9@37@05))))
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
(assert (not (forall ((i__9@37@05 Int)) (!
  (implies
    (and
      (<
        i__9@37@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__9@37@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__9@37@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__9@37@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__9@37@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__9@37@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      33
;  :arith-assert-lower      136
;  :arith-assert-upper      91
;  :arith-bound-prop        1
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             995
;  :mk-clause               219
;  :num-allocs              4018172
;  :num-checks              156
;  :propagations            107
;  :quant-instantiations    50
;  :rlimit-count            156669)
(assert (forall ((i__9@37@05 Int)) (!
  (implies
    (and
      (<
        i__9@37@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__9@37@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__9@37@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__9@37@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__9@37@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__9@37@05))
  :qid |prog.l<no position>|)))
(declare-const $k@38@05 $Perm)
(assert ($Perm.isReadVar $k@38@05 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@38@05 $Perm.No) (< $Perm.No $k@38@05))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      138
;  :arith-assert-upper      92
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1000
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              157
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157230)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@25@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      138
;  :arith-assert-upper      92
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1000
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              158
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157241)
(assert (< $k@38@05 $k@25@05))
(assert (<= $Perm.No (- $k@25@05 $k@38@05)))
(assert (<= (- $k@25@05 $k@38@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@25@05 $k@38@05))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               94
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              159
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157449)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               95
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              160
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157497)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              161
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157545)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               97
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              162
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157593)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               98
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              163
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157641)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               99
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              164
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157689)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               100
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              165
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157737)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               101
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              166
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157785)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               102
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              167
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157833)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               102
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              168
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157846)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1957
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      140
;  :arith-assert-upper      93
;  :arith-bound-prop        1
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         49
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            78
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               103
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 420
;  :datatype-occurs-check   82
;  :datatype-splits         235
;  :decisions               397
;  :del-clause              214
;  :final-checks            59
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1003
;  :mk-clause               221
;  :num-allocs              4018172
;  :num-checks              169
;  :propagations            108
;  :quant-instantiations    50
;  :rlimit-count            157894)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2042
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      141
;  :arith-assert-upper      94
;  :arith-bound-prop        1
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         50
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            80
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               103
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              215
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1021
;  :mk-clause               222
;  :num-allocs              4018172
;  :num-checks              170
;  :propagations            110
;  :quant-instantiations    50
;  :rlimit-count            158652)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2042
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      141
;  :arith-assert-upper      94
;  :arith-bound-prop        1
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         50
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            80
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               104
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              215
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1021
;  :mk-clause               222
;  :num-allocs              4018172
;  :num-checks              171
;  :propagations            110
;  :quant-instantiations    50
;  :rlimit-count            158700)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2042
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      141
;  :arith-assert-upper      94
;  :arith-bound-prop        1
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         50
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            80
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               104
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              215
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1021
;  :mk-clause               222
;  :num-allocs              4018172
;  :num-checks              172
;  :propagations            110
;  :quant-instantiations    50
;  :rlimit-count            158713)
; [exec]
; label __return_get_bit
; [exec]
; sys__result := sys__local__result__3
; [exec]
; // assert
; assert acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(Main_lock_held_EncodedGlobalVariables(diz.ALU_m, globals), write) && acc(diz.ALU_m.Main_process_state, write) && |diz.ALU_m.Main_process_state| == 1 && acc(diz.ALU_m.Main_event_state, write) && |diz.ALU_m.Main_event_state| == 2 && (forall i__10: Int :: { diz.ALU_m.Main_process_state[i__10] } 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|) && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu != null && acc(diz.ALU_m.Main_alu.ALU_OPCODE, write) && acc(diz.ALU_m.Main_alu.ALU_OP1, write) && acc(diz.ALU_m.Main_alu.ALU_OP2, write) && acc(diz.ALU_m.Main_alu.ALU_CARRY, write) && acc(diz.ALU_m.Main_alu.ALU_ZERO, write) && acc(diz.ALU_m.Main_alu.ALU_RESULT, write) && 0 <= diz.ALU_m.Main_alu.ALU_RESULT && diz.ALU_m.Main_alu.ALU_RESULT <= 16 && acc(diz.ALU_m.Main_alu.ALU_init, 1 / 2) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && diz.ALU_init
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2042
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      141
;  :arith-assert-upper      94
;  :arith-bound-prop        1
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         50
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            80
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               104
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              215
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1021
;  :mk-clause               222
;  :num-allocs              4018172
;  :num-checks              173
;  :propagations            110
;  :quant-instantiations    50
;  :rlimit-count            158726)
; [eval] diz.ALU_m != null
; [eval] |diz.ALU_m.Main_process_state| == 1
; [eval] |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_event_state| == 2
; [eval] |diz.ALU_m.Main_event_state|
; [eval] (forall i__10: Int :: { diz.ALU_m.Main_process_state[i__10] } 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|)
(declare-const i__10@39@05 Int)
(push) ; 7
; [eval] 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state| ==> diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= i__10 && i__10 < |diz.ALU_m.Main_process_state|
; [eval] 0 <= i__10
(push) ; 8
; [then-branch: 36 | 0 <= i__10@39@05 | live]
; [else-branch: 36 | !(0 <= i__10@39@05) | live]
(push) ; 9
; [then-branch: 36 | 0 <= i__10@39@05]
(assert (<= 0 i__10@39@05))
; [eval] i__10 < |diz.ALU_m.Main_process_state|
; [eval] |diz.ALU_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 36 | !(0 <= i__10@39@05)]
(assert (not (<= 0 i__10@39@05)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 37 | i__10@39@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__10@39@05 | live]
; [else-branch: 37 | !(i__10@39@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__10@39@05) | live]
(push) ; 9
; [then-branch: 37 | i__10@39@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__10@39@05]
(assert (and
  (<
    i__10@39@05
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
  (<= 0 i__10@39@05)))
; [eval] diz.ALU_m.Main_process_state[i__10] == -1 || 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__10] == -1
; [eval] diz.ALU_m.Main_process_state[i__10]
(push) ; 10
(assert (not (>= i__10@39@05 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2043
;  :arith-add-rows          47
;  :arith-assert-diseq      34
;  :arith-assert-lower      142
;  :arith-assert-upper      95
;  :arith-bound-prop        1
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         51
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            80
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               104
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              215
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1023
;  :mk-clause               222
;  :num-allocs              4018172
;  :num-checks              174
;  :propagations            110
;  :quant-instantiations    50
;  :rlimit-count            158866)
; [eval] -1
(push) ; 10
; [then-branch: 38 | First:(Second:(Second:(Second:($t@23@05))))[i__10@39@05] == -1 | live]
; [else-branch: 38 | First:(Second:(Second:(Second:($t@23@05))))[i__10@39@05] != -1 | live]
(push) ; 11
; [then-branch: 38 | First:(Second:(Second:(Second:($t@23@05))))[i__10@39@05] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__10@39@05)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 38 | First:(Second:(Second:(Second:($t@23@05))))[i__10@39@05] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__10@39@05)
    (- 0 1))))
; [eval] 0 <= diz.ALU_m.Main_process_state[i__10] && diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] 0 <= diz.ALU_m.Main_process_state[i__10]
; [eval] diz.ALU_m.Main_process_state[i__10]
(push) ; 12
(assert (not (>= i__10@39@05 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2045
;  :arith-add-rows          47
;  :arith-assert-diseq      36
;  :arith-assert-lower      145
;  :arith-assert-upper      96
;  :arith-bound-prop        1
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         51
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            80
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               104
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              215
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1030
;  :mk-clause               235
;  :num-allocs              4018172
;  :num-checks              175
;  :propagations            115
;  :quant-instantiations    52
;  :rlimit-count            159108)
(push) ; 12
; [then-branch: 39 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__10@39@05] | live]
; [else-branch: 39 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__10@39@05]) | live]
(push) ; 13
; [then-branch: 39 | 0 <= First:(Second:(Second:(Second:($t@23@05))))[i__10@39@05]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__10@39@05)))
; [eval] diz.ALU_m.Main_process_state[i__10] < |diz.ALU_m.Main_event_state|
; [eval] diz.ALU_m.Main_process_state[i__10]
(push) ; 14
(assert (not (>= i__10@39@05 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      36
;  :arith-assert-lower      147
;  :arith-assert-upper      97
;  :arith-bound-prop        1
;  :arith-eq-adapter        70
;  :arith-fixed-eqs         52
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            81
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               104
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              215
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1034
;  :mk-clause               235
;  :num-allocs              4018172
;  :num-checks              176
;  :propagations            115
;  :quant-instantiations    52
;  :rlimit-count            159243)
; [eval] |diz.ALU_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 39 | !(0 <= First:(Second:(Second:(Second:($t@23@05))))[i__10@39@05])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
      i__10@39@05))))
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
; [else-branch: 37 | !(i__10@39@05 < |First:(Second:(Second:(Second:($t@23@05))))| && 0 <= i__10@39@05)]
(assert (not
  (and
    (<
      i__10@39@05
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
    (<= 0 i__10@39@05))))
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
(assert (not (forall ((i__10@39@05 Int)) (!
  (implies
    (and
      (<
        i__10@39@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__10@39@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__10@39@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__10@39@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__10@39@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__10@39@05))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      38
;  :arith-assert-lower      148
;  :arith-assert-upper      98
;  :arith-bound-prop        1
;  :arith-eq-adapter        71
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            82
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               105
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1042
;  :mk-clause               249
;  :num-allocs              4018172
;  :num-checks              177
;  :propagations            117
;  :quant-instantiations    54
;  :rlimit-count            159717)
(assert (forall ((i__10@39@05 Int)) (!
  (implies
    (and
      (<
        i__10@39@05
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))
      (<= 0 i__10@39@05))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
          i__10@39@05)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__10@39@05)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
            i__10@39@05)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@23@05)))))
    i__10@39@05))
  :qid |prog.l<no position>|)))
(declare-const $k@40@05 $Perm)
(assert ($Perm.isReadVar $k@40@05 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@40@05 $Perm.No) (< $Perm.No $k@40@05))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      150
;  :arith-assert-upper      99
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            82
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               106
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1047
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              178
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160277)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@25@05 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      150
;  :arith-assert-upper      99
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            82
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               106
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1047
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              179
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160288)
(assert (< $k@40@05 $k@25@05))
(assert (<= $Perm.No (- $k@25@05 $k@40@05)))
(assert (<= (- $k@25@05 $k@40@05) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@25@05 $k@40@05))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@23@05)) $Ref.null))))
; [eval] diz.ALU_m.Main_alu != null
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               107
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              180
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160502)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               108
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              181
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160550)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              182
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160598)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               110
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              183
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160646)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               111
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              184
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160694)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               112
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              185
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160742)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               113
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              186
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160790)
; [eval] 0 <= diz.ALU_m.Main_alu.ALU_RESULT
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               114
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              187
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160838)
; [eval] diz.ALU_m.Main_alu.ALU_RESULT <= 16
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               115
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              188
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160886)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               115
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              189
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160899)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2047
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      152
;  :arith-assert-upper      100
;  :arith-bound-prop        1
;  :arith-eq-adapter        72
;  :arith-fixed-eqs         53
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            83
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               116
;  :datatype-accessor-ax    121
;  :datatype-constructor-ax 446
;  :datatype-occurs-check   87
;  :datatype-splits         249
;  :decisions               421
;  :del-clause              242
;  :final-checks            62
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1050
;  :mk-clause               251
;  :num-allocs              4018172
;  :num-checks              190
;  :propagations            118
;  :quant-instantiations    54
;  :rlimit-count            160947)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2132
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      153
;  :arith-assert-upper      101
;  :arith-bound-prop        1
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         54
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            85
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               116
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 472
;  :datatype-occurs-check   92
;  :datatype-splits         263
;  :decisions               445
;  :del-clause              243
;  :final-checks            65
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1068
;  :mk-clause               252
;  :num-allocs              4018172
;  :num-checks              191
;  :propagations            120
;  :quant-instantiations    54
;  :rlimit-count            161712)
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 7
(assert (not (< $Perm.No $k@25@05)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2132
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      153
;  :arith-assert-upper      101
;  :arith-bound-prop        1
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         54
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            85
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               117
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 472
;  :datatype-occurs-check   92
;  :datatype-splits         263
;  :decisions               445
;  :del-clause              243
;  :final-checks            65
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1068
;  :mk-clause               252
;  :num-allocs              4018172
;  :num-checks              192
;  :propagations            120
;  :quant-instantiations    54
;  :rlimit-count            161760)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2132
;  :arith-add-rows          47
;  :arith-assert-diseq      39
;  :arith-assert-lower      153
;  :arith-assert-upper      101
;  :arith-bound-prop        1
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         54
;  :arith-gcd-tests         3
;  :arith-grobner           8
;  :arith-max-min           19
;  :arith-nonlinear-bounds  1
;  :arith-nonlinear-horner  3
;  :arith-offset-eqs        13
;  :arith-patches           3
;  :arith-patches_succ      3
;  :arith-pivots            85
;  :arith-pseudo-nonlinear  4
;  :binary-propagations     7
;  :conflicts               117
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 472
;  :datatype-occurs-check   92
;  :datatype-splits         263
;  :decisions               445
;  :del-clause              243
;  :final-checks            65
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.23
;  :memory                  4.23
;  :mk-bool-var             1068
;  :mk-clause               252
;  :num-allocs              4018172
;  :num-checks              193
;  :propagations            120
;  :quant-instantiations    54
;  :rlimit-count            161773)
; [exec]
; inhale false
(pop) ; 6
(push) ; 6
; [else-branch: 31 | divisor__5@20@05 != 0]
(assert (not (= divisor__5@20@05 0)))
(pop) ; 6
(pop) ; 5
(push) ; 5
; [else-branch: 21 | i__4@22@05 < pos@8@05]
(assert (< i__4@22@05 pos@8@05))
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
