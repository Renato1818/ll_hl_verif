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
; ---------- ALU___contract_unsatisfiable__ALU_EncodedGlobalVariables_Main ----------
(declare-const diz@0@08 $Ref)
(declare-const globals@1@08 $Ref)
(declare-const m_param@2@08 $Ref)
(declare-const diz@3@08 $Ref)
(declare-const globals@4@08 $Ref)
(declare-const m_param@5@08 $Ref)
(push) ; 1
(declare-const $t@6@08 $Snap)
(assert (= $t@6@08 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@3@08 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && true
(declare-const $t@7@08 $Snap)
(assert (= $t@7@08 ($Snap.combine ($Snap.first $t@7@08) ($Snap.second $t@7@08))))
(assert (= ($Snap.first $t@7@08) $Snap.unit))
(assert (= ($Snap.second $t@7@08) $Snap.unit))
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
; ---------- ALU___contract_unsatisfiable__run_EncodedGlobalVariables ----------
(declare-const diz@8@08 $Ref)
(declare-const globals@9@08 $Ref)
(declare-const diz@10@08 $Ref)
(declare-const globals@11@08 $Ref)
(push) ; 1
(declare-const $t@12@08 $Snap)
(assert (= $t@12@08 $Snap.unit))
; [eval] diz != null
(assert (not (= diz@10@08 $Ref.null)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(pop) ; 2
(push) ; 2
; [exec]
; inhale true && (acc(diz.ALU_m, 1 / 2) && diz.ALU_m != null && acc(diz.ALU_m.Main_alu, wildcard) && diz.ALU_m.Main_alu == diz && acc(diz.ALU_init, 1 / 2) && !diz.ALU_init)
(declare-const $t@13@08 $Snap)
(assert (= $t@13@08 ($Snap.combine ($Snap.first $t@13@08) ($Snap.second $t@13@08))))
(assert (= ($Snap.first $t@13@08) $Snap.unit))
(assert (=
  ($Snap.second $t@13@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@13@08))
    ($Snap.second ($Snap.second $t@13@08)))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             24
;  :arith-assert-lower    1
;  :arith-assert-upper    1
;  :arith-eq-adapter      1
;  :binary-propagations   7
;  :datatype-accessor-ax  5
;  :datatype-occurs-check 10
;  :final-checks          6
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.68
;  :mk-bool-var           249
;  :mk-clause             1
;  :num-allocs            3383233
;  :num-checks            7
;  :propagations          7
;  :quant-instantiations  1
;  :rlimit-count          110063)
(assert (=
  ($Snap.second ($Snap.second $t@13@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@13@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@13@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@13@08))) $Snap.unit))
; [eval] diz.ALU_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@13@08))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@13@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08)))))))
(declare-const $k@14@08 $Perm)
(assert ($Perm.isReadVar $k@14@08 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@14@08 $Perm.No) (< $Perm.No $k@14@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             36
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    2
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             1
;  :datatype-accessor-ax  7
;  :datatype-occurs-check 10
;  :final-checks          6
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.68
;  :mk-bool-var           258
;  :mk-clause             3
;  :num-allocs            3383233
;  :num-checks            8
;  :propagations          8
;  :quant-instantiations  2
;  :rlimit-count          110635)
(assert (<= $Perm.No $k@14@08))
(assert (<= $k@14@08 $Perm.Write))
(assert (implies
  (< $Perm.No $k@14@08)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@13@08)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08)))))
  $Snap.unit))
; [eval] diz.ALU_m.Main_alu == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@14@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             42
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             2
;  :datatype-accessor-ax  8
;  :datatype-occurs-check 10
;  :final-checks          6
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.68
;  :mk-bool-var           261
;  :mk-clause             3
;  :num-allocs            3383233
;  :num-checks            9
;  :propagations          8
;  :quant-instantiations  2
;  :rlimit-count          110908)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@13@08)))))
  diz@10@08))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08)))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs             49
;  :arith-assert-diseq    1
;  :arith-assert-lower    3
;  :arith-assert-upper    3
;  :arith-eq-adapter      2
;  :binary-propagations   7
;  :conflicts             2
;  :datatype-accessor-ax  9
;  :datatype-occurs-check 10
;  :final-checks          6
;  :max-generation        1
;  :max-memory            3.96
;  :memory                3.68
;  :mk-bool-var           264
;  :mk-clause             3
;  :num-allocs            3383233
;  :num-checks            10
;  :propagations          8
;  :quant-instantiations  3
;  :rlimit-count          111159)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08))))))
  $Snap.unit))
; [eval] !diz.ALU_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@13@08)))))))))
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
(declare-const diz@15@08 $Ref)
(declare-const globals@16@08 $Ref)
(declare-const diz@17@08 $Ref)
(declare-const globals@18@08 $Ref)
(push) ; 1
(declare-const $t@19@08 $Snap)
(assert (= $t@19@08 ($Snap.combine ($Snap.first $t@19@08) ($Snap.second $t@19@08))))
(assert (= ($Snap.first $t@19@08) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@17@08 $Ref.null)))
(assert (=
  ($Snap.second $t@19@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@19@08))
    ($Snap.second ($Snap.second $t@19@08)))))
(declare-const $k@20@08 $Perm)
(assert ($Perm.isReadVar $k@20@08 $Perm.Write))
(set-option :timeout 0)
(push) ; 2
(assert (not (or (= $k@20@08 $Perm.No) (< $Perm.No $k@20@08))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               97
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               3
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   20
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.68
;  :mk-bool-var             279
;  :mk-clause               5
;  :num-allocs              3383233
;  :num-checks              15
;  :propagations            9
;  :quant-instantiations    5
;  :rlimit-count            113087)
(assert (<= $Perm.No $k@20@08))
(assert (<= $k@20@08 $Perm.Write))
(assert (implies (< $Perm.No $k@20@08) (not (= diz@17@08 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second $t@19@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@19@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@19@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@19@08))) $Snap.unit))
; [eval] diz.Main_alu != null
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@20@08)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               103
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               4
;  :datatype-accessor-ax    13
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   20
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.68
;  :mk-bool-var             282
;  :mk-clause               5
;  :num-allocs              3383233
;  :num-checks              16
;  :propagations            9
;  :quant-instantiations    5
;  :rlimit-count            113340)
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@19@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))))
(push) ; 2
(assert (not (< $Perm.No $k@20@08)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               109
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               5
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   20
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.68
;  :mk-bool-var             285
;  :mk-clause               5
;  :num-allocs              3383233
;  :num-checks              17
;  :propagations            9
;  :quant-instantiations    6
;  :rlimit-count            113624)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               109
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               5
;  :datatype-accessor-ax    14
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   20
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.68
;  :mk-bool-var             285
;  :mk-clause               5
;  :num-allocs              3383233
;  :num-checks              18
;  :propagations            9
;  :quant-instantiations    6
;  :rlimit-count            113637)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_m == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@20@08)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               115
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               6
;  :datatype-accessor-ax    15
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   20
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.68
;  :mk-bool-var             287
;  :mk-clause               5
;  :num-allocs              3383233
;  :num-checks              19
;  :propagations            9
;  :quant-instantiations    6
;  :rlimit-count            113856)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))
  diz@17@08))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))))))
(push) ; 2
(assert (not (< $Perm.No $k@20@08)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               122
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               7
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   20
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.68
;  :mk-bool-var             290
;  :mk-clause               5
;  :num-allocs              3383233
;  :num-checks              20
;  :propagations            9
;  :quant-instantiations    7
;  :rlimit-count            114142)
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               122
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               7
;  :datatype-accessor-ax    16
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   20
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.68
;  :mk-bool-var             290
;  :mk-clause               5
;  :num-allocs              3383233
;  :num-checks              21
;  :propagations            9
;  :quant-instantiations    7
;  :rlimit-count            114155)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))))
  $Snap.unit))
; [eval] !diz.Main_alu.ALU_init
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@20@08)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               128
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               8
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   20
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.68
;  :mk-bool-var             292
;  :mk-clause               5
;  :num-allocs              3383233
;  :num-checks              22
;  :propagations            9
;  :quant-instantiations    7
;  :rlimit-count            114394)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))))))
(push) ; 2
(assert (not (< $Perm.No $k@20@08)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               132
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               9
;  :datatype-accessor-ax    17
;  :datatype-constructor-ax 12
;  :datatype-occurs-check   20
;  :datatype-splits         3
;  :decisions               12
;  :del-clause              2
;  :final-checks            11
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.78
;  :mk-bool-var             295
;  :mk-clause               5
;  :num-allocs              3503925
;  :num-checks              23
;  :propagations            9
;  :quant-instantiations    9
;  :rlimit-count            114610
;  :time                    0.00)
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@21@08 $Snap)
(assert (= $t@21@08 ($Snap.combine ($Snap.first $t@21@08) ($Snap.second $t@21@08))))
(declare-const $k@22@08 $Perm)
(assert ($Perm.isReadVar $k@22@08 $Perm.Write))
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@22@08 $Perm.No) (< $Perm.No $k@22@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               147
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      6
;  :arith-eq-adapter        4
;  :binary-propagations     7
;  :conflicts               10
;  :datatype-accessor-ax    18
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.78
;  :mk-bool-var             304
;  :mk-clause               7
;  :num-allocs              3503925
;  :num-checks              25
;  :propagations            10
;  :quant-instantiations    9
;  :rlimit-count            115229)
(assert (<= $Perm.No $k@22@08))
(assert (<= $k@22@08 $Perm.Write))
(assert (implies (< $Perm.No $k@22@08) (not (= diz@17@08 $Ref.null))))
(assert (=
  ($Snap.second $t@21@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@21@08))
    ($Snap.second ($Snap.second $t@21@08)))))
(assert (= ($Snap.first ($Snap.second $t@21@08)) $Snap.unit))
; [eval] diz.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@22@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               153
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     7
;  :conflicts               11
;  :datatype-accessor-ax    19
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             307
;  :mk-clause               7
;  :num-allocs              3625418
;  :num-checks              26
;  :propagations            10
;  :quant-instantiations    9
;  :rlimit-count            115472)
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@21@08)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@21@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@21@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@21@08))))))
(push) ; 3
(assert (not (< $Perm.No $k@22@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.02s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               159
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     7
;  :conflicts               12
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             310
;  :mk-clause               7
;  :num-allocs              3625418
;  :num-checks              27
;  :propagations            10
;  :quant-instantiations    10
;  :rlimit-count            115744)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               159
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     7
;  :conflicts               12
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             310
;  :mk-clause               7
;  :num-allocs              3625418
;  :num-checks              28
;  :propagations            10
;  :quant-instantiations    10
;  :rlimit-count            115757)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@21@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@21@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@08)))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@21@08))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_m == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@22@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               165
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             312
;  :mk-clause               7
;  :num-allocs              3625418
;  :num-checks              29
;  :propagations            10
;  :quant-instantiations    10
;  :rlimit-count            115966)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@21@08))))
  diz@17@08))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@08))))))))
(push) ; 3
(assert (not (< $Perm.No $k@22@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               173
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     7
;  :conflicts               14
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             315
;  :mk-clause               7
;  :num-allocs              3625418
;  :num-checks              30
;  :propagations            10
;  :quant-instantiations    11
;  :rlimit-count            116241)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               173
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     7
;  :conflicts               14
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             315
;  :mk-clause               7
;  :num-allocs              3625418
;  :num-checks              31
;  :propagations            10
;  :quant-instantiations    11
;  :rlimit-count            116254)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@08)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@08))))))
  $Snap.unit))
; [eval] !diz.Main_alu.ALU_init
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@22@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     7
;  :conflicts               15
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             317
;  :mk-clause               7
;  :num-allocs              3625418
;  :num-checks              32
;  :propagations            10
;  :quant-instantiations    11
;  :rlimit-count            116483)
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@21@08))))))))
(push) ; 3
(assert (not (< $Perm.No $k@22@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               182
;  :arith-assert-diseq      3
;  :arith-assert-lower      7
;  :arith-assert-upper      7
;  :arith-eq-adapter        4
;  :binary-propagations     7
;  :conflicts               16
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 16
;  :datatype-occurs-check   22
;  :datatype-splits         7
;  :decisions               16
;  :del-clause              4
;  :final-checks            13
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             319
;  :mk-clause               7
;  :num-allocs              3625418
;  :num-checks              33
;  :propagations            10
;  :quant-instantiations    12
;  :rlimit-count            116671)
(pop) ; 2
(push) ; 2
; [exec]
; var min_advance__73: Int
(declare-const min_advance__73@23@08 Int)
; [exec]
; var __flatten_49__71: Seq[Int]
(declare-const __flatten_49__71@24@08 Seq<Int>)
; [exec]
; var __flatten_50__72: Seq[Int]
(declare-const __flatten_50__72@25@08 Seq<Int>)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@26@08 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@26@08 ($Snap.combine ($Snap.first $t@26@08) ($Snap.second $t@26@08))))
(assert (= ($Snap.first $t@26@08) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@26@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@26@08))
    ($Snap.second ($Snap.second $t@26@08)))))
(assert (= ($Snap.first ($Snap.second $t@26@08)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@26@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@26@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@26@08))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@26@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@27@08 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@27@08 | live]
; [else-branch: 0 | !(0 <= i@27@08) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@27@08]
(assert (<= 0 i@27@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@27@08)]
(assert (not (<= 0 i@27@08)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@27@08 < |First:(Second:(Second:(Second:($t@26@08))))| && 0 <= i@27@08 | live]
; [else-branch: 1 | !(i@27@08 < |First:(Second:(Second:(Second:($t@26@08))))| && 0 <= i@27@08) | live]
(push) ; 5
; [then-branch: 1 | i@27@08 < |First:(Second:(Second:(Second:($t@26@08))))| && 0 <= i@27@08]
(assert (and
  (<
    i@27@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
  (<= 0 i@27@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@27@08 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               243
;  :arith-assert-diseq      5
;  :arith-assert-lower      14
;  :arith-assert-upper      10
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               16
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              6
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             351
;  :mk-clause               13
;  :num-allocs              3625418
;  :num-checks              35
;  :propagations            12
;  :quant-instantiations    18
;  :rlimit-count            118342)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:($t@26@08))))[i@27@08] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:($t@26@08))))[i@27@08] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:($t@26@08))))[i@27@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
    i@27@08)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:($t@26@08))))[i@27@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
      i@27@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@27@08 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               243
;  :arith-assert-diseq      5
;  :arith-assert-lower      14
;  :arith-assert-upper      10
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               16
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              6
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             352
;  :mk-clause               13
;  :num-allocs              3625418
;  :num-checks              36
;  :propagations            12
;  :quant-instantiations    18
;  :rlimit-count            118517)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@26@08))))[i@27@08] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@26@08))))[i@27@08]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@26@08))))[i@27@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
    i@27@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@27@08 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               243
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      10
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               16
;  :datatype-accessor-ax    31
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              6
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             355
;  :mk-clause               14
;  :num-allocs              3625418
;  :num-checks              37
;  :propagations            12
;  :quant-instantiations    18
;  :rlimit-count            118641)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@26@08))))[i@27@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
      i@27@08))))
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
; [else-branch: 1 | !(i@27@08 < |First:(Second:(Second:(Second:($t@26@08))))| && 0 <= i@27@08)]
(assert (not
  (and
    (<
      i@27@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
    (<= 0 i@27@08))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(pop) ; 3
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@27@08 Int)) (!
  (implies
    (and
      (<
        i@27@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
      (<= 0 i@27@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
          i@27@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
            i@27@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
            i@27@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
    i@27@08))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))
(declare-const $k@28@08 $Perm)
(assert ($Perm.isReadVar $k@28@08 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@28@08 $Perm.No) (< $Perm.No $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               248
;  :arith-assert-diseq      7
;  :arith-assert-lower      19
;  :arith-assert-upper      11
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    32
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             361
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              38
;  :propagations            13
;  :quant-instantiations    18
;  :rlimit-count            119410)
(declare-const $t@29@08 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@20@08)
    (=
      $t@29@08
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08)))))
  (implies
    (< $Perm.No $k@28@08)
    (=
      $t@29@08
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))
(assert (<= $Perm.No (+ $k@20@08 $k@28@08)))
(assert (<= (+ $k@20@08 $k@28@08) $Perm.Write))
(assert (implies (< $Perm.No (+ $k@20@08 $k@28@08)) (not (= diz@17@08 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))
  $Snap.unit))
; [eval] diz.Main_alu != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               258
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      13
;  :arith-conflicts         1
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         2
;  :binary-propagations     7
;  :conflicts               18
;  :datatype-accessor-ax    33
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             369
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              39
;  :propagations            13
;  :quant-instantiations    19
;  :rlimit-count            120009)
(assert (not (= $t@29@08 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               264
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      14
;  :arith-conflicts         2
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         3
;  :binary-propagations     7
;  :conflicts               19
;  :datatype-accessor-ax    34
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             372
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              40
;  :propagations            13
;  :quant-instantiations    19
;  :rlimit-count            120313)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               269
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      15
;  :arith-conflicts         3
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         4
;  :binary-propagations     7
;  :conflicts               20
;  :datatype-accessor-ax    35
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             374
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              41
;  :propagations            13
;  :quant-instantiations    19
;  :rlimit-count            120582)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               274
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      16
;  :arith-conflicts         4
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         5
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             376
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              42
;  :propagations            13
;  :quant-instantiations    19
;  :rlimit-count            120861)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               279
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      17
;  :arith-conflicts         5
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         6
;  :binary-propagations     7
;  :conflicts               22
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             378
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              43
;  :propagations            13
;  :quant-instantiations    19
;  :rlimit-count            121150)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               284
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      18
;  :arith-conflicts         6
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         7
;  :binary-propagations     7
;  :conflicts               23
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             380
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              44
;  :propagations            13
;  :quant-instantiations    19
;  :rlimit-count            121449)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               289
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      19
;  :arith-conflicts         7
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         8
;  :binary-propagations     7
;  :conflicts               24
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             382
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              45
;  :propagations            13
;  :quant-instantiations    19
;  :rlimit-count            121758)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               295
;  :arith-assert-diseq      7
;  :arith-assert-lower      20
;  :arith-assert-upper      20
;  :arith-conflicts         8
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         9
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             385
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              46
;  :propagations            13
;  :quant-instantiations    19
;  :rlimit-count            122109)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               302
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      21
;  :arith-conflicts         9
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         10
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             390
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              47
;  :propagations            13
;  :quant-instantiations    20
;  :rlimit-count            122569)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))))
  16))
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               302
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      23
;  :arith-conflicts         10
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         11
;  :binary-propagations     7
;  :conflicts               27
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             392
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              48
;  :propagations            13
;  :quant-instantiations    20
;  :rlimit-count            122836)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               302
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      23
;  :arith-conflicts         10
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         11
;  :binary-propagations     7
;  :conflicts               27
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             392
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              49
;  :propagations            13
;  :quant-instantiations    20
;  :rlimit-count            122849)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $t@29@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               302
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      23
;  :arith-conflicts         10
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         11
;  :binary-propagations     7
;  :conflicts               28
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 20
;  :datatype-occurs-check   23
;  :datatype-splits         7
;  :decisions               20
;  :del-clause              7
;  :final-checks            14
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             393
;  :mk-clause               16
;  :num-allocs              3625418
;  :num-checks              50
;  :propagations            13
;  :quant-instantiations    20
;  :rlimit-count            122939)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))))
  ($SortWrappers.$SnapToBool ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))))))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@26@08 diz@17@08 globals@18@08))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@30@08 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; ALU_forkOperator_EncodedGlobalVariables(diz.Main_alu, globals)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               391
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      24
;  :arith-conflicts         11
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               30
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              15
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             419
;  :mk-clause               17
;  :num-allocs              3625418
;  :num-checks              53
;  :propagations            14
;  :quant-instantiations    21
;  :rlimit-count            124338)
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
; (:added-eqs               391
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      24
;  :arith-conflicts         11
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               30
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              15
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             419
;  :mk-clause               17
;  :num-allocs              3625418
;  :num-checks              54
;  :propagations            14
;  :quant-instantiations    21
;  :rlimit-count            124351)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $t@29@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               391
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      24
;  :arith-conflicts         11
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               31
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              15
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             420
;  :mk-clause               17
;  :num-allocs              3625418
;  :num-checks              55
;  :propagations            14
;  :quant-instantiations    21
;  :rlimit-count            124441)
; [eval] diz.ALU_m != null
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $t@29@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               391
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      24
;  :arith-conflicts         11
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               32
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              15
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             421
;  :mk-clause               17
;  :num-allocs              3625418
;  :num-checks              56
;  :propagations            14
;  :quant-instantiations    21
;  :rlimit-count            124531)
(set-option :timeout 0)
(push) ; 3
(assert (not (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))
    $Ref.null))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               391
;  :arith-assert-diseq      7
;  :arith-assert-lower      21
;  :arith-assert-upper      24
;  :arith-conflicts         11
;  :arith-eq-adapter        10
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               32
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              15
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             421
;  :mk-clause               17
;  :num-allocs              3625418
;  :num-checks              57
;  :propagations            14
;  :quant-instantiations    21
;  :rlimit-count            124549)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))
    $Ref.null)))
(declare-const $k@31@08 $Perm)
(assert ($Perm.isReadVar $k@31@08 $Perm.Write))
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $t@29@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               391
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      25
;  :arith-conflicts         11
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               33
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              15
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             426
;  :mk-clause               19
;  :num-allocs              3625418
;  :num-checks              58
;  :propagations            15
;  :quant-instantiations    21
;  :rlimit-count            124814)
(set-option :timeout 0)
(push) ; 3
(assert (not (or (= $k@31@08 $Perm.No) (< $Perm.No $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               391
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      25
;  :arith-conflicts         11
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              15
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             426
;  :mk-clause               19
;  :num-allocs              3625418
;  :num-checks              59
;  :propagations            15
;  :quant-instantiations    21
;  :rlimit-count            124864)
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  diz@17@08
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@08))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               391
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      25
;  :arith-conflicts         11
;  :arith-eq-adapter        11
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              15
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             426
;  :mk-clause               19
;  :num-allocs              3625418
;  :num-checks              60
;  :propagations            15
;  :quant-instantiations    21
;  :rlimit-count            124875)
(push) ; 3
(assert (not (not (= (+ $k@20@08 $k@28@08) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-assert-diseq      8
;  :arith-assert-lower      23
;  :arith-assert-upper      26
;  :arith-conflicts         12
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               35
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             428
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              61
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            124935)
(assert (< $k@31@08 (+ $k@20@08 $k@28@08)))
(assert (<= $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08)))
(assert (<= (- (+ $k@20@08 $k@28@08) $k@31@08) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))
  (not (= diz@17@08 $Ref.null))))
; [eval] diz.ALU_m.Main_alu == diz
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $t@29@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-assert-diseq      8
;  :arith-assert-lower      25
;  :arith-assert-upper      27
;  :arith-conflicts         12
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               36
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             432
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              62
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            125193)
(push) ; 3
(assert (not (=
  diz@17@08
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@19@08))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-assert-diseq      8
;  :arith-assert-lower      25
;  :arith-assert-upper      27
;  :arith-conflicts         12
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         12
;  :binary-propagations     7
;  :conflicts               36
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             432
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              63
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            125204)
(push) ; 3
(assert (not (< $Perm.No (+ $k@20@08 $k@28@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-assert-diseq      8
;  :arith-assert-lower      25
;  :arith-assert-upper      28
;  :arith-conflicts         13
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         13
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             433
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              64
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            125264)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-assert-diseq      8
;  :arith-assert-lower      25
;  :arith-assert-upper      28
;  :arith-conflicts         13
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         13
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             433
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              65
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            125277)
(set-option :timeout 10)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $t@29@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               392
;  :arith-assert-diseq      8
;  :arith-assert-lower      25
;  :arith-assert-upper      28
;  :arith-conflicts         13
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         13
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 49
;  :datatype-occurs-check   39
;  :datatype-splits         27
;  :decisions               47
;  :del-clause              17
;  :final-checks            20
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             434
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              66
;  :propagations            16
;  :quant-instantiations    21
;  :rlimit-count            125367)
(push) ; 3
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-assert-diseq      8
;  :arith-assert-lower      25
;  :arith-assert-upper      28
;  :arith-conflicts         13
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         13
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 63
;  :datatype-occurs-check   47
;  :datatype-splits         37
;  :decisions               60
;  :del-clause              17
;  :final-checks            23
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             443
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              67
;  :propagations            17
;  :quant-instantiations    21
;  :rlimit-count            125898)
; [eval] !diz.ALU_init
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $t@29@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-assert-diseq      8
;  :arith-assert-lower      25
;  :arith-assert-upper      28
;  :arith-conflicts         13
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         13
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 63
;  :datatype-occurs-check   47
;  :datatype-splits         37
;  :decisions               60
;  :del-clause              17
;  :final-checks            23
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             444
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              68
;  :propagations            17
;  :quant-instantiations    21
;  :rlimit-count            125988)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $t@29@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               433
;  :arith-assert-diseq      8
;  :arith-assert-lower      25
;  :arith-assert-upper      28
;  :arith-conflicts         13
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         13
;  :binary-propagations     7
;  :conflicts               40
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 63
;  :datatype-occurs-check   47
;  :datatype-splits         37
;  :decisions               60
;  :del-clause              17
;  :final-checks            23
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             445
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              69
;  :propagations            17
;  :quant-instantiations    21
;  :rlimit-count            126078)
(declare-const $t@32@08 $Snap)
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
(declare-const i@33@08 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 4 | 0 <= i@33@08 | live]
; [else-branch: 4 | !(0 <= i@33@08) | live]
(push) ; 5
; [then-branch: 4 | 0 <= i@33@08]
(assert (<= 0 i@33@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 4 | !(0 <= i@33@08)]
(assert (not (<= 0 i@33@08)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 5 | i@33@08 < |First:(Second:(Second:(Second:($t@26@08))))| && 0 <= i@33@08 | live]
; [else-branch: 5 | !(i@33@08 < |First:(Second:(Second:(Second:($t@26@08))))| && 0 <= i@33@08) | live]
(push) ; 5
; [then-branch: 5 | i@33@08 < |First:(Second:(Second:(Second:($t@26@08))))| && 0 <= i@33@08]
(assert (and
  (<
    i@33@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
  (<= 0 i@33@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@33@08 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               475
;  :arith-assert-diseq      8
;  :arith-assert-lower      26
;  :arith-assert-upper      29
;  :arith-conflicts         13
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         14
;  :binary-propagations     7
;  :conflicts               40
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              19
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             456
;  :mk-clause               21
;  :num-allocs              3625418
;  :num-checks              71
;  :propagations            18
;  :quant-instantiations    21
;  :rlimit-count            126733)
; [eval] -1
(push) ; 6
; [then-branch: 6 | First:(Second:(Second:(Second:($t@26@08))))[i@33@08] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@26@08))))[i@33@08] != -1 | live]
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@26@08))))[i@33@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
    i@33@08)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 6 | First:(Second:(Second:(Second:($t@26@08))))[i@33@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
      i@33@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@33@08 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               477
;  :arith-assert-diseq      10
;  :arith-assert-lower      29
;  :arith-assert-upper      30
;  :arith-conflicts         13
;  :arith-eq-adapter        13
;  :arith-fixed-eqs         14
;  :binary-propagations     7
;  :conflicts               40
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              19
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             463
;  :mk-clause               31
;  :num-allocs              3625418
;  :num-checks              72
;  :propagations            23
;  :quant-instantiations    22
;  :rlimit-count            126969)
(push) ; 8
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@26@08))))[i@33@08] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@26@08))))[i@33@08]) | live]
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@26@08))))[i@33@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
    i@33@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@33@08 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-assert-diseq      10
;  :arith-assert-lower      31
;  :arith-assert-upper      31
;  :arith-conflicts         13
;  :arith-eq-adapter        14
;  :arith-fixed-eqs         15
;  :arith-pivots            1
;  :binary-propagations     7
;  :conflicts               40
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              19
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             467
;  :mk-clause               31
;  :num-allocs              3625418
;  :num-checks              73
;  :propagations            23
;  :quant-instantiations    22
;  :rlimit-count            127106)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@26@08))))[i@33@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
      i@33@08))))
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
; [else-branch: 5 | !(i@33@08 < |First:(Second:(Second:(Second:($t@26@08))))| && 0 <= i@33@08)]
(assert (not
  (and
    (<
      i@33@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
    (<= 0 i@33@08))))
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
(assert (not (forall ((i@33@08 Int)) (!
  (implies
    (and
      (<
        i@33@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
      (<= 0 i@33@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
          i@33@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
            i@33@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
            i@33@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
    i@33@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-assert-diseq      12
;  :arith-assert-lower      32
;  :arith-assert-upper      32
;  :arith-conflicts         13
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         16
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               41
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             475
;  :mk-clause               45
;  :num-allocs              3625418
;  :num-checks              74
;  :propagations            25
;  :quant-instantiations    23
;  :rlimit-count            127555)
(assert (forall ((i@33@08 Int)) (!
  (implies
    (and
      (<
        i@33@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))
      (<= 0 i@33@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
          i@33@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
            i@33@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
            i@33@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))
    i@33@08))
  :qid |prog.l<no position>|)))
(declare-const $k@34@08 $Perm)
(assert ($Perm.isReadVar $k@34@08 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@34@08 $Perm.No) (< $Perm.No $k@34@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-assert-diseq      13
;  :arith-assert-lower      34
;  :arith-assert-upper      33
;  :arith-conflicts         13
;  :arith-eq-adapter        16
;  :arith-fixed-eqs         16
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               42
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             480
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              75
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128116)
(set-option :timeout 10)
(push) ; 3
(assert (not (not (= (- (+ $k@20@08 $k@28@08) $k@31@08) $Perm.No))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-assert-diseq      13
;  :arith-assert-lower      34
;  :arith-assert-upper      33
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             481
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              76
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128190)
(assert (< $k@34@08 (- (+ $k@20@08 $k@28@08) $k@31@08)))
(assert (<= $Perm.No (- (- (+ $k@20@08 $k@28@08) $k@31@08) $k@34@08)))
(assert (<= (- (- (+ $k@20@08 $k@28@08) $k@31@08) $k@34@08) $Perm.Write))
(assert (implies
  (< $Perm.No (- (- (+ $k@20@08 $k@28@08) $k@31@08) $k@34@08))
  (not (= diz@17@08 $Ref.null))))
; [eval] diz.Main_alu != null
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              77
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128445)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              78
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128466)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              79
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128487)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              80
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128508)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              81
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128529)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              82
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128550)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              83
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128571)
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              84
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128592)
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              85
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128613)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              86
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128626)
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (- (+ $k@20@08 $k@28@08) $k@31@08))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             484
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              87
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128647)
(push) ; 3
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@19@08))) $t@29@08)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               479
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 77
;  :datatype-occurs-check   55
;  :datatype-splits         47
;  :decisions               73
;  :del-clause              43
;  :final-checks            26
;  :max-generation          2
;  :max-memory              3.96
;  :memory                  3.94
;  :mk-bool-var             485
;  :mk-clause               47
;  :num-allocs              3625418
;  :num-checks              88
;  :propagations            26
;  :quant-instantiations    23
;  :rlimit-count            128737)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@26@08))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($SortWrappers.$RefTo$Snap $t@29@08)
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08)))))))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@26@08))))))))))))))))
                                ($Snap.combine
                                  $Snap.unit
                                  ($Snap.combine
                                    $Snap.unit
                                    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@19@08)))))))))))))))))))))))) diz@17@08 globals@18@08))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const min_advance__73@35@08 Int)
(declare-const __flatten_50__72@36@08 Seq<Int>)
(declare-const __flatten_49__71@37@08 Seq<Int>)
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
; (:added-eqs               660
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      36
;  :arith-assert-upper      34
;  :arith-conflicts         13
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         16
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    66
;  :datatype-constructor-ax 119
;  :datatype-occurs-check   73
;  :datatype-splits         77
;  :decisions               112
;  :del-clause              43
;  :final-checks            35
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             513
;  :mk-clause               47
;  :num-allocs              3758316
;  :num-checks              91
;  :propagations            29
;  :quant-instantiations    23
;  :rlimit-count            131086)
; [then-branch: 8 | True | live]
; [else-branch: 8 | False | dead]
(push) ; 5
; [then-branch: 8 | True]
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@38@08 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
(assert (= $t@38@08 ($Snap.combine ($Snap.first $t@38@08) ($Snap.second $t@38@08))))
(assert (= ($Snap.first $t@38@08) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@38@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@38@08))
    ($Snap.second ($Snap.second $t@38@08)))))
(assert (= ($Snap.first ($Snap.second $t@38@08)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@38@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@38@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@38@08))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@38@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@39@08 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 9 | 0 <= i@39@08 | live]
; [else-branch: 9 | !(0 <= i@39@08) | live]
(push) ; 8
; [then-branch: 9 | 0 <= i@39@08]
(assert (<= 0 i@39@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 9 | !(0 <= i@39@08)]
(assert (not (<= 0 i@39@08)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 10 | i@39@08 < |First:(Second:(Second:(Second:($t@38@08))))| && 0 <= i@39@08 | live]
; [else-branch: 10 | !(i@39@08 < |First:(Second:(Second:(Second:($t@38@08))))| && 0 <= i@39@08) | live]
(push) ; 8
; [then-branch: 10 | i@39@08 < |First:(Second:(Second:(Second:($t@38@08))))| && 0 <= i@39@08]
(assert (and
  (<
    i@39@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
  (<= 0 i@39@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@39@08 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               752
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      37
;  :arith-conflicts         13
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              43
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             548
;  :mk-clause               47
;  :num-allocs              3758316
;  :num-checks              93
;  :propagations            30
;  :quant-instantiations    27
;  :rlimit-count            132923)
; [eval] -1
(push) ; 9
; [then-branch: 11 | First:(Second:(Second:(Second:($t@38@08))))[i@39@08] == -1 | live]
; [else-branch: 11 | First:(Second:(Second:(Second:($t@38@08))))[i@39@08] != -1 | live]
(push) ; 10
; [then-branch: 11 | First:(Second:(Second:(Second:($t@38@08))))[i@39@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    i@39@08)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 11 | First:(Second:(Second:(Second:($t@38@08))))[i@39@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
      i@39@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@39@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               752
;  :arith-add-rows          2
;  :arith-assert-diseq      13
;  :arith-assert-lower      41
;  :arith-assert-upper      37
;  :arith-conflicts         13
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              43
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             549
;  :mk-clause               47
;  :num-allocs              3758316
;  :num-checks              94
;  :propagations            30
;  :quant-instantiations    27
;  :rlimit-count            133098)
(push) ; 11
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:($t@38@08))))[i@39@08] | live]
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:($t@38@08))))[i@39@08]) | live]
(push) ; 12
; [then-branch: 12 | 0 <= First:(Second:(Second:(Second:($t@38@08))))[i@39@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    i@39@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@39@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               752
;  :arith-add-rows          2
;  :arith-assert-diseq      14
;  :arith-assert-lower      44
;  :arith-assert-upper      37
;  :arith-conflicts         13
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    75
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              43
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             552
;  :mk-clause               48
;  :num-allocs              3758316
;  :num-checks              95
;  :propagations            30
;  :quant-instantiations    27
;  :rlimit-count            133222)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 12 | !(0 <= First:(Second:(Second:(Second:($t@38@08))))[i@39@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
      i@39@08))))
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
; [else-branch: 10 | !(i@39@08 < |First:(Second:(Second:(Second:($t@38@08))))| && 0 <= i@39@08)]
(assert (not
  (and
    (<
      i@39@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
    (<= 0 i@39@08))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@39@08 Int)) (!
  (implies
    (and
      (<
        i@39@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
      (<= 0 i@39@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
          i@39@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
            i@39@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
            i@39@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    i@39@08))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))
(declare-const $k@40@08 $Perm)
(assert ($Perm.isReadVar $k@40@08 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@40@08 $Perm.No) (< $Perm.No $k@40@08))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               757
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      38
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    76
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             558
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              96
;  :propagations            31
;  :quant-instantiations    27
;  :rlimit-count            133991)
(assert (<= $Perm.No $k@40@08))
(assert (<= $k@40@08 $Perm.Write))
(assert (implies (< $Perm.No $k@40@08) (not (= diz@17@08 $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))
  $Snap.unit))
; [eval] diz.Main_alu != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               763
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               46
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             561
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              97
;  :propagations            31
;  :quant-instantiations    27
;  :rlimit-count            134314)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               769
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    78
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             564
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              98
;  :propagations            31
;  :quant-instantiations    28
;  :rlimit-count            134670)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               774
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    79
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             565
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              99
;  :propagations            31
;  :quant-instantiations    28
;  :rlimit-count            134927)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               779
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               49
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             566
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              100
;  :propagations            31
;  :quant-instantiations    28
;  :rlimit-count            135194)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               784
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               50
;  :datatype-accessor-ax    81
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             567
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              101
;  :propagations            31
;  :quant-instantiations    28
;  :rlimit-count            135471)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               789
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    82
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             568
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              102
;  :propagations            31
;  :quant-instantiations    28
;  :rlimit-count            135758)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               794
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    83
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             569
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              103
;  :propagations            31
;  :quant-instantiations    28
;  :rlimit-count            136055)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))
  $Snap.unit))
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               800
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      46
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    84
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             571
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              104
;  :propagations            31
;  :quant-instantiations    28
;  :rlimit-count            136394)
(assert (<=
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))))
  $Snap.unit))
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               807
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      47
;  :arith-assert-upper      39
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             575
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              105
;  :propagations            31
;  :quant-instantiations    29
;  :rlimit-count            136842)
(assert (<=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))
  16))
(push) ; 6
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               807
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      47
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               55
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             576
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              106
;  :propagations            31
;  :quant-instantiations    29
;  :rlimit-count            137097)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               807
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      47
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        21
;  :arith-fixed-eqs         17
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               55
;  :datatype-accessor-ax    85
;  :datatype-constructor-ax 133
;  :datatype-occurs-check   79
;  :datatype-splits         87
;  :decisions               125
;  :del-clause              44
;  :final-checks            38
;  :max-generation          2
;  :max-memory              4.04
;  :memory                  4.04
;  :mk-bool-var             576
;  :mk-clause               50
;  :num-allocs              3758316
;  :num-checks              107
;  :propagations            31
;  :quant-instantiations    29
;  :rlimit-count            137110)
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@38@08 diz@17@08 globals@18@08))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz, globals), write)
(declare-const $t@41@08 $Snap)
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
(declare-const i@42@08 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 13 | 0 <= i@42@08 | live]
; [else-branch: 13 | !(0 <= i@42@08) | live]
(push) ; 8
; [then-branch: 13 | 0 <= i@42@08]
(assert (<= 0 i@42@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 13 | !(0 <= i@42@08)]
(assert (not (<= 0 i@42@08)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 14 | i@42@08 < |First:(Second:(Second:(Second:($t@38@08))))| && 0 <= i@42@08 | live]
; [else-branch: 14 | !(i@42@08 < |First:(Second:(Second:(Second:($t@38@08))))| && 0 <= i@42@08) | live]
(push) ; 8
; [then-branch: 14 | i@42@08 < |First:(Second:(Second:(Second:($t@38@08))))| && 0 <= i@42@08]
(assert (and
  (<
    i@42@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
  (<= 0 i@42@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@42@08 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1021
;  :arith-add-rows          2
;  :arith-assert-diseq      15
;  :arith-assert-lower      50
;  :arith-assert-upper      43
;  :arith-conflicts         13
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         20
;  :arith-pivots            7
;  :binary-propagations     7
;  :conflicts               56
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              48
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             629
;  :mk-clause               53
;  :num-allocs              3896955
;  :num-checks              110
;  :propagations            34
;  :quant-instantiations    29
;  :rlimit-count            138915)
; [eval] -1
(push) ; 9
; [then-branch: 15 | First:(Second:(Second:(Second:($t@38@08))))[i@42@08] == -1 | live]
; [else-branch: 15 | First:(Second:(Second:(Second:($t@38@08))))[i@42@08] != -1 | live]
(push) ; 10
; [then-branch: 15 | First:(Second:(Second:(Second:($t@38@08))))[i@42@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    i@42@08)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 15 | First:(Second:(Second:(Second:($t@38@08))))[i@42@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
      i@42@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@42@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1023
;  :arith-add-rows          2
;  :arith-assert-diseq      17
;  :arith-assert-lower      53
;  :arith-assert-upper      44
;  :arith-conflicts         13
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         20
;  :arith-pivots            7
;  :binary-propagations     7
;  :conflicts               56
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              48
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             636
;  :mk-clause               63
;  :num-allocs              3896955
;  :num-checks              111
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            139145)
(push) ; 11
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@38@08))))[i@42@08] | live]
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@38@08))))[i@42@08]) | live]
(push) ; 12
; [then-branch: 16 | 0 <= First:(Second:(Second:(Second:($t@38@08))))[i@42@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    i@42@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@42@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1025
;  :arith-add-rows          2
;  :arith-assert-diseq      17
;  :arith-assert-lower      55
;  :arith-assert-upper      45
;  :arith-conflicts         13
;  :arith-eq-adapter        25
;  :arith-fixed-eqs         21
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               56
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              48
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             640
;  :mk-clause               63
;  :num-allocs              3896955
;  :num-checks              112
;  :propagations            39
;  :quant-instantiations    30
;  :rlimit-count            139280)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 16 | !(0 <= First:(Second:(Second:(Second:($t@38@08))))[i@42@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
      i@42@08))))
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
; [else-branch: 14 | !(i@42@08 < |First:(Second:(Second:(Second:($t@38@08))))| && 0 <= i@42@08)]
(assert (not
  (and
    (<
      i@42@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
    (<= 0 i@42@08))))
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
(assert (not (forall ((i@42@08 Int)) (!
  (implies
    (and
      (<
        i@42@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
      (<= 0 i@42@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
          i@42@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
            i@42@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
            i@42@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    i@42@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1025
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      56
;  :arith-assert-upper      46
;  :arith-conflicts         13
;  :arith-eq-adapter        26
;  :arith-fixed-eqs         22
;  :arith-pivots            9
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    89
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              72
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             648
;  :mk-clause               77
;  :num-allocs              3896955
;  :num-checks              113
;  :propagations            41
;  :quant-instantiations    31
;  :rlimit-count            139729)
(assert (forall ((i@42@08 Int)) (!
  (implies
    (and
      (<
        i@42@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
      (<= 0 i@42@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
          i@42@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
            i@42@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
            i@42@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    i@42@08))
  :qid |prog.l<no position>|)))
(declare-const $t@43@08 $Snap)
(assert (= $t@43@08 ($Snap.combine ($Snap.first $t@43@08) ($Snap.second $t@43@08))))
(assert (=
  ($Snap.second $t@43@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@43@08))
    ($Snap.second ($Snap.second $t@43@08)))))
(assert (=
  ($Snap.second ($Snap.second $t@43@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@43@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@43@08))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@43@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@44@08 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 17 | 0 <= i@44@08 | live]
; [else-branch: 17 | !(0 <= i@44@08) | live]
(push) ; 8
; [then-branch: 17 | 0 <= i@44@08]
(assert (<= 0 i@44@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 17 | !(0 <= i@44@08)]
(assert (not (<= 0 i@44@08)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 18 | i@44@08 < |First:(Second:($t@43@08))| && 0 <= i@44@08 | live]
; [else-branch: 18 | !(i@44@08 < |First:(Second:($t@43@08))| && 0 <= i@44@08) | live]
(push) ; 8
; [then-branch: 18 | i@44@08 < |First:(Second:($t@43@08))| && 0 <= i@44@08]
(assert (and
  (<
    i@44@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))
  (<= 0 i@44@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@44@08 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1063
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      61
;  :arith-assert-upper      49
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         23
;  :arith-pivots            9
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              72
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             670
;  :mk-clause               77
;  :num-allocs              3896955
;  :num-checks              114
;  :propagations            41
;  :quant-instantiations    35
;  :rlimit-count            141161)
; [eval] -1
(push) ; 9
; [then-branch: 19 | First:(Second:($t@43@08))[i@44@08] == -1 | live]
; [else-branch: 19 | First:(Second:($t@43@08))[i@44@08] != -1 | live]
(push) ; 10
; [then-branch: 19 | First:(Second:($t@43@08))[i@44@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
    i@44@08)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 19 | First:(Second:($t@43@08))[i@44@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
      i@44@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@44@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1063
;  :arith-add-rows          2
;  :arith-assert-diseq      19
;  :arith-assert-lower      61
;  :arith-assert-upper      49
;  :arith-conflicts         13
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         23
;  :arith-pivots            9
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              72
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             671
;  :mk-clause               77
;  :num-allocs              3896955
;  :num-checks              115
;  :propagations            41
;  :quant-instantiations    35
;  :rlimit-count            141312)
(push) ; 11
; [then-branch: 20 | 0 <= First:(Second:($t@43@08))[i@44@08] | live]
; [else-branch: 20 | !(0 <= First:(Second:($t@43@08))[i@44@08]) | live]
(push) ; 12
; [then-branch: 20 | 0 <= First:(Second:($t@43@08))[i@44@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
    i@44@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@44@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1063
;  :arith-add-rows          2
;  :arith-assert-diseq      20
;  :arith-assert-lower      64
;  :arith-assert-upper      49
;  :arith-conflicts         13
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         23
;  :arith-pivots            9
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    95
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              72
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             674
;  :mk-clause               78
;  :num-allocs              3896955
;  :num-checks              116
;  :propagations            41
;  :quant-instantiations    35
;  :rlimit-count            141416)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 20 | !(0 <= First:(Second:($t@43@08))[i@44@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
      i@44@08))))
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
; [else-branch: 18 | !(i@44@08 < |First:(Second:($t@43@08))| && 0 <= i@44@08)]
(assert (not
  (and
    (<
      i@44@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))
    (<= 0 i@44@08))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@44@08 Int)) (!
  (implies
    (and
      (<
        i@44@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))
      (<= 0 i@44@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
          i@44@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
            i@44@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
            i@44@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
    i@44@08))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1081
;  :arith-add-rows          2
;  :arith-assert-diseq      20
;  :arith-assert-lower      65
;  :arith-assert-upper      50
;  :arith-conflicts         13
;  :arith-eq-adapter        30
;  :arith-fixed-eqs         24
;  :arith-pivots            9
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              73
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             694
;  :mk-clause               88
;  :num-allocs              3896955
;  :num-checks              117
;  :propagations            45
;  :quant-instantiations    37
;  :rlimit-count            142489)
(push) ; 6
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:($t@38@08))))[0] | live]
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:($t@38@08))))[0]) | live]
(push) ; 7
; [then-branch: 21 | 0 <= First:(Second:(Second:(Second:($t@38@08))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1081
;  :arith-add-rows          2
;  :arith-assert-diseq      20
;  :arith-assert-lower      66
;  :arith-assert-upper      50
;  :arith-conflicts         13
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         24
;  :arith-pivots            9
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              73
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             700
;  :mk-clause               95
;  :num-allocs              3896955
;  :num-checks              118
;  :propagations            45
;  :quant-instantiations    39
;  :rlimit-count            142667)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1081
;  :arith-add-rows          2
;  :arith-assert-diseq      20
;  :arith-assert-lower      66
;  :arith-assert-upper      50
;  :arith-conflicts         13
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         24
;  :arith-pivots            9
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              73
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             700
;  :mk-clause               95
;  :num-allocs              3896955
;  :num-checks              119
;  :propagations            45
;  :quant-instantiations    39
;  :rlimit-count            142676)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1082
;  :arith-add-rows          2
;  :arith-assert-diseq      20
;  :arith-assert-lower      67
;  :arith-assert-upper      51
;  :arith-conflicts         14
;  :arith-eq-adapter        31
;  :arith-fixed-eqs         24
;  :arith-pivots            9
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    97
;  :datatype-constructor-ax 193
;  :datatype-occurs-check   95
;  :datatype-splits         131
;  :decisions               181
;  :del-clause              73
;  :final-checks            44
;  :max-generation          2
;  :max-memory              4.14
;  :memory                  4.14
;  :mk-bool-var             700
;  :mk-clause               95
;  :num-allocs              3896955
;  :num-checks              120
;  :propagations            49
;  :quant-instantiations    39
;  :rlimit-count            142794)
(pop) ; 7
(push) ; 7
; [else-branch: 21 | !(0 <= First:(Second:(Second:(Second:($t@38@08))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1200
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      79
;  :arith-assert-upper      58
;  :arith-conflicts         14
;  :arith-eq-adapter        38
;  :arith-fixed-eqs         26
;  :arith-offset-eqs        1
;  :arith-pivots            15
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    99
;  :datatype-constructor-ax 222
;  :datatype-occurs-check   106
;  :datatype-splits         156
;  :decisions               209
;  :del-clause              98
;  :final-checks            48
;  :interface-eqs           1
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             755
;  :mk-clause               113
;  :num-allocs              4039296
;  :num-checks              121
;  :propagations            59
;  :quant-instantiations    44
;  :rlimit-count            144116
;  :time                    0.00)
(push) ; 7
(assert (not (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1307
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      81
;  :arith-assert-upper      61
;  :arith-conflicts         14
;  :arith-eq-adapter        40
;  :arith-fixed-eqs         27
;  :arith-offset-eqs        1
;  :arith-pivots            17
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   117
;  :datatype-splits         180
;  :decisions               237
;  :del-clause              105
;  :final-checks            52
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             789
;  :mk-clause               120
;  :num-allocs              4039296
;  :num-checks              122
;  :propagations            64
;  :quant-instantiations    46
;  :rlimit-count            145231)
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:(Second:($t@38@08))))))[First:(Second:(Second:(Second:($t@38@08))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@38@08))))[0] | live]
; [else-branch: 22 | !(First:(Second:(Second:(Second:(Second:(Second:($t@38@08))))))[First:(Second:(Second:(Second:($t@38@08))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@38@08))))[0]) | live]
(push) ; 7
; [then-branch: 22 | First:(Second:(Second:(Second:(Second:(Second:($t@38@08))))))[First:(Second:(Second:(Second:($t@38@08))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@38@08))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1308
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      82
;  :arith-assert-upper      61
;  :arith-conflicts         14
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         27
;  :arith-offset-eqs        1
;  :arith-pivots            17
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   117
;  :datatype-splits         180
;  :decisions               237
;  :del-clause              105
;  :final-checks            52
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             796
;  :mk-clause               127
;  :num-allocs              4039296
;  :num-checks              123
;  :propagations            64
;  :quant-instantiations    48
;  :rlimit-count            145448)
; [eval] -1
(pop) ; 7
(push) ; 7
; [else-branch: 22 | !(First:(Second:(Second:(Second:(Second:(Second:($t@38@08))))))[First:(Second:(Second:(Second:($t@38@08))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@38@08))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
        0)))))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@43@08))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1309
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      82
;  :arith-assert-upper      61
;  :arith-conflicts         14
;  :arith-eq-adapter        41
;  :arith-fixed-eqs         27
;  :arith-offset-eqs        1
;  :arith-pivots            17
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   117
;  :datatype-splits         180
;  :decisions               237
;  :del-clause              112
;  :final-checks            52
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             800
;  :mk-clause               128
;  :num-allocs              4039296
;  :num-checks              124
;  :propagations            64
;  :quant-instantiations    48
;  :rlimit-count            145856)
(push) ; 6
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@38@08))))[0] | live]
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@38@08))))[0]) | live]
(push) ; 7
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@38@08))))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1309
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      83
;  :arith-assert-upper      61
;  :arith-conflicts         14
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         27
;  :arith-offset-eqs        1
;  :arith-pivots            17
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   117
;  :datatype-splits         180
;  :decisions               237
;  :del-clause              112
;  :final-checks            52
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             805
;  :mk-clause               135
;  :num-allocs              4039296
;  :num-checks              125
;  :propagations            64
;  :quant-instantiations    50
;  :rlimit-count            145986)
(push) ; 8
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1309
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      83
;  :arith-assert-upper      61
;  :arith-conflicts         14
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         27
;  :arith-offset-eqs        1
;  :arith-pivots            17
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   117
;  :datatype-splits         180
;  :decisions               237
;  :del-clause              112
;  :final-checks            52
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             805
;  :mk-clause               135
;  :num-allocs              4039296
;  :num-checks              126
;  :propagations            64
;  :quant-instantiations    50
;  :rlimit-count            145995)
(push) ; 8
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
    0)
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1310
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      84
;  :arith-assert-upper      62
;  :arith-conflicts         15
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         27
;  :arith-offset-eqs        1
;  :arith-pivots            17
;  :binary-propagations     7
;  :conflicts               59
;  :datatype-accessor-ax    101
;  :datatype-constructor-ax 250
;  :datatype-occurs-check   117
;  :datatype-splits         180
;  :decisions               237
;  :del-clause              112
;  :final-checks            52
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             805
;  :mk-clause               135
;  :num-allocs              4039296
;  :num-checks              127
;  :propagations            68
;  :quant-instantiations    50
;  :rlimit-count            146113)
(pop) ; 7
(push) ; 7
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@38@08))))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
      0)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1418
;  :arith-add-rows          2
;  :arith-assert-diseq      23
;  :arith-assert-lower      86
;  :arith-assert-upper      65
;  :arith-conflicts         15
;  :arith-eq-adapter        44
;  :arith-fixed-eqs         28
;  :arith-offset-eqs        1
;  :arith-pivots            19
;  :binary-propagations     7
;  :conflicts               59
;  :datatype-accessor-ax    103
;  :datatype-constructor-ax 278
;  :datatype-occurs-check   130
;  :datatype-splits         204
;  :decisions               264
;  :del-clause              123
;  :final-checks            55
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             837
;  :mk-clause               139
;  :num-allocs              4039296
;  :num-checks              128
;  :propagations            71
;  :quant-instantiations    52
;  :rlimit-count            147238
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
        0))))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1589
;  :arith-add-rows          2
;  :arith-assert-diseq      25
;  :arith-assert-lower      95
;  :arith-assert-upper      70
;  :arith-conflicts         15
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        1
;  :arith-pivots            25
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 321
;  :datatype-occurs-check   147
;  :datatype-splits         232
;  :decisions               303
;  :del-clause              136
;  :final-checks            59
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             898
;  :mk-clause               152
;  :num-allocs              4039296
;  :num-checks              129
;  :propagations            78
;  :quant-instantiations    56
;  :rlimit-count            148665
;  :time                    0.00)
; [then-branch: 24 | !(First:(Second:(Second:(Second:(Second:(Second:($t@38@08))))))[First:(Second:(Second:(Second:($t@38@08))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@38@08))))[0]) | live]
; [else-branch: 24 | First:(Second:(Second:(Second:(Second:(Second:($t@38@08))))))[First:(Second:(Second:(Second:($t@38@08))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@38@08))))[0] | live]
(push) ; 7
; [then-branch: 24 | !(First:(Second:(Second:(Second:(Second:(Second:($t@38@08))))))[First:(Second:(Second:(Second:($t@38@08))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@38@08))))[0])]
(assert (not
  (and
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
          0))
      0)
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1589
;  :arith-add-rows          2
;  :arith-assert-diseq      25
;  :arith-assert-lower      95
;  :arith-assert-upper      70
;  :arith-conflicts         15
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        1
;  :arith-pivots            25
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 321
;  :datatype-occurs-check   147
;  :datatype-splits         232
;  :decisions               303
;  :del-clause              136
;  :final-checks            59
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             898
;  :mk-clause               153
;  :num-allocs              4039296
;  :num-checks              130
;  :propagations            78
;  :quant-instantiations    56
;  :rlimit-count            148864)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1589
;  :arith-add-rows          2
;  :arith-assert-diseq      25
;  :arith-assert-lower      95
;  :arith-assert-upper      70
;  :arith-conflicts         15
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         31
;  :arith-offset-eqs        1
;  :arith-pivots            25
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 321
;  :datatype-occurs-check   147
;  :datatype-splits         232
;  :decisions               303
;  :del-clause              136
;  :final-checks            59
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             898
;  :mk-clause               153
;  :num-allocs              4039296
;  :num-checks              131
;  :propagations            78
;  :quant-instantiations    56
;  :rlimit-count            148879)
(pop) ; 7
(push) ; 7
; [else-branch: 24 | First:(Second:(Second:(Second:(Second:(Second:($t@38@08))))))[First:(Second:(Second:(Second:($t@38@08))))[0]] == 0 && 0 <= First:(Second:(Second:(Second:($t@38@08))))[0]]
(assert (and
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
        0))
    0)
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
            0))
        0)
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))
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
(declare-const i@45@08 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 25 | 0 <= i@45@08 | live]
; [else-branch: 25 | !(0 <= i@45@08) | live]
(push) ; 8
; [then-branch: 25 | 0 <= i@45@08]
(assert (<= 0 i@45@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 25 | !(0 <= i@45@08)]
(assert (not (<= 0 i@45@08)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 26 | i@45@08 < |First:(Second:($t@43@08))| && 0 <= i@45@08 | live]
; [else-branch: 26 | !(i@45@08 < |First:(Second:($t@43@08))| && 0 <= i@45@08) | live]
(push) ; 8
; [then-branch: 26 | i@45@08 < |First:(Second:($t@43@08))| && 0 <= i@45@08]
(assert (and
  (<
    i@45@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))
  (<= 0 i@45@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@45@08 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1702
;  :arith-add-rows          2
;  :arith-assert-diseq      25
;  :arith-assert-lower      99
;  :arith-assert-upper      75
;  :arith-bound-prop        2
;  :arith-conflicts         15
;  :arith-eq-adapter        52
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 349
;  :datatype-occurs-check   160
;  :datatype-splits         256
;  :decisions               330
;  :del-clause              156
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             944
;  :mk-clause               170
;  :num-allocs              4039296
;  :num-checks              133
;  :propagations            84
;  :quant-instantiations    59
;  :rlimit-count            150268)
; [eval] -1
(push) ; 9
; [then-branch: 27 | First:(Second:($t@43@08))[i@45@08] == -1 | live]
; [else-branch: 27 | First:(Second:($t@43@08))[i@45@08] != -1 | live]
(push) ; 10
; [then-branch: 27 | First:(Second:($t@43@08))[i@45@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
    i@45@08)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 27 | First:(Second:($t@43@08))[i@45@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
      i@45@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@45@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1704
;  :arith-add-rows          2
;  :arith-assert-diseq      27
;  :arith-assert-lower      102
;  :arith-assert-upper      76
;  :arith-bound-prop        2
;  :arith-conflicts         15
;  :arith-eq-adapter        53
;  :arith-fixed-eqs         34
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 349
;  :datatype-occurs-check   160
;  :datatype-splits         256
;  :decisions               330
;  :del-clause              156
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             948
;  :mk-clause               178
;  :num-allocs              4039296
;  :num-checks              134
;  :propagations            88
;  :quant-instantiations    60
;  :rlimit-count            150436)
(push) ; 11
; [then-branch: 28 | 0 <= First:(Second:($t@43@08))[i@45@08] | live]
; [else-branch: 28 | !(0 <= First:(Second:($t@43@08))[i@45@08]) | live]
(push) ; 12
; [then-branch: 28 | 0 <= First:(Second:($t@43@08))[i@45@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
    i@45@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@45@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1706
;  :arith-add-rows          2
;  :arith-assert-diseq      27
;  :arith-assert-lower      104
;  :arith-assert-upper      77
;  :arith-bound-prop        2
;  :arith-conflicts         15
;  :arith-eq-adapter        54
;  :arith-fixed-eqs         35
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 349
;  :datatype-occurs-check   160
;  :datatype-splits         256
;  :decisions               330
;  :del-clause              156
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             952
;  :mk-clause               178
;  :num-allocs              4039296
;  :num-checks              135
;  :propagations            88
;  :quant-instantiations    60
;  :rlimit-count            150547)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 28 | !(0 <= First:(Second:($t@43@08))[i@45@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
      i@45@08))))
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
; [else-branch: 26 | !(i@45@08 < |First:(Second:($t@43@08))| && 0 <= i@45@08)]
(assert (not
  (and
    (<
      i@45@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))
    (<= 0 i@45@08))))
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
(assert (not (forall ((i@45@08 Int)) (!
  (implies
    (and
      (<
        i@45@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))
      (<= 0 i@45@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
          i@45@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
            i@45@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
            i@45@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
    i@45@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1706
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      105
;  :arith-assert-upper      78
;  :arith-bound-prop        2
;  :arith-conflicts         15
;  :arith-eq-adapter        55
;  :arith-fixed-eqs         36
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 349
;  :datatype-occurs-check   160
;  :datatype-splits         256
;  :decisions               330
;  :del-clause              176
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             960
;  :mk-clause               190
;  :num-allocs              4039296
;  :num-checks              136
;  :propagations            90
;  :quant-instantiations    61
;  :rlimit-count            150969)
(assert (forall ((i@45@08 Int)) (!
  (implies
    (and
      (<
        i@45@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))
      (<= 0 i@45@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
          i@45@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
            i@45@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
            i@45@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))
    i@45@08))
  :qid |prog.l<no position>|)))
(declare-const $t@46@08 $Snap)
(assert (= $t@46@08 ($Snap.combine ($Snap.first $t@46@08) ($Snap.second $t@46@08))))
(assert (=
  ($Snap.second $t@46@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@46@08))
    ($Snap.second ($Snap.second $t@46@08)))))
(assert (=
  ($Snap.second ($Snap.second $t@46@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@46@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@46@08))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@46@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@47@08 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 29 | 0 <= i@47@08 | live]
; [else-branch: 29 | !(0 <= i@47@08) | live]
(push) ; 8
; [then-branch: 29 | 0 <= i@47@08]
(assert (<= 0 i@47@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 29 | !(0 <= i@47@08)]
(assert (not (<= 0 i@47@08)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 30 | i@47@08 < |First:(Second:($t@46@08))| && 0 <= i@47@08 | live]
; [else-branch: 30 | !(i@47@08 < |First:(Second:($t@46@08))| && 0 <= i@47@08) | live]
(push) ; 8
; [then-branch: 30 | i@47@08 < |First:(Second:($t@46@08))| && 0 <= i@47@08]
(assert (and
  (<
    i@47@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
  (<= 0 i@47@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 9
(assert (not (>= i@47@08 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1744
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      110
;  :arith-assert-upper      81
;  :arith-bound-prop        2
;  :arith-conflicts         15
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         37
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 349
;  :datatype-occurs-check   160
;  :datatype-splits         256
;  :decisions               330
;  :del-clause              176
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             982
;  :mk-clause               190
;  :num-allocs              4039296
;  :num-checks              137
;  :propagations            90
;  :quant-instantiations    65
;  :rlimit-count            152360)
; [eval] -1
(push) ; 9
; [then-branch: 31 | First:(Second:($t@46@08))[i@47@08] == -1 | live]
; [else-branch: 31 | First:(Second:($t@46@08))[i@47@08] != -1 | live]
(push) ; 10
; [then-branch: 31 | First:(Second:($t@46@08))[i@47@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@47@08)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 31 | First:(Second:($t@46@08))[i@47@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      i@47@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@47@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1744
;  :arith-add-rows          2
;  :arith-assert-diseq      28
;  :arith-assert-lower      110
;  :arith-assert-upper      81
;  :arith-bound-prop        2
;  :arith-conflicts         15
;  :arith-eq-adapter        57
;  :arith-fixed-eqs         37
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 349
;  :datatype-occurs-check   160
;  :datatype-splits         256
;  :decisions               330
;  :del-clause              176
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             983
;  :mk-clause               190
;  :num-allocs              4039296
;  :num-checks              138
;  :propagations            90
;  :quant-instantiations    65
;  :rlimit-count            152511)
(push) ; 11
; [then-branch: 32 | 0 <= First:(Second:($t@46@08))[i@47@08] | live]
; [else-branch: 32 | !(0 <= First:(Second:($t@46@08))[i@47@08]) | live]
(push) ; 12
; [then-branch: 32 | 0 <= First:(Second:($t@46@08))[i@47@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@47@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@47@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1744
;  :arith-add-rows          2
;  :arith-assert-diseq      29
;  :arith-assert-lower      113
;  :arith-assert-upper      81
;  :arith-bound-prop        2
;  :arith-conflicts         15
;  :arith-eq-adapter        58
;  :arith-fixed-eqs         37
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    115
;  :datatype-constructor-ax 349
;  :datatype-occurs-check   160
;  :datatype-splits         256
;  :decisions               330
;  :del-clause              176
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             986
;  :mk-clause               191
;  :num-allocs              4039296
;  :num-checks              139
;  :propagations            90
;  :quant-instantiations    65
;  :rlimit-count            152615)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 32 | !(0 <= First:(Second:($t@46@08))[i@47@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      i@47@08))))
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
; [else-branch: 30 | !(i@47@08 < |First:(Second:($t@46@08))| && 0 <= i@47@08)]
(assert (not
  (and
    (<
      i@47@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
    (<= 0 i@47@08))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@47@08 Int)) (!
  (implies
    (and
      (<
        i@47@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
      (<= 0 i@47@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          i@47@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@47@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@47@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@47@08))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@43@08)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[0]) == 0 ==> diz.Main_event_state[0] == -2
; [eval] old(diz.Main_event_state[0]) == 0
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 6
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1762
;  :arith-add-rows          2
;  :arith-assert-diseq      29
;  :arith-assert-lower      114
;  :arith-assert-upper      82
;  :arith-bound-prop        2
;  :arith-conflicts         15
;  :arith-eq-adapter        59
;  :arith-fixed-eqs         38
;  :arith-offset-eqs        1
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    117
;  :datatype-constructor-ax 349
;  :datatype-occurs-check   160
;  :datatype-splits         256
;  :decisions               330
;  :del-clause              177
;  :final-checks            62
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.24
;  :memory                  4.24
;  :mk-bool-var             1006
;  :mk-clause               201
;  :num-allocs              4039296
;  :num-checks              140
;  :propagations            94
;  :quant-instantiations    67
;  :rlimit-count            153630)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1966
;  :arith-add-rows          4
;  :arith-assert-diseq      29
;  :arith-assert-lower      119
;  :arith-assert-upper      88
;  :arith-bound-prop        4
;  :arith-conflicts         15
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         42
;  :arith-offset-eqs        1
;  :arith-pivots            36
;  :binary-propagations     7
;  :conflicts               63
;  :datatype-accessor-ax    120
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   175
;  :datatype-splits         285
;  :decisions               380
;  :del-clause              196
;  :final-checks            65
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1061
;  :mk-clause               220
;  :num-allocs              4188836
;  :num-checks              141
;  :propagations            105
;  :quant-instantiations    72
;  :rlimit-count            155223
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2169
;  :arith-add-rows          6
;  :arith-assert-diseq      29
;  :arith-assert-lower      124
;  :arith-assert-upper      94
;  :arith-bound-prop        6
;  :arith-conflicts         15
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        1
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 453
;  :datatype-occurs-check   190
;  :datatype-splits         314
;  :decisions               430
;  :del-clause              215
;  :final-checks            68
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1116
;  :mk-clause               239
;  :num-allocs              4188836
;  :num-checks              142
;  :propagations            116
;  :quant-instantiations    77
;  :rlimit-count            156791
;  :time                    0.00)
; [then-branch: 33 | First:(Second:(Second:(Second:($t@43@08))))[0] == 0 | live]
; [else-branch: 33 | First:(Second:(Second:(Second:($t@43@08))))[0] != 0 | live]
(push) ; 7
; [then-branch: 33 | First:(Second:(Second:(Second:($t@43@08))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
    0)
  0))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2170
;  :arith-add-rows          6
;  :arith-assert-diseq      29
;  :arith-assert-lower      124
;  :arith-assert-upper      94
;  :arith-bound-prop        6
;  :arith-conflicts         15
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        1
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 453
;  :datatype-occurs-check   190
;  :datatype-splits         314
;  :decisions               430
;  :del-clause              215
;  :final-checks            68
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1117
;  :mk-clause               239
;  :num-allocs              4188836
;  :num-checks              143
;  :propagations            116
;  :quant-instantiations    77
;  :rlimit-count            156919)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 33 | First:(Second:(Second:(Second:($t@43@08))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      0)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
  $Snap.unit))
; [eval] old(diz.Main_event_state[1]) == 0 ==> diz.Main_event_state[1] == -2
; [eval] old(diz.Main_event_state[1]) == 0
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 6
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2176
;  :arith-add-rows          6
;  :arith-assert-diseq      29
;  :arith-assert-lower      124
;  :arith-assert-upper      94
;  :arith-bound-prop        6
;  :arith-conflicts         15
;  :arith-eq-adapter        69
;  :arith-fixed-eqs         46
;  :arith-offset-eqs        1
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    124
;  :datatype-constructor-ax 453
;  :datatype-occurs-check   190
;  :datatype-splits         314
;  :decisions               430
;  :del-clause              215
;  :final-checks            68
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1121
;  :mk-clause               240
;  :num-allocs              4188836
;  :num-checks              144
;  :propagations            116
;  :quant-instantiations    77
;  :rlimit-count            157354)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2378
;  :arith-add-rows          8
;  :arith-assert-diseq      29
;  :arith-assert-lower      129
;  :arith-assert-upper      100
;  :arith-bound-prop        8
;  :arith-conflicts         15
;  :arith-eq-adapter        74
;  :arith-fixed-eqs         50
;  :arith-offset-eqs        1
;  :arith-pivots            48
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    127
;  :datatype-constructor-ax 505
;  :datatype-occurs-check   206
;  :datatype-splits         343
;  :decisions               481
;  :del-clause              234
;  :final-checks            71
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1176
;  :mk-clause               259
;  :num-allocs              4188836
;  :num-checks              145
;  :propagations            127
;  :quant-instantiations    82
;  :rlimit-count            158929
;  :time                    0.00)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          10
;  :arith-assert-diseq      29
;  :arith-assert-lower      134
;  :arith-assert-upper      106
;  :arith-bound-prop        10
;  :arith-conflicts         15
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        1
;  :arith-pivots            54
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 557
;  :datatype-occurs-check   222
;  :datatype-splits         372
;  :decisions               532
;  :del-clause              253
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1231
;  :mk-clause               278
;  :num-allocs              4188836
;  :num-checks              146
;  :propagations            138
;  :quant-instantiations    87
;  :rlimit-count            160513
;  :time                    0.00)
; [then-branch: 34 | First:(Second:(Second:(Second:($t@43@08))))[1] == 0 | live]
; [else-branch: 34 | First:(Second:(Second:(Second:($t@43@08))))[1] != 0 | live]
(push) ; 7
; [then-branch: 34 | First:(Second:(Second:(Second:($t@43@08))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
    1)
  0))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2580
;  :arith-add-rows          10
;  :arith-assert-diseq      29
;  :arith-assert-lower      134
;  :arith-assert-upper      106
;  :arith-bound-prop        10
;  :arith-conflicts         15
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        1
;  :arith-pivots            54
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 557
;  :datatype-occurs-check   222
;  :datatype-splits         372
;  :decisions               532
;  :del-clause              253
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1232
;  :mk-clause               278
;  :num-allocs              4188836
;  :num-checks              147
;  :propagations            138
;  :quant-instantiations    87
;  :rlimit-count            160641)
; [eval] -2
(pop) ; 7
(push) ; 7
; [else-branch: 34 | First:(Second:(Second:(Second:($t@43@08))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      1)
    0)))
(pop) ; 7
(pop) ; 6
; Joined path conditions
; Joined path conditions
(assert (implies
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2586
;  :arith-add-rows          10
;  :arith-assert-diseq      29
;  :arith-assert-lower      134
;  :arith-assert-upper      106
;  :arith-bound-prop        10
;  :arith-conflicts         15
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         54
;  :arith-offset-eqs        1
;  :arith-pivots            54
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    131
;  :datatype-constructor-ax 557
;  :datatype-occurs-check   222
;  :datatype-splits         372
;  :decisions               532
;  :del-clause              253
;  :final-checks            74
;  :interface-eqs           2
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1236
;  :mk-clause               279
;  :num-allocs              4188836
;  :num-checks              148
;  :propagations            138
;  :quant-instantiations    87
;  :rlimit-count            161082)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
    0)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2790
;  :arith-add-rows          12
;  :arith-assert-diseq      29
;  :arith-assert-lower      139
;  :arith-assert-upper      113
;  :arith-bound-prop        12
;  :arith-conflicts         15
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         56
;  :arith-offset-eqs        3
;  :arith-pivots            60
;  :binary-propagations     7
;  :conflicts               67
;  :datatype-accessor-ax    134
;  :datatype-constructor-ax 609
;  :datatype-occurs-check   238
;  :datatype-splits         401
;  :decisions               584
;  :del-clause              274
;  :final-checks            78
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1292
;  :mk-clause               300
;  :num-allocs              4188836
;  :num-checks              149
;  :propagations            150
;  :quant-instantiations    92
;  :rlimit-count            162670
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      0)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3005
;  :arith-add-rows          14
;  :arith-assert-diseq      29
;  :arith-assert-lower      144
;  :arith-assert-upper      119
;  :arith-bound-prop        14
;  :arith-conflicts         15
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         60
;  :arith-offset-eqs        3
;  :arith-pivots            66
;  :binary-propagations     7
;  :conflicts               69
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 664
;  :datatype-occurs-check   259
;  :datatype-splits         432
;  :decisions               637
;  :del-clause              294
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1358
;  :mk-clause               320
;  :num-allocs              4188836
;  :num-checks              150
;  :propagations            162
;  :quant-instantiations    97
;  :rlimit-count            164302
;  :time                    0.00)
; [then-branch: 35 | First:(Second:(Second:(Second:($t@43@08))))[0] != 0 | live]
; [else-branch: 35 | First:(Second:(Second:(Second:($t@43@08))))[0] == 0 | live]
(push) ; 7
; [then-branch: 35 | First:(Second:(Second:(Second:($t@43@08))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      0)
    0)))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3005
;  :arith-add-rows          14
;  :arith-assert-diseq      29
;  :arith-assert-lower      144
;  :arith-assert-upper      119
;  :arith-bound-prop        14
;  :arith-conflicts         15
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         60
;  :arith-offset-eqs        3
;  :arith-pivots            66
;  :binary-propagations     7
;  :conflicts               69
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 664
;  :datatype-occurs-check   259
;  :datatype-splits         432
;  :decisions               637
;  :del-clause              294
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1358
;  :mk-clause               320
;  :num-allocs              4188836
;  :num-checks              151
;  :propagations            162
;  :quant-instantiations    97
;  :rlimit-count            164432)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3005
;  :arith-add-rows          14
;  :arith-assert-diseq      29
;  :arith-assert-lower      144
;  :arith-assert-upper      119
;  :arith-bound-prop        14
;  :arith-conflicts         15
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         60
;  :arith-offset-eqs        3
;  :arith-pivots            66
;  :binary-propagations     7
;  :conflicts               69
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 664
;  :datatype-occurs-check   259
;  :datatype-splits         432
;  :decisions               637
;  :del-clause              294
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1358
;  :mk-clause               320
;  :num-allocs              4188836
;  :num-checks              152
;  :propagations            162
;  :quant-instantiations    97
;  :rlimit-count            164447)
(pop) ; 7
(push) ; 7
; [else-branch: 35 | First:(Second:(Second:(Second:($t@43@08))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
        0)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3010
;  :arith-add-rows          14
;  :arith-assert-diseq      29
;  :arith-assert-lower      144
;  :arith-assert-upper      119
;  :arith-bound-prop        14
;  :arith-conflicts         15
;  :arith-eq-adapter        90
;  :arith-fixed-eqs         60
;  :arith-offset-eqs        3
;  :arith-pivots            66
;  :binary-propagations     7
;  :conflicts               69
;  :datatype-accessor-ax    138
;  :datatype-constructor-ax 664
;  :datatype-occurs-check   259
;  :datatype-splits         432
;  :decisions               637
;  :del-clause              294
;  :final-checks            82
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1360
;  :mk-clause               321
;  :num-allocs              4188836
;  :num-checks              153
;  :propagations            162
;  :quant-instantiations    97
;  :rlimit-count            164767)
(push) ; 6
(set-option :timeout 10)
(push) ; 7
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
    1)
  0)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3209
;  :arith-add-rows          16
;  :arith-assert-diseq      29
;  :arith-assert-lower      149
;  :arith-assert-upper      125
;  :arith-bound-prop        16
;  :arith-conflicts         15
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         64
;  :arith-offset-eqs        3
;  :arith-pivots            72
;  :binary-propagations     7
;  :conflicts               70
;  :datatype-accessor-ax    141
;  :datatype-constructor-ax 715
;  :datatype-occurs-check   273
;  :datatype-splits         460
;  :decisions               687
;  :del-clause              313
;  :final-checks            85
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1413
;  :mk-clause               340
;  :num-allocs              4188836
;  :num-checks              154
;  :propagations            174
;  :quant-instantiations    102
;  :rlimit-count            166340
;  :time                    0.00)
(push) ; 7
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      1)
    0))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3421
;  :arith-add-rows          18
;  :arith-assert-diseq      29
;  :arith-assert-lower      154
;  :arith-assert-upper      131
;  :arith-bound-prop        18
;  :arith-conflicts         15
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            78
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    145
;  :datatype-constructor-ax 769
;  :datatype-occurs-check   291
;  :datatype-splits         490
;  :decisions               739
;  :del-clause              333
;  :final-checks            89
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1478
;  :mk-clause               360
;  :num-allocs              4188836
;  :num-checks              155
;  :propagations            187
;  :quant-instantiations    107
;  :rlimit-count            167963
;  :time                    0.00)
; [then-branch: 36 | First:(Second:(Second:(Second:($t@43@08))))[1] != 0 | live]
; [else-branch: 36 | First:(Second:(Second:(Second:($t@43@08))))[1] == 0 | live]
(push) ; 7
; [then-branch: 36 | First:(Second:(Second:(Second:($t@43@08))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
      1)
    0)))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3421
;  :arith-add-rows          18
;  :arith-assert-diseq      29
;  :arith-assert-lower      154
;  :arith-assert-upper      131
;  :arith-bound-prop        18
;  :arith-conflicts         15
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            78
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    145
;  :datatype-constructor-ax 769
;  :datatype-occurs-check   291
;  :datatype-splits         490
;  :decisions               739
;  :del-clause              333
;  :final-checks            89
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1478
;  :mk-clause               360
;  :num-allocs              4188836
;  :num-checks              156
;  :propagations            187
;  :quant-instantiations    107
;  :rlimit-count            168093)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3421
;  :arith-add-rows          18
;  :arith-assert-diseq      29
;  :arith-assert-lower      154
;  :arith-assert-upper      131
;  :arith-bound-prop        18
;  :arith-conflicts         15
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         68
;  :arith-offset-eqs        3
;  :arith-pivots            78
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    145
;  :datatype-constructor-ax 769
;  :datatype-occurs-check   291
;  :datatype-splits         490
;  :decisions               739
;  :del-clause              333
;  :final-checks            89
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1478
;  :mk-clause               360
;  :num-allocs              4188836
;  :num-checks              157
;  :propagations            187
;  :quant-instantiations    107
;  :rlimit-count            168108)
(pop) ; 7
(push) ; 7
; [else-branch: 36 | First:(Second:(Second:(Second:($t@43@08))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
        1)
      0))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@43@08)))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3621
;  :arith-add-rows          20
;  :arith-assert-diseq      29
;  :arith-assert-lower      159
;  :arith-assert-upper      137
;  :arith-bound-prop        20
;  :arith-conflicts         15
;  :arith-eq-adapter        106
;  :arith-fixed-eqs         72
;  :arith-offset-eqs        3
;  :arith-pivots            84
;  :binary-propagations     7
;  :conflicts               73
;  :datatype-accessor-ax    148
;  :datatype-constructor-ax 820
;  :datatype-occurs-check   305
;  :datatype-splits         518
;  :decisions               790
;  :del-clause              359
;  :final-checks            92
;  :interface-eqs           3
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1534
;  :mk-clause               381
;  :num-allocs              4188836
;  :num-checks              159
;  :propagations            200
;  :quant-instantiations    112
;  :rlimit-count            169801)
; [eval] -1
(set-option :timeout 10)
(push) ; 6
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3759
;  :arith-add-rows          24
;  :arith-assert-diseq      33
;  :arith-assert-lower      175
;  :arith-assert-upper      146
;  :arith-bound-prop        20
;  :arith-conflicts         15
;  :arith-eq-adapter        115
;  :arith-fixed-eqs         76
;  :arith-offset-eqs        3
;  :arith-pivots            91
;  :binary-propagations     7
;  :conflicts               74
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 852
;  :datatype-occurs-check   319
;  :datatype-splits         546
;  :decisions               823
;  :del-clause              385
;  :final-checks            96
;  :interface-eqs           4
;  :max-generation          2
;  :max-memory              4.33
;  :memory                  4.33
;  :mk-bool-var             1591
;  :mk-clause               407
;  :num-allocs              4188836
;  :num-checks              160
;  :propagations            223
;  :quant-instantiations    119
;  :rlimit-count            171256
;  :time                    0.00)
(push) ; 6
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3989
;  :arith-add-rows          25
;  :arith-assert-diseq      38
;  :arith-assert-lower      189
;  :arith-assert-upper      153
;  :arith-bound-prop        24
;  :arith-conflicts         15
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         82
;  :arith-offset-eqs        3
;  :arith-pivots            99
;  :binary-propagations     7
;  :conflicts               79
;  :datatype-accessor-ax    158
;  :datatype-constructor-ax 906
;  :datatype-occurs-check   341
;  :datatype-splits         582
;  :decisions               874
;  :del-clause              417
;  :final-checks            102
;  :interface-eqs           5
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             1682
;  :mk-clause               439
;  :num-allocs              4350177
;  :num-checks              161
;  :propagations            240
;  :quant-instantiations    123
;  :rlimit-count            172951
;  :time                    0.00)
; [then-branch: 37 | First:(Second:($t@46@08))[0] != -1 | live]
; [else-branch: 37 | First:(Second:($t@46@08))[0] == -1 | live]
(push) ; 6
; [then-branch: 37 | First:(Second:($t@46@08))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0)
    (- 0 1))))
; [exec]
; min_advance__73 := Main_find_minimum_advance_Sequence$Integer$(diz, diz.Main_event_state)
; [eval] Main_find_minimum_advance_Sequence$Integer$(diz, diz.Main_event_state)
(push) ; 7
; [eval] diz != null
; [eval] |vals| == 2
; [eval] |vals|
(pop) ; 7
; Joined path conditions
(declare-const min_advance__73@48@08 Int)
(assert (=
  min_advance__73@48@08
  (Main_find_minimum_advance_Sequence$Integer$ ($Snap.combine
    $Snap.unit
    $Snap.unit) diz@17@08 ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08))))))))
; [eval] min_advance__73 == -1
; [eval] -1
(push) ; 7
(assert (not (not (= min_advance__73@48@08 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4146
;  :arith-add-rows          28
;  :arith-assert-diseq      55
;  :arith-assert-lower      216
;  :arith-assert-upper      168
;  :arith-bound-prop        26
;  :arith-conflicts         16
;  :arith-eq-adapter        141
;  :arith-fixed-eqs         87
;  :arith-offset-eqs        3
;  :arith-pivots            107
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    162
;  :datatype-constructor-ax 938
;  :datatype-occurs-check   355
;  :datatype-splits         610
;  :decisions               911
;  :del-clause              450
;  :final-checks            106
;  :interface-eqs           6
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             1778
;  :mk-clause               526
;  :num-allocs              4350177
;  :num-checks              162
;  :propagations            282
;  :quant-instantiations    133
;  :rlimit-count            174929
;  :time                    0.00)
(push) ; 7
(assert (not (= min_advance__73@48@08 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4292
;  :arith-add-rows          28
;  :arith-assert-diseq      73
;  :arith-assert-lower      241
;  :arith-assert-upper      182
;  :arith-bound-prop        32
;  :arith-conflicts         17
;  :arith-eq-adapter        152
;  :arith-fixed-eqs         91
;  :arith-offset-eqs        3
;  :arith-pivots            113
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 970
;  :datatype-occurs-check   369
;  :datatype-splits         638
;  :decisions               948
;  :del-clause              494
;  :final-checks            110
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             1846
;  :mk-clause               570
;  :num-allocs              4350177
;  :num-checks              163
;  :propagations            323
;  :quant-instantiations    137
;  :rlimit-count            176382
;  :time                    0.00)
; [then-branch: 38 | min_advance__73@48@08 == -1 | live]
; [else-branch: 38 | min_advance__73@48@08 != -1 | live]
(push) ; 7
; [then-branch: 38 | min_advance__73@48@08 == -1]
(assert (= min_advance__73@48@08 (- 0 1)))
; [exec]
; min_advance__73 := 0
; [exec]
; __flatten_50__72 := Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__73), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__73))
; [eval] Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__73), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__73))
; [eval] (diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__73)
; [eval] diz.Main_event_state[0] < -1
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4294
;  :arith-add-rows          28
;  :arith-assert-diseq      74
;  :arith-assert-lower      242
;  :arith-assert-upper      185
;  :arith-bound-prop        32
;  :arith-conflicts         17
;  :arith-eq-adapter        153
;  :arith-fixed-eqs         91
;  :arith-offset-eqs        3
;  :arith-pivots            113
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    165
;  :datatype-constructor-ax 970
;  :datatype-occurs-check   369
;  :datatype-splits         638
;  :decisions               948
;  :del-clause              494
;  :final-checks            110
;  :interface-eqs           7
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             1850
;  :mk-clause               570
;  :num-allocs              4350177
;  :num-checks              164
;  :propagations            324
;  :quant-instantiations    137
;  :rlimit-count            176463)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4435
;  :arith-add-rows          28
;  :arith-assert-diseq      85
;  :arith-assert-lower      255
;  :arith-assert-upper      199
;  :arith-bound-prop        34
;  :arith-conflicts         18
;  :arith-eq-adapter        162
;  :arith-fixed-eqs         94
;  :arith-offset-eqs        4
;  :arith-pivots            118
;  :binary-propagations     7
;  :conflicts               85
;  :datatype-accessor-ax    168
;  :datatype-constructor-ax 1002
;  :datatype-occurs-check   383
;  :datatype-splits         666
;  :decisions               982
;  :del-clause              513
;  :final-checks            114
;  :interface-eqs           8
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             1907
;  :mk-clause               589
;  :num-allocs              4350177
;  :num-checks              165
;  :propagations            351
;  :quant-instantiations    141
;  :rlimit-count            177859
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4576
;  :arith-add-rows          28
;  :arith-assert-diseq      95
;  :arith-assert-lower      269
;  :arith-assert-upper      211
;  :arith-bound-prop        36
;  :arith-conflicts         18
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         98
;  :arith-offset-eqs        4
;  :arith-pivots            122
;  :binary-propagations     7
;  :conflicts               86
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 1034
;  :datatype-occurs-check   397
;  :datatype-splits         694
;  :decisions               1017
;  :del-clause              538
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             1966
;  :mk-clause               614
;  :num-allocs              4350177
;  :num-checks              166
;  :propagations            378
;  :quant-instantiations    145
;  :rlimit-count            179240
;  :time                    0.00)
; [then-branch: 39 | First:(Second:(Second:(Second:($t@46@08))))[0] < -1 | live]
; [else-branch: 39 | !(First:(Second:(Second:(Second:($t@46@08))))[0] < -1) | live]
(push) ; 9
; [then-branch: 39 | First:(Second:(Second:(Second:($t@46@08))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 39 | !(First:(Second:(Second:(Second:($t@46@08))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__73
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4576
;  :arith-add-rows          28
;  :arith-assert-diseq      95
;  :arith-assert-lower      271
;  :arith-assert-upper      211
;  :arith-bound-prop        36
;  :arith-conflicts         18
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         98
;  :arith-offset-eqs        4
;  :arith-pivots            122
;  :binary-propagations     7
;  :conflicts               86
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 1034
;  :datatype-occurs-check   397
;  :datatype-splits         694
;  :decisions               1017
;  :del-clause              538
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             1966
;  :mk-clause               614
;  :num-allocs              4350177
;  :num-checks              167
;  :propagations            380
;  :quant-instantiations    145
;  :rlimit-count            179403)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__73)
; [eval] diz.Main_event_state[1] < -1
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4576
;  :arith-add-rows          28
;  :arith-assert-diseq      95
;  :arith-assert-lower      271
;  :arith-assert-upper      211
;  :arith-bound-prop        36
;  :arith-conflicts         18
;  :arith-eq-adapter        171
;  :arith-fixed-eqs         98
;  :arith-offset-eqs        4
;  :arith-pivots            122
;  :binary-propagations     7
;  :conflicts               86
;  :datatype-accessor-ax    171
;  :datatype-constructor-ax 1034
;  :datatype-occurs-check   397
;  :datatype-splits         694
;  :decisions               1017
;  :del-clause              538
;  :final-checks            118
;  :interface-eqs           9
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             1966
;  :mk-clause               614
;  :num-allocs              4350177
;  :num-checks              168
;  :propagations            380
;  :quant-instantiations    145
;  :rlimit-count            179418)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4717
;  :arith-add-rows          28
;  :arith-assert-diseq      105
;  :arith-assert-lower      287
;  :arith-assert-upper      223
;  :arith-bound-prop        38
;  :arith-conflicts         19
;  :arith-eq-adapter        180
;  :arith-fixed-eqs         102
;  :arith-offset-eqs        4
;  :arith-pivots            126
;  :binary-propagations     7
;  :conflicts               88
;  :datatype-accessor-ax    174
;  :datatype-constructor-ax 1066
;  :datatype-occurs-check   411
;  :datatype-splits         722
;  :decisions               1051
;  :del-clause              557
;  :final-checks            122
;  :interface-eqs           10
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2024
;  :mk-clause               633
;  :num-allocs              4350177
;  :num-checks              169
;  :propagations            407
;  :quant-instantiations    149
;  :rlimit-count            180810
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4860
;  :arith-add-rows          28
;  :arith-assert-diseq      119
;  :arith-assert-lower      309
;  :arith-assert-upper      232
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        190
;  :arith-fixed-eqs         106
;  :arith-offset-eqs        4
;  :arith-pivots            132
;  :binary-propagations     7
;  :conflicts               90
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              585
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2086
;  :mk-clause               661
;  :num-allocs              4350177
;  :num-checks              170
;  :propagations            439
;  :quant-instantiations    153
;  :rlimit-count            182268
;  :time                    0.00)
; [then-branch: 40 | First:(Second:(Second:(Second:($t@46@08))))[1] < -1 | live]
; [else-branch: 40 | !(First:(Second:(Second:(Second:($t@46@08))))[1] < -1) | live]
(push) ; 9
; [then-branch: 40 | First:(Second:(Second:(Second:($t@46@08))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 40 | !(First:(Second:(Second:(Second:($t@46@08))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__73
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4860
;  :arith-add-rows          28
;  :arith-assert-diseq      119
;  :arith-assert-lower      310
;  :arith-assert-upper      233
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        190
;  :arith-fixed-eqs         106
;  :arith-offset-eqs        4
;  :arith-pivots            132
;  :binary-propagations     7
;  :conflicts               90
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              585
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2086
;  :mk-clause               661
;  :num-allocs              4350177
;  :num-checks              171
;  :propagations            441
;  :quant-instantiations    153
;  :rlimit-count            182431)
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
            0)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
          0)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
            1)
          (- 0 1))
        (- 0 3)
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
          1)))))
  2))
(declare-const __flatten_50__72@49@08 Seq<Int>)
(assert (Seq_equal
  __flatten_50__72@49@08
  (Seq_append
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
          0)
        (- 0 1))
      (- 0 3)
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
        0)))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
          1)
        (- 0 1))
      (- 0 3)
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
        1))))))
; [exec]
; __flatten_49__71 := __flatten_50__72
; [exec]
; diz.Main_event_state := __flatten_49__71
; [exec]
; Main_wakeup_after_wait_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(push) ; 8
(assert (not (= (Seq_length __flatten_50__72@49@08) 2)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4867
;  :arith-add-rows          29
;  :arith-assert-diseq      119
;  :arith-assert-lower      313
;  :arith-assert-upper      235
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        194
;  :arith-fixed-eqs         107
;  :arith-offset-eqs        4
;  :arith-pivots            133
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              585
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2117
;  :mk-clause               681
;  :num-allocs              4350177
;  :num-checks              172
;  :propagations            446
;  :quant-instantiations    157
;  :rlimit-count            183106)
(assert (= (Seq_length __flatten_50__72@49@08) 2))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@50@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 41 | 0 <= i@50@08 | live]
; [else-branch: 41 | !(0 <= i@50@08) | live]
(push) ; 10
; [then-branch: 41 | 0 <= i@50@08]
(assert (<= 0 i@50@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 41 | !(0 <= i@50@08)]
(assert (not (<= 0 i@50@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 42 | i@50@08 < |First:(Second:($t@46@08))| && 0 <= i@50@08 | live]
; [else-branch: 42 | !(i@50@08 < |First:(Second:($t@46@08))| && 0 <= i@50@08) | live]
(push) ; 10
; [then-branch: 42 | i@50@08 < |First:(Second:($t@46@08))| && 0 <= i@50@08]
(assert (and
  (<
    i@50@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
  (<= 0 i@50@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@50@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4869
;  :arith-add-rows          29
;  :arith-assert-diseq      119
;  :arith-assert-lower      315
;  :arith-assert-upper      237
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        195
;  :arith-fixed-eqs         108
;  :arith-offset-eqs        4
;  :arith-pivots            133
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              585
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2122
;  :mk-clause               681
;  :num-allocs              4350177
;  :num-checks              173
;  :propagations            446
;  :quant-instantiations    157
;  :rlimit-count            183297)
; [eval] -1
(push) ; 11
; [then-branch: 43 | First:(Second:($t@46@08))[i@50@08] == -1 | live]
; [else-branch: 43 | First:(Second:($t@46@08))[i@50@08] != -1 | live]
(push) ; 12
; [then-branch: 43 | First:(Second:($t@46@08))[i@50@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@50@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 43 | First:(Second:($t@46@08))[i@50@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      i@50@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@50@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4871
;  :arith-add-rows          29
;  :arith-assert-diseq      120
;  :arith-assert-lower      315
;  :arith-assert-upper      237
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        195
;  :arith-fixed-eqs         108
;  :arith-offset-eqs        4
;  :arith-pivots            133
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              585
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2123
;  :mk-clause               681
;  :num-allocs              4350177
;  :num-checks              174
;  :propagations            446
;  :quant-instantiations    157
;  :rlimit-count            183445)
(push) ; 13
; [then-branch: 44 | 0 <= First:(Second:($t@46@08))[i@50@08] | live]
; [else-branch: 44 | !(0 <= First:(Second:($t@46@08))[i@50@08]) | live]
(push) ; 14
; [then-branch: 44 | 0 <= First:(Second:($t@46@08))[i@50@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@50@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@50@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4873
;  :arith-add-rows          30
;  :arith-assert-diseq      120
;  :arith-assert-lower      317
;  :arith-assert-upper      238
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        196
;  :arith-fixed-eqs         109
;  :arith-offset-eqs        4
;  :arith-pivots            134
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              585
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2127
;  :mk-clause               681
;  :num-allocs              4350177
;  :num-checks              175
;  :propagations            446
;  :quant-instantiations    157
;  :rlimit-count            183564)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 44 | !(0 <= First:(Second:($t@46@08))[i@50@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      i@50@08))))
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
; [else-branch: 42 | !(i@50@08 < |First:(Second:($t@46@08))| && 0 <= i@50@08)]
(assert (not
  (and
    (<
      i@50@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
    (<= 0 i@50@08))))
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
(assert (not (forall ((i@50@08 Int)) (!
  (implies
    (and
      (<
        i@50@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
      (<= 0 i@50@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          i@50@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@50@08)
          (Seq_length __flatten_50__72@49@08))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@50@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@50@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4873
;  :arith-add-rows          30
;  :arith-assert-diseq      122
;  :arith-assert-lower      318
;  :arith-assert-upper      239
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        198
;  :arith-fixed-eqs         110
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    177
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              612
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2141
;  :mk-clause               708
;  :num-allocs              4350177
;  :num-checks              176
;  :propagations            448
;  :quant-instantiations    160
;  :rlimit-count            184056)
(assert (forall ((i@50@08 Int)) (!
  (implies
    (and
      (<
        i@50@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
      (<= 0 i@50@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          i@50@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@50@08)
          (Seq_length __flatten_50__72@49@08))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@50@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@50@08))
  :qid |prog.l<no position>|)))
(declare-const $t@51@08 $Snap)
(assert (= $t@51@08 ($Snap.combine ($Snap.first $t@51@08) ($Snap.second $t@51@08))))
(assert (=
  ($Snap.second $t@51@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@51@08))
    ($Snap.second ($Snap.second $t@51@08)))))
(assert (=
  ($Snap.second ($Snap.second $t@51@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@51@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@51@08))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@51@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@52@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 45 | 0 <= i@52@08 | live]
; [else-branch: 45 | !(0 <= i@52@08) | live]
(push) ; 10
; [then-branch: 45 | 0 <= i@52@08]
(assert (<= 0 i@52@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 45 | !(0 <= i@52@08)]
(assert (not (<= 0 i@52@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 46 | i@52@08 < |First:(Second:($t@51@08))| && 0 <= i@52@08 | live]
; [else-branch: 46 | !(i@52@08 < |First:(Second:($t@51@08))| && 0 <= i@52@08) | live]
(push) ; 10
; [then-branch: 46 | i@52@08 < |First:(Second:($t@51@08))| && 0 <= i@52@08]
(assert (and
  (<
    i@52@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))
  (<= 0 i@52@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@52@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4911
;  :arith-add-rows          30
;  :arith-assert-diseq      122
;  :arith-assert-lower      323
;  :arith-assert-upper      242
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        200
;  :arith-fixed-eqs         111
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              612
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2163
;  :mk-clause               708
;  :num-allocs              4350177
;  :num-checks              177
;  :propagations            448
;  :quant-instantiations    165
;  :rlimit-count            185475)
; [eval] -1
(push) ; 11
; [then-branch: 47 | First:(Second:($t@51@08))[i@52@08] == -1 | live]
; [else-branch: 47 | First:(Second:($t@51@08))[i@52@08] != -1 | live]
(push) ; 12
; [then-branch: 47 | First:(Second:($t@51@08))[i@52@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
    i@52@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 47 | First:(Second:($t@51@08))[i@52@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
      i@52@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@52@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4911
;  :arith-add-rows          30
;  :arith-assert-diseq      122
;  :arith-assert-lower      323
;  :arith-assert-upper      242
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        200
;  :arith-fixed-eqs         111
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              612
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2164
;  :mk-clause               708
;  :num-allocs              4350177
;  :num-checks              178
;  :propagations            448
;  :quant-instantiations    165
;  :rlimit-count            185626)
(push) ; 13
; [then-branch: 48 | 0 <= First:(Second:($t@51@08))[i@52@08] | live]
; [else-branch: 48 | !(0 <= First:(Second:($t@51@08))[i@52@08]) | live]
(push) ; 14
; [then-branch: 48 | 0 <= First:(Second:($t@51@08))[i@52@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
    i@52@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@52@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4911
;  :arith-add-rows          30
;  :arith-assert-diseq      123
;  :arith-assert-lower      326
;  :arith-assert-upper      242
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        201
;  :arith-fixed-eqs         111
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    183
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              612
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2167
;  :mk-clause               709
;  :num-allocs              4350177
;  :num-checks              179
;  :propagations            448
;  :quant-instantiations    165
;  :rlimit-count            185729)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 48 | !(0 <= First:(Second:($t@51@08))[i@52@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
      i@52@08))))
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
; [else-branch: 46 | !(i@52@08 < |First:(Second:($t@51@08))| && 0 <= i@52@08)]
(assert (not
  (and
    (<
      i@52@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))
    (<= 0 i@52@08))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@52@08 Int)) (!
  (implies
    (and
      (<
        i@52@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))
      (<= 0 i@52@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
          i@52@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
            i@52@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
            i@52@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
    i@52@08))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
  __flatten_50__72@49@08))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4932
;  :arith-add-rows          30
;  :arith-assert-diseq      123
;  :arith-assert-lower      327
;  :arith-assert-upper      243
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              613
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2191
;  :mk-clause               725
;  :num-allocs              4350177
;  :num-checks              180
;  :propagations            454
;  :quant-instantiations    167
;  :rlimit-count            186754)
(push) ; 8
; [then-branch: 49 | 0 <= First:(Second:($t@46@08))[0] | live]
; [else-branch: 49 | !(0 <= First:(Second:($t@46@08))[0]) | live]
(push) ; 9
; [then-branch: 49 | 0 <= First:(Second:($t@46@08))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4932
;  :arith-add-rows          30
;  :arith-assert-diseq      123
;  :arith-assert-lower      327
;  :arith-assert-upper      243
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              613
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2191
;  :mk-clause               725
;  :num-allocs              4350177
;  :num-checks              181
;  :propagations            454
;  :quant-instantiations    167
;  :rlimit-count            186854)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4932
;  :arith-add-rows          30
;  :arith-assert-diseq      123
;  :arith-assert-lower      327
;  :arith-assert-upper      243
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              613
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2191
;  :mk-clause               725
;  :num-allocs              4350177
;  :num-checks              182
;  :propagations            454
;  :quant-instantiations    167
;  :rlimit-count            186863)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (Seq_length __flatten_50__72@49@08))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4932
;  :arith-add-rows          30
;  :arith-assert-diseq      123
;  :arith-assert-lower      327
;  :arith-assert-upper      243
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              613
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2191
;  :mk-clause               725
;  :num-allocs              4350177
;  :num-checks              183
;  :propagations            454
;  :quant-instantiations    167
;  :rlimit-count            186951)
(push) ; 10
; [then-branch: 50 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 | live]
; [else-branch: 50 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] != 0 | live]
(push) ; 11
; [then-branch: 50 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_50__72@49@08
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 50 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_50__72@49@08
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4933
;  :arith-add-rows          31
;  :arith-assert-diseq      123
;  :arith-assert-lower      327
;  :arith-assert-upper      243
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              613
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2196
;  :mk-clause               730
;  :num-allocs              4350177
;  :num-checks              184
;  :propagations            454
;  :quant-instantiations    168
;  :rlimit-count            187166)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4933
;  :arith-add-rows          31
;  :arith-assert-diseq      123
;  :arith-assert-lower      327
;  :arith-assert-upper      243
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              613
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2196
;  :mk-clause               730
;  :num-allocs              4350177
;  :num-checks              185
;  :propagations            454
;  :quant-instantiations    168
;  :rlimit-count            187175)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (Seq_length __flatten_50__72@49@08))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4933
;  :arith-add-rows          31
;  :arith-assert-diseq      123
;  :arith-assert-lower      327
;  :arith-assert-upper      243
;  :arith-bound-prop        40
;  :arith-conflicts         20
;  :arith-eq-adapter        203
;  :arith-fixed-eqs         112
;  :arith-offset-eqs        4
;  :arith-pivots            135
;  :binary-propagations     7
;  :conflicts               94
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 1098
;  :datatype-occurs-check   425
;  :datatype-splits         750
;  :decisions               1089
;  :del-clause              613
;  :final-checks            126
;  :interface-eqs           11
;  :max-generation          2
;  :max-memory              4.44
;  :memory                  4.44
;  :minimized-lits          1
;  :mk-bool-var             2196
;  :mk-clause               730
;  :num-allocs              4350177
;  :num-checks              186
;  :propagations            454
;  :quant-instantiations    168
;  :rlimit-count            187263)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 49 | !(0 <= First:(Second:($t@46@08))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5267
;  :arith-add-rows          43
;  :arith-assert-diseq      146
;  :arith-assert-lower      368
;  :arith-assert-upper      269
;  :arith-bound-prop        46
;  :arith-conflicts         21
;  :arith-eq-adapter        231
;  :arith-fixed-eqs         130
;  :arith-offset-eqs        8
;  :arith-pivots            151
;  :binary-propagations     7
;  :conflicts               102
;  :datatype-accessor-ax    189
;  :datatype-constructor-ax 1157
;  :datatype-occurs-check   441
;  :datatype-splits         784
;  :decisions               1154
;  :del-clause              708
;  :final-checks            130
;  :interface-eqs           12
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          14
;  :mk-bool-var             2359
;  :mk-clause               820
;  :num-allocs              4522451
;  :num-checks              187
;  :propagations            509
;  :quant-instantiations    194
;  :rlimit-count            190184
;  :time                    0.00)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_50__72@49@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      0)
    (=
      (Seq_index
        __flatten_50__72@49@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5580
;  :arith-add-rows          58
;  :arith-assert-diseq      166
;  :arith-assert-lower      407
;  :arith-assert-upper      293
;  :arith-bound-prop        51
;  :arith-conflicts         22
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        9
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               108
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1216
;  :datatype-occurs-check   457
;  :datatype-splits         818
;  :decisions               1217
;  :del-clause              788
;  :final-checks            134
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          16
;  :mk-bool-var             2510
;  :mk-clause               900
;  :num-allocs              4522451
;  :num-checks              188
;  :propagations            561
;  :quant-instantiations    217
;  :rlimit-count            192918
;  :time                    0.00)
; [then-branch: 51 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0] | live]
; [else-branch: 51 | !(__flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0]) | live]
(push) ; 9
; [then-branch: 51 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_50__72@49@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      0)
    (=
      (Seq_index
        __flatten_50__72@49@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5580
;  :arith-add-rows          58
;  :arith-assert-diseq      166
;  :arith-assert-lower      407
;  :arith-assert-upper      293
;  :arith-bound-prop        51
;  :arith-conflicts         22
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        9
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               108
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1216
;  :datatype-occurs-check   457
;  :datatype-splits         818
;  :decisions               1217
;  :del-clause              788
;  :final-checks            134
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          16
;  :mk-bool-var             2512
;  :mk-clause               901
;  :num-allocs              4522451
;  :num-checks              189
;  :propagations            561
;  :quant-instantiations    217
;  :rlimit-count            193086)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 51 | !(__flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@51@08))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5585
;  :arith-add-rows          58
;  :arith-assert-diseq      166
;  :arith-assert-lower      407
;  :arith-assert-upper      293
;  :arith-bound-prop        51
;  :arith-conflicts         22
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        9
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               108
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1216
;  :datatype-occurs-check   457
;  :datatype-splits         818
;  :decisions               1217
;  :del-clause              789
;  :final-checks            134
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          16
;  :mk-bool-var             2517
;  :mk-clause               905
;  :num-allocs              4522451
;  :num-checks              190
;  :propagations            561
;  :quant-instantiations    217
;  :rlimit-count            193468)
(push) ; 8
; [then-branch: 52 | 0 <= First:(Second:($t@46@08))[0] | live]
; [else-branch: 52 | !(0 <= First:(Second:($t@46@08))[0]) | live]
(push) ; 9
; [then-branch: 52 | 0 <= First:(Second:($t@46@08))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5585
;  :arith-add-rows          58
;  :arith-assert-diseq      166
;  :arith-assert-lower      407
;  :arith-assert-upper      293
;  :arith-bound-prop        51
;  :arith-conflicts         22
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        9
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               108
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1216
;  :datatype-occurs-check   457
;  :datatype-splits         818
;  :decisions               1217
;  :del-clause              789
;  :final-checks            134
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          16
;  :mk-bool-var             2517
;  :mk-clause               905
;  :num-allocs              4522451
;  :num-checks              191
;  :propagations            561
;  :quant-instantiations    217
;  :rlimit-count            193568)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5585
;  :arith-add-rows          58
;  :arith-assert-diseq      166
;  :arith-assert-lower      407
;  :arith-assert-upper      293
;  :arith-bound-prop        51
;  :arith-conflicts         22
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        9
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               108
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1216
;  :datatype-occurs-check   457
;  :datatype-splits         818
;  :decisions               1217
;  :del-clause              789
;  :final-checks            134
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          16
;  :mk-bool-var             2517
;  :mk-clause               905
;  :num-allocs              4522451
;  :num-checks              192
;  :propagations            561
;  :quant-instantiations    217
;  :rlimit-count            193577)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (Seq_length __flatten_50__72@49@08))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5585
;  :arith-add-rows          58
;  :arith-assert-diseq      166
;  :arith-assert-lower      407
;  :arith-assert-upper      293
;  :arith-bound-prop        51
;  :arith-conflicts         22
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        9
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1216
;  :datatype-occurs-check   457
;  :datatype-splits         818
;  :decisions               1217
;  :del-clause              789
;  :final-checks            134
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          16
;  :mk-bool-var             2517
;  :mk-clause               905
;  :num-allocs              4522451
;  :num-checks              193
;  :propagations            561
;  :quant-instantiations    217
;  :rlimit-count            193665)
(push) ; 10
; [then-branch: 53 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 | live]
; [else-branch: 53 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] != 0 | live]
(push) ; 11
; [then-branch: 53 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_50__72@49@08
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 53 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_50__72@49@08
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5586
;  :arith-add-rows          60
;  :arith-assert-diseq      166
;  :arith-assert-lower      407
;  :arith-assert-upper      293
;  :arith-bound-prop        51
;  :arith-conflicts         22
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        9
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1216
;  :datatype-occurs-check   457
;  :datatype-splits         818
;  :decisions               1217
;  :del-clause              789
;  :final-checks            134
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          16
;  :mk-bool-var             2521
;  :mk-clause               910
;  :num-allocs              4522451
;  :num-checks              194
;  :propagations            561
;  :quant-instantiations    218
;  :rlimit-count            193819)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5586
;  :arith-add-rows          60
;  :arith-assert-diseq      166
;  :arith-assert-lower      407
;  :arith-assert-upper      293
;  :arith-bound-prop        51
;  :arith-conflicts         22
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        9
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1216
;  :datatype-occurs-check   457
;  :datatype-splits         818
;  :decisions               1217
;  :del-clause              789
;  :final-checks            134
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          16
;  :mk-bool-var             2521
;  :mk-clause               910
;  :num-allocs              4522451
;  :num-checks              195
;  :propagations            561
;  :quant-instantiations    218
;  :rlimit-count            193828)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (Seq_length __flatten_50__72@49@08))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5586
;  :arith-add-rows          60
;  :arith-assert-diseq      166
;  :arith-assert-lower      407
;  :arith-assert-upper      293
;  :arith-bound-prop        51
;  :arith-conflicts         22
;  :arith-eq-adapter        258
;  :arith-fixed-eqs         145
;  :arith-offset-eqs        9
;  :arith-pivots            161
;  :binary-propagations     7
;  :conflicts               110
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 1216
;  :datatype-occurs-check   457
;  :datatype-splits         818
;  :decisions               1217
;  :del-clause              789
;  :final-checks            134
;  :interface-eqs           13
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          16
;  :mk-bool-var             2521
;  :mk-clause               910
;  :num-allocs              4522451
;  :num-checks              196
;  :propagations            561
;  :quant-instantiations    218
;  :rlimit-count            193916)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 52 | !(0 <= First:(Second:($t@46@08))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
        __flatten_50__72@49@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      0)
    (=
      (Seq_index
        __flatten_50__72@49@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5992
;  :arith-add-rows          75
;  :arith-assert-diseq      188
;  :arith-assert-lower      455
;  :arith-assert-upper      323
;  :arith-bound-prop        56
;  :arith-conflicts         23
;  :arith-eq-adapter        292
;  :arith-fixed-eqs         160
;  :arith-offset-eqs        12
;  :arith-pivots            171
;  :binary-propagations     7
;  :conflicts               116
;  :datatype-accessor-ax    201
;  :datatype-constructor-ax 1299
;  :datatype-occurs-check   479
;  :datatype-splits         876
;  :decisions               1301
;  :del-clause              885
;  :final-checks            140
;  :interface-eqs           15
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          18
;  :mk-bool-var             2717
;  :mk-clause               1001
;  :num-allocs              4522451
;  :num-checks              197
;  :propagations            621
;  :quant-instantiations    244
;  :rlimit-count            197095
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6477
;  :arith-add-rows          90
;  :arith-assert-diseq      210
;  :arith-assert-lower      494
;  :arith-assert-upper      350
;  :arith-bound-prop        62
;  :arith-conflicts         24
;  :arith-eq-adapter        322
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        18
;  :arith-pivots            181
;  :binary-propagations     7
;  :conflicts               127
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 1400
;  :datatype-occurs-check   507
;  :datatype-splits         938
;  :decisions               1402
;  :del-clause              978
;  :final-checks            147
;  :interface-eqs           17
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          31
;  :mk-bool-var             2929
;  :mk-clause               1094
;  :num-allocs              4522451
;  :num-checks              198
;  :propagations            683
;  :quant-instantiations    270
;  :rlimit-count            200492
;  :time                    0.00)
; [then-branch: 54 | !(__flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0]) | live]
; [else-branch: 54 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0] | live]
(push) ; 9
; [then-branch: 54 | !(__flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@49@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6478
;  :arith-add-rows          92
;  :arith-assert-diseq      210
;  :arith-assert-lower      494
;  :arith-assert-upper      350
;  :arith-bound-prop        62
;  :arith-conflicts         24
;  :arith-eq-adapter        322
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        18
;  :arith-pivots            181
;  :binary-propagations     7
;  :conflicts               127
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 1400
;  :datatype-occurs-check   507
;  :datatype-splits         938
;  :decisions               1402
;  :del-clause              978
;  :final-checks            147
;  :interface-eqs           17
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          31
;  :mk-bool-var             2933
;  :mk-clause               1099
;  :num-allocs              4522451
;  :num-checks              199
;  :propagations            685
;  :quant-instantiations    271
;  :rlimit-count            200676)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6478
;  :arith-add-rows          92
;  :arith-assert-diseq      210
;  :arith-assert-lower      494
;  :arith-assert-upper      350
;  :arith-bound-prop        62
;  :arith-conflicts         24
;  :arith-eq-adapter        322
;  :arith-fixed-eqs         177
;  :arith-offset-eqs        18
;  :arith-pivots            181
;  :binary-propagations     7
;  :conflicts               127
;  :datatype-accessor-ax    213
;  :datatype-constructor-ax 1400
;  :datatype-occurs-check   507
;  :datatype-splits         938
;  :decisions               1402
;  :del-clause              978
;  :final-checks            147
;  :interface-eqs           17
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          31
;  :mk-bool-var             2933
;  :mk-clause               1099
;  :num-allocs              4522451
;  :num-checks              200
;  :propagations            685
;  :quant-instantiations    271
;  :rlimit-count            200691)
(pop) ; 9
(push) ; 9
; [else-branch: 54 | __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@49@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_50__72@49@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      0)
    (=
      (Seq_index
        __flatten_50__72@49@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
            __flatten_50__72@49@08
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
              0))
          0)
        (=
          (Seq_index
            __flatten_50__72@49@08
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
(declare-const i@53@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 55 | 0 <= i@53@08 | live]
; [else-branch: 55 | !(0 <= i@53@08) | live]
(push) ; 10
; [then-branch: 55 | 0 <= i@53@08]
(assert (<= 0 i@53@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 55 | !(0 <= i@53@08)]
(assert (not (<= 0 i@53@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 56 | i@53@08 < |First:(Second:($t@51@08))| && 0 <= i@53@08 | live]
; [else-branch: 56 | !(i@53@08 < |First:(Second:($t@51@08))| && 0 <= i@53@08) | live]
(push) ; 10
; [then-branch: 56 | i@53@08 < |First:(Second:($t@51@08))| && 0 <= i@53@08]
(assert (and
  (<
    i@53@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))
  (<= 0 i@53@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@53@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6883
;  :arith-add-rows          108
;  :arith-assert-diseq      231
;  :arith-assert-lower      541
;  :arith-assert-upper      380
;  :arith-bound-prop        68
;  :arith-conflicts         25
;  :arith-eq-adapter        355
;  :arith-fixed-eqs         195
;  :arith-offset-eqs        19
;  :arith-pivots            194
;  :binary-propagations     7
;  :conflicts               133
;  :datatype-accessor-ax    221
;  :datatype-constructor-ax 1483
;  :datatype-occurs-check   529
;  :datatype-splits         996
;  :decisions               1488
;  :del-clause              1084
;  :final-checks            154
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          33
;  :mk-bool-var             3131
;  :mk-clause               1206
;  :num-allocs              4522451
;  :num-checks              202
;  :propagations            749
;  :quant-instantiations    297
;  :rlimit-count            204134)
; [eval] -1
(push) ; 11
; [then-branch: 57 | First:(Second:($t@51@08))[i@53@08] == -1 | live]
; [else-branch: 57 | First:(Second:($t@51@08))[i@53@08] != -1 | live]
(push) ; 12
; [then-branch: 57 | First:(Second:($t@51@08))[i@53@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
    i@53@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 57 | First:(Second:($t@51@08))[i@53@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
      i@53@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@53@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6889
;  :arith-add-rows          109
;  :arith-assert-diseq      233
;  :arith-assert-lower      545
;  :arith-assert-upper      382
;  :arith-bound-prop        68
;  :arith-conflicts         25
;  :arith-eq-adapter        357
;  :arith-fixed-eqs         196
;  :arith-offset-eqs        19
;  :arith-pivots            195
;  :binary-propagations     7
;  :conflicts               133
;  :datatype-accessor-ax    221
;  :datatype-constructor-ax 1483
;  :datatype-occurs-check   529
;  :datatype-splits         996
;  :decisions               1488
;  :del-clause              1084
;  :final-checks            154
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          33
;  :mk-bool-var             3140
;  :mk-clause               1211
;  :num-allocs              4522451
;  :num-checks              203
;  :propagations            756
;  :quant-instantiations    299
;  :rlimit-count            204341)
(push) ; 13
; [then-branch: 58 | 0 <= First:(Second:($t@51@08))[i@53@08] | live]
; [else-branch: 58 | !(0 <= First:(Second:($t@51@08))[i@53@08]) | live]
(push) ; 14
; [then-branch: 58 | 0 <= First:(Second:($t@51@08))[i@53@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
    i@53@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@53@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6891
;  :arith-add-rows          110
;  :arith-assert-diseq      233
;  :arith-assert-lower      547
;  :arith-assert-upper      383
;  :arith-bound-prop        68
;  :arith-conflicts         25
;  :arith-eq-adapter        358
;  :arith-fixed-eqs         197
;  :arith-offset-eqs        19
;  :arith-pivots            196
;  :binary-propagations     7
;  :conflicts               133
;  :datatype-accessor-ax    221
;  :datatype-constructor-ax 1483
;  :datatype-occurs-check   529
;  :datatype-splits         996
;  :decisions               1488
;  :del-clause              1084
;  :final-checks            154
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          33
;  :mk-bool-var             3144
;  :mk-clause               1211
;  :num-allocs              4522451
;  :num-checks              204
;  :propagations            756
;  :quant-instantiations    299
;  :rlimit-count            204460)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 58 | !(0 <= First:(Second:($t@51@08))[i@53@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
      i@53@08))))
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
; [else-branch: 56 | !(i@53@08 < |First:(Second:($t@51@08))| && 0 <= i@53@08)]
(assert (not
  (and
    (<
      i@53@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))
    (<= 0 i@53@08))))
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
(assert (not (forall ((i@53@08 Int)) (!
  (implies
    (and
      (<
        i@53@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))
      (<= 0 i@53@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
          i@53@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
            i@53@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
            i@53@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
    i@53@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6891
;  :arith-add-rows          110
;  :arith-assert-diseq      235
;  :arith-assert-lower      548
;  :arith-assert-upper      384
;  :arith-bound-prop        68
;  :arith-conflicts         25
;  :arith-eq-adapter        359
;  :arith-fixed-eqs         198
;  :arith-offset-eqs        19
;  :arith-pivots            198
;  :binary-propagations     7
;  :conflicts               134
;  :datatype-accessor-ax    221
;  :datatype-constructor-ax 1483
;  :datatype-occurs-check   529
;  :datatype-splits         996
;  :decisions               1488
;  :del-clause              1103
;  :final-checks            154
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          33
;  :mk-bool-var             3152
;  :mk-clause               1225
;  :num-allocs              4522451
;  :num-checks              205
;  :propagations            758
;  :quant-instantiations    300
;  :rlimit-count            204891)
(assert (forall ((i@53@08 Int)) (!
  (implies
    (and
      (<
        i@53@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))
      (<= 0 i@53@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
          i@53@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
            i@53@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
            i@53@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))
    i@53@08))
  :qid |prog.l<no position>|)))
(declare-const $t@54@08 $Snap)
(assert (= $t@54@08 ($Snap.combine ($Snap.first $t@54@08) ($Snap.second $t@54@08))))
(assert (=
  ($Snap.second $t@54@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@54@08))
    ($Snap.second ($Snap.second $t@54@08)))))
(assert (=
  ($Snap.second ($Snap.second $t@54@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@54@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@54@08))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@54@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@55@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 59 | 0 <= i@55@08 | live]
; [else-branch: 59 | !(0 <= i@55@08) | live]
(push) ; 10
; [then-branch: 59 | 0 <= i@55@08]
(assert (<= 0 i@55@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 59 | !(0 <= i@55@08)]
(assert (not (<= 0 i@55@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 60 | i@55@08 < |First:(Second:($t@54@08))| && 0 <= i@55@08 | live]
; [else-branch: 60 | !(i@55@08 < |First:(Second:($t@54@08))| && 0 <= i@55@08) | live]
(push) ; 10
; [then-branch: 60 | i@55@08 < |First:(Second:($t@54@08))| && 0 <= i@55@08]
(assert (and
  (<
    i@55@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))))
  (<= 0 i@55@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@55@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6929
;  :arith-add-rows          110
;  :arith-assert-diseq      235
;  :arith-assert-lower      553
;  :arith-assert-upper      387
;  :arith-bound-prop        68
;  :arith-conflicts         25
;  :arith-eq-adapter        361
;  :arith-fixed-eqs         199
;  :arith-offset-eqs        19
;  :arith-pivots            198
;  :binary-propagations     7
;  :conflicts               134
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 1483
;  :datatype-occurs-check   529
;  :datatype-splits         996
;  :decisions               1488
;  :del-clause              1103
;  :final-checks            154
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          33
;  :mk-bool-var             3174
;  :mk-clause               1225
;  :num-allocs              4522451
;  :num-checks              206
;  :propagations            758
;  :quant-instantiations    304
;  :rlimit-count            206284)
; [eval] -1
(push) ; 11
; [then-branch: 61 | First:(Second:($t@54@08))[i@55@08] == -1 | live]
; [else-branch: 61 | First:(Second:($t@54@08))[i@55@08] != -1 | live]
(push) ; 12
; [then-branch: 61 | First:(Second:($t@54@08))[i@55@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
    i@55@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 61 | First:(Second:($t@54@08))[i@55@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
      i@55@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@55@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6929
;  :arith-add-rows          110
;  :arith-assert-diseq      235
;  :arith-assert-lower      553
;  :arith-assert-upper      387
;  :arith-bound-prop        68
;  :arith-conflicts         25
;  :arith-eq-adapter        361
;  :arith-fixed-eqs         199
;  :arith-offset-eqs        19
;  :arith-pivots            198
;  :binary-propagations     7
;  :conflicts               134
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 1483
;  :datatype-occurs-check   529
;  :datatype-splits         996
;  :decisions               1488
;  :del-clause              1103
;  :final-checks            154
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          33
;  :mk-bool-var             3175
;  :mk-clause               1225
;  :num-allocs              4522451
;  :num-checks              207
;  :propagations            758
;  :quant-instantiations    304
;  :rlimit-count            206435)
(push) ; 13
; [then-branch: 62 | 0 <= First:(Second:($t@54@08))[i@55@08] | live]
; [else-branch: 62 | !(0 <= First:(Second:($t@54@08))[i@55@08]) | live]
(push) ; 14
; [then-branch: 62 | 0 <= First:(Second:($t@54@08))[i@55@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
    i@55@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@55@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6929
;  :arith-add-rows          110
;  :arith-assert-diseq      236
;  :arith-assert-lower      556
;  :arith-assert-upper      387
;  :arith-bound-prop        68
;  :arith-conflicts         25
;  :arith-eq-adapter        362
;  :arith-fixed-eqs         199
;  :arith-offset-eqs        19
;  :arith-pivots            198
;  :binary-propagations     7
;  :conflicts               134
;  :datatype-accessor-ax    227
;  :datatype-constructor-ax 1483
;  :datatype-occurs-check   529
;  :datatype-splits         996
;  :decisions               1488
;  :del-clause              1103
;  :final-checks            154
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          33
;  :mk-bool-var             3178
;  :mk-clause               1226
;  :num-allocs              4522451
;  :num-checks              208
;  :propagations            758
;  :quant-instantiations    304
;  :rlimit-count            206539)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 62 | !(0 <= First:(Second:($t@54@08))[i@55@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
      i@55@08))))
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
; [else-branch: 60 | !(i@55@08 < |First:(Second:($t@54@08))| && 0 <= i@55@08)]
(assert (not
  (and
    (<
      i@55@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))))
    (<= 0 i@55@08))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@55@08 Int)) (!
  (implies
    (and
      (<
        i@55@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))))
      (<= 0 i@55@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
          i@55@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
            i@55@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
            i@55@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
    i@55@08))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@51@08)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6947
;  :arith-add-rows          110
;  :arith-assert-diseq      236
;  :arith-assert-lower      557
;  :arith-assert-upper      388
;  :arith-bound-prop        68
;  :arith-conflicts         25
;  :arith-eq-adapter        363
;  :arith-fixed-eqs         200
;  :arith-offset-eqs        19
;  :arith-pivots            198
;  :binary-propagations     7
;  :conflicts               134
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1483
;  :datatype-occurs-check   529
;  :datatype-splits         996
;  :decisions               1488
;  :del-clause              1104
;  :final-checks            154
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          33
;  :mk-bool-var             3198
;  :mk-clause               1236
;  :num-allocs              4522451
;  :num-checks              209
;  :propagations            762
;  :quant-instantiations    306
;  :rlimit-count            207554)
(push) ; 8
; [then-branch: 63 | First:(Second:(Second:(Second:($t@51@08))))[0] == 0 | live]
; [else-branch: 63 | First:(Second:(Second:(Second:($t@51@08))))[0] != 0 | live]
(push) ; 9
; [then-branch: 63 | First:(Second:(Second:(Second:($t@51@08))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 63 | First:(Second:(Second:(Second:($t@51@08))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6948
;  :arith-add-rows          111
;  :arith-assert-diseq      236
;  :arith-assert-lower      557
;  :arith-assert-upper      388
;  :arith-bound-prop        68
;  :arith-conflicts         25
;  :arith-eq-adapter        363
;  :arith-fixed-eqs         200
;  :arith-offset-eqs        19
;  :arith-pivots            198
;  :binary-propagations     7
;  :conflicts               134
;  :datatype-accessor-ax    229
;  :datatype-constructor-ax 1483
;  :datatype-occurs-check   529
;  :datatype-splits         996
;  :decisions               1488
;  :del-clause              1104
;  :final-checks            154
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.54
;  :memory                  4.54
;  :minimized-lits          33
;  :mk-bool-var             3203
;  :mk-clause               1241
;  :num-allocs              4522451
;  :num-checks              210
;  :propagations            762
;  :quant-instantiations    307
;  :rlimit-count            207767)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7384
;  :arith-add-rows          130
;  :arith-assert-diseq      278
;  :arith-assert-lower      619
;  :arith-assert-upper      430
;  :arith-bound-prop        71
;  :arith-conflicts         25
;  :arith-eq-adapter        398
;  :arith-fixed-eqs         226
;  :arith-offset-eqs        20
;  :arith-pivots            215
;  :binary-propagations     7
;  :conflicts               144
;  :datatype-accessor-ax    234
;  :datatype-constructor-ax 1547
;  :datatype-occurs-check   547
;  :datatype-splits         1034
;  :decisions               1564
;  :del-clause              1216
;  :final-checks            157
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          49
;  :mk-bool-var             3392
;  :mk-clause               1348
;  :num-allocs              4705664
;  :num-checks              211
;  :propagations            875
;  :quant-instantiations    352
;  :rlimit-count            211467
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7715
;  :arith-add-rows          142
;  :arith-assert-diseq      304
;  :arith-assert-lower      652
;  :arith-assert-upper      452
;  :arith-bound-prop        73
;  :arith-conflicts         25
;  :arith-eq-adapter        422
;  :arith-fixed-eqs         234
;  :arith-offset-eqs        24
;  :arith-pivots            229
;  :binary-propagations     7
;  :conflicts               147
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 1611
;  :datatype-occurs-check   565
;  :datatype-splits         1072
;  :decisions               1632
;  :del-clause              1276
;  :final-checks            160
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          49
;  :mk-bool-var             3522
;  :mk-clause               1408
;  :num-allocs              4705664
;  :num-checks              212
;  :propagations            925
;  :quant-instantiations    373
;  :rlimit-count            214308
;  :time                    0.00)
; [then-branch: 64 | First:(Second:(Second:(Second:($t@51@08))))[0] == 0 || First:(Second:(Second:(Second:($t@51@08))))[0] == -1 | live]
; [else-branch: 64 | !(First:(Second:(Second:(Second:($t@51@08))))[0] == 0 || First:(Second:(Second:(Second:($t@51@08))))[0] == -1) | live]
(push) ; 9
; [then-branch: 64 | First:(Second:(Second:(Second:($t@51@08))))[0] == 0 || First:(Second:(Second:(Second:($t@51@08))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7715
;  :arith-add-rows          142
;  :arith-assert-diseq      304
;  :arith-assert-lower      652
;  :arith-assert-upper      452
;  :arith-bound-prop        73
;  :arith-conflicts         25
;  :arith-eq-adapter        422
;  :arith-fixed-eqs         234
;  :arith-offset-eqs        24
;  :arith-pivots            229
;  :binary-propagations     7
;  :conflicts               147
;  :datatype-accessor-ax    239
;  :datatype-constructor-ax 1611
;  :datatype-occurs-check   565
;  :datatype-splits         1072
;  :decisions               1632
;  :del-clause              1276
;  :final-checks            160
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          49
;  :mk-bool-var             3524
;  :mk-clause               1409
;  :num-allocs              4705664
;  :num-checks              213
;  :propagations            925
;  :quant-instantiations    373
;  :rlimit-count            214457)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 64 | !(First:(Second:(Second:(Second:($t@51@08))))[0] == 0 || First:(Second:(Second:(Second:($t@51@08))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7721
;  :arith-add-rows          142
;  :arith-assert-diseq      304
;  :arith-assert-lower      652
;  :arith-assert-upper      452
;  :arith-bound-prop        73
;  :arith-conflicts         25
;  :arith-eq-adapter        422
;  :arith-fixed-eqs         234
;  :arith-offset-eqs        24
;  :arith-pivots            229
;  :binary-propagations     7
;  :conflicts               147
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 1611
;  :datatype-occurs-check   565
;  :datatype-splits         1072
;  :decisions               1632
;  :del-clause              1277
;  :final-checks            160
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          49
;  :mk-bool-var             3530
;  :mk-clause               1413
;  :num-allocs              4705664
;  :num-checks              214
;  :propagations            925
;  :quant-instantiations    373
;  :rlimit-count            214940)
(push) ; 8
; [then-branch: 65 | First:(Second:(Second:(Second:($t@51@08))))[1] == 0 | live]
; [else-branch: 65 | First:(Second:(Second:(Second:($t@51@08))))[1] != 0 | live]
(push) ; 9
; [then-branch: 65 | First:(Second:(Second:(Second:($t@51@08))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 65 | First:(Second:(Second:(Second:($t@51@08))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               7722
;  :arith-add-rows          143
;  :arith-assert-diseq      304
;  :arith-assert-lower      652
;  :arith-assert-upper      452
;  :arith-bound-prop        73
;  :arith-conflicts         25
;  :arith-eq-adapter        422
;  :arith-fixed-eqs         234
;  :arith-offset-eqs        24
;  :arith-pivots            229
;  :binary-propagations     7
;  :conflicts               147
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 1611
;  :datatype-occurs-check   565
;  :datatype-splits         1072
;  :decisions               1632
;  :del-clause              1277
;  :final-checks            160
;  :interface-eqs           20
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          49
;  :mk-bool-var             3535
;  :mk-clause               1418
;  :num-allocs              4705664
;  :num-checks              215
;  :propagations            925
;  :quant-instantiations    374
;  :rlimit-count            215125)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8093
;  :arith-add-rows          151
;  :arith-assert-diseq      337
;  :arith-assert-lower      695
;  :arith-assert-upper      483
;  :arith-bound-prop        75
;  :arith-conflicts         25
;  :arith-eq-adapter        453
;  :arith-fixed-eqs         247
;  :arith-offset-eqs        29
;  :arith-pivots            239
;  :binary-propagations     7
;  :conflicts               151
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 1675
;  :datatype-occurs-check   584
;  :datatype-splits         1110
;  :decisions               1705
;  :del-clause              1366
;  :final-checks            164
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          54
;  :mk-bool-var             3698
;  :mk-clause               1502
;  :num-allocs              4705664
;  :num-checks              216
;  :propagations            996
;  :quant-instantiations    403
;  :rlimit-count            218063
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8489
;  :arith-add-rows          158
;  :arith-assert-diseq      368
;  :arith-assert-lower      753
;  :arith-assert-upper      515
;  :arith-bound-prop        77
;  :arith-conflicts         25
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         270
;  :arith-offset-eqs        31
;  :arith-pivots            249
;  :binary-propagations     7
;  :conflicts               157
;  :datatype-accessor-ax    251
;  :datatype-constructor-ax 1742
;  :datatype-occurs-check   608
;  :datatype-splits         1150
;  :decisions               1778
;  :del-clause              1463
;  :final-checks            168
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          55
;  :mk-bool-var             3877
;  :mk-clause               1599
;  :num-allocs              4705664
;  :num-checks              217
;  :propagations            1091
;  :quant-instantiations    437
;  :rlimit-count            221175
;  :time                    0.00)
; [then-branch: 66 | First:(Second:(Second:(Second:($t@51@08))))[1] == 0 || First:(Second:(Second:(Second:($t@51@08))))[1] == -1 | live]
; [else-branch: 66 | !(First:(Second:(Second:(Second:($t@51@08))))[1] == 0 || First:(Second:(Second:(Second:($t@51@08))))[1] == -1) | live]
(push) ; 9
; [then-branch: 66 | First:(Second:(Second:(Second:($t@51@08))))[1] == 0 || First:(Second:(Second:(Second:($t@51@08))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8489
;  :arith-add-rows          158
;  :arith-assert-diseq      368
;  :arith-assert-lower      753
;  :arith-assert-upper      515
;  :arith-bound-prop        77
;  :arith-conflicts         25
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         270
;  :arith-offset-eqs        31
;  :arith-pivots            249
;  :binary-propagations     7
;  :conflicts               157
;  :datatype-accessor-ax    251
;  :datatype-constructor-ax 1742
;  :datatype-occurs-check   608
;  :datatype-splits         1150
;  :decisions               1778
;  :del-clause              1463
;  :final-checks            168
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          55
;  :mk-bool-var             3879
;  :mk-clause               1600
;  :num-allocs              4705664
;  :num-checks              218
;  :propagations            1091
;  :quant-instantiations    437
;  :rlimit-count            221324)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 66 | !(First:(Second:(Second:(Second:($t@51@08))))[1] == 0 || First:(Second:(Second:(Second:($t@51@08))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8495
;  :arith-add-rows          158
;  :arith-assert-diseq      368
;  :arith-assert-lower      753
;  :arith-assert-upper      515
;  :arith-bound-prop        77
;  :arith-conflicts         25
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         270
;  :arith-offset-eqs        31
;  :arith-pivots            249
;  :binary-propagations     7
;  :conflicts               157
;  :datatype-accessor-ax    252
;  :datatype-constructor-ax 1742
;  :datatype-occurs-check   608
;  :datatype-splits         1150
;  :decisions               1778
;  :del-clause              1464
;  :final-checks            168
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          55
;  :mk-bool-var             3885
;  :mk-clause               1604
;  :num-allocs              4705664
;  :num-checks              219
;  :propagations            1091
;  :quant-instantiations    437
;  :rlimit-count            221813)
(push) ; 8
; [then-branch: 67 | First:(Second:(Second:(Second:($t@51@08))))[0] == 0 | live]
; [else-branch: 67 | First:(Second:(Second:(Second:($t@51@08))))[0] != 0 | live]
(push) ; 9
; [then-branch: 67 | First:(Second:(Second:(Second:($t@51@08))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 67 | First:(Second:(Second:(Second:($t@51@08))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8496
;  :arith-add-rows          159
;  :arith-assert-diseq      368
;  :arith-assert-lower      753
;  :arith-assert-upper      515
;  :arith-bound-prop        77
;  :arith-conflicts         25
;  :arith-eq-adapter        486
;  :arith-fixed-eqs         270
;  :arith-offset-eqs        31
;  :arith-pivots            249
;  :binary-propagations     7
;  :conflicts               157
;  :datatype-accessor-ax    252
;  :datatype-constructor-ax 1742
;  :datatype-occurs-check   608
;  :datatype-splits         1150
;  :decisions               1778
;  :del-clause              1464
;  :final-checks            168
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          55
;  :mk-bool-var             3889
;  :mk-clause               1609
;  :num-allocs              4705664
;  :num-checks              220
;  :propagations            1091
;  :quant-instantiations    438
;  :rlimit-count            221982)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               8870
;  :arith-add-rows          175
;  :arith-assert-diseq      402
;  :arith-assert-lower      794
;  :arith-assert-upper      545
;  :arith-bound-prop        79
;  :arith-conflicts         25
;  :arith-eq-adapter        515
;  :arith-fixed-eqs         282
;  :arith-offset-eqs        34
;  :arith-pivots            265
;  :binary-propagations     7
;  :conflicts               162
;  :datatype-accessor-ax    258
;  :datatype-constructor-ax 1809
;  :datatype-occurs-check   632
;  :datatype-splits         1190
;  :decisions               1852
;  :del-clause              1551
;  :final-checks            172
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          60
;  :mk-bool-var             4053
;  :mk-clause               1691
;  :num-allocs              4705664
;  :num-checks              221
;  :propagations            1162
;  :quant-instantiations    465
;  :rlimit-count            225205
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9352
;  :arith-add-rows          190
;  :arith-assert-diseq      444
;  :arith-assert-lower      856
;  :arith-assert-upper      587
;  :arith-bound-prop        82
;  :arith-conflicts         25
;  :arith-eq-adapter        550
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        36
;  :arith-pivots            281
;  :binary-propagations     7
;  :conflicts               174
;  :datatype-accessor-ax    264
;  :datatype-constructor-ax 1876
;  :datatype-occurs-check   656
;  :datatype-splits         1230
;  :decisions               1931
;  :del-clause              1665
;  :final-checks            176
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          76
;  :mk-bool-var             4261
;  :mk-clause               1805
;  :num-allocs              4705664
;  :num-checks              222
;  :propagations            1292
;  :quant-instantiations    513
;  :rlimit-count            228871
;  :time                    0.00)
; [then-branch: 68 | !(First:(Second:(Second:(Second:($t@51@08))))[0] == 0 || First:(Second:(Second:(Second:($t@51@08))))[0] == -1) | live]
; [else-branch: 68 | First:(Second:(Second:(Second:($t@51@08))))[0] == 0 || First:(Second:(Second:(Second:($t@51@08))))[0] == -1 | live]
(push) ; 9
; [then-branch: 68 | !(First:(Second:(Second:(Second:($t@51@08))))[0] == 0 || First:(Second:(Second:(Second:($t@51@08))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9353
;  :arith-add-rows          191
;  :arith-assert-diseq      444
;  :arith-assert-lower      856
;  :arith-assert-upper      587
;  :arith-bound-prop        82
;  :arith-conflicts         25
;  :arith-eq-adapter        550
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        36
;  :arith-pivots            281
;  :binary-propagations     7
;  :conflicts               174
;  :datatype-accessor-ax    264
;  :datatype-constructor-ax 1876
;  :datatype-occurs-check   656
;  :datatype-splits         1230
;  :decisions               1931
;  :del-clause              1665
;  :final-checks            176
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          76
;  :mk-bool-var             4265
;  :mk-clause               1810
;  :num-allocs              4705664
;  :num-checks              223
;  :propagations            1293
;  :quant-instantiations    514
;  :rlimit-count            229061)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9353
;  :arith-add-rows          191
;  :arith-assert-diseq      444
;  :arith-assert-lower      856
;  :arith-assert-upper      587
;  :arith-bound-prop        82
;  :arith-conflicts         25
;  :arith-eq-adapter        550
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        36
;  :arith-pivots            281
;  :binary-propagations     7
;  :conflicts               174
;  :datatype-accessor-ax    264
;  :datatype-constructor-ax 1876
;  :datatype-occurs-check   656
;  :datatype-splits         1230
;  :decisions               1931
;  :del-clause              1665
;  :final-checks            176
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          76
;  :mk-bool-var             4265
;  :mk-clause               1810
;  :num-allocs              4705664
;  :num-checks              224
;  :propagations            1293
;  :quant-instantiations    514
;  :rlimit-count            229076)
(pop) ; 9
(push) ; 9
; [else-branch: 68 | First:(Second:(Second:(Second:($t@51@08))))[0] == 0 || First:(Second:(Second:(Second:($t@51@08))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@08))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9360
;  :arith-add-rows          191
;  :arith-assert-diseq      444
;  :arith-assert-lower      856
;  :arith-assert-upper      587
;  :arith-bound-prop        82
;  :arith-conflicts         25
;  :arith-eq-adapter        550
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        36
;  :arith-pivots            281
;  :binary-propagations     7
;  :conflicts               174
;  :datatype-accessor-ax    264
;  :datatype-constructor-ax 1876
;  :datatype-occurs-check   656
;  :datatype-splits         1230
;  :decisions               1931
;  :del-clause              1670
;  :final-checks            176
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          76
;  :mk-bool-var             4267
;  :mk-clause               1811
;  :num-allocs              4705664
;  :num-checks              225
;  :propagations            1293
;  :quant-instantiations    514
;  :rlimit-count            229428)
(push) ; 8
; [then-branch: 69 | First:(Second:(Second:(Second:($t@51@08))))[1] == 0 | live]
; [else-branch: 69 | First:(Second:(Second:(Second:($t@51@08))))[1] != 0 | live]
(push) ; 9
; [then-branch: 69 | First:(Second:(Second:(Second:($t@51@08))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 69 | First:(Second:(Second:(Second:($t@51@08))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9361
;  :arith-add-rows          192
;  :arith-assert-diseq      444
;  :arith-assert-lower      856
;  :arith-assert-upper      587
;  :arith-bound-prop        82
;  :arith-conflicts         25
;  :arith-eq-adapter        550
;  :arith-fixed-eqs         319
;  :arith-offset-eqs        36
;  :arith-pivots            281
;  :binary-propagations     7
;  :conflicts               174
;  :datatype-accessor-ax    264
;  :datatype-constructor-ax 1876
;  :datatype-occurs-check   656
;  :datatype-splits         1230
;  :decisions               1931
;  :del-clause              1670
;  :final-checks            176
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          76
;  :mk-bool-var             4271
;  :mk-clause               1816
;  :num-allocs              4705664
;  :num-checks              226
;  :propagations            1293
;  :quant-instantiations    515
;  :rlimit-count            229597)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               9756
;  :arith-add-rows          200
;  :arith-assert-diseq      475
;  :arith-assert-lower      914
;  :arith-assert-upper      619
;  :arith-bound-prop        84
;  :arith-conflicts         25
;  :arith-eq-adapter        583
;  :arith-fixed-eqs         342
;  :arith-offset-eqs        38
;  :arith-pivots            295
;  :binary-propagations     7
;  :conflicts               180
;  :datatype-accessor-ax    270
;  :datatype-constructor-ax 1942
;  :datatype-occurs-check   680
;  :datatype-splits         1269
;  :decisions               2003
;  :del-clause              1772
;  :final-checks            180
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          77
;  :mk-bool-var             4447
;  :mk-clause               1913
;  :num-allocs              4705664
;  :num-checks              227
;  :propagations            1390
;  :quant-instantiations    549
;  :rlimit-count            232753
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10138
;  :arith-add-rows          217
;  :arith-assert-diseq      508
;  :arith-assert-lower      956
;  :arith-assert-upper      649
;  :arith-bound-prop        86
;  :arith-conflicts         25
;  :arith-eq-adapter        613
;  :arith-fixed-eqs         355
;  :arith-offset-eqs        42
;  :arith-pivots            313
;  :binary-propagations     7
;  :conflicts               186
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 2008
;  :datatype-occurs-check   704
;  :datatype-splits         1308
;  :decisions               2077
;  :del-clause              1853
;  :final-checks            184
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          82
;  :mk-bool-var             4616
;  :mk-clause               1994
;  :num-allocs              4705664
;  :num-checks              228
;  :propagations            1465
;  :quant-instantiations    578
;  :rlimit-count            235996
;  :time                    0.00)
; [then-branch: 70 | !(First:(Second:(Second:(Second:($t@51@08))))[1] == 0 || First:(Second:(Second:(Second:($t@51@08))))[1] == -1) | live]
; [else-branch: 70 | First:(Second:(Second:(Second:($t@51@08))))[1] == 0 || First:(Second:(Second:(Second:($t@51@08))))[1] == -1 | live]
(push) ; 9
; [then-branch: 70 | !(First:(Second:(Second:(Second:($t@51@08))))[1] == 0 || First:(Second:(Second:(Second:($t@51@08))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10139
;  :arith-add-rows          218
;  :arith-assert-diseq      508
;  :arith-assert-lower      956
;  :arith-assert-upper      649
;  :arith-bound-prop        86
;  :arith-conflicts         25
;  :arith-eq-adapter        613
;  :arith-fixed-eqs         355
;  :arith-offset-eqs        42
;  :arith-pivots            313
;  :binary-propagations     7
;  :conflicts               186
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 2008
;  :datatype-occurs-check   704
;  :datatype-splits         1308
;  :decisions               2077
;  :del-clause              1853
;  :final-checks            184
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          82
;  :mk-bool-var             4620
;  :mk-clause               1999
;  :num-allocs              4705664
;  :num-checks              229
;  :propagations            1466
;  :quant-instantiations    579
;  :rlimit-count            236186)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10139
;  :arith-add-rows          218
;  :arith-assert-diseq      508
;  :arith-assert-lower      956
;  :arith-assert-upper      649
;  :arith-bound-prop        86
;  :arith-conflicts         25
;  :arith-eq-adapter        613
;  :arith-fixed-eqs         355
;  :arith-offset-eqs        42
;  :arith-pivots            313
;  :binary-propagations     7
;  :conflicts               186
;  :datatype-accessor-ax    276
;  :datatype-constructor-ax 2008
;  :datatype-occurs-check   704
;  :datatype-splits         1308
;  :decisions               2077
;  :del-clause              1853
;  :final-checks            184
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          82
;  :mk-bool-var             4620
;  :mk-clause               1999
;  :num-allocs              4705664
;  :num-checks              230
;  :propagations            1466
;  :quant-instantiations    579
;  :rlimit-count            236201)
(pop) ; 9
(push) ; 9
; [else-branch: 70 | First:(Second:(Second:(Second:($t@51@08))))[1] == 0 || First:(Second:(Second:(Second:($t@51@08))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@51@08)))))
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
(declare-const i@56@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 71 | 0 <= i@56@08 | live]
; [else-branch: 71 | !(0 <= i@56@08) | live]
(push) ; 10
; [then-branch: 71 | 0 <= i@56@08]
(assert (<= 0 i@56@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 71 | !(0 <= i@56@08)]
(assert (not (<= 0 i@56@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 72 | i@56@08 < |First:(Second:($t@54@08))| && 0 <= i@56@08 | live]
; [else-branch: 72 | !(i@56@08 < |First:(Second:($t@54@08))| && 0 <= i@56@08) | live]
(push) ; 10
; [then-branch: 72 | i@56@08 < |First:(Second:($t@54@08))| && 0 <= i@56@08]
(assert (and
  (<
    i@56@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))))
  (<= 0 i@56@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@56@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10522
;  :arith-add-rows          226
;  :arith-assert-diseq      541
;  :arith-assert-lower      999
;  :arith-assert-upper      680
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        643
;  :arith-fixed-eqs         369
;  :arith-offset-eqs        47
;  :arith-pivots            325
;  :binary-propagations     7
;  :conflicts               191
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1951
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4792
;  :mk-clause               2080
;  :num-allocs              4705664
;  :num-checks              232
;  :propagations            1541
;  :quant-instantiations    608
;  :rlimit-count            239413)
; [eval] -1
(push) ; 11
; [then-branch: 73 | First:(Second:($t@54@08))[i@56@08] == -1 | live]
; [else-branch: 73 | First:(Second:($t@54@08))[i@56@08] != -1 | live]
(push) ; 12
; [then-branch: 73 | First:(Second:($t@54@08))[i@56@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
    i@56@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 73 | First:(Second:($t@54@08))[i@56@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
      i@56@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@56@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10532
;  :arith-add-rows          227
;  :arith-assert-diseq      544
;  :arith-assert-lower      1007
;  :arith-assert-upper      684
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        647
;  :arith-fixed-eqs         371
;  :arith-offset-eqs        47
;  :arith-pivots            325
;  :binary-propagations     7
;  :conflicts               191
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1951
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4810
;  :mk-clause               2097
;  :num-allocs              4705664
;  :num-checks              233
;  :propagations            1553
;  :quant-instantiations    612
;  :rlimit-count            239646)
(push) ; 13
; [then-branch: 74 | 0 <= First:(Second:($t@54@08))[i@56@08] | live]
; [else-branch: 74 | !(0 <= First:(Second:($t@54@08))[i@56@08]) | live]
(push) ; 14
; [then-branch: 74 | 0 <= First:(Second:($t@54@08))[i@56@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
    i@56@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@56@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      544
;  :arith-assert-lower      1009
;  :arith-assert-upper      685
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        648
;  :arith-fixed-eqs         372
;  :arith-offset-eqs        47
;  :arith-pivots            326
;  :binary-propagations     7
;  :conflicts               191
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1951
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4814
;  :mk-clause               2097
;  :num-allocs              4705664
;  :num-checks              234
;  :propagations            1553
;  :quant-instantiations    612
;  :rlimit-count            239763)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 74 | !(0 <= First:(Second:($t@54@08))[i@56@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
      i@56@08))))
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
; [else-branch: 72 | !(i@56@08 < |First:(Second:($t@54@08))| && 0 <= i@56@08)]
(assert (not
  (and
    (<
      i@56@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))))
    (<= 0 i@56@08))))
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
(assert (not (forall ((i@56@08 Int)) (!
  (implies
    (and
      (<
        i@56@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))))
      (<= 0 i@56@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
          i@56@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
            i@56@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
            i@56@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
    i@56@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      546
;  :arith-assert-lower      1010
;  :arith-assert-upper      686
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        650
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            327
;  :binary-propagations     7
;  :conflicts               192
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4828
;  :mk-clause               2124
;  :num-allocs              4705664
;  :num-checks              235
;  :propagations            1555
;  :quant-instantiations    615
;  :rlimit-count            240255)
(assert (forall ((i@56@08 Int)) (!
  (implies
    (and
      (<
        i@56@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))))
      (<= 0 i@56@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
          i@56@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
            i@56@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
            i@56@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@54@08)))
    i@56@08))
  :qid |prog.l<no position>|)))
(declare-const $k@57@08 $Perm)
(assert ($Perm.isReadVar $k@57@08 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@57@08 $Perm.No) (< $Perm.No $k@57@08))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1012
;  :arith-assert-upper      687
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            327
;  :binary-propagations     7
;  :conflicts               193
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4833
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              236
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            240779)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@40@08 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1012
;  :arith-assert-upper      687
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            327
;  :binary-propagations     7
;  :conflicts               193
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4833
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              237
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            240790)
(assert (< $k@57@08 $k@40@08))
(assert (<= $Perm.No (- $k@40@08 $k@57@08)))
(assert (<= (- $k@40@08 $k@57@08) $Perm.Write))
(assert (implies (< $Perm.No (- $k@40@08 $k@57@08)) (not (= diz@17@08 $Ref.null))))
; [eval] diz.Main_alu != null
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               194
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              238
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241010)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               195
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              239
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241058)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               196
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              240
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241106)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               197
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              241
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241154)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               198
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              242
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241202)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               199
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              243
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241250)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               200
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              244
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241298)
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               201
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              245
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241346)
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               202
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              246
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241394)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               202
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              247
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241407)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10534
;  :arith-add-rows          228
;  :arith-assert-diseq      547
;  :arith-assert-lower      1014
;  :arith-assert-upper      688
;  :arith-bound-prop        88
;  :arith-conflicts         25
;  :arith-eq-adapter        651
;  :arith-fixed-eqs         373
;  :arith-offset-eqs        47
;  :arith-pivots            329
;  :binary-propagations     7
;  :conflicts               203
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 2074
;  :datatype-occurs-check   728
;  :datatype-splits         1347
;  :decisions               2150
;  :del-clause              1995
;  :final-checks            188
;  :interface-eqs           21
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4836
;  :mk-clause               2126
;  :num-allocs              4705664
;  :num-checks              248
;  :propagations            1556
;  :quant-instantiations    615
;  :rlimit-count            241455)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@54@08))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@08))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))
                                ($Snap.combine
                                  $Snap.unit
                                  ($Snap.combine
                                    $Snap.unit
                                    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))))))))))))))))))))) diz@17@08 globals@18@08))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 38 | min_advance__73@48@08 != -1]
(assert (not (= min_advance__73@48@08 (- 0 1))))
(pop) ; 7
; [eval] !(min_advance__73 == -1)
; [eval] min_advance__73 == -1
; [eval] -1
(push) ; 7
(assert (not (= min_advance__73@48@08 (- 0 1))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10680
;  :arith-add-rows          229
;  :arith-assert-diseq      565
;  :arith-assert-lower      1038
;  :arith-assert-upper      702
;  :arith-bound-prop        94
;  :arith-conflicts         26
;  :arith-eq-adapter        662
;  :arith-fixed-eqs         376
;  :arith-offset-eqs        48
;  :arith-pivots            337
;  :binary-propagations     7
;  :conflicts               205
;  :datatype-accessor-ax    285
;  :datatype-constructor-ax 2106
;  :datatype-occurs-check   742
;  :datatype-splits         1375
;  :decisions               2187
;  :del-clause              2094
;  :final-checks            192
;  :interface-eqs           22
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4903
;  :mk-clause               2170
;  :num-allocs              4705664
;  :num-checks              249
;  :propagations            1597
;  :quant-instantiations    619
;  :rlimit-count            243030
;  :time                    0.00)
(push) ; 7
(assert (not (not (= min_advance__73@48@08 (- 0 1)))))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10825
;  :arith-add-rows          229
;  :arith-assert-diseq      580
;  :arith-assert-lower      1058
;  :arith-assert-upper      714
;  :arith-bound-prop        96
;  :arith-conflicts         27
;  :arith-eq-adapter        673
;  :arith-fixed-eqs         380
;  :arith-offset-eqs        48
;  :arith-pivots            341
;  :binary-propagations     7
;  :conflicts               207
;  :datatype-accessor-ax    288
;  :datatype-constructor-ax 2138
;  :datatype-occurs-check   756
;  :datatype-splits         1403
;  :decisions               2224
;  :del-clause              2127
;  :final-checks            196
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4969
;  :mk-clause               2203
;  :num-allocs              4705664
;  :num-checks              250
;  :propagations            1629
;  :quant-instantiations    623
;  :rlimit-count            244414
;  :time                    0.00)
; [then-branch: 75 | min_advance__73@48@08 != -1 | live]
; [else-branch: 75 | min_advance__73@48@08 == -1 | live]
(push) ; 7
; [then-branch: 75 | min_advance__73@48@08 != -1]
(assert (not (= min_advance__73@48@08 (- 0 1))))
; [exec]
; __flatten_50__72 := Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__73), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__73))
; [eval] Seq((diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__73), (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__73))
; [eval] (diz.Main_event_state[0] < -1 ? -3 : diz.Main_event_state[0] - min_advance__73)
; [eval] diz.Main_event_state[0] < -1
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 8
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10826
;  :arith-add-rows          229
;  :arith-assert-diseq      582
;  :arith-assert-lower      1058
;  :arith-assert-upper      714
;  :arith-bound-prop        96
;  :arith-conflicts         27
;  :arith-eq-adapter        674
;  :arith-fixed-eqs         380
;  :arith-offset-eqs        48
;  :arith-pivots            341
;  :binary-propagations     7
;  :conflicts               207
;  :datatype-accessor-ax    288
;  :datatype-constructor-ax 2138
;  :datatype-occurs-check   756
;  :datatype-splits         1403
;  :decisions               2224
;  :del-clause              2127
;  :final-checks            196
;  :interface-eqs           23
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             4973
;  :mk-clause               2212
;  :num-allocs              4705664
;  :num-checks              251
;  :propagations            1629
;  :quant-instantiations    623
;  :rlimit-count            244504)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               10968
;  :arith-add-rows          229
;  :arith-assert-diseq      594
;  :arith-assert-lower      1072
;  :arith-assert-upper      729
;  :arith-bound-prop        100
;  :arith-conflicts         27
;  :arith-eq-adapter        683
;  :arith-fixed-eqs         382
;  :arith-offset-eqs        50
;  :arith-pivots            346
;  :binary-propagations     7
;  :conflicts               208
;  :datatype-accessor-ax    291
;  :datatype-constructor-ax 2170
;  :datatype-occurs-check   770
;  :datatype-splits         1431
;  :decisions               2258
;  :del-clause              2150
;  :final-checks            200
;  :interface-eqs           24
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5032
;  :mk-clause               2235
;  :num-allocs              4705664
;  :num-checks              252
;  :propagations            1657
;  :quant-instantiations    627
;  :rlimit-count            245899
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11109
;  :arith-add-rows          231
;  :arith-assert-diseq      605
;  :arith-assert-lower      1091
;  :arith-assert-upper      739
;  :arith-bound-prop        103
;  :arith-conflicts         27
;  :arith-eq-adapter        692
;  :arith-fixed-eqs         385
;  :arith-offset-eqs        51
;  :arith-pivots            352
;  :binary-propagations     7
;  :conflicts               209
;  :datatype-accessor-ax    294
;  :datatype-constructor-ax 2202
;  :datatype-occurs-check   784
;  :datatype-splits         1459
;  :decisions               2293
;  :del-clause              2176
;  :final-checks            204
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5090
;  :mk-clause               2261
;  :num-allocs              4705664
;  :num-checks              253
;  :propagations            1687
;  :quant-instantiations    631
;  :rlimit-count            247329
;  :time                    0.00)
; [then-branch: 76 | First:(Second:(Second:(Second:($t@46@08))))[0] < -1 | live]
; [else-branch: 76 | !(First:(Second:(Second:(Second:($t@46@08))))[0] < -1) | live]
(push) ; 9
; [then-branch: 76 | First:(Second:(Second:(Second:($t@46@08))))[0] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
    0)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 76 | !(First:(Second:(Second:(Second:($t@46@08))))[0] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] - min_advance__73
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11109
;  :arith-add-rows          231
;  :arith-assert-diseq      605
;  :arith-assert-lower      1093
;  :arith-assert-upper      739
;  :arith-bound-prop        103
;  :arith-conflicts         27
;  :arith-eq-adapter        692
;  :arith-fixed-eqs         385
;  :arith-offset-eqs        51
;  :arith-pivots            352
;  :binary-propagations     7
;  :conflicts               209
;  :datatype-accessor-ax    294
;  :datatype-constructor-ax 2202
;  :datatype-occurs-check   784
;  :datatype-splits         1459
;  :decisions               2293
;  :del-clause              2176
;  :final-checks            204
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5090
;  :mk-clause               2261
;  :num-allocs              4705664
;  :num-checks              254
;  :propagations            1689
;  :quant-instantiations    631
;  :rlimit-count            247492)
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
; [eval] (diz.Main_event_state[1] < -1 ? -3 : diz.Main_event_state[1] - min_advance__73)
; [eval] diz.Main_event_state[1] < -1
; [eval] diz.Main_event_state[1]
(push) ; 8
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11109
;  :arith-add-rows          231
;  :arith-assert-diseq      605
;  :arith-assert-lower      1093
;  :arith-assert-upper      739
;  :arith-bound-prop        103
;  :arith-conflicts         27
;  :arith-eq-adapter        692
;  :arith-fixed-eqs         385
;  :arith-offset-eqs        51
;  :arith-pivots            352
;  :binary-propagations     7
;  :conflicts               209
;  :datatype-accessor-ax    294
;  :datatype-constructor-ax 2202
;  :datatype-occurs-check   784
;  :datatype-splits         1459
;  :decisions               2293
;  :del-clause              2176
;  :final-checks            204
;  :interface-eqs           25
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5090
;  :mk-clause               2261
;  :num-allocs              4705664
;  :num-checks              255
;  :propagations            1689
;  :quant-instantiations    631
;  :rlimit-count            247507)
; [eval] -1
(push) ; 8
(set-option :timeout 10)
(push) ; 9
(assert (not (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11251
;  :arith-add-rows          231
;  :arith-assert-diseq      617
;  :arith-assert-lower      1107
;  :arith-assert-upper      754
;  :arith-bound-prop        107
;  :arith-conflicts         27
;  :arith-eq-adapter        701
;  :arith-fixed-eqs         387
;  :arith-offset-eqs        53
;  :arith-pivots            357
;  :binary-propagations     7
;  :conflicts               210
;  :datatype-accessor-ax    297
;  :datatype-constructor-ax 2234
;  :datatype-occurs-check   798
;  :datatype-splits         1487
;  :decisions               2327
;  :del-clause              2199
;  :final-checks            208
;  :interface-eqs           26
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5148
;  :mk-clause               2284
;  :num-allocs              4705664
;  :num-checks              256
;  :propagations            1718
;  :quant-instantiations    635
;  :rlimit-count            248906
;  :time                    0.00)
(push) ; 9
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
    1)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11391
;  :arith-add-rows          233
;  :arith-assert-diseq      629
;  :arith-assert-lower      1128
;  :arith-assert-upper      761
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        710
;  :arith-fixed-eqs         390
;  :arith-offset-eqs        54
;  :arith-pivots            364
;  :binary-propagations     7
;  :conflicts               211
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2228
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5208
;  :mk-clause               2313
;  :num-allocs              4705664
;  :num-checks              257
;  :propagations            1745
;  :quant-instantiations    639
;  :rlimit-count            250346
;  :time                    0.00)
; [then-branch: 77 | First:(Second:(Second:(Second:($t@46@08))))[1] < -1 | live]
; [else-branch: 77 | !(First:(Second:(Second:(Second:($t@46@08))))[1] < -1) | live]
(push) ; 9
; [then-branch: 77 | First:(Second:(Second:(Second:($t@46@08))))[1] < -1]
(assert (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
    1)
  (- 0 1)))
; [eval] -3
(pop) ; 9
(push) ; 9
; [else-branch: 77 | !(First:(Second:(Second:(Second:($t@46@08))))[1] < -1)]
(assert (not
  (<
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] - min_advance__73
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11391
;  :arith-add-rows          233
;  :arith-assert-diseq      629
;  :arith-assert-lower      1129
;  :arith-assert-upper      762
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        710
;  :arith-fixed-eqs         390
;  :arith-offset-eqs        54
;  :arith-pivots            364
;  :binary-propagations     7
;  :conflicts               211
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2228
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5208
;  :mk-clause               2313
;  :num-allocs              4705664
;  :num-checks              258
;  :propagations            1747
;  :quant-instantiations    639
;  :rlimit-count            250509)
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
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
            0)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
            0)
          min_advance__73@48@08)))
      (Seq_singleton (ite
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
            1)
          (- 0 1))
        (- 0 3)
        (-
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
            1)
          min_advance__73@48@08)))))
  2))
(declare-const __flatten_50__72@58@08 Seq<Int>)
(assert (Seq_equal
  __flatten_50__72@58@08
  (Seq_append
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
          0)
        (- 0 1))
      (- 0 3)
      (-
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
          0)
        min_advance__73@48@08)))
    (Seq_singleton (ite
      (<
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
          1)
        (- 0 1))
      (- 0 3)
      (-
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))
          1)
        min_advance__73@48@08))))))
; [exec]
; __flatten_49__71 := __flatten_50__72
; [exec]
; diz.Main_event_state := __flatten_49__71
; [exec]
; Main_wakeup_after_wait_EncodedGlobalVariables(diz, globals)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(push) ; 8
(assert (not (= (Seq_length __flatten_50__72@58@08) 2)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11400
;  :arith-add-rows          238
;  :arith-assert-diseq      629
;  :arith-assert-lower      1133
;  :arith-assert-upper      765
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        715
;  :arith-fixed-eqs         392
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               212
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2228
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5241
;  :mk-clause               2334
;  :num-allocs              4705664
;  :num-checks              259
;  :propagations            1752
;  :quant-instantiations    643
;  :rlimit-count            251288)
(assert (= (Seq_length __flatten_50__72@58@08) 2))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@59@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 78 | 0 <= i@59@08 | live]
; [else-branch: 78 | !(0 <= i@59@08) | live]
(push) ; 10
; [then-branch: 78 | 0 <= i@59@08]
(assert (<= 0 i@59@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 78 | !(0 <= i@59@08)]
(assert (not (<= 0 i@59@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 79 | i@59@08 < |First:(Second:($t@46@08))| && 0 <= i@59@08 | live]
; [else-branch: 79 | !(i@59@08 < |First:(Second:($t@46@08))| && 0 <= i@59@08) | live]
(push) ; 10
; [then-branch: 79 | i@59@08 < |First:(Second:($t@46@08))| && 0 <= i@59@08]
(assert (and
  (<
    i@59@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
  (<= 0 i@59@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@59@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11402
;  :arith-add-rows          238
;  :arith-assert-diseq      629
;  :arith-assert-lower      1135
;  :arith-assert-upper      767
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        716
;  :arith-fixed-eqs         393
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               212
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2228
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5246
;  :mk-clause               2334
;  :num-allocs              4705664
;  :num-checks              260
;  :propagations            1752
;  :quant-instantiations    643
;  :rlimit-count            251479)
; [eval] -1
(push) ; 11
; [then-branch: 80 | First:(Second:($t@46@08))[i@59@08] == -1 | live]
; [else-branch: 80 | First:(Second:($t@46@08))[i@59@08] != -1 | live]
(push) ; 12
; [then-branch: 80 | First:(Second:($t@46@08))[i@59@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@59@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 80 | First:(Second:($t@46@08))[i@59@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      i@59@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@59@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11404
;  :arith-add-rows          238
;  :arith-assert-diseq      630
;  :arith-assert-lower      1135
;  :arith-assert-upper      767
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        716
;  :arith-fixed-eqs         393
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               212
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2228
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5247
;  :mk-clause               2334
;  :num-allocs              4705664
;  :num-checks              261
;  :propagations            1752
;  :quant-instantiations    643
;  :rlimit-count            251627)
(push) ; 13
; [then-branch: 81 | 0 <= First:(Second:($t@46@08))[i@59@08] | live]
; [else-branch: 81 | !(0 <= First:(Second:($t@46@08))[i@59@08]) | live]
(push) ; 14
; [then-branch: 81 | 0 <= First:(Second:($t@46@08))[i@59@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@59@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@59@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11406
;  :arith-add-rows          239
;  :arith-assert-diseq      630
;  :arith-assert-lower      1137
;  :arith-assert-upper      768
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        717
;  :arith-fixed-eqs         394
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               212
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2228
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5251
;  :mk-clause               2334
;  :num-allocs              4705664
;  :num-checks              262
;  :propagations            1752
;  :quant-instantiations    643
;  :rlimit-count            251739)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 81 | !(0 <= First:(Second:($t@46@08))[i@59@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      i@59@08))))
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
; [else-branch: 79 | !(i@59@08 < |First:(Second:($t@46@08))| && 0 <= i@59@08)]
(assert (not
  (and
    (<
      i@59@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
    (<= 0 i@59@08))))
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
(assert (not (forall ((i@59@08 Int)) (!
  (implies
    (and
      (<
        i@59@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
      (<= 0 i@59@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          i@59@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@59@08)
          (Seq_length __flatten_50__72@58@08))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@59@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@59@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11406
;  :arith-add-rows          239
;  :arith-assert-diseq      631
;  :arith-assert-lower      1138
;  :arith-assert-upper      769
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        718
;  :arith-fixed-eqs         395
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               213
;  :datatype-accessor-ax    300
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2246
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5263
;  :mk-clause               2352
;  :num-allocs              4705664
;  :num-checks              263
;  :propagations            1754
;  :quant-instantiations    646
;  :rlimit-count            252227)
(assert (forall ((i@59@08 Int)) (!
  (implies
    (and
      (<
        i@59@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
      (<= 0 i@59@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          i@59@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@59@08)
          (Seq_length __flatten_50__72@58@08))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@59@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@59@08))
  :qid |prog.l<no position>|)))
(declare-const $t@60@08 $Snap)
(assert (= $t@60@08 ($Snap.combine ($Snap.first $t@60@08) ($Snap.second $t@60@08))))
(assert (=
  ($Snap.second $t@60@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@60@08))
    ($Snap.second ($Snap.second $t@60@08)))))
(assert (=
  ($Snap.second ($Snap.second $t@60@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@60@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@60@08))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@60@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@61@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 82 | 0 <= i@61@08 | live]
; [else-branch: 82 | !(0 <= i@61@08) | live]
(push) ; 10
; [then-branch: 82 | 0 <= i@61@08]
(assert (<= 0 i@61@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 82 | !(0 <= i@61@08)]
(assert (not (<= 0 i@61@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 83 | i@61@08 < |First:(Second:($t@60@08))| && 0 <= i@61@08 | live]
; [else-branch: 83 | !(i@61@08 < |First:(Second:($t@60@08))| && 0 <= i@61@08) | live]
(push) ; 10
; [then-branch: 83 | i@61@08 < |First:(Second:($t@60@08))| && 0 <= i@61@08]
(assert (and
  (<
    i@61@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))
  (<= 0 i@61@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@61@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11444
;  :arith-add-rows          239
;  :arith-assert-diseq      631
;  :arith-assert-lower      1143
;  :arith-assert-upper      772
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        720
;  :arith-fixed-eqs         396
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               213
;  :datatype-accessor-ax    306
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2246
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5285
;  :mk-clause               2352
;  :num-allocs              4705664
;  :num-checks              264
;  :propagations            1754
;  :quant-instantiations    651
;  :rlimit-count            253645)
; [eval] -1
(push) ; 11
; [then-branch: 84 | First:(Second:($t@60@08))[i@61@08] == -1 | live]
; [else-branch: 84 | First:(Second:($t@60@08))[i@61@08] != -1 | live]
(push) ; 12
; [then-branch: 84 | First:(Second:($t@60@08))[i@61@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
    i@61@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 84 | First:(Second:($t@60@08))[i@61@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
      i@61@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@61@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11444
;  :arith-add-rows          239
;  :arith-assert-diseq      631
;  :arith-assert-lower      1143
;  :arith-assert-upper      772
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        720
;  :arith-fixed-eqs         396
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               213
;  :datatype-accessor-ax    306
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2246
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5286
;  :mk-clause               2352
;  :num-allocs              4705664
;  :num-checks              265
;  :propagations            1754
;  :quant-instantiations    651
;  :rlimit-count            253796)
(push) ; 13
; [then-branch: 85 | 0 <= First:(Second:($t@60@08))[i@61@08] | live]
; [else-branch: 85 | !(0 <= First:(Second:($t@60@08))[i@61@08]) | live]
(push) ; 14
; [then-branch: 85 | 0 <= First:(Second:($t@60@08))[i@61@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
    i@61@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@61@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11444
;  :arith-add-rows          239
;  :arith-assert-diseq      632
;  :arith-assert-lower      1146
;  :arith-assert-upper      772
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        721
;  :arith-fixed-eqs         396
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               213
;  :datatype-accessor-ax    306
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2246
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5289
;  :mk-clause               2353
;  :num-allocs              4705664
;  :num-checks              266
;  :propagations            1754
;  :quant-instantiations    651
;  :rlimit-count            253900)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 85 | !(0 <= First:(Second:($t@60@08))[i@61@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
      i@61@08))))
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
; [else-branch: 83 | !(i@61@08 < |First:(Second:($t@60@08))| && 0 <= i@61@08)]
(assert (not
  (and
    (<
      i@61@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))
    (<= 0 i@61@08))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@61@08 Int)) (!
  (implies
    (and
      (<
        i@61@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))
      (<= 0 i@61@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
          i@61@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
            i@61@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
            i@61@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
    i@61@08))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))
  $Snap.unit))
; [eval] diz.Main_event_state == old(diz.Main_event_state)
; [eval] old(diz.Main_event_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
  __flatten_50__72@58@08))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11464
;  :arith-add-rows          239
;  :arith-assert-diseq      632
;  :arith-assert-lower      1147
;  :arith-assert-upper      773
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        723
;  :arith-fixed-eqs         397
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               213
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2247
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5312
;  :mk-clause               2369
;  :num-allocs              4705664
;  :num-checks              267
;  :propagations            1760
;  :quant-instantiations    653
;  :rlimit-count            254929)
(push) ; 8
; [then-branch: 86 | 0 <= First:(Second:($t@46@08))[0] | live]
; [else-branch: 86 | !(0 <= First:(Second:($t@46@08))[0]) | live]
(push) ; 9
; [then-branch: 86 | 0 <= First:(Second:($t@46@08))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11464
;  :arith-add-rows          239
;  :arith-assert-diseq      632
;  :arith-assert-lower      1147
;  :arith-assert-upper      773
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        723
;  :arith-fixed-eqs         397
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               213
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2247
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5312
;  :mk-clause               2369
;  :num-allocs              4705664
;  :num-checks              268
;  :propagations            1760
;  :quant-instantiations    653
;  :rlimit-count            255029)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11464
;  :arith-add-rows          239
;  :arith-assert-diseq      632
;  :arith-assert-lower      1147
;  :arith-assert-upper      773
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        723
;  :arith-fixed-eqs         397
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               213
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2247
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5312
;  :mk-clause               2369
;  :num-allocs              4705664
;  :num-checks              269
;  :propagations            1760
;  :quant-instantiations    653
;  :rlimit-count            255038)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (Seq_length __flatten_50__72@58@08))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11464
;  :arith-add-rows          239
;  :arith-assert-diseq      632
;  :arith-assert-lower      1147
;  :arith-assert-upper      773
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        723
;  :arith-fixed-eqs         397
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               214
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2247
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5312
;  :mk-clause               2369
;  :num-allocs              4705664
;  :num-checks              270
;  :propagations            1760
;  :quant-instantiations    653
;  :rlimit-count            255126)
(push) ; 10
; [then-branch: 87 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 | live]
; [else-branch: 87 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] != 0 | live]
(push) ; 11
; [then-branch: 87 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_50__72@58@08
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 87 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_50__72@58@08
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11465
;  :arith-add-rows          240
;  :arith-assert-diseq      632
;  :arith-assert-lower      1147
;  :arith-assert-upper      773
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        723
;  :arith-fixed-eqs         397
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               214
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2247
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5317
;  :mk-clause               2374
;  :num-allocs              4705664
;  :num-checks              271
;  :propagations            1760
;  :quant-instantiations    654
;  :rlimit-count            255341)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11465
;  :arith-add-rows          240
;  :arith-assert-diseq      632
;  :arith-assert-lower      1147
;  :arith-assert-upper      773
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        723
;  :arith-fixed-eqs         397
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               214
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2247
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5317
;  :mk-clause               2374
;  :num-allocs              4705664
;  :num-checks              272
;  :propagations            1760
;  :quant-instantiations    654
;  :rlimit-count            255350)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (Seq_length __flatten_50__72@58@08))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11465
;  :arith-add-rows          240
;  :arith-assert-diseq      632
;  :arith-assert-lower      1147
;  :arith-assert-upper      773
;  :arith-bound-prop        113
;  :arith-conflicts         27
;  :arith-eq-adapter        723
;  :arith-fixed-eqs         397
;  :arith-offset-eqs        55
;  :arith-pivots            366
;  :binary-propagations     7
;  :conflicts               215
;  :datatype-accessor-ax    308
;  :datatype-constructor-ax 2266
;  :datatype-occurs-check   812
;  :datatype-splits         1515
;  :decisions               2362
;  :del-clause              2247
;  :final-checks            212
;  :interface-eqs           27
;  :max-generation          3
;  :max-memory              4.64
;  :memory                  4.64
;  :minimized-lits          87
;  :mk-bool-var             5317
;  :mk-clause               2374
;  :num-allocs              4705664
;  :num-checks              273
;  :propagations            1760
;  :quant-instantiations    654
;  :rlimit-count            255438)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 86 | !(0 <= First:(Second:($t@46@08))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               11745
;  :arith-add-rows          243
;  :arith-assert-diseq      648
;  :arith-assert-lower      1186
;  :arith-assert-upper      795
;  :arith-bound-prop        117
;  :arith-conflicts         27
;  :arith-eq-adapter        745
;  :arith-fixed-eqs         405
;  :arith-offset-eqs        57
;  :arith-pivots            377
;  :binary-propagations     7
;  :conflicts               218
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 2328
;  :datatype-occurs-check   834
;  :datatype-splits         1551
;  :decisions               2431
;  :del-clause              2328
;  :final-checks            218
;  :interface-eqs           29
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          87
;  :mk-bool-var             5450
;  :mk-clause               2450
;  :num-allocs              4916439
;  :num-checks              274
;  :propagations            1807
;  :quant-instantiations    669
;  :rlimit-count            257866
;  :time                    0.00)
(push) ; 9
(assert (not (and
  (or
    (=
      (Seq_index
        __flatten_50__72@58@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      0)
    (=
      (Seq_index
        __flatten_50__72@58@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12626
;  :arith-add-rows          261
;  :arith-assert-diseq      689
;  :arith-assert-lower      1292
;  :arith-assert-upper      845
;  :arith-bound-prop        122
;  :arith-conflicts         28
;  :arith-eq-adapter        807
;  :arith-fixed-eqs         443
;  :arith-offset-eqs        62
;  :arith-pivots            405
;  :binary-propagations     7
;  :conflicts               226
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 2515
;  :datatype-occurs-check   898
;  :datatype-splits         1713
;  :decisions               2616
;  :del-clause              2528
;  :final-checks            229
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          92
;  :mk-bool-var             5878
;  :mk-clause               2650
;  :num-allocs              4916439
;  :num-checks              275
;  :propagations            1929
;  :quant-instantiations    719
;  :rlimit-count            263468
;  :time                    0.00)
; [then-branch: 88 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0] | live]
; [else-branch: 88 | !(__flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0]) | live]
(push) ; 9
; [then-branch: 88 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_50__72@58@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      0)
    (=
      (Seq_index
        __flatten_50__72@58@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0))))
; [eval] diz.Main_process_state[0] == -1
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12626
;  :arith-add-rows          261
;  :arith-assert-diseq      689
;  :arith-assert-lower      1292
;  :arith-assert-upper      845
;  :arith-bound-prop        122
;  :arith-conflicts         28
;  :arith-eq-adapter        807
;  :arith-fixed-eqs         443
;  :arith-offset-eqs        62
;  :arith-pivots            405
;  :binary-propagations     7
;  :conflicts               226
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 2515
;  :datatype-occurs-check   898
;  :datatype-splits         1713
;  :decisions               2616
;  :del-clause              2528
;  :final-checks            229
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          92
;  :mk-bool-var             5880
;  :mk-clause               2651
;  :num-allocs              4916439
;  :num-checks              276
;  :propagations            1929
;  :quant-instantiations    719
;  :rlimit-count            263636)
; [eval] -1
(pop) ; 9
(push) ; 9
; [else-branch: 88 | !(__flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
        0)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
      0)
    (- 0 1))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@60@08))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12631
;  :arith-add-rows          261
;  :arith-assert-diseq      689
;  :arith-assert-lower      1292
;  :arith-assert-upper      845
;  :arith-bound-prop        122
;  :arith-conflicts         28
;  :arith-eq-adapter        807
;  :arith-fixed-eqs         443
;  :arith-offset-eqs        62
;  :arith-pivots            405
;  :binary-propagations     7
;  :conflicts               226
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 2515
;  :datatype-occurs-check   898
;  :datatype-splits         1713
;  :decisions               2616
;  :del-clause              2529
;  :final-checks            229
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          92
;  :mk-bool-var             5885
;  :mk-clause               2655
;  :num-allocs              4916439
;  :num-checks              277
;  :propagations            1929
;  :quant-instantiations    719
;  :rlimit-count            264018)
(push) ; 8
; [then-branch: 89 | 0 <= First:(Second:($t@46@08))[0] | live]
; [else-branch: 89 | !(0 <= First:(Second:($t@46@08))[0]) | live]
(push) ; 9
; [then-branch: 89 | 0 <= First:(Second:($t@46@08))[0]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12631
;  :arith-add-rows          261
;  :arith-assert-diseq      689
;  :arith-assert-lower      1292
;  :arith-assert-upper      845
;  :arith-bound-prop        122
;  :arith-conflicts         28
;  :arith-eq-adapter        807
;  :arith-fixed-eqs         443
;  :arith-offset-eqs        62
;  :arith-pivots            405
;  :binary-propagations     7
;  :conflicts               226
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 2515
;  :datatype-occurs-check   898
;  :datatype-splits         1713
;  :decisions               2616
;  :del-clause              2529
;  :final-checks            229
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          92
;  :mk-bool-var             5885
;  :mk-clause               2655
;  :num-allocs              4916439
;  :num-checks              278
;  :propagations            1929
;  :quant-instantiations    719
;  :rlimit-count            264118)
(push) ; 10
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12631
;  :arith-add-rows          261
;  :arith-assert-diseq      689
;  :arith-assert-lower      1292
;  :arith-assert-upper      845
;  :arith-bound-prop        122
;  :arith-conflicts         28
;  :arith-eq-adapter        807
;  :arith-fixed-eqs         443
;  :arith-offset-eqs        62
;  :arith-pivots            405
;  :binary-propagations     7
;  :conflicts               226
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 2515
;  :datatype-occurs-check   898
;  :datatype-splits         1713
;  :decisions               2616
;  :del-clause              2529
;  :final-checks            229
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          92
;  :mk-bool-var             5885
;  :mk-clause               2655
;  :num-allocs              4916439
;  :num-checks              279
;  :propagations            1929
;  :quant-instantiations    719
;  :rlimit-count            264127)
(push) ; 10
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (Seq_length __flatten_50__72@58@08))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12631
;  :arith-add-rows          261
;  :arith-assert-diseq      689
;  :arith-assert-lower      1292
;  :arith-assert-upper      845
;  :arith-bound-prop        122
;  :arith-conflicts         28
;  :arith-eq-adapter        807
;  :arith-fixed-eqs         443
;  :arith-offset-eqs        62
;  :arith-pivots            405
;  :binary-propagations     7
;  :conflicts               227
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 2515
;  :datatype-occurs-check   898
;  :datatype-splits         1713
;  :decisions               2616
;  :del-clause              2529
;  :final-checks            229
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          92
;  :mk-bool-var             5885
;  :mk-clause               2655
;  :num-allocs              4916439
;  :num-checks              280
;  :propagations            1929
;  :quant-instantiations    719
;  :rlimit-count            264215)
(push) ; 10
; [then-branch: 90 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 | live]
; [else-branch: 90 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] != 0 | live]
(push) ; 11
; [then-branch: 90 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0]
(assert (=
  (Seq_index
    __flatten_50__72@58@08
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0))
  0))
(pop) ; 11
(push) ; 11
; [else-branch: 90 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] != 0]
(assert (not
  (=
    (Seq_index
      __flatten_50__72@58@08
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12632
;  :arith-add-rows          263
;  :arith-assert-diseq      689
;  :arith-assert-lower      1292
;  :arith-assert-upper      845
;  :arith-bound-prop        122
;  :arith-conflicts         28
;  :arith-eq-adapter        807
;  :arith-fixed-eqs         443
;  :arith-offset-eqs        62
;  :arith-pivots            405
;  :binary-propagations     7
;  :conflicts               227
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 2515
;  :datatype-occurs-check   898
;  :datatype-splits         1713
;  :decisions               2616
;  :del-clause              2529
;  :final-checks            229
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          92
;  :mk-bool-var             5889
;  :mk-clause               2660
;  :num-allocs              4916439
;  :num-checks              281
;  :propagations            1929
;  :quant-instantiations    720
;  :rlimit-count            264373)
(push) ; 12
(assert (not (>=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12632
;  :arith-add-rows          263
;  :arith-assert-diseq      689
;  :arith-assert-lower      1292
;  :arith-assert-upper      845
;  :arith-bound-prop        122
;  :arith-conflicts         28
;  :arith-eq-adapter        807
;  :arith-fixed-eqs         443
;  :arith-offset-eqs        62
;  :arith-pivots            405
;  :binary-propagations     7
;  :conflicts               227
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 2515
;  :datatype-occurs-check   898
;  :datatype-splits         1713
;  :decisions               2616
;  :del-clause              2529
;  :final-checks            229
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          92
;  :mk-bool-var             5889
;  :mk-clause               2660
;  :num-allocs              4916439
;  :num-checks              282
;  :propagations            1929
;  :quant-instantiations    720
;  :rlimit-count            264382)
(push) ; 12
(assert (not (<
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (Seq_length __flatten_50__72@58@08))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               12632
;  :arith-add-rows          263
;  :arith-assert-diseq      689
;  :arith-assert-lower      1292
;  :arith-assert-upper      845
;  :arith-bound-prop        122
;  :arith-conflicts         28
;  :arith-eq-adapter        807
;  :arith-fixed-eqs         443
;  :arith-offset-eqs        62
;  :arith-pivots            405
;  :binary-propagations     7
;  :conflicts               228
;  :datatype-accessor-ax    334
;  :datatype-constructor-ax 2515
;  :datatype-occurs-check   898
;  :datatype-splits         1713
;  :decisions               2616
;  :del-clause              2529
;  :final-checks            229
;  :interface-eqs           31
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          92
;  :mk-bool-var             5889
;  :mk-clause               2660
;  :num-allocs              4916439
;  :num-checks              283
;  :propagations            1929
;  :quant-instantiations    720
;  :rlimit-count            264470)
; [eval] -1
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 89 | !(0 <= First:(Second:($t@46@08))[0])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
        __flatten_50__72@58@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      0)
    (=
      (Seq_index
        __flatten_50__72@58@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13222
;  :arith-add-rows          278
;  :arith-assert-diseq      722
;  :arith-assert-lower      1375
;  :arith-assert-upper      883
;  :arith-bound-prop        127
;  :arith-conflicts         29
;  :arith-eq-adapter        854
;  :arith-fixed-eqs         465
;  :arith-offset-eqs        65
;  :arith-pivots            421
;  :binary-propagations     7
;  :conflicts               236
;  :datatype-accessor-ax    347
;  :datatype-constructor-ax 2638
;  :datatype-occurs-check   944
;  :datatype-splits         1811
;  :decisions               2743
;  :del-clause              2683
;  :final-checks            237
;  :interface-eqs           33
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          97
;  :mk-bool-var             6184
;  :mk-clause               2809
;  :num-allocs              4916439
;  :num-checks              284
;  :propagations            2022
;  :quant-instantiations    761
;  :rlimit-count            268657
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (and
    (or
      (=
        (Seq_index
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
        0))))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13603
;  :arith-add-rows          291
;  :arith-assert-diseq      740
;  :arith-assert-lower      1421
;  :arith-assert-upper      907
;  :arith-bound-prop        131
;  :arith-conflicts         29
;  :arith-eq-adapter        880
;  :arith-fixed-eqs         474
;  :arith-offset-eqs        65
;  :arith-pivots            431
;  :binary-propagations     7
;  :conflicts               245
;  :datatype-accessor-ax    356
;  :datatype-constructor-ax 2720
;  :datatype-occurs-check   971
;  :datatype-splits         1852
;  :decisions               2832
;  :del-clause              2773
;  :final-checks            243
;  :interface-eqs           34
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          99
;  :mk-bool-var             6354
;  :mk-clause               2899
;  :num-allocs              4916439
;  :num-checks              285
;  :propagations            2076
;  :quant-instantiations    788
;  :rlimit-count            271630
;  :time                    0.00)
; [then-branch: 91 | !(__flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0]) | live]
; [else-branch: 91 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0] | live]
(push) ; 9
; [then-branch: 91 | !(__flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0])]
(assert (not
  (and
    (or
      (=
        (Seq_index
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        0)
      (=
        (Seq_index
          __flatten_50__72@58@08
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            0))
        (- 0 1)))
    (<=
      0
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
        0)))))
; [eval] diz.Main_process_state[0] == old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13604
;  :arith-add-rows          293
;  :arith-assert-diseq      740
;  :arith-assert-lower      1421
;  :arith-assert-upper      907
;  :arith-bound-prop        131
;  :arith-conflicts         29
;  :arith-eq-adapter        880
;  :arith-fixed-eqs         474
;  :arith-offset-eqs        65
;  :arith-pivots            431
;  :binary-propagations     7
;  :conflicts               245
;  :datatype-accessor-ax    356
;  :datatype-constructor-ax 2720
;  :datatype-occurs-check   971
;  :datatype-splits         1852
;  :decisions               2832
;  :del-clause              2773
;  :final-checks            243
;  :interface-eqs           34
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          99
;  :mk-bool-var             6358
;  :mk-clause               2904
;  :num-allocs              4916439
;  :num-checks              286
;  :propagations            2078
;  :quant-instantiations    789
;  :rlimit-count            271818)
; [eval] old(diz.Main_process_state[0])
; [eval] diz.Main_process_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               13604
;  :arith-add-rows          293
;  :arith-assert-diseq      740
;  :arith-assert-lower      1421
;  :arith-assert-upper      907
;  :arith-bound-prop        131
;  :arith-conflicts         29
;  :arith-eq-adapter        880
;  :arith-fixed-eqs         474
;  :arith-offset-eqs        65
;  :arith-pivots            431
;  :binary-propagations     7
;  :conflicts               245
;  :datatype-accessor-ax    356
;  :datatype-constructor-ax 2720
;  :datatype-occurs-check   971
;  :datatype-splits         1852
;  :decisions               2832
;  :del-clause              2773
;  :final-checks            243
;  :interface-eqs           34
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          99
;  :mk-bool-var             6358
;  :mk-clause               2904
;  :num-allocs              4916439
;  :num-checks              287
;  :propagations            2078
;  :quant-instantiations    789
;  :rlimit-count            271833)
(pop) ; 9
(push) ; 9
; [else-branch: 91 | __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == 0 || __flatten_50__72@58@08[First:(Second:($t@46@08))[0]] == -1 && 0 <= First:(Second:($t@46@08))[0]]
(assert (and
  (or
    (=
      (Seq_index
        __flatten_50__72@58@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      0)
    (=
      (Seq_index
        __flatten_50__72@58@08
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))
      (- 0 1)))
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
            __flatten_50__72@58@08
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
              0))
          0)
        (=
          (Seq_index
            __flatten_50__72@58@08
            (Seq_index
              ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
              0))
          (- 0 1)))
      (<=
        0
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          0))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
(declare-const i@62@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 92 | 0 <= i@62@08 | live]
; [else-branch: 92 | !(0 <= i@62@08) | live]
(push) ; 10
; [then-branch: 92 | 0 <= i@62@08]
(assert (<= 0 i@62@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 92 | !(0 <= i@62@08)]
(assert (not (<= 0 i@62@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 93 | i@62@08 < |First:(Second:($t@60@08))| && 0 <= i@62@08 | live]
; [else-branch: 93 | !(i@62@08 < |First:(Second:($t@60@08))| && 0 <= i@62@08) | live]
(push) ; 10
; [then-branch: 93 | i@62@08 < |First:(Second:($t@60@08))| && 0 <= i@62@08]
(assert (and
  (<
    i@62@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))
  (<= 0 i@62@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@62@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14367
;  :arith-add-rows          320
;  :arith-assert-diseq      784
;  :arith-assert-lower      1520
;  :arith-assert-upper      951
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        936
;  :arith-fixed-eqs         513
;  :arith-offset-eqs        70
;  :arith-pivots            461
;  :binary-propagations     7
;  :conflicts               253
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 2875
;  :datatype-occurs-check   1029
;  :datatype-splits         1982
;  :decisions               2993
;  :del-clause              2963
;  :final-checks            251
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6724
;  :mk-clause               3099
;  :num-allocs              4916439
;  :num-checks              289
;  :propagations            2200
;  :quant-instantiations    842
;  :rlimit-count            277240)
; [eval] -1
(push) ; 11
; [then-branch: 94 | First:(Second:($t@60@08))[i@62@08] == -1 | live]
; [else-branch: 94 | First:(Second:($t@60@08))[i@62@08] != -1 | live]
(push) ; 12
; [then-branch: 94 | First:(Second:($t@60@08))[i@62@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
    i@62@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 94 | First:(Second:($t@60@08))[i@62@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
      i@62@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@62@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14373
;  :arith-add-rows          321
;  :arith-assert-diseq      786
;  :arith-assert-lower      1524
;  :arith-assert-upper      953
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        938
;  :arith-fixed-eqs         514
;  :arith-offset-eqs        70
;  :arith-pivots            462
;  :binary-propagations     7
;  :conflicts               253
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 2875
;  :datatype-occurs-check   1029
;  :datatype-splits         1982
;  :decisions               2993
;  :del-clause              2963
;  :final-checks            251
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6733
;  :mk-clause               3104
;  :num-allocs              4916439
;  :num-checks              290
;  :propagations            2207
;  :quant-instantiations    844
;  :rlimit-count            277447)
(push) ; 13
; [then-branch: 95 | 0 <= First:(Second:($t@60@08))[i@62@08] | live]
; [else-branch: 95 | !(0 <= First:(Second:($t@60@08))[i@62@08]) | live]
(push) ; 14
; [then-branch: 95 | 0 <= First:(Second:($t@60@08))[i@62@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
    i@62@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@62@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14375
;  :arith-add-rows          322
;  :arith-assert-diseq      786
;  :arith-assert-lower      1526
;  :arith-assert-upper      954
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        939
;  :arith-fixed-eqs         515
;  :arith-offset-eqs        70
;  :arith-pivots            463
;  :binary-propagations     7
;  :conflicts               253
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 2875
;  :datatype-occurs-check   1029
;  :datatype-splits         1982
;  :decisions               2993
;  :del-clause              2963
;  :final-checks            251
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6737
;  :mk-clause               3104
;  :num-allocs              4916439
;  :num-checks              291
;  :propagations            2207
;  :quant-instantiations    844
;  :rlimit-count            277564)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 95 | !(0 <= First:(Second:($t@60@08))[i@62@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
      i@62@08))))
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
; [else-branch: 93 | !(i@62@08 < |First:(Second:($t@60@08))| && 0 <= i@62@08)]
(assert (not
  (and
    (<
      i@62@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))
    (<= 0 i@62@08))))
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
(assert (not (forall ((i@62@08 Int)) (!
  (implies
    (and
      (<
        i@62@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))
      (<= 0 i@62@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
          i@62@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
            i@62@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
            i@62@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
    i@62@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14375
;  :arith-add-rows          322
;  :arith-assert-diseq      787
;  :arith-assert-lower      1527
;  :arith-assert-upper      955
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        940
;  :arith-fixed-eqs         516
;  :arith-offset-eqs        70
;  :arith-pivots            465
;  :binary-propagations     7
;  :conflicts               254
;  :datatype-accessor-ax    373
;  :datatype-constructor-ax 2875
;  :datatype-occurs-check   1029
;  :datatype-splits         1982
;  :decisions               2993
;  :del-clause              2980
;  :final-checks            251
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6745
;  :mk-clause               3116
;  :num-allocs              4916439
;  :num-checks              292
;  :propagations            2209
;  :quant-instantiations    845
;  :rlimit-count            277995)
(assert (forall ((i@62@08 Int)) (!
  (implies
    (and
      (<
        i@62@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))
      (<= 0 i@62@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
          i@62@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
            i@62@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
            i@62@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))
    i@62@08))
  :qid |prog.l<no position>|)))
(declare-const $t@63@08 $Snap)
(assert (= $t@63@08 ($Snap.combine ($Snap.first $t@63@08) ($Snap.second $t@63@08))))
(assert (=
  ($Snap.second $t@63@08)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@63@08))
    ($Snap.second ($Snap.second $t@63@08)))))
(assert (=
  ($Snap.second ($Snap.second $t@63@08))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@63@08)))
    ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@63@08))) $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@63@08)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@64@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 96 | 0 <= i@64@08 | live]
; [else-branch: 96 | !(0 <= i@64@08) | live]
(push) ; 10
; [then-branch: 96 | 0 <= i@64@08]
(assert (<= 0 i@64@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 96 | !(0 <= i@64@08)]
(assert (not (<= 0 i@64@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 97 | i@64@08 < |First:(Second:($t@63@08))| && 0 <= i@64@08 | live]
; [else-branch: 97 | !(i@64@08 < |First:(Second:($t@63@08))| && 0 <= i@64@08) | live]
(push) ; 10
; [then-branch: 97 | i@64@08 < |First:(Second:($t@63@08))| && 0 <= i@64@08]
(assert (and
  (<
    i@64@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))))
  (<= 0 i@64@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@64@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14413
;  :arith-add-rows          322
;  :arith-assert-diseq      787
;  :arith-assert-lower      1532
;  :arith-assert-upper      958
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        942
;  :arith-fixed-eqs         517
;  :arith-offset-eqs        70
;  :arith-pivots            465
;  :binary-propagations     7
;  :conflicts               254
;  :datatype-accessor-ax    379
;  :datatype-constructor-ax 2875
;  :datatype-occurs-check   1029
;  :datatype-splits         1982
;  :decisions               2993
;  :del-clause              2980
;  :final-checks            251
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6767
;  :mk-clause               3116
;  :num-allocs              4916439
;  :num-checks              293
;  :propagations            2209
;  :quant-instantiations    849
;  :rlimit-count            279387)
; [eval] -1
(push) ; 11
; [then-branch: 98 | First:(Second:($t@63@08))[i@64@08] == -1 | live]
; [else-branch: 98 | First:(Second:($t@63@08))[i@64@08] != -1 | live]
(push) ; 12
; [then-branch: 98 | First:(Second:($t@63@08))[i@64@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
    i@64@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 98 | First:(Second:($t@63@08))[i@64@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
      i@64@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@64@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14413
;  :arith-add-rows          322
;  :arith-assert-diseq      787
;  :arith-assert-lower      1532
;  :arith-assert-upper      958
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        942
;  :arith-fixed-eqs         517
;  :arith-offset-eqs        70
;  :arith-pivots            465
;  :binary-propagations     7
;  :conflicts               254
;  :datatype-accessor-ax    379
;  :datatype-constructor-ax 2875
;  :datatype-occurs-check   1029
;  :datatype-splits         1982
;  :decisions               2993
;  :del-clause              2980
;  :final-checks            251
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6768
;  :mk-clause               3116
;  :num-allocs              4916439
;  :num-checks              294
;  :propagations            2209
;  :quant-instantiations    849
;  :rlimit-count            279538)
(push) ; 13
; [then-branch: 99 | 0 <= First:(Second:($t@63@08))[i@64@08] | live]
; [else-branch: 99 | !(0 <= First:(Second:($t@63@08))[i@64@08]) | live]
(push) ; 14
; [then-branch: 99 | 0 <= First:(Second:($t@63@08))[i@64@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
    i@64@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@64@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14413
;  :arith-add-rows          322
;  :arith-assert-diseq      788
;  :arith-assert-lower      1535
;  :arith-assert-upper      958
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        943
;  :arith-fixed-eqs         517
;  :arith-offset-eqs        70
;  :arith-pivots            465
;  :binary-propagations     7
;  :conflicts               254
;  :datatype-accessor-ax    379
;  :datatype-constructor-ax 2875
;  :datatype-occurs-check   1029
;  :datatype-splits         1982
;  :decisions               2993
;  :del-clause              2980
;  :final-checks            251
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6771
;  :mk-clause               3117
;  :num-allocs              4916439
;  :num-checks              295
;  :propagations            2209
;  :quant-instantiations    849
;  :rlimit-count            279642)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 99 | !(0 <= First:(Second:($t@63@08))[i@64@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
      i@64@08))))
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
; [else-branch: 97 | !(i@64@08 < |First:(Second:($t@63@08))| && 0 <= i@64@08)]
(assert (not
  (and
    (<
      i@64@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))))
    (<= 0 i@64@08))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(pop) ; 8
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@64@08 Int)) (!
  (implies
    (and
      (<
        i@64@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))))
      (<= 0 i@64@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
          i@64@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
            i@64@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
            i@64@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
    i@64@08))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))
  $Snap.unit))
; [eval] diz.Main_process_state == old(diz.Main_process_state)
; [eval] old(diz.Main_process_state)
(assert (Seq_equal
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
  ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@60@08)))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14431
;  :arith-add-rows          322
;  :arith-assert-diseq      788
;  :arith-assert-lower      1536
;  :arith-assert-upper      959
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        944
;  :arith-fixed-eqs         518
;  :arith-offset-eqs        70
;  :arith-pivots            465
;  :binary-propagations     7
;  :conflicts               254
;  :datatype-accessor-ax    381
;  :datatype-constructor-ax 2875
;  :datatype-occurs-check   1029
;  :datatype-splits         1982
;  :decisions               2993
;  :del-clause              2981
;  :final-checks            251
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6791
;  :mk-clause               3127
;  :num-allocs              4916439
;  :num-checks              296
;  :propagations            2213
;  :quant-instantiations    851
;  :rlimit-count            280657)
(push) ; 8
; [then-branch: 100 | First:(Second:(Second:(Second:($t@60@08))))[0] == 0 | live]
; [else-branch: 100 | First:(Second:(Second:(Second:($t@60@08))))[0] != 0 | live]
(push) ; 9
; [then-branch: 100 | First:(Second:(Second:(Second:($t@60@08))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 100 | First:(Second:(Second:(Second:($t@60@08))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14432
;  :arith-add-rows          322
;  :arith-assert-diseq      788
;  :arith-assert-lower      1536
;  :arith-assert-upper      959
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        944
;  :arith-fixed-eqs         518
;  :arith-offset-eqs        70
;  :arith-pivots            465
;  :binary-propagations     7
;  :conflicts               254
;  :datatype-accessor-ax    381
;  :datatype-constructor-ax 2875
;  :datatype-occurs-check   1029
;  :datatype-splits         1982
;  :decisions               2993
;  :del-clause              2981
;  :final-checks            251
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6792
;  :mk-clause               3128
;  :num-allocs              4916439
;  :num-checks              297
;  :propagations            2213
;  :quant-instantiations    852
;  :rlimit-count            280866)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               14753
;  :arith-add-rows          325
;  :arith-assert-diseq      808
;  :arith-assert-lower      1578
;  :arith-assert-upper      975
;  :arith-bound-prop        138
;  :arith-conflicts         30
;  :arith-eq-adapter        964
;  :arith-fixed-eqs         532
;  :arith-offset-eqs        71
;  :arith-pivots            478
;  :binary-propagations     7
;  :conflicts               255
;  :datatype-accessor-ax    388
;  :datatype-constructor-ax 2947
;  :datatype-occurs-check   1053
;  :datatype-splits         2022
;  :decisions               3073
;  :del-clause              3047
;  :final-checks            254
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          104
;  :mk-bool-var             6896
;  :mk-clause               3193
;  :num-allocs              4916439
;  :num-checks              298
;  :propagations            2266
;  :quant-instantiations    868
;  :rlimit-count            283461
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15370
;  :arith-add-rows          348
;  :arith-assert-diseq      881
;  :arith-assert-lower      1715
;  :arith-assert-upper      1034
;  :arith-bound-prop        147
;  :arith-conflicts         31
;  :arith-eq-adapter        1037
;  :arith-fixed-eqs         572
;  :arith-offset-eqs        93
;  :arith-pivots            509
;  :binary-propagations     7
;  :conflicts               266
;  :datatype-accessor-ax    403
;  :datatype-constructor-ax 3042
;  :datatype-occurs-check   1103
;  :datatype-splits         2130
;  :decisions               3186
;  :del-clause              3295
;  :final-checks            259
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          107
;  :mk-bool-var             7234
;  :mk-clause               3441
;  :num-allocs              4916439
;  :num-checks              299
;  :propagations            2478
;  :quant-instantiations    939
;  :rlimit-count            288119
;  :time                    0.00)
; [then-branch: 101 | First:(Second:(Second:(Second:($t@60@08))))[0] == 0 || First:(Second:(Second:(Second:($t@60@08))))[0] == -1 | live]
; [else-branch: 101 | !(First:(Second:(Second:(Second:($t@60@08))))[0] == 0 || First:(Second:(Second:(Second:($t@60@08))))[0] == -1) | live]
(push) ; 9
; [then-branch: 101 | First:(Second:(Second:(Second:($t@60@08))))[0] == 0 || First:(Second:(Second:(Second:($t@60@08))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0)
    (- 0 1))))
; [eval] diz.Main_event_state[0] == -2
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15371
;  :arith-add-rows          348
;  :arith-assert-diseq      881
;  :arith-assert-lower      1715
;  :arith-assert-upper      1034
;  :arith-bound-prop        147
;  :arith-conflicts         31
;  :arith-eq-adapter        1037
;  :arith-fixed-eqs         572
;  :arith-offset-eqs        93
;  :arith-pivots            509
;  :binary-propagations     7
;  :conflicts               266
;  :datatype-accessor-ax    403
;  :datatype-constructor-ax 3042
;  :datatype-occurs-check   1103
;  :datatype-splits         2130
;  :decisions               3186
;  :del-clause              3295
;  :final-checks            259
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          107
;  :mk-bool-var             7236
;  :mk-clause               3442
;  :num-allocs              4916439
;  :num-checks              300
;  :propagations            2478
;  :quant-instantiations    939
;  :rlimit-count            288269)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 101 | !(First:(Second:(Second:(Second:($t@60@08))))[0] == 0 || First:(Second:(Second:(Second:($t@60@08))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        0)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))
      0)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15378
;  :arith-add-rows          348
;  :arith-assert-diseq      881
;  :arith-assert-lower      1715
;  :arith-assert-upper      1034
;  :arith-bound-prop        147
;  :arith-conflicts         31
;  :arith-eq-adapter        1037
;  :arith-fixed-eqs         572
;  :arith-offset-eqs        93
;  :arith-pivots            509
;  :binary-propagations     7
;  :conflicts               266
;  :datatype-accessor-ax    404
;  :datatype-constructor-ax 3042
;  :datatype-occurs-check   1103
;  :datatype-splits         2130
;  :decisions               3186
;  :del-clause              3296
;  :final-checks            259
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          107
;  :mk-bool-var             7242
;  :mk-clause               3446
;  :num-allocs              4916439
;  :num-checks              301
;  :propagations            2478
;  :quant-instantiations    939
;  :rlimit-count            288753)
(push) ; 8
; [then-branch: 102 | First:(Second:(Second:(Second:($t@60@08))))[1] == 0 | live]
; [else-branch: 102 | First:(Second:(Second:(Second:($t@60@08))))[1] != 0 | live]
(push) ; 9
; [then-branch: 102 | First:(Second:(Second:(Second:($t@60@08))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 102 | First:(Second:(Second:(Second:($t@60@08))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               15379
;  :arith-add-rows          349
;  :arith-assert-diseq      881
;  :arith-assert-lower      1715
;  :arith-assert-upper      1034
;  :arith-bound-prop        147
;  :arith-conflicts         31
;  :arith-eq-adapter        1037
;  :arith-fixed-eqs         572
;  :arith-offset-eqs        93
;  :arith-pivots            509
;  :binary-propagations     7
;  :conflicts               266
;  :datatype-accessor-ax    404
;  :datatype-constructor-ax 3042
;  :datatype-occurs-check   1103
;  :datatype-splits         2130
;  :decisions               3186
;  :del-clause              3296
;  :final-checks            259
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          107
;  :mk-bool-var             7247
;  :mk-clause               3452
;  :num-allocs              4916439
;  :num-checks              302
;  :propagations            2478
;  :quant-instantiations    940
;  :rlimit-count            288938)
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16237
;  :arith-add-rows          359
;  :arith-assert-diseq      921
;  :arith-assert-lower      1800
;  :arith-assert-upper      1077
;  :arith-bound-prop        150
;  :arith-conflicts         32
;  :arith-eq-adapter        1081
;  :arith-fixed-eqs         615
;  :arith-offset-eqs        113
;  :arith-pivots            525
;  :binary-propagations     7
;  :conflicts               280
;  :datatype-accessor-ax    423
;  :datatype-constructor-ax 3191
;  :datatype-occurs-check   1159
;  :datatype-splits         2220
;  :decisions               3347
;  :del-clause              3457
;  :final-checks            266
;  :interface-eqs           35
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          110
;  :mk-bool-var             7524
;  :mk-clause               3607
;  :num-allocs              4916439
;  :num-checks              303
;  :propagations            2647
;  :quant-instantiations    997
;  :rlimit-count            294472
;  :time                    0.00)
(push) ; 9
(assert (not (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16819
;  :arith-add-rows          366
;  :arith-assert-diseq      969
;  :arith-assert-lower      1895
;  :arith-assert-upper      1115
;  :arith-bound-prop        155
;  :arith-conflicts         32
;  :arith-eq-adapter        1127
;  :arith-fixed-eqs         651
;  :arith-offset-eqs        119
;  :arith-pivots            547
;  :binary-propagations     7
;  :conflicts               285
;  :datatype-accessor-ax    437
;  :datatype-constructor-ax 3304
;  :datatype-occurs-check   1209
;  :datatype-splits         2302
;  :decisions               3468
;  :del-clause              3605
;  :final-checks            273
;  :interface-eqs           36
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          113
;  :mk-bool-var             7759
;  :mk-clause               3755
;  :num-allocs              4916439
;  :num-checks              304
;  :propagations            2787
;  :quant-instantiations    1040
;  :rlimit-count            298583
;  :time                    0.00)
; [then-branch: 103 | First:(Second:(Second:(Second:($t@60@08))))[1] == 0 || First:(Second:(Second:(Second:($t@60@08))))[1] == -1 | live]
; [else-branch: 103 | !(First:(Second:(Second:(Second:($t@60@08))))[1] == 0 || First:(Second:(Second:(Second:($t@60@08))))[1] == -1) | live]
(push) ; 9
; [then-branch: 103 | First:(Second:(Second:(Second:($t@60@08))))[1] == 0 || First:(Second:(Second:(Second:($t@60@08))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      1)
    (- 0 1))))
; [eval] diz.Main_event_state[1] == -2
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16819
;  :arith-add-rows          366
;  :arith-assert-diseq      969
;  :arith-assert-lower      1895
;  :arith-assert-upper      1115
;  :arith-bound-prop        155
;  :arith-conflicts         32
;  :arith-eq-adapter        1127
;  :arith-fixed-eqs         651
;  :arith-offset-eqs        119
;  :arith-pivots            547
;  :binary-propagations     7
;  :conflicts               285
;  :datatype-accessor-ax    437
;  :datatype-constructor-ax 3304
;  :datatype-occurs-check   1209
;  :datatype-splits         2302
;  :decisions               3468
;  :del-clause              3605
;  :final-checks            273
;  :interface-eqs           36
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          113
;  :mk-bool-var             7761
;  :mk-clause               3756
;  :num-allocs              4916439
;  :num-checks              305
;  :propagations            2787
;  :quant-instantiations    1040
;  :rlimit-count            298732)
; [eval] -2
(pop) ; 9
(push) ; 9
; [else-branch: 103 | !(First:(Second:(Second:(Second:($t@60@08))))[1] == 0 || First:(Second:(Second:(Second:($t@60@08))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
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
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        1)
      (- 0 1)))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))
      1)
    (- 0 2))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16825
;  :arith-add-rows          366
;  :arith-assert-diseq      969
;  :arith-assert-lower      1895
;  :arith-assert-upper      1115
;  :arith-bound-prop        155
;  :arith-conflicts         32
;  :arith-eq-adapter        1127
;  :arith-fixed-eqs         651
;  :arith-offset-eqs        119
;  :arith-pivots            547
;  :binary-propagations     7
;  :conflicts               285
;  :datatype-accessor-ax    438
;  :datatype-constructor-ax 3304
;  :datatype-occurs-check   1209
;  :datatype-splits         2302
;  :decisions               3468
;  :del-clause              3606
;  :final-checks            273
;  :interface-eqs           36
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          113
;  :mk-bool-var             7767
;  :mk-clause               3760
;  :num-allocs              4916439
;  :num-checks              306
;  :propagations            2787
;  :quant-instantiations    1040
;  :rlimit-count            299221)
(push) ; 8
; [then-branch: 104 | First:(Second:(Second:(Second:($t@60@08))))[0] == 0 | live]
; [else-branch: 104 | First:(Second:(Second:(Second:($t@60@08))))[0] != 0 | live]
(push) ; 9
; [then-branch: 104 | First:(Second:(Second:(Second:($t@60@08))))[0] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
    0)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 104 | First:(Second:(Second:(Second:($t@60@08))))[0] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0)
    0)))
; [eval] old(diz.Main_event_state[0]) == -1
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               16825
;  :arith-add-rows          366
;  :arith-assert-diseq      969
;  :arith-assert-lower      1895
;  :arith-assert-upper      1115
;  :arith-bound-prop        155
;  :arith-conflicts         32
;  :arith-eq-adapter        1127
;  :arith-fixed-eqs         651
;  :arith-offset-eqs        119
;  :arith-pivots            547
;  :binary-propagations     7
;  :conflicts               285
;  :datatype-accessor-ax    438
;  :datatype-constructor-ax 3304
;  :datatype-occurs-check   1209
;  :datatype-splits         2302
;  :decisions               3468
;  :del-clause              3606
;  :final-checks            273
;  :interface-eqs           36
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          113
;  :mk-bool-var             7767
;  :mk-clause               3761
;  :num-allocs              4916439
;  :num-checks              307
;  :propagations            2787
;  :quant-instantiations    1041
;  :rlimit-count            299385)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               17551
;  :arith-add-rows          385
;  :arith-assert-diseq      1051
;  :arith-assert-lower      2043
;  :arith-assert-upper      1177
;  :arith-bound-prop        164
;  :arith-conflicts         32
;  :arith-eq-adapter        1203
;  :arith-fixed-eqs         696
;  :arith-offset-eqs        142
;  :arith-pivots            581
;  :binary-propagations     7
;  :conflicts               297
;  :datatype-accessor-ax    452
;  :datatype-constructor-ax 3418
;  :datatype-occurs-check   1259
;  :datatype-splits         2384
;  :decisions               3604
;  :del-clause              3879
;  :final-checks            280
;  :interface-eqs           37
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          117
;  :mk-bool-var             8111
;  :mk-clause               4033
;  :num-allocs              4916439
;  :num-checks              308
;  :propagations            3023
;  :quant-instantiations    1118
;  :rlimit-count            304621
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        0)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18104
;  :arith-add-rows          391
;  :arith-assert-diseq      1088
;  :arith-assert-lower      2120
;  :arith-assert-upper      1206
;  :arith-bound-prop        164
;  :arith-conflicts         32
;  :arith-eq-adapter        1240
;  :arith-fixed-eqs         726
;  :arith-offset-eqs        146
;  :arith-pivots            599
;  :binary-propagations     7
;  :conflicts               301
;  :datatype-accessor-ax    466
;  :datatype-constructor-ax 3530
;  :datatype-occurs-check   1309
;  :datatype-splits         2465
;  :decisions               3732
;  :del-clause              4006
;  :final-checks            287
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          117
;  :mk-bool-var             8312
;  :mk-clause               4160
;  :num-allocs              4916439
;  :num-checks              309
;  :propagations            3130
;  :quant-instantiations    1150
;  :rlimit-count            308501
;  :time                    0.00)
; [then-branch: 105 | !(First:(Second:(Second:(Second:($t@60@08))))[0] == 0 || First:(Second:(Second:(Second:($t@60@08))))[0] == -1) | live]
; [else-branch: 105 | First:(Second:(Second:(Second:($t@60@08))))[0] == 0 || First:(Second:(Second:(Second:($t@60@08))))[0] == -1 | live]
(push) ; 9
; [then-branch: 105 | !(First:(Second:(Second:(Second:($t@60@08))))[0] == 0 || First:(Second:(Second:(Second:($t@60@08))))[0] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        0)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        0)
      (- 0 1)))))
; [eval] diz.Main_event_state[0] == old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18104
;  :arith-add-rows          391
;  :arith-assert-diseq      1088
;  :arith-assert-lower      2120
;  :arith-assert-upper      1206
;  :arith-bound-prop        164
;  :arith-conflicts         32
;  :arith-eq-adapter        1240
;  :arith-fixed-eqs         726
;  :arith-offset-eqs        146
;  :arith-pivots            599
;  :binary-propagations     7
;  :conflicts               301
;  :datatype-accessor-ax    466
;  :datatype-constructor-ax 3530
;  :datatype-occurs-check   1309
;  :datatype-splits         2465
;  :decisions               3732
;  :del-clause              4006
;  :final-checks            287
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          117
;  :mk-bool-var             8312
;  :mk-clause               4161
;  :num-allocs              4916439
;  :num-checks              310
;  :propagations            3131
;  :quant-instantiations    1151
;  :rlimit-count            308686)
; [eval] old(diz.Main_event_state[0])
; [eval] diz.Main_event_state[0]
(push) ; 10
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18104
;  :arith-add-rows          391
;  :arith-assert-diseq      1088
;  :arith-assert-lower      2120
;  :arith-assert-upper      1206
;  :arith-bound-prop        164
;  :arith-conflicts         32
;  :arith-eq-adapter        1240
;  :arith-fixed-eqs         726
;  :arith-offset-eqs        146
;  :arith-pivots            599
;  :binary-propagations     7
;  :conflicts               301
;  :datatype-accessor-ax    466
;  :datatype-constructor-ax 3530
;  :datatype-occurs-check   1309
;  :datatype-splits         2465
;  :decisions               3732
;  :del-clause              4006
;  :final-checks            287
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          117
;  :mk-bool-var             8312
;  :mk-clause               4161
;  :num-allocs              4916439
;  :num-checks              311
;  :propagations            3131
;  :quant-instantiations    1151
;  :rlimit-count            308701)
(pop) ; 9
(push) ; 9
; [else-branch: 105 | First:(Second:(Second:(Second:($t@60@08))))[0] == 0 || First:(Second:(Second:(Second:($t@60@08))))[0] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
          0)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
          0)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))
      0)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      0))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@63@08))))))))))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18111
;  :arith-add-rows          391
;  :arith-assert-diseq      1088
;  :arith-assert-lower      2120
;  :arith-assert-upper      1206
;  :arith-bound-prop        164
;  :arith-conflicts         32
;  :arith-eq-adapter        1240
;  :arith-fixed-eqs         726
;  :arith-offset-eqs        146
;  :arith-pivots            599
;  :binary-propagations     7
;  :conflicts               301
;  :datatype-accessor-ax    466
;  :datatype-constructor-ax 3530
;  :datatype-occurs-check   1309
;  :datatype-splits         2465
;  :decisions               3732
;  :del-clause              4007
;  :final-checks            287
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          117
;  :mk-bool-var             8314
;  :mk-clause               4162
;  :num-allocs              4916439
;  :num-checks              312
;  :propagations            3131
;  :quant-instantiations    1151
;  :rlimit-count            309053)
(push) ; 8
; [then-branch: 106 | First:(Second:(Second:(Second:($t@60@08))))[1] == 0 | live]
; [else-branch: 106 | First:(Second:(Second:(Second:($t@60@08))))[1] != 0 | live]
(push) ; 9
; [then-branch: 106 | First:(Second:(Second:(Second:($t@60@08))))[1] == 0]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
    1)
  0))
(pop) ; 9
(push) ; 9
; [else-branch: 106 | First:(Second:(Second:(Second:($t@60@08))))[1] != 0]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      1)
    0)))
; [eval] old(diz.Main_event_state[1]) == -1
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18112
;  :arith-add-rows          392
;  :arith-assert-diseq      1088
;  :arith-assert-lower      2120
;  :arith-assert-upper      1206
;  :arith-bound-prop        164
;  :arith-conflicts         32
;  :arith-eq-adapter        1240
;  :arith-fixed-eqs         726
;  :arith-offset-eqs        146
;  :arith-pivots            599
;  :binary-propagations     7
;  :conflicts               301
;  :datatype-accessor-ax    466
;  :datatype-constructor-ax 3530
;  :datatype-occurs-check   1309
;  :datatype-splits         2465
;  :decisions               3732
;  :del-clause              4007
;  :final-checks            287
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          117
;  :mk-bool-var             8318
;  :mk-clause               4168
;  :num-allocs              4916439
;  :num-checks              313
;  :propagations            3131
;  :quant-instantiations    1152
;  :rlimit-count            309222)
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
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      1)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               18691
;  :arith-add-rows          398
;  :arith-assert-diseq      1136
;  :arith-assert-lower      2214
;  :arith-assert-upper      1243
;  :arith-bound-prop        169
;  :arith-conflicts         32
;  :arith-eq-adapter        1285
;  :arith-fixed-eqs         761
;  :arith-offset-eqs        152
;  :arith-pivots            619
;  :binary-propagations     7
;  :conflicts               306
;  :datatype-accessor-ax    480
;  :datatype-constructor-ax 3641
;  :datatype-occurs-check   1359
;  :datatype-splits         2545
;  :decisions               3850
;  :del-clause              4159
;  :final-checks            293
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          120
;  :mk-bool-var             8546
;  :mk-clause               4314
;  :num-allocs              4916439
;  :num-checks              314
;  :propagations            3271
;  :quant-instantiations    1196
;  :rlimit-count            313294
;  :time                    0.00)
(push) ; 9
(assert (not (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        1)
      (- 0 1))))))
(check-sat)
; unknown
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19499
;  :arith-add-rows          412
;  :arith-assert-diseq      1177
;  :arith-assert-lower      2299
;  :arith-assert-upper      1286
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1328
;  :arith-fixed-eqs         797
;  :arith-offset-eqs        171
;  :arith-pivots            634
;  :binary-propagations     7
;  :conflicts               320
;  :datatype-accessor-ax    499
;  :datatype-constructor-ax 3774
;  :datatype-occurs-check   1415
;  :datatype-splits         2633
;  :decisions               3995
;  :del-clause              4316
;  :final-checks            300
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          123
;  :mk-bool-var             8816
;  :mk-clause               4471
;  :num-allocs              4916439
;  :num-checks              315
;  :propagations            3457
;  :quant-instantiations    1254
;  :rlimit-count            318446
;  :time                    0.00)
; [then-branch: 107 | !(First:(Second:(Second:(Second:($t@60@08))))[1] == 0 || First:(Second:(Second:(Second:($t@60@08))))[1] == -1) | live]
; [else-branch: 107 | First:(Second:(Second:(Second:($t@60@08))))[1] == 0 || First:(Second:(Second:(Second:($t@60@08))))[1] == -1 | live]
(push) ; 9
; [then-branch: 107 | !(First:(Second:(Second:(Second:($t@60@08))))[1] == 0 || First:(Second:(Second:(Second:($t@60@08))))[1] == -1)]
(assert (not
  (or
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        1)
      0)
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
        1)
      (- 0 1)))))
; [eval] diz.Main_event_state[1] == old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(set-option :timeout 0)
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19500
;  :arith-add-rows          413
;  :arith-assert-diseq      1177
;  :arith-assert-lower      2299
;  :arith-assert-upper      1286
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1328
;  :arith-fixed-eqs         797
;  :arith-offset-eqs        171
;  :arith-pivots            634
;  :binary-propagations     7
;  :conflicts               320
;  :datatype-accessor-ax    499
;  :datatype-constructor-ax 3774
;  :datatype-occurs-check   1415
;  :datatype-splits         2633
;  :decisions               3995
;  :del-clause              4316
;  :final-checks            300
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          123
;  :mk-bool-var             8820
;  :mk-clause               4477
;  :num-allocs              4916439
;  :num-checks              316
;  :propagations            3458
;  :quant-instantiations    1255
;  :rlimit-count            318636)
; [eval] old(diz.Main_event_state[1])
; [eval] diz.Main_event_state[1]
(push) ; 10
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               19500
;  :arith-add-rows          413
;  :arith-assert-diseq      1177
;  :arith-assert-lower      2299
;  :arith-assert-upper      1286
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1328
;  :arith-fixed-eqs         797
;  :arith-offset-eqs        171
;  :arith-pivots            634
;  :binary-propagations     7
;  :conflicts               320
;  :datatype-accessor-ax    499
;  :datatype-constructor-ax 3774
;  :datatype-occurs-check   1415
;  :datatype-splits         2633
;  :decisions               3995
;  :del-clause              4316
;  :final-checks            300
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          123
;  :mk-bool-var             8820
;  :mk-clause               4477
;  :num-allocs              4916439
;  :num-checks              317
;  :propagations            3458
;  :quant-instantiations    1255
;  :rlimit-count            318651)
(pop) ; 9
(push) ; 9
; [else-branch: 107 | First:(Second:(Second:(Second:($t@60@08))))[1] == 0 || First:(Second:(Second:(Second:($t@60@08))))[1] == -1]
(assert (or
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
      1)
    0)
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
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
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
          1)
        0)
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
          1)
        (- 0 1))))
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))
      1)
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@60@08)))))
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
(declare-const i@65@08 Int)
(push) ; 8
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 9
; [then-branch: 108 | 0 <= i@65@08 | live]
; [else-branch: 108 | !(0 <= i@65@08) | live]
(push) ; 10
; [then-branch: 108 | 0 <= i@65@08]
(assert (<= 0 i@65@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 10
(push) ; 10
; [else-branch: 108 | !(0 <= i@65@08)]
(assert (not (<= 0 i@65@08)))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(push) ; 9
; [then-branch: 109 | i@65@08 < |First:(Second:($t@63@08))| && 0 <= i@65@08 | live]
; [else-branch: 109 | !(i@65@08 < |First:(Second:($t@63@08))| && 0 <= i@65@08) | live]
(push) ; 10
; [then-branch: 109 | i@65@08 < |First:(Second:($t@63@08))| && 0 <= i@65@08]
(assert (and
  (<
    i@65@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))))
  (<= 0 i@65@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 11
(assert (not (>= i@65@08 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20054
;  :arith-add-rows          419
;  :arith-assert-diseq      1218
;  :arith-assert-lower      2378
;  :arith-assert-upper      1316
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1367
;  :arith-fixed-eqs         826
;  :arith-offset-eqs        175
;  :arith-pivots            652
;  :binary-propagations     7
;  :conflicts               325
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4470
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9031
;  :mk-clause               4610
;  :num-allocs              4916439
;  :num-checks              319
;  :propagations            3582
;  :quant-instantiations    1290
;  :rlimit-count            322785)
; [eval] -1
(push) ; 11
; [then-branch: 110 | First:(Second:($t@63@08))[i@65@08] == -1 | live]
; [else-branch: 110 | First:(Second:($t@63@08))[i@65@08] != -1 | live]
(push) ; 12
; [then-branch: 110 | First:(Second:($t@63@08))[i@65@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
    i@65@08)
  (- 0 1)))
(pop) ; 12
(push) ; 12
; [else-branch: 110 | First:(Second:($t@63@08))[i@65@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
      i@65@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@65@08 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20064
;  :arith-add-rows          421
;  :arith-assert-diseq      1221
;  :arith-assert-lower      2386
;  :arith-assert-upper      1320
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1371
;  :arith-fixed-eqs         828
;  :arith-offset-eqs        175
;  :arith-pivots            653
;  :binary-propagations     7
;  :conflicts               325
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4470
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9049
;  :mk-clause               4621
;  :num-allocs              4916439
;  :num-checks              320
;  :propagations            3592
;  :quant-instantiations    1294
;  :rlimit-count            323047)
(push) ; 13
; [then-branch: 111 | 0 <= First:(Second:($t@63@08))[i@65@08] | live]
; [else-branch: 111 | !(0 <= First:(Second:($t@63@08))[i@65@08]) | live]
(push) ; 14
; [then-branch: 111 | 0 <= First:(Second:($t@63@08))[i@65@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
    i@65@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 15
(assert (not (>= i@65@08 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1221
;  :arith-assert-lower      2388
;  :arith-assert-upper      1321
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1372
;  :arith-fixed-eqs         829
;  :arith-offset-eqs        175
;  :arith-pivots            654
;  :binary-propagations     7
;  :conflicts               325
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4470
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9053
;  :mk-clause               4621
;  :num-allocs              4916439
;  :num-checks              321
;  :propagations            3592
;  :quant-instantiations    1294
;  :rlimit-count            323164)
; [eval] |diz.Main_event_state|
(pop) ; 14
(push) ; 14
; [else-branch: 111 | !(0 <= First:(Second:($t@63@08))[i@65@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
      i@65@08))))
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
; [else-branch: 109 | !(i@65@08 < |First:(Second:($t@63@08))| && 0 <= i@65@08)]
(assert (not
  (and
    (<
      i@65@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))))
    (<= 0 i@65@08))))
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
(assert (not (forall ((i@65@08 Int)) (!
  (implies
    (and
      (<
        i@65@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))))
      (<= 0 i@65@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
          i@65@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
            i@65@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
            i@65@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
    i@65@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1223
;  :arith-assert-lower      2389
;  :arith-assert-upper      1322
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1374
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            656
;  :binary-propagations     7
;  :conflicts               326
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9067
;  :mk-clause               4648
;  :num-allocs              4916439
;  :num-checks              322
;  :propagations            3594
;  :quant-instantiations    1297
;  :rlimit-count            323661)
(assert (forall ((i@65@08 Int)) (!
  (implies
    (and
      (<
        i@65@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))))
      (<= 0 i@65@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
          i@65@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
            i@65@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
            i@65@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@63@08)))
    i@65@08))
  :qid |prog.l<no position>|)))
(declare-const $k@66@08 $Perm)
(assert ($Perm.isReadVar $k@66@08 $Perm.Write))
(push) ; 8
(assert (not (or (= $k@66@08 $Perm.No) (< $Perm.No $k@66@08))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2391
;  :arith-assert-upper      1323
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            656
;  :binary-propagations     7
;  :conflicts               327
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9072
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              323
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324185)
(set-option :timeout 10)
(push) ; 8
(assert (not (not (= $k@40@08 $Perm.No))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2391
;  :arith-assert-upper      1323
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            656
;  :binary-propagations     7
;  :conflicts               327
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9072
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              324
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324196)
(assert (< $k@66@08 $k@40@08))
(assert (<= $Perm.No (- $k@40@08 $k@66@08)))
(assert (<= (- $k@40@08 $k@66@08) $Perm.Write))
(assert (implies (< $Perm.No (- $k@40@08 $k@66@08)) (not (= diz@17@08 $Ref.null))))
; [eval] diz.Main_alu != null
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               328
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              325
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324416)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               329
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              326
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324464)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               330
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              327
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324512)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               331
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              328
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324560)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               332
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              329
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324608)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               333
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              330
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324656)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               334
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              331
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324704)
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               335
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              332
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324752)
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               336
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              333
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324800)
(set-option :timeout 0)
(push) ; 8
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               336
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              334
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324813)
(set-option :timeout 10)
(push) ; 8
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          422
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            658
;  :binary-propagations     7
;  :conflicts               337
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4508
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              335
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            324861)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@63@08))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@63@08))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))
                                ($Snap.combine
                                  $Snap.unit
                                  ($Snap.combine
                                    $Snap.unit
                                    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))))))))))))))))))))) diz@17@08 globals@18@08))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 7
(push) ; 7
; [else-branch: 75 | min_advance__73@48@08 == -1]
(assert (= min_advance__73@48@08 (- 0 1)))
(pop) ; 7
(pop) ; 6
(push) ; 6
; [else-branch: 37 | First:(Second:($t@46@08))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20066
;  :arith-add-rows          426
;  :arith-assert-diseq      1224
;  :arith-assert-lower      2393
;  :arith-assert-upper      1324
;  :arith-bound-prop        171
;  :arith-conflicts         34
;  :arith-eq-adapter        1375
;  :arith-fixed-eqs         830
;  :arith-offset-eqs        175
;  :arith-pivots            664
;  :binary-propagations     7
;  :conflicts               337
;  :datatype-accessor-ax    513
;  :datatype-constructor-ax 3885
;  :datatype-occurs-check   1465
;  :datatype-splits         2713
;  :decisions               4115
;  :del-clause              4628
;  :final-checks            306
;  :interface-eqs           38
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          124
;  :mk-bool-var             9075
;  :mk-clause               4650
;  :num-allocs              4916439
;  :num-checks              336
;  :propagations            3595
;  :quant-instantiations    1297
;  :rlimit-count            325077)
; [eval] -1
(set-option :timeout 10)
(push) ; 6
(assert (not (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0)
    (- 0 1)))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20296
;  :arith-add-rows          427
;  :arith-assert-diseq      1229
;  :arith-assert-lower      2407
;  :arith-assert-upper      1331
;  :arith-bound-prop        175
;  :arith-conflicts         34
;  :arith-eq-adapter        1385
;  :arith-fixed-eqs         836
;  :arith-offset-eqs        175
;  :arith-pivots            671
;  :binary-propagations     7
;  :conflicts               342
;  :datatype-accessor-ax    520
;  :datatype-constructor-ax 3939
;  :datatype-occurs-check   1487
;  :datatype-splits         2749
;  :decisions               4166
;  :del-clause              4660
;  :final-checks            312
;  :interface-eqs           39
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9166
;  :mk-clause               4682
;  :num-allocs              4916439
;  :num-checks              337
;  :propagations            3612
;  :quant-instantiations    1301
;  :rlimit-count            326763
;  :time                    0.00)
(push) ; 6
(assert (not (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    0)
  (- 0 1))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20434
;  :arith-add-rows          430
;  :arith-assert-diseq      1233
;  :arith-assert-lower      2424
;  :arith-assert-upper      1340
;  :arith-bound-prop        175
;  :arith-conflicts         34
;  :arith-eq-adapter        1394
;  :arith-fixed-eqs         840
;  :arith-offset-eqs        175
;  :arith-pivots            677
;  :binary-propagations     7
;  :conflicts               343
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4686
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9224
;  :mk-clause               4708
;  :num-allocs              4916439
;  :num-checks              338
;  :propagations            3635
;  :quant-instantiations    1308
;  :rlimit-count            328197
;  :time                    0.00)
; [then-branch: 112 | First:(Second:($t@46@08))[0] == -1 | live]
; [else-branch: 112 | First:(Second:($t@46@08))[0] != -1 | live]
(push) ; 6
; [then-branch: 112 | First:(Second:($t@46@08))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
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
(declare-const i@67@08 Int)
(push) ; 7
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 8
; [then-branch: 113 | 0 <= i@67@08 | live]
; [else-branch: 113 | !(0 <= i@67@08) | live]
(push) ; 9
; [then-branch: 113 | 0 <= i@67@08]
(assert (<= 0 i@67@08))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 113 | !(0 <= i@67@08)]
(assert (not (<= 0 i@67@08)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 114 | i@67@08 < |First:(Second:($t@46@08))| && 0 <= i@67@08 | live]
; [else-branch: 114 | !(i@67@08 < |First:(Second:($t@46@08))| && 0 <= i@67@08) | live]
(push) ; 9
; [then-branch: 114 | i@67@08 < |First:(Second:($t@46@08))| && 0 <= i@67@08]
(assert (and
  (<
    i@67@08
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
  (<= 0 i@67@08)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 10
(assert (not (>= i@67@08 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20440
;  :arith-add-rows          431
;  :arith-assert-diseq      1233
;  :arith-assert-lower      2427
;  :arith-assert-upper      1343
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1395
;  :arith-fixed-eqs         842
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               343
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4686
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9229
;  :mk-clause               4713
;  :num-allocs              4916439
;  :num-checks              339
;  :propagations            3638
;  :quant-instantiations    1308
;  :rlimit-count            328471)
; [eval] -1
(push) ; 10
; [then-branch: 115 | First:(Second:($t@46@08))[i@67@08] == -1 | live]
; [else-branch: 115 | First:(Second:($t@46@08))[i@67@08] != -1 | live]
(push) ; 11
; [then-branch: 115 | First:(Second:($t@46@08))[i@67@08] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@67@08)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 115 | First:(Second:($t@46@08))[i@67@08] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      i@67@08)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 12
(assert (not (>= i@67@08 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1233
;  :arith-assert-lower      2427
;  :arith-assert-upper      1343
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1395
;  :arith-fixed-eqs         842
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               344
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4686
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9230
;  :mk-clause               4713
;  :num-allocs              4916439
;  :num-checks              340
;  :propagations            3638
;  :quant-instantiations    1308
;  :rlimit-count            328615)
(push) ; 12
; [then-branch: 116 | 0 <= First:(Second:($t@46@08))[i@67@08] | live]
; [else-branch: 116 | !(0 <= First:(Second:($t@46@08))[i@67@08]) | live]
(push) ; 13
; [then-branch: 116 | 0 <= First:(Second:($t@46@08))[i@67@08]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@67@08)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 14
(assert (not (>= i@67@08 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1233
;  :arith-assert-lower      2427
;  :arith-assert-upper      1343
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1395
;  :arith-fixed-eqs         842
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               344
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4686
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9231
;  :mk-clause               4713
;  :num-allocs              4916439
;  :num-checks              341
;  :propagations            3638
;  :quant-instantiations    1308
;  :rlimit-count            328700)
; [eval] |diz.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 116 | !(0 <= First:(Second:($t@46@08))[i@67@08])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      i@67@08))))
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
; [else-branch: 114 | !(i@67@08 < |First:(Second:($t@46@08))| && 0 <= i@67@08)]
(assert (not
  (and
    (<
      i@67@08
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
    (<= 0 i@67@08))))
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
(assert (not (forall ((i@67@08 Int)) (!
  (implies
    (and
      (<
        i@67@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
      (<= 0 i@67@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          i@67@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@67@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@67@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@67@08))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1234
;  :arith-assert-lower      2428
;  :arith-assert-upper      1344
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1397
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               345
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9245
;  :mk-clause               4738
;  :num-allocs              4916439
;  :num-checks              342
;  :propagations            3640
;  :quant-instantiations    1311
;  :rlimit-count            329185)
(assert (forall ((i@67@08 Int)) (!
  (implies
    (and
      (<
        i@67@08
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))))
      (<= 0 i@67@08))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
          i@67@08)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@67@08)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08)))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
            i@67@08)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
    i@67@08))
  :qid |prog.l<no position>|)))
(declare-const $k@68@08 $Perm)
(assert ($Perm.isReadVar $k@68@08 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@68@08 $Perm.No) (< $Perm.No $k@68@08))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2430
;  :arith-assert-upper      1345
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               346
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9250
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              343
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            329712)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@40@08 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2430
;  :arith-assert-upper      1345
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               346
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9250
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              344
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            329723)
(assert (< $k@68@08 $k@40@08))
(assert (<= $Perm.No (- $k@40@08 $k@68@08)))
(assert (<= (- $k@40@08 $k@68@08) $Perm.Write))
(assert (implies (< $Perm.No (- $k@40@08 $k@68@08)) (not (= diz@17@08 $Ref.null))))
; [eval] diz.Main_alu != null
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               347
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              345
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            329931)
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               348
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              346
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            329979)
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               349
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              347
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            330027)
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               350
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              348
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            330075)
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               351
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              349
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            330123)
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               352
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              350
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            330171)
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               353
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              351
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            330219)
; [eval] 0 <= diz.Main_alu.ALU_RESULT
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               354
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              352
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            330267)
; [eval] diz.Main_alu.ALU_RESULT <= 16
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               355
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              353
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            330315)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               355
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              354
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            330328)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@40@08)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               20441
;  :arith-add-rows          431
;  :arith-assert-diseq      1235
;  :arith-assert-lower      2432
;  :arith-assert-upper      1346
;  :arith-bound-prop        177
;  :arith-conflicts         34
;  :arith-eq-adapter        1398
;  :arith-fixed-eqs         843
;  :arith-offset-eqs        175
;  :arith-pivots            678
;  :binary-propagations     7
;  :conflicts               356
;  :datatype-accessor-ax    523
;  :datatype-constructor-ax 3971
;  :datatype-occurs-check   1501
;  :datatype-splits         2777
;  :decisions               4199
;  :del-clause              4711
;  :final-checks            316
;  :interface-eqs           40
;  :max-generation          3
;  :max-memory              4.74
;  :memory                  4.74
;  :minimized-lits          125
;  :mk-bool-var             9253
;  :mk-clause               4740
;  :num-allocs              4916439
;  :num-checks              355
;  :propagations            3641
;  :quant-instantiations    1311
;  :rlimit-count            330376)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second $t@46@08))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@46@08))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))
                            ($Snap.combine
                              ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))
                              ($Snap.combine
                                ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08))))))))))))))))
                                ($Snap.combine
                                  $Snap.unit
                                  ($Snap.combine
                                    $Snap.unit
                                    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@38@08)))))))))))))))))))))))))))))))))))) diz@17@08 globals@18@08))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz, globals), write)
; Loop head block: Re-establish invariant
(pop) ; 6
(push) ; 6
; [else-branch: 112 | First:(Second:($t@46@08))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second $t@46@08)))
      0)
    (- 0 1))))
(pop) ; 6
(pop) ; 5
; [eval] !true
; [then-branch: 117 | False | dead]
; [else-branch: 117 | True | live]
(push) ; 5
; [else-branch: 117 | True]
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
