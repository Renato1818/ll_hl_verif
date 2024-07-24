(get-info :version)
; (:version "4.8.6")
; Started: 2024-07-24 15:46:25
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
(declare-const class_Half_adder<TYPE> TYPE)
(declare-const class_java_DOT_lang_DOT_Object<TYPE> TYPE)
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
; /field_value_functions_declarations.smt2 [Half_adder_m: Ref]
(declare-fun $FVF.domain_Half_adder_m ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_Half_adder_m ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_Half_adder_m ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_Half_adder_m ($Ref $Ref) Bool)
(declare-fun $FVF.perm_Half_adder_m ($FPM $Ref) $Perm)
(declare-const $fvfTOP_Half_adder_m $FVF<$Ref>)
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
(declare-fun Half_adder_joinToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Half_adder_idleToken_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_held_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
(declare-fun Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
(assert (distinct class_Half_adder<TYPE> class_java_DOT_lang_DOT_Object<TYPE> class_Main<TYPE> class_EncodedGlobalVariables<TYPE>))
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
  (directSuperclass<TYPE> (as class_Half_adder<TYPE>  TYPE))
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
; /field_value_functions_axioms.smt2 [Half_adder_m: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_Half_adder_m vs) ($FVF.domain_Half_adder_m ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_Half_adder_m vs))
            (= ($FVF.lookup_Half_adder_m vs x) ($FVF.lookup_Half_adder_m ws x)))
          :pattern (($FVF.lookup_Half_adder_m vs x) ($FVF.lookup_Half_adder_m ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_Half_adder_m pm r))
    :pattern ($FVF.perm_Half_adder_m pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_Half_adder_m f r) true)
    :pattern ($FVF.loc_Half_adder_m f r))))
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
; ---------- Half_adder_run_EncodedGlobalVariables ----------
(declare-const diz@0@03 $Ref)
(declare-const globals@1@03 $Ref)
(declare-const diz@2@03 $Ref)
(declare-const globals@3@03 $Ref)
(push) ; 1
(declare-const $t@4@03 $Snap)
(assert (= $t@4@03 ($Snap.combine ($Snap.first $t@4@03) ($Snap.second $t@4@03))))
(assert (= ($Snap.first $t@4@03) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@2@03 $Ref.null)))
(assert (=
  ($Snap.second $t@4@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@4@03))
    ($Snap.second ($Snap.second $t@4@03)))))
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
;  :max-memory           3.91
;  :memory               3.56
;  :mk-bool-var          214
;  :mk-clause            1
;  :num-allocs           2988714
;  :num-checks           1
;  :propagations         7
;  :quant-instantiations 1
;  :rlimit-count         94875)
(assert (=
  ($Snap.second ($Snap.second $t@4@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@4@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@4@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@4@03))) $Snap.unit))
; [eval] diz.Half_adder_m != null
(assert (not
  (= ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@4@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))))
(declare-const $k@5@03 $Perm)
(assert ($Perm.isReadVar $k@5@03 $Perm.Write))
(push) ; 2
(assert (not (or (= $k@5@03 $Perm.No) (< $Perm.No $k@5@03))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            27
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   2
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            1
;  :datatype-accessor-ax 5
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          223
;  :mk-clause            3
;  :num-allocs           3093130
;  :num-checks           2
;  :propagations         8
;  :quant-instantiations 2
;  :rlimit-count         95447)
(assert (<= $Perm.No $k@5@03))
(assert (<= $k@5@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@5@03)
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))
  $Snap.unit))
; [eval] diz.Half_adder_m.Main_half == diz
(set-option :timeout 10)
(push) ; 2
(assert (not (< $Perm.No $k@5@03)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            33
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            2
;  :datatype-accessor-ax 6
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          226
;  :mk-clause            3
;  :num-allocs           3093130
;  :num-checks           3
;  :propagations         8
;  :quant-instantiations 2
;  :rlimit-count         95720)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))
  diz@2@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))))))
(set-option :timeout 0)
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs            40
;  :arith-assert-diseq   1
;  :arith-assert-lower   3
;  :arith-assert-upper   3
;  :arith-eq-adapter     2
;  :binary-propagations  7
;  :conflicts            2
;  :datatype-accessor-ax 7
;  :max-generation       1
;  :max-memory           3.91
;  :memory               3.66
;  :mk-bool-var          229
;  :mk-clause            3
;  :num-allocs           3093130
;  :num-checks           4
;  :propagations         8
;  :quant-instantiations 3
;  :rlimit-count         95971)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03))))))
  $Snap.unit))
; [eval] !diz.Half_adder_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(push) ; 2
(declare-const $t@6@03 $Snap)
(assert (= $t@6@03 ($Snap.combine ($Snap.first $t@6@03) ($Snap.second $t@6@03))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               58
;  :arith-assert-diseq      1
;  :arith-assert-lower      3
;  :arith-assert-upper      3
;  :arith-eq-adapter        2
;  :binary-propagations     7
;  :conflicts               2
;  :datatype-accessor-ax    8
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   2
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            2
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             237
;  :mk-clause               3
;  :num-allocs              3093130
;  :num-checks              6
;  :propagations            8
;  :quant-instantiations    5
;  :rlimit-count            96587)
(assert (=
  ($Snap.second $t@6@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@6@03))
    ($Snap.second ($Snap.second $t@6@03)))))
(assert (= ($Snap.first ($Snap.second $t@6@03)) $Snap.unit))
; [eval] diz.Half_adder_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@6@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@6@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@6@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@6@03))))))
(declare-const $k@7@03 $Perm)
(assert ($Perm.isReadVar $k@7@03 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@7@03 $Perm.No) (< $Perm.No $k@7@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               70
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      4
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               3
;  :datatype-accessor-ax    10
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   2
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            2
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             246
;  :mk-clause               5
;  :num-allocs              3093130
;  :num-checks              7
;  :propagations            9
;  :quant-instantiations    6
;  :rlimit-count            97148)
(assert (<= $Perm.No $k@7@03))
(assert (<= $k@7@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@7@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@6@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@6@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@6@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@03)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@6@03)))) $Snap.unit))
; [eval] diz.Half_adder_m.Main_half == diz
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No $k@7@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               76
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               4
;  :datatype-accessor-ax    11
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   2
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            2
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             249
;  :mk-clause               5
;  :num-allocs              3093130
;  :num-checks              8
;  :propagations            9
;  :quant-instantiations    6
;  :rlimit-count            97411)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second $t@6@03))))
  diz@2@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@03))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               84
;  :arith-assert-diseq      2
;  :arith-assert-lower      5
;  :arith-assert-upper      5
;  :arith-eq-adapter        3
;  :binary-propagations     7
;  :conflicts               4
;  :datatype-accessor-ax    12
;  :datatype-constructor-ax 3
;  :datatype-occurs-check   2
;  :datatype-splits         3
;  :decisions               3
;  :del-clause              2
;  :final-checks            2
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.66
;  :mk-bool-var             252
;  :mk-clause               5
;  :num-allocs              3093130
;  :num-checks              9
;  :propagations            9
;  :quant-instantiations    7
;  :rlimit-count            97651)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@03)))))
  $Snap.unit))
; [eval] !diz.Half_adder_init
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@6@03))))))))
(pop) ; 2
(push) ; 2
; [exec]
; var s_nand__2: Bool
(declare-const s_nand__2@8@03 Bool)
; [exec]
; var s_or__3: Bool
(declare-const s_or__3@9@03 Bool)
; [exec]
; var __flatten_1__4: Ref
(declare-const __flatten_1__4@10@03 $Ref)
; [exec]
; var __flatten_2__5: Seq[Int]
(declare-const __flatten_2__5@11@03 Seq<Int>)
; [exec]
; var __flatten_3__6: Ref
(declare-const __flatten_3__6@12@03 $Ref)
; [exec]
; var __flatten_4__7: Ref
(declare-const __flatten_4__7@13@03 $Ref)
; [exec]
; var __flatten_5__8: Seq[Int]
(declare-const __flatten_5__8@14@03 Seq<Int>)
; [exec]
; var __flatten_6__9: Ref
(declare-const __flatten_6__9@15@03 $Ref)
; [exec]
; var __flatten_7__11: Bool
(declare-const __flatten_7__11@16@03 Bool)
; [exec]
; var __flatten_8__12: Bool
(declare-const __flatten_8__12@17@03 Bool)
; [exec]
; var __flatten_9__13: Ref
(declare-const __flatten_9__13@18@03 $Ref)
; [exec]
; var __flatten_10__14: Seq[Int]
(declare-const __flatten_10__14@19@03 Seq<Int>)
; [exec]
; var __flatten_11__15: Ref
(declare-const __flatten_11__15@20@03 $Ref)
; [exec]
; var __flatten_12__16: Ref
(declare-const __flatten_12__16@21@03 $Ref)
; [exec]
; var __flatten_13__17: Seq[Int]
(declare-const __flatten_13__17@22@03 Seq<Int>)
; [exec]
; var __flatten_14__18: Ref
(declare-const __flatten_14__18@23@03 $Ref)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
(declare-const $t@24@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
(assert (= $t@24@03 ($Snap.combine ($Snap.first $t@24@03) ($Snap.second $t@24@03))))
(assert (= ($Snap.first $t@24@03) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@24@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@24@03))
    ($Snap.second ($Snap.second $t@24@03)))))
(assert (= ($Snap.first ($Snap.second $t@24@03)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@24@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@24@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@24@03))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@24@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@25@03 Int)
(push) ; 3
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 4
; [then-branch: 0 | 0 <= i@25@03 | live]
; [else-branch: 0 | !(0 <= i@25@03) | live]
(push) ; 5
; [then-branch: 0 | 0 <= i@25@03]
(assert (<= 0 i@25@03))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 5
(push) ; 5
; [else-branch: 0 | !(0 <= i@25@03)]
(assert (not (<= 0 i@25@03)))
(pop) ; 5
(pop) ; 4
; Joined path conditions
; Joined path conditions
(push) ; 4
; [then-branch: 1 | i@25@03 < |First:(Second:(Second:(Second:($t@24@03))))| && 0 <= i@25@03 | live]
; [else-branch: 1 | !(i@25@03 < |First:(Second:(Second:(Second:($t@24@03))))| && 0 <= i@25@03) | live]
(push) ; 5
; [then-branch: 1 | i@25@03 < |First:(Second:(Second:(Second:($t@24@03))))| && 0 <= i@25@03]
(assert (and
  (<
    i@25@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
  (<= 0 i@25@03)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 6
(assert (not (>= i@25@03 0)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-assert-diseq      4
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              4
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             284
;  :mk-clause               11
;  :num-allocs              3200308
;  :num-checks              11
;  :propagations            11
;  :quant-instantiations    13
;  :rlimit-count            99301)
; [eval] -1
(push) ; 6
; [then-branch: 2 | First:(Second:(Second:(Second:($t@24@03))))[i@25@03] == -1 | live]
; [else-branch: 2 | First:(Second:(Second:(Second:($t@24@03))))[i@25@03] != -1 | live]
(push) ; 7
; [then-branch: 2 | First:(Second:(Second:(Second:($t@24@03))))[i@25@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    i@25@03)
  (- 0 1)))
(pop) ; 7
(push) ; 7
; [else-branch: 2 | First:(Second:(Second:(Second:($t@24@03))))[i@25@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
      i@25@03)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 8
(assert (not (>= i@25@03 0)))
(check-sat)
; unsat
(pop) ; 8
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-assert-diseq      4
;  :arith-assert-lower      12
;  :arith-assert-upper      8
;  :arith-eq-adapter        7
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              4
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             285
;  :mk-clause               11
;  :num-allocs              3200308
;  :num-checks              12
;  :propagations            11
;  :quant-instantiations    13
;  :rlimit-count            99476)
(push) ; 8
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@24@03))))[i@25@03] | live]
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@24@03))))[i@25@03]) | live]
(push) ; 9
; [then-branch: 3 | 0 <= First:(Second:(Second:(Second:($t@24@03))))[i@25@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    i@25@03)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 10
(assert (not (>= i@25@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               143
;  :arith-assert-diseq      5
;  :arith-assert-lower      15
;  :arith-assert-upper      8
;  :arith-eq-adapter        8
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               4
;  :datatype-accessor-ax    20
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              4
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             288
;  :mk-clause               12
;  :num-allocs              3200308
;  :num-checks              13
;  :propagations            11
;  :quant-instantiations    13
;  :rlimit-count            99600)
; [eval] |diz.Main_event_state|
(pop) ; 9
(push) ; 9
; [else-branch: 3 | !(0 <= First:(Second:(Second:(Second:($t@24@03))))[i@25@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
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
; [else-branch: 1 | !(i@25@03 < |First:(Second:(Second:(Second:($t@24@03))))| && 0 <= i@25@03)]
(assert (not
  (and
    (<
      i@25@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
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
(assert (forall ((i@25@03 Int)) (!
  (implies
    (and
      (<
        i@25@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
      (<= 0 i@25@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
          i@25@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
            i@25@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
            i@25@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    i@25@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
(declare-const $k@26@03 $Perm)
(assert ($Perm.isReadVar $k@26@03 $Perm.Write))
(push) ; 3
(assert (not (or (= $k@26@03 $Perm.No) (< $Perm.No $k@26@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.01s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               148
;  :arith-assert-diseq      6
;  :arith-assert-lower      17
;  :arith-assert-upper      9
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         1
;  :binary-propagations     7
;  :conflicts               5
;  :datatype-accessor-ax    21
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             294
;  :mk-clause               14
;  :num-allocs              3200308
;  :num-checks              14
;  :propagations            12
;  :quant-instantiations    13
;  :rlimit-count            100368)
(declare-const $t@27@03 $Ref)
(assert (and
  (implies
    (< $Perm.No $k@5@03)
    (=
      $t@27@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))))
  (implies
    (< $Perm.No $k@26@03)
    (=
      $t@27@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))
(assert (<= $Perm.No (+ $k@5@03 $k@26@03)))
(assert (<= (+ $k@5@03 $k@26@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ $k@5@03 $k@26@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
  $Snap.unit))
; [eval] diz.Main_half != null
(set-option :timeout 10)
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               158
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      11
;  :arith-conflicts         1
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         2
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               6
;  :datatype-accessor-ax    22
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             302
;  :mk-clause               14
;  :num-allocs              3200308
;  :num-checks              15
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            100953)
(assert (not (= $t@27@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               164
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      12
;  :arith-conflicts         2
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         3
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               7
;  :datatype-accessor-ax    23
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             305
;  :mk-clause               14
;  :num-allocs              3200308
;  :num-checks              16
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            101259)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               169
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      13
;  :arith-conflicts         3
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         4
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               8
;  :datatype-accessor-ax    24
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             307
;  :mk-clause               14
;  :num-allocs              3200308
;  :num-checks              17
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            101530)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               174
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      14
;  :arith-conflicts         4
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         5
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               9
;  :datatype-accessor-ax    25
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             309
;  :mk-clause               14
;  :num-allocs              3200308
;  :num-checks              18
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            101811)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      15
;  :arith-conflicts         5
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         6
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               10
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             311
;  :mk-clause               14
;  :num-allocs              3200308
;  :num-checks              19
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            102102)
(push) ; 3
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      16
;  :arith-conflicts         6
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               11
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             312
;  :mk-clause               14
;  :num-allocs              3200308
;  :num-checks              20
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            102164)
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      16
;  :arith-conflicts         6
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               11
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             312
;  :mk-clause               14
;  :num-allocs              3200308
;  :num-checks              21
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            102177)
(set-option :timeout 10)
(push) ; 3
(assert (not (= diz@2@03 $t@27@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               179
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      16
;  :arith-conflicts         6
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               12
;  :datatype-accessor-ax    26
;  :datatype-constructor-ax 6
;  :datatype-occurs-check   3
;  :datatype-splits         3
;  :decisions               6
;  :del-clause              5
;  :final-checks            3
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             313
;  :mk-clause               14
;  :num-allocs              3200308
;  :num-checks              22
;  :propagations            12
;  :quant-instantiations    14
;  :rlimit-count            102237)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@4@03)))))))
  ($SortWrappers.$SnapToBool ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))))))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@24@03 ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))) globals@3@03))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
(declare-const $t@28@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; __flatten_1__4 := diz.Half_adder_m
(declare-const __flatten_1__4@29@03 $Ref)
(assert (=
  __flatten_1__4@29@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))))
; [exec]
; __flatten_3__6 := diz.Half_adder_m
(declare-const __flatten_3__6@30@03 $Ref)
(assert (=
  __flatten_3__6@30@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))))
; [exec]
; __flatten_2__5 := __flatten_3__6.Main_process_state[0 := 0]
; [eval] __flatten_3__6.Main_process_state[0 := 0]
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
  __flatten_3__6@30@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               256
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      16
;  :arith-conflicts         6
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             336
;  :mk-clause               15
;  :num-allocs              3200308
;  :num-checks              25
;  :propagations            13
;  :quant-instantiations    15
;  :rlimit-count            103542)
(set-option :timeout 0)
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               256
;  :arith-assert-diseq      6
;  :arith-assert-lower      18
;  :arith-assert-upper      16
;  :arith-conflicts         6
;  :arith-eq-adapter        9
;  :arith-fixed-eqs         7
;  :arith-pivots            2
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.91
;  :memory                  3.75
;  :mk-bool-var             336
;  :mk-clause               15
;  :num-allocs              3200308
;  :num-checks              26
;  :propagations            13
;  :quant-instantiations    15
;  :rlimit-count            103557)
(declare-const __flatten_2__5@31@03 Seq<Int>)
(assert (Seq_equal
  __flatten_2__5@31@03
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))
    0
    0)))
; [exec]
; __flatten_1__4.Main_process_state := __flatten_2__5
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
  __flatten_1__4@29@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               266
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      18
;  :arith-conflicts         6
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         9
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             358
;  :mk-clause               33
;  :num-allocs              3311761
;  :num-checks              27
;  :propagations            21
;  :quant-instantiations    20
;  :rlimit-count            104000)
(assert (not (= __flatten_1__4@29@03 $Ref.null)))
; [exec]
; __flatten_4__7 := diz.Half_adder_m
(declare-const __flatten_4__7@32@03 $Ref)
(assert (=
  __flatten_4__7@32@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))))
; [exec]
; __flatten_6__9 := diz.Half_adder_m
(declare-const __flatten_6__9@33@03 $Ref)
(assert (=
  __flatten_6__9@33@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))))
; [exec]
; __flatten_5__8 := __flatten_6__9.Main_event_state[0 := 20]
; [eval] __flatten_6__9.Main_event_state[0 := 20]
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
  __flatten_6__9@33@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               269
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      18
;  :arith-conflicts         6
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         9
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             361
;  :mk-clause               33
;  :num-allocs              3311761
;  :num-checks              28
;  :propagations            21
;  :quant-instantiations    20
;  :rlimit-count            104127)
(set-option :timeout 0)
(push) ; 3
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               269
;  :arith-add-rows          1
;  :arith-assert-diseq      7
;  :arith-assert-lower      22
;  :arith-assert-upper      18
;  :arith-conflicts         6
;  :arith-eq-adapter        12
;  :arith-fixed-eqs         9
;  :arith-pivots            3
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             361
;  :mk-clause               33
;  :num-allocs              3311761
;  :num-checks              29
;  :propagations            21
;  :quant-instantiations    20
;  :rlimit-count            104142)
(declare-const __flatten_5__8@34@03 Seq<Int>)
(assert (Seq_equal
  __flatten_5__8@34@03
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@24@03)))))))
    0
    20)))
; [exec]
; __flatten_4__7.Main_event_state := __flatten_5__8
(set-option :timeout 10)
(push) ; 3
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
  __flatten_4__7@32@03)))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               279
;  :arith-add-rows          3
;  :arith-assert-diseq      8
;  :arith-assert-lower      26
;  :arith-assert-upper      20
;  :arith-conflicts         6
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    28
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             383
;  :mk-clause               51
;  :num-allocs              3311761
;  :num-checks              30
;  :propagations            29
;  :quant-instantiations    25
;  :rlimit-count            104634)
(assert (not (= __flatten_4__7@32@03 $Ref.null)))
; [exec]
; diz.Half_adder_init := true
(push) ; 3
; Loop head block: Check well-definedness of invariant
(declare-const $t@35@03 $Snap)
(assert (= $t@35@03 ($Snap.combine ($Snap.first $t@35@03) ($Snap.second $t@35@03))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               284
;  :arith-add-rows          3
;  :arith-assert-diseq      8
;  :arith-assert-lower      26
;  :arith-assert-upper      20
;  :arith-conflicts         6
;  :arith-eq-adapter        15
;  :arith-fixed-eqs         11
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    29
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             384
;  :mk-clause               51
;  :num-allocs              3311761
;  :num-checks              31
;  :propagations            29
;  :quant-instantiations    25
;  :rlimit-count            104767)
(assert (=
  ($Snap.second $t@35@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@35@03))
    ($Snap.second ($Snap.second $t@35@03)))))
(assert (= ($Snap.first ($Snap.second $t@35@03)) $Snap.unit))
; [eval] diz.Half_adder_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@35@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@35@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@35@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
  $Snap.unit))
; [eval] |diz.Half_adder_m.Main_process_state| == 1
; [eval] |diz.Half_adder_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
  $Snap.unit))
; [eval] |diz.Half_adder_m.Main_event_state| == 2
; [eval] |diz.Half_adder_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
  $Snap.unit))
; [eval] (forall i__10: Int :: { diz.Half_adder_m.Main_process_state[i__10] } 0 <= i__10 && i__10 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__10] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|)
(declare-const i__10@36@03 Int)
(push) ; 4
; [eval] 0 <= i__10 && i__10 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__10] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= i__10 && i__10 < |diz.Half_adder_m.Main_process_state|
; [eval] 0 <= i__10
(push) ; 5
; [then-branch: 4 | 0 <= i__10@36@03 | live]
; [else-branch: 4 | !(0 <= i__10@36@03) | live]
(push) ; 6
; [then-branch: 4 | 0 <= i__10@36@03]
(assert (<= 0 i__10@36@03))
; [eval] i__10 < |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 4 | !(0 <= i__10@36@03)]
(assert (not (<= 0 i__10@36@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 5 | i__10@36@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i__10@36@03 | live]
; [else-branch: 5 | !(i__10@36@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i__10@36@03) | live]
(push) ; 6
; [then-branch: 5 | i__10@36@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i__10@36@03]
(assert (and
  (<
    i__10@36@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
  (<= 0 i__10@36@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__10] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__10] == -1
; [eval] diz.Half_adder_m.Main_process_state[i__10]
(push) ; 7
(assert (not (>= i__10@36@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-add-rows          3
;  :arith-assert-diseq      8
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         6
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             409
;  :mk-clause               51
;  :num-allocs              3311761
;  :num-checks              32
;  :propagations            29
;  :quant-instantiations    30
;  :rlimit-count            106050)
; [eval] -1
(push) ; 7
; [then-branch: 6 | First:(Second:(Second:(Second:($t@35@03))))[i__10@36@03] == -1 | live]
; [else-branch: 6 | First:(Second:(Second:(Second:($t@35@03))))[i__10@36@03] != -1 | live]
(push) ; 8
; [then-branch: 6 | First:(Second:(Second:(Second:($t@35@03))))[i__10@36@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i__10@36@03)
  (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 6 | First:(Second:(Second:(Second:($t@35@03))))[i__10@36@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      i__10@36@03)
    (- 0 1))))
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__10]
; [eval] diz.Half_adder_m.Main_process_state[i__10]
(push) ; 9
(assert (not (>= i__10@36@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-add-rows          3
;  :arith-assert-diseq      8
;  :arith-assert-lower      31
;  :arith-assert-upper      23
;  :arith-conflicts         6
;  :arith-eq-adapter        17
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             410
;  :mk-clause               51
;  :num-allocs              3311761
;  :num-checks              33
;  :propagations            29
;  :quant-instantiations    30
;  :rlimit-count            106225)
(push) ; 9
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@35@03))))[i__10@36@03] | live]
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@35@03))))[i__10@36@03]) | live]
(push) ; 10
; [then-branch: 7 | 0 <= First:(Second:(Second:(Second:($t@35@03))))[i__10@36@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i__10@36@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__10]
(push) ; 11
(assert (not (>= i__10@36@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               329
;  :arith-add-rows          3
;  :arith-assert-diseq      9
;  :arith-assert-lower      34
;  :arith-assert-upper      23
;  :arith-conflicts         6
;  :arith-eq-adapter        18
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               13
;  :datatype-accessor-ax    36
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              13
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             413
;  :mk-clause               52
;  :num-allocs              3311761
;  :num-checks              34
;  :propagations            29
;  :quant-instantiations    30
;  :rlimit-count            106349)
; [eval] |diz.Half_adder_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 7 | !(0 <= First:(Second:(Second:(Second:($t@35@03))))[i__10@36@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      i__10@36@03))))
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
; [else-branch: 5 | !(i__10@36@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i__10@36@03)]
(assert (not
  (and
    (<
      i__10@36@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
    (<= 0 i__10@36@03))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__10@36@03 Int)) (!
  (implies
    (and
      (<
        i__10@36@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
      (<= 0 i__10@36@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          i__10@36@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i__10@36@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i__10@36@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i__10@36@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))
(declare-const $k@37@03 $Perm)
(assert ($Perm.isReadVar $k@37@03 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@37@03 $Perm.No) (< $Perm.No $k@37@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               334
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      24
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               14
;  :datatype-accessor-ax    37
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             419
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              35
;  :propagations            30
;  :quant-instantiations    30
;  :rlimit-count            107118)
(assert (<= $Perm.No $k@37@03))
(assert (<= $k@37@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@37@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
  $Snap.unit))
; [eval] diz.Half_adder_m.Main_half != null
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               340
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               15
;  :datatype-accessor-ax    38
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             422
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              36
;  :propagations            30
;  :quant-instantiations    30
;  :rlimit-count            107441)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               346
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               16
;  :datatype-accessor-ax    39
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             425
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              37
;  :propagations            30
;  :quant-instantiations    31
;  :rlimit-count            107797)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               351
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               17
;  :datatype-accessor-ax    40
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             426
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              38
;  :propagations            30
;  :quant-instantiations    31
;  :rlimit-count            108054)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               356
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               18
;  :datatype-accessor-ax    41
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             427
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              39
;  :propagations            30
;  :quant-instantiations    31
;  :rlimit-count            108321)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               361
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               19
;  :datatype-accessor-ax    42
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             428
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              40
;  :propagations            30
;  :quant-instantiations    31
;  :rlimit-count            108598)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))))
(push) ; 4
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               20
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             429
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              41
;  :propagations            30
;  :quant-instantiations    31
;  :rlimit-count            108885)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               366
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               20
;  :datatype-accessor-ax    43
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             429
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              42
;  :propagations            30
;  :quant-instantiations    31
;  :rlimit-count            108898)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
  $Snap.unit))
; [eval] diz.Half_adder_m.Main_half == diz
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               372
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    44
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             431
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              43
;  :propagations            30
;  :quant-instantiations    31
;  :rlimit-count            109227)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
  diz@2@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))))))
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               380
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             433
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              44
;  :propagations            30
;  :quant-instantiations    31
;  :rlimit-count            109551)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 4
; [eval] diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[0] != -2
; [eval] diz.Half_adder_m.Main_process_state[0] != -1
; [eval] diz.Half_adder_m.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               388
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             439
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              45
;  :propagations            30
;  :quant-instantiations    34
;  :rlimit-count            109976)
; [eval] -1
(push) ; 5
; [then-branch: 8 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1 | live]
; [else-branch: 8 | First:(Second:(Second:(Second:($t@35@03))))[0] == -1 | live]
(push) ; 6
; [then-branch: 8 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      0)
    (- 0 1))))
(pop) ; 6
(push) ; 6
; [else-branch: 8 | First:(Second:(Second:(Second:($t@35@03))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    0)
  (- 0 1)))
; [eval] diz.Half_adder_m.Main_event_state[0] != -2
; [eval] diz.Half_adder_m.Main_event_state[0]
(push) ; 7
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               389
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             440
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              46
;  :propagations            30
;  :quant-instantiations    34
;  :rlimit-count            110138)
; [eval] -2
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [eval] !(diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[0] != -2)
; [eval] diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[0] != -2
; [eval] diz.Half_adder_m.Main_process_state[0] != -1
; [eval] diz.Half_adder_m.Main_process_state[0]
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               389
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             440
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              47
;  :propagations            30
;  :quant-instantiations    34
;  :rlimit-count            110158)
; [eval] -1
(push) ; 5
; [then-branch: 9 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1 | live]
; [else-branch: 9 | First:(Second:(Second:(Second:($t@35@03))))[0] == -1 | live]
(push) ; 6
; [then-branch: 9 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      0)
    (- 0 1))))
(pop) ; 6
(push) ; 6
; [else-branch: 9 | First:(Second:(Second:(Second:($t@35@03))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    0)
  (- 0 1)))
; [eval] diz.Half_adder_m.Main_event_state[0] != -2
; [eval] diz.Half_adder_m.Main_event_state[0]
(push) ; 7
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               390
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              14
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             441
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              48
;  :propagations            30
;  :quant-instantiations    34
;  :rlimit-count            110316)
; [eval] -2
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
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
; (:added-eqs               390
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        19
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               21
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             441
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              49
;  :propagations            30
;  :quant-instantiations    34
;  :rlimit-count            110334)
; [eval] diz.Half_adder_m != null
; [eval] |diz.Half_adder_m.Main_process_state| == 1
; [eval] |diz.Half_adder_m.Main_process_state|
(push) ; 4
(assert (not (= (Seq_length __flatten_2__5@31@03) 1)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               390
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      36
;  :arith-assert-upper      25
;  :arith-conflicts         6
;  :arith-eq-adapter        20
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               22
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             444
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              50
;  :propagations            30
;  :quant-instantiations    34
;  :rlimit-count            110408)
(assert (= (Seq_length __flatten_2__5@31@03) 1))
; [eval] |diz.Half_adder_m.Main_event_state| == 2
; [eval] |diz.Half_adder_m.Main_event_state|
(push) ; 4
(assert (not (= (Seq_length __flatten_5__8@34@03) 2)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               391
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      37
;  :arith-assert-upper      26
;  :arith-conflicts         6
;  :arith-eq-adapter        22
;  :arith-fixed-eqs         12
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               23
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             450
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              51
;  :propagations            30
;  :quant-instantiations    34
;  :rlimit-count            110533)
(assert (= (Seq_length __flatten_5__8@34@03) 2))
; [eval] (forall i__10: Int :: { diz.Half_adder_m.Main_process_state[i__10] } 0 <= i__10 && i__10 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__10] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|)
(declare-const i__10@38@03 Int)
(push) ; 4
; [eval] 0 <= i__10 && i__10 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__10] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= i__10 && i__10 < |diz.Half_adder_m.Main_process_state|
; [eval] 0 <= i__10
(push) ; 5
; [then-branch: 10 | 0 <= i__10@38@03 | live]
; [else-branch: 10 | !(0 <= i__10@38@03) | live]
(push) ; 6
; [then-branch: 10 | 0 <= i__10@38@03]
(assert (<= 0 i__10@38@03))
; [eval] i__10 < |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_process_state|
(pop) ; 6
(push) ; 6
; [else-branch: 10 | !(0 <= i__10@38@03)]
(assert (not (<= 0 i__10@38@03)))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(push) ; 5
; [then-branch: 11 | i__10@38@03 < |__flatten_2__5@31@03| && 0 <= i__10@38@03 | live]
; [else-branch: 11 | !(i__10@38@03 < |__flatten_2__5@31@03| && 0 <= i__10@38@03) | live]
(push) ; 6
; [then-branch: 11 | i__10@38@03 < |__flatten_2__5@31@03| && 0 <= i__10@38@03]
(assert (and (< i__10@38@03 (Seq_length __flatten_2__5@31@03)) (<= 0 i__10@38@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__10] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__10] == -1
; [eval] diz.Half_adder_m.Main_process_state[i__10]
(push) ; 7
(assert (not (>= i__10@38@03 0)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               393
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      39
;  :arith-assert-upper      28
;  :arith-conflicts         6
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         13
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               23
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             455
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              52
;  :propagations            30
;  :quant-instantiations    34
;  :rlimit-count            110724)
; [eval] -1
(push) ; 7
; [then-branch: 12 | __flatten_2__5@31@03[i__10@38@03] == -1 | live]
; [else-branch: 12 | __flatten_2__5@31@03[i__10@38@03] != -1 | live]
(push) ; 8
; [then-branch: 12 | __flatten_2__5@31@03[i__10@38@03] == -1]
(assert (= (Seq_index __flatten_2__5@31@03 i__10@38@03) (- 0 1)))
(pop) ; 8
(push) ; 8
; [else-branch: 12 | __flatten_2__5@31@03[i__10@38@03] != -1]
(assert (not (= (Seq_index __flatten_2__5@31@03 i__10@38@03) (- 0 1))))
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__10]
; [eval] diz.Half_adder_m.Main_process_state[i__10]
(push) ; 9
(assert (not (>= i__10@38@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               395
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      39
;  :arith-assert-upper      28
;  :arith-conflicts         6
;  :arith-eq-adapter        23
;  :arith-fixed-eqs         13
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               23
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             457
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              53
;  :propagations            30
;  :quant-instantiations    35
;  :rlimit-count            110884)
(push) ; 9
; [then-branch: 13 | 0 <= __flatten_2__5@31@03[i__10@38@03] | live]
; [else-branch: 13 | !(0 <= __flatten_2__5@31@03[i__10@38@03]) | live]
(push) ; 10
; [then-branch: 13 | 0 <= __flatten_2__5@31@03[i__10@38@03]]
(assert (<= 0 (Seq_index __flatten_2__5@31@03 i__10@38@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__10]
(push) ; 11
(assert (not (>= i__10@38@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               396
;  :arith-add-rows          3
;  :arith-assert-diseq      10
;  :arith-assert-lower      40
;  :arith-assert-upper      29
;  :arith-conflicts         6
;  :arith-eq-adapter        24
;  :arith-fixed-eqs         13
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               23
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              16
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             460
;  :mk-clause               54
;  :num-allocs              3311761
;  :num-checks              54
;  :propagations            30
;  :quant-instantiations    35
;  :rlimit-count            110958)
; [eval] |diz.Half_adder_m.Main_event_state|
(pop) ; 10
(push) ; 10
; [else-branch: 13 | !(0 <= __flatten_2__5@31@03[i__10@38@03])]
(assert (not (<= 0 (Seq_index __flatten_2__5@31@03 i__10@38@03))))
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
; [else-branch: 11 | !(i__10@38@03 < |__flatten_2__5@31@03| && 0 <= i__10@38@03)]
(assert (not (and (< i__10@38@03 (Seq_length __flatten_2__5@31@03)) (<= 0 i__10@38@03))))
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
(assert (not (forall ((i__10@38@03 Int)) (!
  (implies
    (and (< i__10@38@03 (Seq_length __flatten_2__5@31@03)) (<= 0 i__10@38@03))
    (or
      (= (Seq_index __flatten_2__5@31@03 i__10@38@03) (- 0 1))
      (and
        (<
          (Seq_index __flatten_2__5@31@03 i__10@38@03)
          (Seq_length __flatten_5__8@34@03))
        (<= 0 (Seq_index __flatten_2__5@31@03 i__10@38@03)))))
  :pattern ((Seq_index __flatten_2__5@31@03 i__10@38@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               401
;  :arith-add-rows          3
;  :arith-assert-diseq      12
;  :arith-assert-lower      45
;  :arith-assert-upper      32
;  :arith-conflicts         7
;  :arith-eq-adapter        27
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               24
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              38
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             475
;  :mk-clause               76
;  :num-allocs              3311761
;  :num-checks              55
;  :propagations            36
;  :quant-instantiations    36
;  :rlimit-count            111376)
(assert (forall ((i__10@38@03 Int)) (!
  (implies
    (and (< i__10@38@03 (Seq_length __flatten_2__5@31@03)) (<= 0 i__10@38@03))
    (or
      (= (Seq_index __flatten_2__5@31@03 i__10@38@03) (- 0 1))
      (and
        (<
          (Seq_index __flatten_2__5@31@03 i__10@38@03)
          (Seq_length __flatten_5__8@34@03))
        (<= 0 (Seq_index __flatten_2__5@31@03 i__10@38@03)))))
  :pattern ((Seq_index __flatten_2__5@31@03 i__10@38@03))
  :qid |prog.l<no position>|)))
(declare-const $k@39@03 $Perm)
(assert ($Perm.isReadVar $k@39@03 $Perm.Write))
(push) ; 4
(assert (not (or (= $k@39@03 $Perm.No) (< $Perm.No $k@39@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               401
;  :arith-add-rows          3
;  :arith-assert-diseq      13
;  :arith-assert-lower      47
;  :arith-assert-upper      33
;  :arith-conflicts         7
;  :arith-eq-adapter        28
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               25
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              38
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             480
;  :mk-clause               78
;  :num-allocs              3311761
;  :num-checks              56
;  :propagations            37
;  :quant-instantiations    36
;  :rlimit-count            111847)
(set-option :timeout 10)
(push) ; 4
(assert (not (not (= (+ $k@5@03 $k@26@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-add-rows          3
;  :arith-assert-diseq      13
;  :arith-assert-lower      47
;  :arith-assert-upper      34
;  :arith-conflicts         8
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         14
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               26
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              40
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             482
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              57
;  :propagations            38
;  :quant-instantiations    36
;  :rlimit-count            111909)
(assert (< $k@39@03 (+ $k@5@03 $k@26@03)))
(assert (<= $Perm.No (- (+ $k@5@03 $k@26@03) $k@39@03)))
(assert (<= (- (+ $k@5@03 $k@26@03) $k@39@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ $k@5@03 $k@26@03) $k@39@03))
  (not
    (=
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03)))
      $Ref.null))))
; [eval] diz.Half_adder_m.Main_half != null
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-add-rows          4
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      36
;  :arith-conflicts         9
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         15
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               27
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              40
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             486
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              58
;  :propagations            38
;  :quant-instantiations    36
;  :rlimit-count            112141)
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-add-rows          4
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      37
;  :arith-conflicts         10
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         16
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               28
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              40
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             487
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              59
;  :propagations            38
;  :quant-instantiations    36
;  :rlimit-count            112204)
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-add-rows          4
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      38
;  :arith-conflicts         11
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         17
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               29
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              40
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             488
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              60
;  :propagations            38
;  :quant-instantiations    36
;  :rlimit-count            112267)
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-add-rows          4
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      39
;  :arith-conflicts         12
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         18
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               30
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              40
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             489
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              61
;  :propagations            38
;  :quant-instantiations    36
;  :rlimit-count            112330)
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-add-rows          4
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         19
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               31
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              40
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             490
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              62
;  :propagations            38
;  :quant-instantiations    36
;  :rlimit-count            112393)
(set-option :timeout 0)
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-add-rows          4
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      40
;  :arith-conflicts         13
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         19
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               31
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              40
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             490
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              63
;  :propagations            38
;  :quant-instantiations    36
;  :rlimit-count            112406)
(set-option :timeout 10)
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-add-rows          4
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      41
;  :arith-conflicts         14
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         20
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               32
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              40
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             491
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              64
;  :propagations            38
;  :quant-instantiations    36
;  :rlimit-count            112469)
(push) ; 4
(assert (not (= diz@2@03 $t@27@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               402
;  :arith-add-rows          4
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      41
;  :arith-conflicts         14
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         20
;  :arith-pivots            5
;  :binary-propagations     7
;  :conflicts               33
;  :datatype-accessor-ax    45
;  :datatype-constructor-ax 29
;  :datatype-occurs-check   15
;  :datatype-splits         19
;  :decisions               27
;  :del-clause              40
;  :final-checks            9
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             492
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              65
;  :propagations            38
;  :quant-instantiations    36
;  :rlimit-count            112529)
(push) ; 4
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               436
;  :arith-add-rows          6
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      41
;  :arith-conflicts         14
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         20
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               33
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   21
;  :datatype-splits         27
;  :decisions               37
;  :del-clause              40
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             499
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              66
;  :propagations            39
;  :quant-instantiations    36
;  :rlimit-count            113024
;  :time                    0.00)
; [eval] diz.Half_adder_m.Main_half == diz
(push) ; 4
(assert (not (< $Perm.No (+ $k@5@03 $k@26@03))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               436
;  :arith-add-rows          6
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      42
;  :arith-conflicts         15
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         21
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               34
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   21
;  :datatype-splits         27
;  :decisions               37
;  :del-clause              40
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             500
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              67
;  :propagations            39
;  :quant-instantiations    36
;  :rlimit-count            113087)
(set-option :timeout 0)
(push) ; 4
(assert (not (= $t@27@03 diz@2@03)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               436
;  :arith-add-rows          6
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      42
;  :arith-conflicts         15
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         21
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               35
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   21
;  :datatype-splits         27
;  :decisions               37
;  :del-clause              40
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             500
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              68
;  :propagations            39
;  :quant-instantiations    36
;  :rlimit-count            113143)
(assert (= $t@27@03 diz@2@03))
(push) ; 4
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               436
;  :arith-add-rows          6
;  :arith-assert-diseq      13
;  :arith-assert-lower      49
;  :arith-assert-upper      42
;  :arith-conflicts         15
;  :arith-eq-adapter        29
;  :arith-fixed-eqs         21
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               35
;  :datatype-accessor-ax    46
;  :datatype-constructor-ax 40
;  :datatype-occurs-check   21
;  :datatype-splits         27
;  :decisions               37
;  :del-clause              40
;  :final-checks            12
;  :max-generation          2
;  :max-memory              3.99
;  :memory                  3.99
;  :mk-bool-var             500
;  :mk-clause               80
;  :num-allocs              3311761
;  :num-checks              69
;  :propagations            39
;  :quant-instantiations    36
;  :rlimit-count            113191)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 4
(assert ($Perm.isReadVar $k@37@03 $Perm.Write))
(assert (= $t@35@03 ($Snap.combine ($Snap.first $t@35@03) ($Snap.second $t@35@03))))
(assert (=
  ($Snap.second $t@35@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@35@03))
    ($Snap.second ($Snap.second $t@35@03)))))
(assert (= ($Snap.first ($Snap.second $t@35@03)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@35@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@35@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@35@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
  $Snap.unit))
(assert (forall ((i__10@36@03 Int)) (!
  (implies
    (and
      (<
        i__10@36@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
      (<= 0 i__10@36@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          i__10@36@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i__10@36@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i__10@36@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i__10@36@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))
(assert (<= $Perm.No $k@37@03))
(assert (<= $k@37@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@37@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
  diz@2@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
; [eval] diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[0] != -2
; [eval] diz.Half_adder_m.Main_process_state[0] != -1
; [eval] diz.Half_adder_m.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               761
;  :arith-add-rows          6
;  :arith-assert-diseq      14
;  :arith-assert-lower      55
;  :arith-assert-upper      46
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         21
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 111
;  :datatype-occurs-check   39
;  :datatype-splits         69
;  :decisions               100
;  :del-clause              44
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             595
;  :mk-clause               86
;  :num-allocs              3431517
;  :num-checks              72
;  :propagations            46
;  :quant-instantiations    45
;  :rlimit-count            117509)
; [eval] -1
(push) ; 5
; [then-branch: 14 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1 | live]
; [else-branch: 14 | First:(Second:(Second:(Second:($t@35@03))))[0] == -1 | live]
(push) ; 6
; [then-branch: 14 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      0)
    (- 0 1))))
(pop) ; 6
(push) ; 6
; [else-branch: 14 | First:(Second:(Second:(Second:($t@35@03))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    0)
  (- 0 1)))
; [eval] diz.Half_adder_m.Main_event_state[0] != -2
; [eval] diz.Half_adder_m.Main_event_state[0]
(push) ; 7
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               762
;  :arith-add-rows          6
;  :arith-assert-diseq      14
;  :arith-assert-lower      55
;  :arith-assert-upper      46
;  :arith-conflicts         15
;  :arith-eq-adapter        32
;  :arith-fixed-eqs         21
;  :arith-pivots            6
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    71
;  :datatype-constructor-ax 111
;  :datatype-occurs-check   39
;  :datatype-splits         69
;  :decisions               100
;  :del-clause              44
;  :final-checks            18
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             596
;  :mk-clause               86
;  :num-allocs              3431517
;  :num-checks              73
;  :propagations            46
;  :quant-instantiations    45
;  :rlimit-count            117667)
; [eval] -2
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 5
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
          0)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               838
;  :arith-add-rows          6
;  :arith-assert-diseq      16
;  :arith-assert-lower      62
;  :arith-assert-upper      49
;  :arith-conflicts         15
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         22
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    74
;  :datatype-constructor-ax 135
;  :datatype-occurs-check   48
;  :datatype-splits         90
;  :decisions               122
;  :del-clause              55
;  :final-checks            21
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             632
;  :mk-clause               97
;  :num-allocs              3431517
;  :num-checks              74
;  :propagations            54
;  :quant-instantiations    47
;  :rlimit-count            118708
;  :time                    0.00)
(push) ; 5
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
        0)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               912
;  :arith-add-rows          6
;  :arith-assert-diseq      16
;  :arith-assert-lower      62
;  :arith-assert-upper      49
;  :arith-conflicts         15
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         22
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              55
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             654
;  :mk-clause               97
;  :num-allocs              3431517
;  :num-checks              75
;  :propagations            57
;  :quant-instantiations    47
;  :rlimit-count            119564
;  :time                    0.00)
; [then-branch: 15 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@35@03))))))[0] != -2 | live]
; [else-branch: 15 | !(First:(Second:(Second:(Second:($t@35@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@35@03))))))[0] != -2) | live]
(push) ; 5
; [then-branch: 15 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@35@03))))))[0] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
        0)
      (- 0 2)))))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@40@03 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 16 | 0 <= i@40@03 | live]
; [else-branch: 16 | !(0 <= i@40@03) | live]
(push) ; 8
; [then-branch: 16 | 0 <= i@40@03]
(assert (<= 0 i@40@03))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 16 | !(0 <= i@40@03)]
(assert (not (<= 0 i@40@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 17 | i@40@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i@40@03 | live]
; [else-branch: 17 | !(i@40@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i@40@03) | live]
(push) ; 8
; [then-branch: 17 | i@40@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i@40@03]
(assert (and
  (<
    i@40@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
  (<= 0 i@40@03)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@40@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               913
;  :arith-add-rows          6
;  :arith-assert-diseq      16
;  :arith-assert-lower      63
;  :arith-assert-upper      50
;  :arith-conflicts         15
;  :arith-eq-adapter        35
;  :arith-fixed-eqs         23
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              55
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             658
;  :mk-clause               98
;  :num-allocs              3431517
;  :num-checks              76
;  :propagations            57
;  :quant-instantiations    47
;  :rlimit-count            119934)
; [eval] -1
(push) ; 9
; [then-branch: 18 | First:(Second:(Second:(Second:($t@35@03))))[i@40@03] == -1 | live]
; [else-branch: 18 | First:(Second:(Second:(Second:($t@35@03))))[i@40@03] != -1 | live]
(push) ; 10
; [then-branch: 18 | First:(Second:(Second:(Second:($t@35@03))))[i@40@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i@40@03)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 18 | First:(Second:(Second:(Second:($t@35@03))))[i@40@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      i@40@03)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@40@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               915
;  :arith-add-rows          6
;  :arith-assert-diseq      18
;  :arith-assert-lower      66
;  :arith-assert-upper      51
;  :arith-conflicts         15
;  :arith-eq-adapter        36
;  :arith-fixed-eqs         23
;  :arith-pivots            8
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              55
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             664
;  :mk-clause               102
;  :num-allocs              3431517
;  :num-checks              77
;  :propagations            59
;  :quant-instantiations    48
;  :rlimit-count            120150)
(push) ; 11
; [then-branch: 19 | 0 <= First:(Second:(Second:(Second:($t@35@03))))[i@40@03] | live]
; [else-branch: 19 | !(0 <= First:(Second:(Second:(Second:($t@35@03))))[i@40@03]) | live]
(push) ; 12
; [then-branch: 19 | 0 <= First:(Second:(Second:(Second:($t@35@03))))[i@40@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i@40@03)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@40@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      18
;  :arith-assert-lower      68
;  :arith-assert-upper      52
;  :arith-conflicts         15
;  :arith-eq-adapter        37
;  :arith-fixed-eqs         24
;  :arith-pivots            9
;  :binary-propagations     7
;  :conflicts               37
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              55
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             668
;  :mk-clause               102
;  :num-allocs              3431517
;  :num-checks              78
;  :propagations            59
;  :quant-instantiations    48
;  :rlimit-count            120287)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 19 | !(0 <= First:(Second:(Second:(Second:($t@35@03))))[i@40@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      i@40@03))))
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
; [else-branch: 17 | !(i@40@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i@40@03)]
(assert (not
  (and
    (<
      i@40@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
    (<= 0 i@40@03))))
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
(assert (not (forall ((i@40@03 Int)) (!
  (implies
    (and
      (<
        i@40@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
      (<= 0 i@40@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          i@40@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i@40@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i@40@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i@40@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      20
;  :arith-assert-lower      69
;  :arith-assert-upper      53
;  :arith-conflicts         15
;  :arith-eq-adapter        38
;  :arith-fixed-eqs         25
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               38
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             676
;  :mk-clause               116
;  :num-allocs              3431517
;  :num-checks              79
;  :propagations            61
;  :quant-instantiations    49
;  :rlimit-count            120736)
(assert (forall ((i@40@03 Int)) (!
  (implies
    (and
      (<
        i@40@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
      (<= 0 i@40@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          i@40@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i@40@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i@40@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i@40@03))
  :qid |prog.l<no position>|)))
(declare-const $k@41@03 $Perm)
(assert ($Perm.isReadVar $k@41@03 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@41@03 $Perm.No) (< $Perm.No $k@41@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      21
;  :arith-assert-lower      71
;  :arith-assert-upper      54
;  :arith-conflicts         15
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         25
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             681
;  :mk-clause               118
;  :num-allocs              3431517
;  :num-checks              80
;  :propagations            62
;  :quant-instantiations    49
;  :rlimit-count            121296)
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= $k@37@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      21
;  :arith-assert-lower      71
;  :arith-assert-upper      54
;  :arith-conflicts         15
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         25
;  :arith-pivots            10
;  :binary-propagations     7
;  :conflicts               39
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             681
;  :mk-clause               118
;  :num-allocs              3431517
;  :num-checks              81
;  :propagations            62
;  :quant-instantiations    49
;  :rlimit-count            121307)
(assert (< $k@41@03 $k@37@03))
(assert (<= $Perm.No (- $k@37@03 $k@41@03)))
(assert (<= (- $k@37@03 $k@41@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@37@03 $k@41@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) $Ref.null))))
; [eval] diz.Main_half != null
(push) ; 6
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         15
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         25
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               40
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             684
;  :mk-clause               118
;  :num-allocs              3431517
;  :num-checks              82
;  :propagations            62
;  :quant-instantiations    49
;  :rlimit-count            121527)
(push) ; 6
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         15
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         25
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               41
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             684
;  :mk-clause               118
;  :num-allocs              3431517
;  :num-checks              83
;  :propagations            62
;  :quant-instantiations    49
;  :rlimit-count            121575)
(push) ; 6
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         15
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         25
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               42
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             684
;  :mk-clause               118
;  :num-allocs              3431517
;  :num-checks              84
;  :propagations            62
;  :quant-instantiations    49
;  :rlimit-count            121623)
(push) ; 6
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         15
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         25
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               43
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             684
;  :mk-clause               118
;  :num-allocs              3431517
;  :num-checks              85
;  :propagations            62
;  :quant-instantiations    49
;  :rlimit-count            121671)
(push) ; 6
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         15
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         25
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             684
;  :mk-clause               118
;  :num-allocs              3431517
;  :num-checks              86
;  :propagations            62
;  :quant-instantiations    49
;  :rlimit-count            121719)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         15
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         25
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               44
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             684
;  :mk-clause               118
;  :num-allocs              3431517
;  :num-checks              87
;  :propagations            62
;  :quant-instantiations    49
;  :rlimit-count            121732)
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               917
;  :arith-add-rows          6
;  :arith-assert-diseq      21
;  :arith-assert-lower      73
;  :arith-assert-upper      55
;  :arith-conflicts         15
;  :arith-eq-adapter        39
;  :arith-fixed-eqs         25
;  :arith-pivots            12
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    77
;  :datatype-constructor-ax 159
;  :datatype-occurs-check   57
;  :datatype-splits         111
;  :decisions               143
;  :del-clause              73
;  :final-checks            24
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             684
;  :mk-clause               118
;  :num-allocs              3431517
;  :num-checks              88
;  :propagations            62
;  :quant-instantiations    49
;  :rlimit-count            121780)
(push) ; 6
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               993
;  :arith-add-rows          6
;  :arith-assert-diseq      23
;  :arith-assert-lower      80
;  :arith-assert-upper      58
;  :arith-conflicts         15
;  :arith-eq-adapter        42
;  :arith-fixed-eqs         26
;  :arith-pivots            14
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    80
;  :datatype-constructor-ax 183
;  :datatype-occurs-check   66
;  :datatype-splits         132
;  :decisions               165
;  :del-clause              83
;  :final-checks            27
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             718
;  :mk-clause               128
;  :num-allocs              3431517
;  :num-checks              89
;  :propagations            70
;  :quant-instantiations    52
;  :rlimit-count            122597
;  :time                    0.00)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))))))))))))))) ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) globals@3@03))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
(declare-const $t@42@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
(assert (= $t@42@03 ($Snap.combine ($Snap.first $t@42@03) ($Snap.second $t@42@03))))
(assert (= ($Snap.first $t@42@03) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@42@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@42@03))
    ($Snap.second ($Snap.second $t@42@03)))))
(assert (= ($Snap.first ($Snap.second $t@42@03)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@42@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@42@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@42@03))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@42@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@43@03 Int)
(push) ; 6
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 7
; [then-branch: 20 | 0 <= i@43@03 | live]
; [else-branch: 20 | !(0 <= i@43@03) | live]
(push) ; 8
; [then-branch: 20 | 0 <= i@43@03]
(assert (<= 0 i@43@03))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 20 | !(0 <= i@43@03)]
(assert (not (<= 0 i@43@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 21 | i@43@03 < |First:(Second:(Second:(Second:($t@42@03))))| && 0 <= i@43@03 | live]
; [else-branch: 21 | !(i@43@03 < |First:(Second:(Second:(Second:($t@42@03))))| && 0 <= i@43@03) | live]
(push) ; 8
; [then-branch: 21 | i@43@03 < |First:(Second:(Second:(Second:($t@42@03))))| && 0 <= i@43@03]
(assert (and
  (<
    i@43@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
  (<= 0 i@43@03)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 9
(assert (not (>= i@43@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1155
;  :arith-add-rows          6
;  :arith-assert-diseq      25
;  :arith-assert-lower      92
;  :arith-assert-upper      64
;  :arith-conflicts         15
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         28
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              95
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             779
;  :mk-clause               138
;  :num-allocs              3431517
;  :num-checks              91
;  :propagations            78
;  :quant-instantiations    59
;  :rlimit-count            125287)
; [eval] -1
(push) ; 9
; [then-branch: 22 | First:(Second:(Second:(Second:($t@42@03))))[i@43@03] == -1 | live]
; [else-branch: 22 | First:(Second:(Second:(Second:($t@42@03))))[i@43@03] != -1 | live]
(push) ; 10
; [then-branch: 22 | First:(Second:(Second:(Second:($t@42@03))))[i@43@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
    i@43@03)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 22 | First:(Second:(Second:(Second:($t@42@03))))[i@43@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
      i@43@03)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 11
(assert (not (>= i@43@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1155
;  :arith-add-rows          6
;  :arith-assert-diseq      25
;  :arith-assert-lower      92
;  :arith-assert-upper      64
;  :arith-conflicts         15
;  :arith-eq-adapter        47
;  :arith-fixed-eqs         28
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              95
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             780
;  :mk-clause               138
;  :num-allocs              3431517
;  :num-checks              92
;  :propagations            78
;  :quant-instantiations    59
;  :rlimit-count            125462)
(push) ; 11
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@42@03))))[i@43@03] | live]
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@42@03))))[i@43@03]) | live]
(push) ; 12
; [then-branch: 23 | 0 <= First:(Second:(Second:(Second:($t@42@03))))[i@43@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
    i@43@03)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 13
(assert (not (>= i@43@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1155
;  :arith-add-rows          6
;  :arith-assert-diseq      26
;  :arith-assert-lower      95
;  :arith-assert-upper      64
;  :arith-conflicts         15
;  :arith-eq-adapter        48
;  :arith-fixed-eqs         28
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               45
;  :datatype-accessor-ax    105
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              95
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             783
;  :mk-clause               139
;  :num-allocs              3431517
;  :num-checks              93
;  :propagations            78
;  :quant-instantiations    59
;  :rlimit-count            125586)
; [eval] |diz.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 23 | !(0 <= First:(Second:(Second:(Second:($t@42@03))))[i@43@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
      i@43@03))))
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
; [else-branch: 21 | !(i@43@03 < |First:(Second:(Second:(Second:($t@42@03))))| && 0 <= i@43@03)]
(assert (not
  (and
    (<
      i@43@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
    (<= 0 i@43@03))))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(pop) ; 6
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@43@03 Int)) (!
  (implies
    (and
      (<
        i@43@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
      (<= 0 i@43@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
          i@43@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
            i@43@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
            i@43@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
    i@43@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))))
(declare-const $k@44@03 $Perm)
(assert ($Perm.isReadVar $k@44@03 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@44@03 $Perm.No) (< $Perm.No $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1160
;  :arith-add-rows          6
;  :arith-assert-diseq      27
;  :arith-assert-lower      97
;  :arith-assert-upper      65
;  :arith-conflicts         15
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         28
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               46
;  :datatype-accessor-ax    106
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              96
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             789
;  :mk-clause               141
;  :num-allocs              3431517
;  :num-checks              94
;  :propagations            79
;  :quant-instantiations    59
;  :rlimit-count            126355)
(declare-const $t@45@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@37@03 $k@41@03))
    (=
      $t@45@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))
  (implies
    (< $Perm.No $k@44@03)
    (=
      $t@45@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))))))
(assert (<= $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03)))
(assert (<= (+ (- $k@37@03 $k@41@03) $k@44@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))
  $Snap.unit))
; [eval] diz.Main_half != null
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1170
;  :arith-add-rows          7
;  :arith-assert-diseq      27
;  :arith-assert-lower      98
;  :arith-assert-upper      67
;  :arith-conflicts         16
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         29
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               47
;  :datatype-accessor-ax    107
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              96
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             797
;  :mk-clause               141
;  :num-allocs              3431517
;  :num-checks              95
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            126941)
(assert (not (= $t@45@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))))))
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1175
;  :arith-add-rows          7
;  :arith-assert-diseq      27
;  :arith-assert-lower      98
;  :arith-assert-upper      68
;  :arith-conflicts         17
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         30
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               48
;  :datatype-accessor-ax    108
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              96
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             799
;  :mk-clause               141
;  :num-allocs              3431517
;  :num-checks              96
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            127236)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))))))))
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1180
;  :arith-add-rows          7
;  :arith-assert-diseq      27
;  :arith-assert-lower      98
;  :arith-assert-upper      69
;  :arith-conflicts         18
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         31
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               49
;  :datatype-accessor-ax    109
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              96
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             801
;  :mk-clause               141
;  :num-allocs              3431517
;  :num-checks              97
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            127523)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1185
;  :arith-add-rows          7
;  :arith-assert-diseq      27
;  :arith-assert-lower      98
;  :arith-assert-upper      70
;  :arith-conflicts         19
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         32
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               50
;  :datatype-accessor-ax    110
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              96
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             803
;  :mk-clause               141
;  :num-allocs              3431517
;  :num-checks              98
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            127820)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))))))))))
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1190
;  :arith-add-rows          7
;  :arith-assert-diseq      27
;  :arith-assert-lower      98
;  :arith-assert-upper      71
;  :arith-conflicts         20
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         33
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               51
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              96
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             805
;  :mk-clause               141
;  :num-allocs              3431517
;  :num-checks              99
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            128127)
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1190
;  :arith-add-rows          7
;  :arith-assert-diseq      27
;  :arith-assert-lower      98
;  :arith-assert-upper      72
;  :arith-conflicts         21
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         34
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              96
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             806
;  :mk-clause               141
;  :num-allocs              3431517
;  :num-checks              100
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            128205)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1190
;  :arith-add-rows          7
;  :arith-assert-diseq      27
;  :arith-assert-lower      98
;  :arith-assert-upper      72
;  :arith-conflicts         21
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         34
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              96
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             806
;  :mk-clause               141
;  :num-allocs              3431517
;  :num-checks              101
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            128218)
(set-option :timeout 10)
(push) ; 6
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
  $t@45@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1190
;  :arith-add-rows          7
;  :arith-assert-diseq      27
;  :arith-assert-lower      98
;  :arith-assert-upper      72
;  :arith-conflicts         21
;  :arith-eq-adapter        49
;  :arith-fixed-eqs         34
;  :arith-pivots            16
;  :binary-propagations     7
;  :conflicts               52
;  :datatype-accessor-ax    111
;  :datatype-constructor-ax 207
;  :datatype-occurs-check   110
;  :datatype-splits         153
;  :decisions               187
;  :del-clause              96
;  :final-checks            30
;  :max-generation          2
;  :max-memory              4.09
;  :memory                  4.09
;  :mk-bool-var             806
;  :mk-clause               141
;  :num-allocs              3431517
;  :num-checks              102
;  :propagations            79
;  :quant-instantiations    60
;  :rlimit-count            128229)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))))))))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@42@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) globals@3@03))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
(declare-const $t@46@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
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
; (:added-eqs               1486
;  :arith-add-rows          10
;  :arith-assert-diseq      35
;  :arith-assert-lower      128
;  :arith-assert-upper      86
;  :arith-conflicts         21
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         40
;  :arith-pivots            26
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              142
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             931
;  :mk-clause               186
;  :num-allocs              3690684
;  :num-checks              105
;  :propagations            108
;  :quant-instantiations    71
;  :rlimit-count            130900)
; [eval] diz.Half_adder_m != null
; [eval] |diz.Half_adder_m.Main_process_state| == 1
; [eval] |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_event_state| == 2
; [eval] |diz.Half_adder_m.Main_event_state|
; [eval] (forall i__10: Int :: { diz.Half_adder_m.Main_process_state[i__10] } 0 <= i__10 && i__10 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__10] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|)
(declare-const i__10@47@03 Int)
(push) ; 6
; [eval] 0 <= i__10 && i__10 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__10] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= i__10 && i__10 < |diz.Half_adder_m.Main_process_state|
; [eval] 0 <= i__10
(push) ; 7
; [then-branch: 24 | 0 <= i__10@47@03 | live]
; [else-branch: 24 | !(0 <= i__10@47@03) | live]
(push) ; 8
; [then-branch: 24 | 0 <= i__10@47@03]
(assert (<= 0 i__10@47@03))
; [eval] i__10 < |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_process_state|
(pop) ; 8
(push) ; 8
; [else-branch: 24 | !(0 <= i__10@47@03)]
(assert (not (<= 0 i__10@47@03)))
(pop) ; 8
(pop) ; 7
; Joined path conditions
; Joined path conditions
(push) ; 7
; [then-branch: 25 | i__10@47@03 < |First:(Second:(Second:(Second:($t@42@03))))| && 0 <= i__10@47@03 | live]
; [else-branch: 25 | !(i__10@47@03 < |First:(Second:(Second:(Second:($t@42@03))))| && 0 <= i__10@47@03) | live]
(push) ; 8
; [then-branch: 25 | i__10@47@03 < |First:(Second:(Second:(Second:($t@42@03))))| && 0 <= i__10@47@03]
(assert (and
  (<
    i__10@47@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
  (<= 0 i__10@47@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__10] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__10] == -1
; [eval] diz.Half_adder_m.Main_process_state[i__10]
(push) ; 9
(assert (not (>= i__10@47@03 0)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1487
;  :arith-add-rows          10
;  :arith-assert-diseq      35
;  :arith-assert-lower      129
;  :arith-assert-upper      87
;  :arith-conflicts         21
;  :arith-eq-adapter        63
;  :arith-fixed-eqs         41
;  :arith-pivots            26
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              142
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             933
;  :mk-clause               186
;  :num-allocs              3690684
;  :num-checks              106
;  :propagations            108
;  :quant-instantiations    71
;  :rlimit-count            131040)
; [eval] -1
(push) ; 9
; [then-branch: 26 | First:(Second:(Second:(Second:($t@42@03))))[i__10@47@03] == -1 | live]
; [else-branch: 26 | First:(Second:(Second:(Second:($t@42@03))))[i__10@47@03] != -1 | live]
(push) ; 10
; [then-branch: 26 | First:(Second:(Second:(Second:($t@42@03))))[i__10@47@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
    i__10@47@03)
  (- 0 1)))
(pop) ; 10
(push) ; 10
; [else-branch: 26 | First:(Second:(Second:(Second:($t@42@03))))[i__10@47@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
      i__10@47@03)
    (- 0 1))))
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__10] && diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__10]
; [eval] diz.Half_adder_m.Main_process_state[i__10]
(push) ; 11
(assert (not (>= i__10@47@03 0)))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1489
;  :arith-add-rows          10
;  :arith-assert-diseq      37
;  :arith-assert-lower      132
;  :arith-assert-upper      88
;  :arith-conflicts         21
;  :arith-eq-adapter        64
;  :arith-fixed-eqs         41
;  :arith-pivots            26
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              142
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             940
;  :mk-clause               196
;  :num-allocs              3690684
;  :num-checks              107
;  :propagations            113
;  :quant-instantiations    72
;  :rlimit-count            131234)
(push) ; 11
; [then-branch: 27 | 0 <= First:(Second:(Second:(Second:($t@42@03))))[i__10@47@03] | live]
; [else-branch: 27 | !(0 <= First:(Second:(Second:(Second:($t@42@03))))[i__10@47@03]) | live]
(push) ; 12
; [then-branch: 27 | 0 <= First:(Second:(Second:(Second:($t@42@03))))[i__10@47@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
    i__10@47@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__10] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__10]
(push) ; 13
(assert (not (>= i__10@47@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1491
;  :arith-add-rows          10
;  :arith-assert-diseq      37
;  :arith-assert-lower      134
;  :arith-assert-upper      89
;  :arith-conflicts         21
;  :arith-eq-adapter        65
;  :arith-fixed-eqs         42
;  :arith-pivots            27
;  :binary-propagations     7
;  :conflicts               53
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              142
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             944
;  :mk-clause               196
;  :num-allocs              3690684
;  :num-checks              108
;  :propagations            113
;  :quant-instantiations    72
;  :rlimit-count            131371)
; [eval] |diz.Half_adder_m.Main_event_state|
(pop) ; 12
(push) ; 12
; [else-branch: 27 | !(0 <= First:(Second:(Second:(Second:($t@42@03))))[i__10@47@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
      i__10@47@03))))
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
; [else-branch: 25 | !(i__10@47@03 < |First:(Second:(Second:(Second:($t@42@03))))| && 0 <= i__10@47@03)]
(assert (not
  (and
    (<
      i__10@47@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
    (<= 0 i__10@47@03))))
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
(assert (not (forall ((i__10@47@03 Int)) (!
  (implies
    (and
      (<
        i__10@47@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
      (<= 0 i__10@47@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
          i__10@47@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
            i__10@47@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
            i__10@47@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
    i__10@47@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1491
;  :arith-add-rows          10
;  :arith-assert-diseq      39
;  :arith-assert-lower      135
;  :arith-assert-upper      90
;  :arith-conflicts         21
;  :arith-eq-adapter        66
;  :arith-fixed-eqs         43
;  :arith-pivots            28
;  :binary-propagations     7
;  :conflicts               54
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              166
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             952
;  :mk-clause               210
;  :num-allocs              3690684
;  :num-checks              109
;  :propagations            115
;  :quant-instantiations    73
;  :rlimit-count            131820)
(assert (forall ((i__10@47@03 Int)) (!
  (implies
    (and
      (<
        i__10@47@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))
      (<= 0 i__10@47@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
          i__10@47@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
            i__10@47@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
            i__10@47@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@42@03)))))
    i__10@47@03))
  :qid |prog.l<no position>|)))
(declare-const $k@48@03 $Perm)
(assert ($Perm.isReadVar $k@48@03 $Perm.Write))
(push) ; 6
(assert (not (or (= $k@48@03 $Perm.No) (< $Perm.No $k@48@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1491
;  :arith-add-rows          10
;  :arith-assert-diseq      40
;  :arith-assert-lower      137
;  :arith-assert-upper      91
;  :arith-conflicts         21
;  :arith-eq-adapter        67
;  :arith-fixed-eqs         43
;  :arith-pivots            28
;  :binary-propagations     7
;  :conflicts               55
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              166
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             957
;  :mk-clause               212
;  :num-allocs              3690684
;  :num-checks              110
;  :propagations            116
;  :quant-instantiations    73
;  :rlimit-count            132380)
(set-option :timeout 10)
(push) ; 6
(assert (not (not (= (+ (- $k@37@03 $k@41@03) $k@44@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          10
;  :arith-assert-diseq      40
;  :arith-assert-lower      137
;  :arith-assert-upper      92
;  :arith-conflicts         22
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         43
;  :arith-pivots            28
;  :binary-propagations     7
;  :conflicts               56
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              168
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             959
;  :mk-clause               214
;  :num-allocs              3690684
;  :num-checks              111
;  :propagations            117
;  :quant-instantiations    73
;  :rlimit-count            132458)
(assert (< $k@48@03 (+ (- $k@37@03 $k@41@03) $k@44@03)))
(assert (<= $Perm.No (- (+ (- $k@37@03 $k@41@03) $k@44@03) $k@48@03)))
(assert (<= (- (+ (- $k@37@03 $k@41@03) $k@44@03) $k@48@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@37@03 $k@41@03) $k@44@03) $k@48@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) $Ref.null))))
; [eval] diz.Half_adder_m.Main_half != null
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          11
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      94
;  :arith-conflicts         23
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         44
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               57
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              168
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             963
;  :mk-clause               214
;  :num-allocs              3690684
;  :num-checks              112
;  :propagations            117
;  :quant-instantiations    73
;  :rlimit-count            132730)
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          11
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      95
;  :arith-conflicts         24
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         45
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               58
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              168
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             964
;  :mk-clause               214
;  :num-allocs              3690684
;  :num-checks              113
;  :propagations            117
;  :quant-instantiations    73
;  :rlimit-count            132808)
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          11
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      96
;  :arith-conflicts         25
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         46
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               59
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              168
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             965
;  :mk-clause               214
;  :num-allocs              3690684
;  :num-checks              114
;  :propagations            117
;  :quant-instantiations    73
;  :rlimit-count            132886)
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          11
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      97
;  :arith-conflicts         26
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         47
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               60
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              168
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             966
;  :mk-clause               214
;  :num-allocs              3690684
;  :num-checks              115
;  :propagations            117
;  :quant-instantiations    73
;  :rlimit-count            132964)
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          11
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      98
;  :arith-conflicts         27
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         48
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              168
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             967
;  :mk-clause               214
;  :num-allocs              3690684
;  :num-checks              116
;  :propagations            117
;  :quant-instantiations    73
;  :rlimit-count            133042)
(set-option :timeout 0)
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          11
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      98
;  :arith-conflicts         27
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         48
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               61
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              168
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             967
;  :mk-clause               214
;  :num-allocs              3690684
;  :num-checks              117
;  :propagations            117
;  :quant-instantiations    73
;  :rlimit-count            133055)
(set-option :timeout 10)
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          11
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      99
;  :arith-conflicts         28
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         49
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              168
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             968
;  :mk-clause               214
;  :num-allocs              3690684
;  :num-checks              118
;  :propagations            117
;  :quant-instantiations    73
;  :rlimit-count            133133)
(push) ; 6
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03))))))))))
  $t@45@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1492
;  :arith-add-rows          11
;  :arith-assert-diseq      40
;  :arith-assert-lower      139
;  :arith-assert-upper      99
;  :arith-conflicts         28
;  :arith-eq-adapter        68
;  :arith-fixed-eqs         49
;  :arith-pivots            29
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    119
;  :datatype-constructor-ax 284
;  :datatype-occurs-check   174
;  :datatype-splits         211
;  :decisions               258
;  :del-clause              168
;  :final-checks            36
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             968
;  :mk-clause               214
;  :num-allocs              3690684
;  :num-checks              119
;  :propagations            117
;  :quant-instantiations    73
;  :rlimit-count            133144)
(push) ; 6
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1616
;  :arith-add-rows          13
;  :arith-assert-diseq      43
;  :arith-assert-lower      150
;  :arith-assert-upper      104
;  :arith-conflicts         28
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         51
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               62
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   206
;  :datatype-splits         240
;  :decisions               287
;  :del-clause              185
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1019
;  :mk-clause               231
;  :num-allocs              3690684
;  :num-checks              120
;  :propagations            129
;  :quant-instantiations    78
;  :rlimit-count            134244
;  :time                    0.00)
; [eval] diz.Half_adder_m.Main_half == diz
(push) ; 6
(assert (not (< $Perm.No (+ (- $k@37@03 $k@41@03) $k@44@03))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1616
;  :arith-add-rows          13
;  :arith-assert-diseq      43
;  :arith-assert-lower      150
;  :arith-assert-upper      105
;  :arith-conflicts         29
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         52
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               63
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   206
;  :datatype-splits         240
;  :decisions               287
;  :del-clause              185
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1020
;  :mk-clause               231
;  :num-allocs              3690684
;  :num-checks              121
;  :propagations            129
;  :quant-instantiations    78
;  :rlimit-count            134322)
(set-option :timeout 0)
(push) ; 6
(assert (not (= $t@45@03 diz@2@03)))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1616
;  :arith-add-rows          13
;  :arith-assert-diseq      43
;  :arith-assert-lower      150
;  :arith-assert-upper      105
;  :arith-conflicts         29
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         52
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               63
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   206
;  :datatype-splits         240
;  :decisions               287
;  :del-clause              185
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1020
;  :mk-clause               231
;  :num-allocs              3690684
;  :num-checks              122
;  :propagations            129
;  :quant-instantiations    78
;  :rlimit-count            134333)
(assert (= $t@45@03 diz@2@03))
(push) ; 6
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1616
;  :arith-add-rows          13
;  :arith-assert-diseq      43
;  :arith-assert-lower      150
;  :arith-assert-upper      105
;  :arith-conflicts         29
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         52
;  :arith-pivots            33
;  :binary-propagations     7
;  :conflicts               63
;  :datatype-accessor-ax    123
;  :datatype-constructor-ax 316
;  :datatype-occurs-check   206
;  :datatype-splits         240
;  :decisions               287
;  :del-clause              185
;  :final-checks            39
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1020
;  :mk-clause               231
;  :num-allocs              3690684
;  :num-checks              123
;  :propagations            129
;  :quant-instantiations    78
;  :rlimit-count            134349)
(pop) ; 5
(push) ; 5
; [else-branch: 15 | !(First:(Second:(Second:(Second:($t@35@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@35@03))))))[0] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
          0)
        (- 0 2))))))
(pop) ; 5
(set-option :timeout 10)
(push) ; 5
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1734
;  :arith-add-rows          13
;  :arith-assert-diseq      43
;  :arith-assert-lower      150
;  :arith-assert-upper      105
;  :arith-conflicts         29
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         52
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 353
;  :datatype-occurs-check   218
;  :datatype-splits         277
;  :decisions               317
;  :del-clause              190
;  :final-checks            43
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1059
;  :mk-clause               232
;  :num-allocs              3690684
;  :num-checks              124
;  :propagations            135
;  :quant-instantiations    78
;  :rlimit-count            135299
;  :time                    0.00)
; [eval] !(diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[0] != -2)
; [eval] diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[0] != -2
; [eval] diz.Half_adder_m.Main_process_state[0] != -1
; [eval] diz.Half_adder_m.Main_process_state[0]
(set-option :timeout 0)
(push) ; 5
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1734
;  :arith-add-rows          13
;  :arith-assert-diseq      43
;  :arith-assert-lower      150
;  :arith-assert-upper      105
;  :arith-conflicts         29
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         52
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 353
;  :datatype-occurs-check   218
;  :datatype-splits         277
;  :decisions               317
;  :del-clause              190
;  :final-checks            43
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1059
;  :mk-clause               232
;  :num-allocs              3690684
;  :num-checks              125
;  :propagations            135
;  :quant-instantiations    78
;  :rlimit-count            135314)
; [eval] -1
(push) ; 5
; [then-branch: 28 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1 | live]
; [else-branch: 28 | First:(Second:(Second:(Second:($t@35@03))))[0] == -1 | live]
(push) ; 6
; [then-branch: 28 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      0)
    (- 0 1))))
(pop) ; 6
(push) ; 6
; [else-branch: 28 | First:(Second:(Second:(Second:($t@35@03))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    0)
  (- 0 1)))
; [eval] diz.Half_adder_m.Main_event_state[0] != -2
; [eval] diz.Half_adder_m.Main_event_state[0]
(push) ; 7
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1735
;  :arith-add-rows          13
;  :arith-assert-diseq      43
;  :arith-assert-lower      150
;  :arith-assert-upper      105
;  :arith-conflicts         29
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         52
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    130
;  :datatype-constructor-ax 353
;  :datatype-occurs-check   218
;  :datatype-splits         277
;  :decisions               317
;  :del-clause              190
;  :final-checks            43
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1060
;  :mk-clause               232
;  :num-allocs              3690684
;  :num-checks              126
;  :propagations            135
;  :quant-instantiations    78
;  :rlimit-count            135472)
; [eval] -2
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 5
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
        0)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1809
;  :arith-add-rows          13
;  :arith-assert-diseq      43
;  :arith-assert-lower      150
;  :arith-assert-upper      105
;  :arith-conflicts         29
;  :arith-eq-adapter        73
;  :arith-fixed-eqs         52
;  :arith-pivots            35
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    133
;  :datatype-constructor-ax 377
;  :datatype-occurs-check   227
;  :datatype-splits         298
;  :decisions               338
;  :del-clause              190
;  :final-checks            46
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1082
;  :mk-clause               232
;  :num-allocs              3690684
;  :num-checks              127
;  :propagations            138
;  :quant-instantiations    78
;  :rlimit-count            136328
;  :time                    0.00)
(push) ; 5
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
          0)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1885
;  :arith-add-rows          13
;  :arith-assert-diseq      45
;  :arith-assert-lower      157
;  :arith-assert-upper      108
;  :arith-conflicts         29
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         53
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    136
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              201
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1118
;  :mk-clause               243
;  :num-allocs              3690684
;  :num-checks              128
;  :propagations            146
;  :quant-instantiations    80
;  :rlimit-count            137327
;  :time                    0.00)
; [then-branch: 29 | !(First:(Second:(Second:(Second:($t@35@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@35@03))))))[0] != -2) | live]
; [else-branch: 29 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@35@03))))))[0] != -2 | live]
(push) ; 5
; [then-branch: 29 | !(First:(Second:(Second:(Second:($t@35@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@35@03))))))[0] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
          0)
        (- 0 2))))))
(declare-const s_nand__2@49@03 Bool)
(declare-const s_or__3@50@03 Bool)
(declare-const __flatten_7__11@51@03 Bool)
(declare-const __flatten_8__12@52@03 Bool)
(declare-const __flatten_9__13@53@03 $Ref)
(declare-const __flatten_11__15@54@03 $Ref)
(declare-const __flatten_10__14@55@03 Seq<Int>)
(declare-const __flatten_12__16@56@03 $Ref)
(declare-const __flatten_14__18@57@03 $Ref)
(declare-const __flatten_13__17@58@03 Seq<Int>)
(push) ; 6
; Loop head block: Check well-definedness of invariant
(declare-const $t@59@03 $Snap)
(assert (= $t@59@03 ($Snap.combine ($Snap.first $t@59@03) ($Snap.second $t@59@03))))
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1892
;  :arith-add-rows          13
;  :arith-assert-diseq      45
;  :arith-assert-lower      157
;  :arith-assert-upper      108
;  :arith-conflicts         29
;  :arith-eq-adapter        76
;  :arith-fixed-eqs         53
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    137
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              201
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1121
;  :mk-clause               243
;  :num-allocs              3690684
;  :num-checks              129
;  :propagations            146
;  :quant-instantiations    80
;  :rlimit-count            137644)
(assert (=
  ($Snap.second $t@59@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@59@03))
    ($Snap.second ($Snap.second $t@59@03)))))
(assert (= ($Snap.first ($Snap.second $t@59@03)) $Snap.unit))
; [eval] diz.Half_adder_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@59@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@59@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@59@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
  $Snap.unit))
; [eval] |diz.Half_adder_m.Main_process_state| == 1
; [eval] |diz.Half_adder_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
  $Snap.unit))
; [eval] |diz.Half_adder_m.Main_event_state| == 2
; [eval] |diz.Half_adder_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
  $Snap.unit))
; [eval] (forall i__19: Int :: { diz.Half_adder_m.Main_process_state[i__19] } 0 <= i__19 && i__19 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__19] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|)
(declare-const i__19@60@03 Int)
(push) ; 7
; [eval] 0 <= i__19 && i__19 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__19] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= i__19 && i__19 < |diz.Half_adder_m.Main_process_state|
; [eval] 0 <= i__19
(push) ; 8
; [then-branch: 30 | 0 <= i__19@60@03 | live]
; [else-branch: 30 | !(0 <= i__19@60@03) | live]
(push) ; 9
; [then-branch: 30 | 0 <= i__19@60@03]
(assert (<= 0 i__19@60@03))
; [eval] i__19 < |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 30 | !(0 <= i__19@60@03)]
(assert (not (<= 0 i__19@60@03)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 31 | i__19@60@03 < |First:(Second:(Second:(Second:($t@59@03))))| && 0 <= i__19@60@03 | live]
; [else-branch: 31 | !(i__19@60@03 < |First:(Second:(Second:(Second:($t@59@03))))| && 0 <= i__19@60@03) | live]
(push) ; 9
; [then-branch: 31 | i__19@60@03 < |First:(Second:(Second:(Second:($t@59@03))))| && 0 <= i__19@60@03]
(assert (and
  (<
    i__19@60@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
  (<= 0 i__19@60@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__19] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__19] == -1
; [eval] diz.Half_adder_m.Main_process_state[i__19]
(push) ; 10
(assert (not (>= i__19@60@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1937
;  :arith-add-rows          13
;  :arith-assert-diseq      45
;  :arith-assert-lower      162
;  :arith-assert-upper      111
;  :arith-conflicts         29
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              201
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1146
;  :mk-clause               243
;  :num-allocs              3690684
;  :num-checks              130
;  :propagations            146
;  :quant-instantiations    85
;  :rlimit-count            138927)
; [eval] -1
(push) ; 10
; [then-branch: 32 | First:(Second:(Second:(Second:($t@59@03))))[i__19@60@03] == -1 | live]
; [else-branch: 32 | First:(Second:(Second:(Second:($t@59@03))))[i__19@60@03] != -1 | live]
(push) ; 11
; [then-branch: 32 | First:(Second:(Second:(Second:($t@59@03))))[i__19@60@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
    i__19@60@03)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 32 | First:(Second:(Second:(Second:($t@59@03))))[i__19@60@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
      i__19@60@03)
    (- 0 1))))
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__19]
; [eval] diz.Half_adder_m.Main_process_state[i__19]
(push) ; 12
(assert (not (>= i__19@60@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1937
;  :arith-add-rows          13
;  :arith-assert-diseq      45
;  :arith-assert-lower      162
;  :arith-assert-upper      111
;  :arith-conflicts         29
;  :arith-eq-adapter        78
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              201
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1147
;  :mk-clause               243
;  :num-allocs              3690684
;  :num-checks              131
;  :propagations            146
;  :quant-instantiations    85
;  :rlimit-count            139102)
(push) ; 12
; [then-branch: 33 | 0 <= First:(Second:(Second:(Second:($t@59@03))))[i__19@60@03] | live]
; [else-branch: 33 | !(0 <= First:(Second:(Second:(Second:($t@59@03))))[i__19@60@03]) | live]
(push) ; 13
; [then-branch: 33 | 0 <= First:(Second:(Second:(Second:($t@59@03))))[i__19@60@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
    i__19@60@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__19]
(push) ; 14
(assert (not (>= i__19@60@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1937
;  :arith-add-rows          13
;  :arith-assert-diseq      46
;  :arith-assert-lower      165
;  :arith-assert-upper      111
;  :arith-conflicts         29
;  :arith-eq-adapter        79
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               64
;  :datatype-accessor-ax    144
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              201
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1150
;  :mk-clause               244
;  :num-allocs              3690684
;  :num-checks              132
;  :propagations            146
;  :quant-instantiations    85
;  :rlimit-count            139226)
; [eval] |diz.Half_adder_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 33 | !(0 <= First:(Second:(Second:(Second:($t@59@03))))[i__19@60@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
      i__19@60@03))))
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
; [else-branch: 31 | !(i__19@60@03 < |First:(Second:(Second:(Second:($t@59@03))))| && 0 <= i__19@60@03)]
(assert (not
  (and
    (<
      i__19@60@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
    (<= 0 i__19@60@03))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__19@60@03 Int)) (!
  (implies
    (and
      (<
        i__19@60@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
      (<= 0 i__19@60@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
          i__19@60@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
            i__19@60@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
            i__19@60@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
    i__19@60@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))
(declare-const $k@61@03 $Perm)
(assert ($Perm.isReadVar $k@61@03 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@61@03 $Perm.No) (< $Perm.No $k@61@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1942
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      112
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               65
;  :datatype-accessor-ax    145
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1156
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              133
;  :propagations            147
;  :quant-instantiations    85
;  :rlimit-count            139994)
(assert (<= $Perm.No $k@61@03))
(assert (<= $k@61@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@61@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
  $Snap.unit))
; [eval] diz.Half_adder_m.Main_half != null
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1948
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               66
;  :datatype-accessor-ax    146
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1159
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              134
;  :propagations            147
;  :quant-instantiations    85
;  :rlimit-count            140317)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1954
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               67
;  :datatype-accessor-ax    147
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1162
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              135
;  :propagations            147
;  :quant-instantiations    86
;  :rlimit-count            140673)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1959
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               68
;  :datatype-accessor-ax    148
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1163
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              136
;  :propagations            147
;  :quant-instantiations    86
;  :rlimit-count            140930)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1964
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               69
;  :datatype-accessor-ax    149
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1164
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              137
;  :propagations            147
;  :quant-instantiations    86
;  :rlimit-count            141197)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1969
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               70
;  :datatype-accessor-ax    150
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1165
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              138
;  :propagations            147
;  :quant-instantiations    86
;  :rlimit-count            141474)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))))
(push) ; 7
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1974
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               71
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1166
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              139
;  :propagations            147
;  :quant-instantiations    86
;  :rlimit-count            141761)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1974
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               71
;  :datatype-accessor-ax    151
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1166
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              140
;  :propagations            147
;  :quant-instantiations    86
;  :rlimit-count            141774)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
  $Snap.unit))
; [eval] diz.Half_adder_m.Main_half == diz
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1980
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    152
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1168
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              141
;  :propagations            147
;  :quant-instantiations    86
;  :rlimit-count            142103)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
  diz@2@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))))))
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1988
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              202
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1170
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              142
;  :propagations            147
;  :quant-instantiations    86
;  :rlimit-count            142427)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 7
(pop) ; 7
(push) ; 7
; [eval] !true
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
; (:added-eqs               1998
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      167
;  :arith-assert-upper      113
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         54
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              204
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1175
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              143
;  :propagations            147
;  :quant-instantiations    88
;  :rlimit-count            142843)
; [eval] diz.Half_adder_m != null
; [eval] |diz.Half_adder_m.Main_process_state| == 1
; [eval] |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_event_state| == 2
; [eval] |diz.Half_adder_m.Main_event_state|
; [eval] (forall i__19: Int :: { diz.Half_adder_m.Main_process_state[i__19] } 0 <= i__19 && i__19 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__19] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|)
(declare-const i__19@62@03 Int)
(push) ; 7
; [eval] 0 <= i__19 && i__19 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__19] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= i__19 && i__19 < |diz.Half_adder_m.Main_process_state|
; [eval] 0 <= i__19
(push) ; 8
; [then-branch: 34 | 0 <= i__19@62@03 | live]
; [else-branch: 34 | !(0 <= i__19@62@03) | live]
(push) ; 9
; [then-branch: 34 | 0 <= i__19@62@03]
(assert (<= 0 i__19@62@03))
; [eval] i__19 < |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_process_state|
(pop) ; 9
(push) ; 9
; [else-branch: 34 | !(0 <= i__19@62@03)]
(assert (not (<= 0 i__19@62@03)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 35 | i__19@62@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i__19@62@03 | live]
; [else-branch: 35 | !(i__19@62@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i__19@62@03) | live]
(push) ; 9
; [then-branch: 35 | i__19@62@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i__19@62@03]
(assert (and
  (<
    i__19@62@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
  (<= 0 i__19@62@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__19] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__19] == -1
; [eval] diz.Half_adder_m.Main_process_state[i__19]
(push) ; 10
(assert (not (>= i__19@62@03 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               1999
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      168
;  :arith-assert-upper      114
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         55
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               72
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              204
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1177
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              144
;  :propagations            147
;  :quant-instantiations    88
;  :rlimit-count            142983)
; [eval] -1
(push) ; 10
; [then-branch: 36 | First:(Second:(Second:(Second:($t@35@03))))[i__19@62@03] == -1 | live]
; [else-branch: 36 | First:(Second:(Second:(Second:($t@35@03))))[i__19@62@03] != -1 | live]
(push) ; 11
; [then-branch: 36 | First:(Second:(Second:(Second:($t@35@03))))[i__19@62@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i__19@62@03)
  (- 0 1)))
(pop) ; 11
(push) ; 11
; [else-branch: 36 | First:(Second:(Second:(Second:($t@35@03))))[i__19@62@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      i__19@62@03)
    (- 0 1))))
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__19]
; [eval] diz.Half_adder_m.Main_process_state[i__19]
(push) ; 12
(assert (not (>= i__19@62@03 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      168
;  :arith-assert-upper      114
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         55
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               73
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              204
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1178
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              145
;  :propagations            147
;  :quant-instantiations    88
;  :rlimit-count            143151)
(push) ; 12
; [then-branch: 37 | 0 <= First:(Second:(Second:(Second:($t@35@03))))[i__19@62@03] | live]
; [else-branch: 37 | !(0 <= First:(Second:(Second:(Second:($t@35@03))))[i__19@62@03]) | live]
(push) ; 13
; [then-branch: 37 | 0 <= First:(Second:(Second:(Second:($t@35@03))))[i__19@62@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i__19@62@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__19]
(push) ; 14
(assert (not (>= i__19@62@03 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      47
;  :arith-assert-lower      168
;  :arith-assert-upper      114
;  :arith-conflicts         29
;  :arith-eq-adapter        80
;  :arith-fixed-eqs         55
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               73
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              204
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1179
;  :mk-clause               246
;  :num-allocs              3690684
;  :num-checks              146
;  :propagations            147
;  :quant-instantiations    88
;  :rlimit-count            143256)
; [eval] |diz.Half_adder_m.Main_event_state|
(pop) ; 13
(push) ; 13
; [else-branch: 37 | !(0 <= First:(Second:(Second:(Second:($t@35@03))))[i__19@62@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
      i__19@62@03))))
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
; [else-branch: 35 | !(i__19@62@03 < |First:(Second:(Second:(Second:($t@35@03))))| && 0 <= i__19@62@03)]
(assert (not
  (and
    (<
      i__19@62@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
    (<= 0 i__19@62@03))))
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
(assert (not (forall ((i__19@62@03 Int)) (!
  (implies
    (and
      (<
        i__19@62@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
      (<= 0 i__19@62@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          i__19@62@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i__19@62@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i__19@62@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i__19@62@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      48
;  :arith-assert-lower      169
;  :arith-assert-upper      115
;  :arith-conflicts         29
;  :arith-eq-adapter        81
;  :arith-fixed-eqs         56
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               74
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1187
;  :mk-clause               258
;  :num-allocs              3690684
;  :num-checks              147
;  :propagations            149
;  :quant-instantiations    89
;  :rlimit-count            143699)
(assert (forall ((i__19@62@03 Int)) (!
  (implies
    (and
      (<
        i__19@62@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
      (<= 0 i__19@62@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
          i__19@62@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i__19@62@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
            i__19@62@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
    i__19@62@03))
  :qid |prog.l<no position>|)))
(declare-const $k@63@03 $Perm)
(assert ($Perm.isReadVar $k@63@03 $Perm.Write))
(push) ; 7
(assert (not (or (= $k@63@03 $Perm.No) (< $Perm.No $k@63@03))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      171
;  :arith-assert-upper      116
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               75
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1192
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              148
;  :propagations            150
;  :quant-instantiations    89
;  :rlimit-count            144260)
(set-option :timeout 10)
(push) ; 7
(assert (not (not (= $k@37@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      171
;  :arith-assert-upper      116
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            37
;  :binary-propagations     7
;  :conflicts               75
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1192
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              149
;  :propagations            150
;  :quant-instantiations    89
;  :rlimit-count            144271)
(assert (< $k@63@03 $k@37@03))
(assert (<= $Perm.No (- $k@37@03 $k@63@03)))
(assert (<= (- $k@37@03 $k@63@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@37@03 $k@63@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)) $Ref.null))))
; [eval] diz.Half_adder_m.Main_half != null
(push) ; 7
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               76
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1195
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              150
;  :propagations            150
;  :quant-instantiations    89
;  :rlimit-count            144485)
(push) ; 7
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               77
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1195
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              151
;  :propagations            150
;  :quant-instantiations    89
;  :rlimit-count            144533)
(push) ; 7
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               78
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1195
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              152
;  :propagations            150
;  :quant-instantiations    89
;  :rlimit-count            144581)
(push) ; 7
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               79
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1195
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              153
;  :propagations            150
;  :quant-instantiations    89
;  :rlimit-count            144629)
(push) ; 7
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1195
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              154
;  :propagations            150
;  :quant-instantiations    89
;  :rlimit-count            144677)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               80
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1195
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              155
;  :propagations            150
;  :quant-instantiations    89
;  :rlimit-count            144690)
(set-option :timeout 10)
(push) ; 7
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2000
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    153
;  :datatype-constructor-ax 401
;  :datatype-occurs-check   236
;  :datatype-splits         319
;  :decisions               360
;  :del-clause              216
;  :final-checks            49
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1195
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              156
;  :propagations            150
;  :quant-instantiations    89
;  :rlimit-count            144738)
(push) ; 7
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2072
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               81
;  :datatype-accessor-ax    156
;  :datatype-constructor-ax 425
;  :datatype-occurs-check   245
;  :datatype-splits         340
;  :decisions               381
;  :del-clause              216
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1215
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              157
;  :propagations            153
;  :quant-instantiations    89
;  :rlimit-count            145411
;  :time                    0.00)
; [eval] diz.Half_adder_m.Main_half == diz
(push) ; 7
(assert (not (< $Perm.No $k@37@03)))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2072
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               82
;  :datatype-accessor-ax    156
;  :datatype-constructor-ax 425
;  :datatype-occurs-check   245
;  :datatype-splits         340
;  :decisions               381
;  :del-clause              216
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1215
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              158
;  :propagations            153
;  :quant-instantiations    89
;  :rlimit-count            145459)
(set-option :timeout 0)
(push) ; 7
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2072
;  :arith-add-rows          13
;  :arith-assert-diseq      49
;  :arith-assert-lower      173
;  :arith-assert-upper      117
;  :arith-conflicts         29
;  :arith-eq-adapter        82
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               82
;  :datatype-accessor-ax    156
;  :datatype-constructor-ax 425
;  :datatype-occurs-check   245
;  :datatype-splits         340
;  :decisions               381
;  :del-clause              216
;  :final-checks            52
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1215
;  :mk-clause               260
;  :num-allocs              3690684
;  :num-checks              159
;  :propagations            153
;  :quant-instantiations    89
;  :rlimit-count            145472)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 7
(assert ($Perm.isReadVar $k@61@03 $Perm.Write))
(assert (= $t@59@03 ($Snap.combine ($Snap.first $t@59@03) ($Snap.second $t@59@03))))
(assert (=
  ($Snap.second $t@59@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@59@03))
    ($Snap.second ($Snap.second $t@59@03)))))
(assert (= ($Snap.first ($Snap.second $t@59@03)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@59@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@59@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@59@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
  $Snap.unit))
(assert (forall ((i__19@60@03 Int)) (!
  (implies
    (and
      (<
        i__19@60@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
      (<= 0 i__19@60@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
          i__19@60@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
            i__19@60@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
            i__19@60@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
    i__19@60@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))
(assert (<= $Perm.No $k@61@03))
(assert (<= $k@61@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@61@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))
  diz@2@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
(push) ; 8
(assert (not false))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2567
;  :arith-add-rows          13
;  :arith-assert-diseq      50
;  :arith-assert-lower      179
;  :arith-assert-upper      121
;  :arith-conflicts         29
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1355
;  :mk-clause               265
;  :num-allocs              3690684
;  :num-checks              162
;  :propagations            165
;  :quant-instantiations    97
;  :rlimit-count            150890
;  :time                    0.00)
; [then-branch: 38 | True | live]
; [else-branch: 38 | False | dead]
(push) ; 8
; [then-branch: 38 | True]
; [exec]
; s_nand__2 := !(diz.Half_adder_a && diz.Half_adder_b)
; [eval] !(diz.Half_adder_a && diz.Half_adder_b)
; [eval] diz.Half_adder_a && diz.Half_adder_b
(push) ; 9
; [then-branch: 39 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03))))))))))) | live]
; [else-branch: 39 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03)))))))))))) | live]
(push) ; 10
; [then-branch: 39 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03)))))))))))]
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
(pop) ; 10
(push) ; 10
; [else-branch: 39 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03))))))))))))]
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(declare-const s_nand__2@64@03 Bool)
(assert (=
  s_nand__2@64@03
  (not
    (and
      ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
      ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
; [exec]
; s_or__3 := diz.Half_adder_a || diz.Half_adder_b
; [eval] diz.Half_adder_a || diz.Half_adder_b
(push) ; 9
; [then-branch: 40 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03))))))))))) | live]
; [else-branch: 40 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03)))))))))))) | live]
(push) ; 10
; [then-branch: 40 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03)))))))))))]
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
(pop) ; 10
(push) ; 10
; [else-branch: 40 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03))))))))))))]
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(declare-const s_or__3@65@03 Bool)
(assert (=
  s_or__3@65@03
  (or
    ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))
    ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))))
; [exec]
; __flatten_7__11 := s_nand__2 && s_or__3
; [eval] s_nand__2 && s_or__3
(push) ; 9
; [then-branch: 41 | s_nand__2@64@03 | live]
; [else-branch: 41 | !(s_nand__2@64@03) | live]
(push) ; 10
; [then-branch: 41 | s_nand__2@64@03]
(assert s_nand__2@64@03)
(pop) ; 10
(push) ; 10
; [else-branch: 41 | !(s_nand__2@64@03)]
(assert (not s_nand__2@64@03))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(declare-const __flatten_7__11@66@03 Bool)
(assert (= __flatten_7__11@66@03 (and s_or__3@65@03 s_nand__2@64@03)))
; [exec]
; diz.Half_adder_sum := __flatten_7__11
; [exec]
; __flatten_8__12 := diz.Half_adder_a && diz.Half_adder_b
; [eval] diz.Half_adder_a && diz.Half_adder_b
(push) ; 9
; [then-branch: 42 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03))))))))))) | live]
; [else-branch: 42 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03)))))))))))) | live]
(push) ; 10
; [then-branch: 42 | First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03)))))))))))]
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
(pop) ; 10
(push) ; 10
; [else-branch: 42 | !(First:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:(Second:($t@59@03))))))))))))]
(assert (not
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03))))))))))))))
(pop) ; 10
(pop) ; 9
; Joined path conditions
; Joined path conditions
(declare-const __flatten_8__12@67@03 Bool)
(assert (=
  __flatten_8__12@67@03
  (and
    ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
    ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))))
; [exec]
; diz.Half_adder_carry := __flatten_8__12
; [exec]
; __flatten_9__13 := diz.Half_adder_m
(declare-const __flatten_9__13@68@03 $Ref)
(assert (= __flatten_9__13@68@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03))))
; [exec]
; __flatten_11__15 := diz.Half_adder_m
(declare-const __flatten_11__15@69@03 $Ref)
(assert (= __flatten_11__15@69@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03))))
; [exec]
; __flatten_10__14 := __flatten_11__15.Main_process_state[0 := 1]
; [eval] __flatten_11__15.Main_process_state[0 := 1]
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)) __flatten_11__15@69@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2569
;  :arith-add-rows          13
;  :arith-assert-diseq      50
;  :arith-assert-lower      179
;  :arith-assert-upper      121
;  :arith-conflicts         29
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1366
;  :mk-clause               282
;  :num-allocs              3690684
;  :num-checks              163
;  :propagations            165
;  :quant-instantiations    97
;  :rlimit-count            151960)
(set-option :timeout 0)
(push) ; 9
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2569
;  :arith-add-rows          13
;  :arith-assert-diseq      50
;  :arith-assert-lower      179
;  :arith-assert-upper      121
;  :arith-conflicts         29
;  :arith-eq-adapter        85
;  :arith-fixed-eqs         56
;  :arith-pivots            38
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1366
;  :mk-clause               282
;  :num-allocs              3690684
;  :num-checks              164
;  :propagations            165
;  :quant-instantiations    97
;  :rlimit-count            151975)
(declare-const __flatten_10__14@70@03 Seq<Int>)
(assert (Seq_equal
  __flatten_10__14@70@03
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))
    0
    1)))
; [exec]
; __flatten_9__13.Main_process_state := __flatten_10__14
(set-option :timeout 10)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)) __flatten_9__13@68@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2579
;  :arith-add-rows          14
;  :arith-assert-diseq      51
;  :arith-assert-lower      183
;  :arith-assert-upper      123
;  :arith-conflicts         29
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         58
;  :arith-pivots            39
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1389
;  :mk-clause               301
;  :num-allocs              3690684
;  :num-checks              165
;  :propagations            174
;  :quant-instantiations    102
;  :rlimit-count            152419)
(assert (not (= __flatten_9__13@68@03 $Ref.null)))
; [exec]
; __flatten_12__16 := diz.Half_adder_m
(declare-const __flatten_12__16@71@03 $Ref)
(assert (= __flatten_12__16@71@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03))))
; [exec]
; __flatten_14__18 := diz.Half_adder_m
(declare-const __flatten_14__18@72@03 $Ref)
(assert (= __flatten_14__18@72@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03))))
; [exec]
; __flatten_13__17 := __flatten_14__18.Main_event_state[1 := 50]
; [eval] __flatten_14__18.Main_event_state[1 := 50]
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)) __flatten_14__18@72@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          14
;  :arith-assert-diseq      51
;  :arith-assert-lower      183
;  :arith-assert-upper      123
;  :arith-conflicts         29
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         58
;  :arith-pivots            39
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1392
;  :mk-clause               301
;  :num-allocs              3690684
;  :num-checks              166
;  :propagations            174
;  :quant-instantiations    102
;  :rlimit-count            152546)
(set-option :timeout 0)
(push) ; 9
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2582
;  :arith-add-rows          14
;  :arith-assert-diseq      51
;  :arith-assert-lower      183
;  :arith-assert-upper      123
;  :arith-conflicts         29
;  :arith-eq-adapter        88
;  :arith-fixed-eqs         58
;  :arith-pivots            39
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1392
;  :mk-clause               301
;  :num-allocs              3690684
;  :num-checks              167
;  :propagations            174
;  :quant-instantiations    102
;  :rlimit-count            152561)
(declare-const __flatten_13__17@73@03 Seq<Int>)
(assert (Seq_equal
  __flatten_13__17@73@03
  (Seq_update
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))
    1
    50)))
; [exec]
; __flatten_12__16.Main_event_state := __flatten_13__17
(set-option :timeout 10)
(push) ; 9
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)) __flatten_12__16@71@03)))
(check-sat)
; unsat
(pop) ; 9
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2592
;  :arith-add-rows          17
;  :arith-assert-diseq      52
;  :arith-assert-lower      187
;  :arith-assert-upper      125
;  :arith-conflicts         29
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         60
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    185
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1415
;  :mk-clause               320
;  :num-allocs              3690684
;  :num-checks              168
;  :propagations            183
;  :quant-instantiations    107
;  :rlimit-count            153063)
(assert (not (= __flatten_12__16@71@03 $Ref.null)))
(push) ; 9
; Loop head block: Check well-definedness of invariant
(declare-const $t@74@03 $Snap)
(assert (= $t@74@03 ($Snap.combine ($Snap.first $t@74@03) ($Snap.second $t@74@03))))
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2597
;  :arith-add-rows          17
;  :arith-assert-diseq      52
;  :arith-assert-lower      187
;  :arith-assert-upper      125
;  :arith-conflicts         29
;  :arith-eq-adapter        91
;  :arith-fixed-eqs         60
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    186
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1416
;  :mk-clause               320
;  :num-allocs              3690684
;  :num-checks              169
;  :propagations            183
;  :quant-instantiations    107
;  :rlimit-count            153196)
(assert (=
  ($Snap.second $t@74@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@74@03))
    ($Snap.second ($Snap.second $t@74@03)))))
(assert (= ($Snap.first ($Snap.second $t@74@03)) $Snap.unit))
; [eval] diz.Half_adder_m != null
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@74@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@74@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@74@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
  $Snap.unit))
; [eval] |diz.Half_adder_m.Main_process_state| == 1
; [eval] |diz.Half_adder_m.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
  $Snap.unit))
; [eval] |diz.Half_adder_m.Main_event_state| == 2
; [eval] |diz.Half_adder_m.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
  $Snap.unit))
; [eval] (forall i__20: Int :: { diz.Half_adder_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__20] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|)
(declare-const i__20@75@03 Int)
(push) ; 10
; [eval] 0 <= i__20 && i__20 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__20] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.Half_adder_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 11
; [then-branch: 43 | 0 <= i__20@75@03 | live]
; [else-branch: 43 | !(0 <= i__20@75@03) | live]
(push) ; 12
; [then-branch: 43 | 0 <= i__20@75@03]
(assert (<= 0 i__20@75@03))
; [eval] i__20 < |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_process_state|
(pop) ; 12
(push) ; 12
; [else-branch: 43 | !(0 <= i__20@75@03)]
(assert (not (<= 0 i__20@75@03)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
; [then-branch: 44 | i__20@75@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i__20@75@03 | live]
; [else-branch: 44 | !(i__20@75@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i__20@75@03) | live]
(push) ; 12
; [then-branch: 44 | i__20@75@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i__20@75@03]
(assert (and
  (<
    i__20@75@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
  (<= 0 i__20@75@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__20] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__20] == -1
; [eval] diz.Half_adder_m.Main_process_state[i__20]
(push) ; 13
(assert (not (>= i__20@75@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2642
;  :arith-add-rows          17
;  :arith-assert-diseq      52
;  :arith-assert-lower      192
;  :arith-assert-upper      128
;  :arith-conflicts         29
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1441
;  :mk-clause               320
;  :num-allocs              3690684
;  :num-checks              170
;  :propagations            183
;  :quant-instantiations    112
;  :rlimit-count            154477)
; [eval] -1
(push) ; 13
; [then-branch: 45 | First:(Second:(Second:(Second:($t@74@03))))[i__20@75@03] == -1 | live]
; [else-branch: 45 | First:(Second:(Second:(Second:($t@74@03))))[i__20@75@03] != -1 | live]
(push) ; 14
; [then-branch: 45 | First:(Second:(Second:(Second:($t@74@03))))[i__20@75@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i__20@75@03)
  (- 0 1)))
(pop) ; 14
(push) ; 14
; [else-branch: 45 | First:(Second:(Second:(Second:($t@74@03))))[i__20@75@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      i__20@75@03)
    (- 0 1))))
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__20]
; [eval] diz.Half_adder_m.Main_process_state[i__20]
(push) ; 15
(assert (not (>= i__20@75@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2642
;  :arith-add-rows          17
;  :arith-assert-diseq      52
;  :arith-assert-lower      192
;  :arith-assert-upper      128
;  :arith-conflicts         29
;  :arith-eq-adapter        93
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1442
;  :mk-clause               320
;  :num-allocs              3690684
;  :num-checks              171
;  :propagations            183
;  :quant-instantiations    112
;  :rlimit-count            154652)
(push) ; 15
; [then-branch: 46 | 0 <= First:(Second:(Second:(Second:($t@74@03))))[i__20@75@03] | live]
; [else-branch: 46 | !(0 <= First:(Second:(Second:(Second:($t@74@03))))[i__20@75@03]) | live]
(push) ; 16
; [then-branch: 46 | 0 <= First:(Second:(Second:(Second:($t@74@03))))[i__20@75@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i__20@75@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__20]
(push) ; 17
(assert (not (>= i__20@75@03 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2642
;  :arith-add-rows          17
;  :arith-assert-diseq      53
;  :arith-assert-lower      195
;  :arith-assert-upper      128
;  :arith-conflicts         29
;  :arith-eq-adapter        94
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               83
;  :datatype-accessor-ax    193
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              220
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1445
;  :mk-clause               321
;  :num-allocs              3690684
;  :num-checks              172
;  :propagations            183
;  :quant-instantiations    112
;  :rlimit-count            154775)
; [eval] |diz.Half_adder_m.Main_event_state|
(pop) ; 16
(push) ; 16
; [else-branch: 46 | !(0 <= First:(Second:(Second:(Second:($t@74@03))))[i__20@75@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      i__20@75@03))))
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 44 | !(i__20@75@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i__20@75@03)]
(assert (not
  (and
    (<
      i__20@75@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
    (<= 0 i__20@75@03))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i__20@75@03 Int)) (!
  (implies
    (and
      (<
        i__20@75@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
      (<= 0 i__20@75@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          i__20@75@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i__20@75@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i__20@75@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i__20@75@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))
(declare-const $k@76@03 $Perm)
(assert ($Perm.isReadVar $k@76@03 $Perm.Write))
(push) ; 10
(assert (not (or (= $k@76@03 $Perm.No) (< $Perm.No $k@76@03))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2647
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      129
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               84
;  :datatype-accessor-ax    194
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1451
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              173
;  :propagations            184
;  :quant-instantiations    112
;  :rlimit-count            155543)
(assert (<= $Perm.No $k@76@03))
(assert (<= $k@76@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@76@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
  $Snap.unit))
; [eval] diz.Half_adder_m.Main_half != null
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2653
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               85
;  :datatype-accessor-ax    195
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1454
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              174
;  :propagations            184
;  :quant-instantiations    112
;  :rlimit-count            155866)
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))
(push) ; 10
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2659
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               86
;  :datatype-accessor-ax    196
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1457
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              175
;  :propagations            184
;  :quant-instantiations    113
;  :rlimit-count            156222)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))
(push) ; 10
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2664
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               87
;  :datatype-accessor-ax    197
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1458
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              176
;  :propagations            184
;  :quant-instantiations    113
;  :rlimit-count            156479)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
(push) ; 10
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2669
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               88
;  :datatype-accessor-ax    198
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1459
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              177
;  :propagations            184
;  :quant-instantiations    113
;  :rlimit-count            156746)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))
(push) ; 10
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2674
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               89
;  :datatype-accessor-ax    199
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1460
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              178
;  :propagations            184
;  :quant-instantiations    113
;  :rlimit-count            157023)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))))
(push) ; 10
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2679
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               90
;  :datatype-accessor-ax    200
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1461
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              179
;  :propagations            184
;  :quant-instantiations    113
;  :rlimit-count            157310)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2679
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               90
;  :datatype-accessor-ax    200
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1461
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              180
;  :propagations            184
;  :quant-instantiations    113
;  :rlimit-count            157323)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
  $Snap.unit))
; [eval] diz.Half_adder_m.Main_half == diz
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2685
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    201
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1463
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              181
;  :propagations            184
;  :quant-instantiations    113
;  :rlimit-count            157652)
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
  diz@2@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))))))
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2693
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1465
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              182
;  :propagations            184
;  :quant-instantiations    113
;  :rlimit-count            157976)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))
; Loop head block: Check well-definedness of edge conditions
(push) ; 10
; [eval] diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[1] != -2
; [eval] diz.Half_adder_m.Main_process_state[0] != -1
; [eval] diz.Half_adder_m.Main_process_state[0]
(push) ; 11
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2703
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.29
;  :memory                  4.29
;  :mk-bool-var             1470
;  :mk-clause               323
;  :num-allocs              3690684
;  :num-checks              183
;  :propagations            184
;  :quant-instantiations    115
;  :rlimit-count            158384)
; [eval] -1
(push) ; 11
; [then-branch: 47 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1 | live]
; [else-branch: 47 | First:(Second:(Second:(Second:($t@74@03))))[0] == -1 | live]
(push) ; 12
; [then-branch: 47 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      0)
    (- 0 1))))
(pop) ; 12
(push) ; 12
; [else-branch: 47 | First:(Second:(Second:(Second:($t@74@03))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    0)
  (- 0 1)))
; [eval] diz.Half_adder_m.Main_event_state[1] != -2
; [eval] diz.Half_adder_m.Main_event_state[1]
(push) ; 13
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2704
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1471
;  :mk-clause               323
;  :num-allocs              3840780
;  :num-checks              184
;  :propagations            184
;  :quant-instantiations    115
;  :rlimit-count            158546)
; [eval] -2
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(push) ; 10
; [eval] !(diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[1] != -2)
; [eval] diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[1] != -2
; [eval] diz.Half_adder_m.Main_process_state[0] != -1
; [eval] diz.Half_adder_m.Main_process_state[0]
(push) ; 11
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2704
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1471
;  :mk-clause               323
;  :num-allocs              3840780
;  :num-checks              185
;  :propagations            184
;  :quant-instantiations    115
;  :rlimit-count            158566)
; [eval] -1
(push) ; 11
; [then-branch: 48 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1 | live]
; [else-branch: 48 | First:(Second:(Second:(Second:($t@74@03))))[0] == -1 | live]
(push) ; 12
; [then-branch: 48 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      0)
    (- 0 1))))
(pop) ; 12
(push) ; 12
; [else-branch: 48 | First:(Second:(Second:(Second:($t@74@03))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    0)
  (- 0 1)))
; [eval] diz.Half_adder_m.Main_event_state[1] != -2
; [eval] diz.Half_adder_m.Main_event_state[1]
(push) ; 13
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2705
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              221
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1472
;  :mk-clause               323
;  :num-allocs              3840780
;  :num-checks              186
;  :propagations            184
;  :quant-instantiations    115
;  :rlimit-count            158724)
; [eval] -2
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
(pop) ; 9
(push) ; 9
; Loop head block: Establish invariant
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2705
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        95
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               91
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              223
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1472
;  :mk-clause               323
;  :num-allocs              3840780
;  :num-checks              187
;  :propagations            184
;  :quant-instantiations    115
;  :rlimit-count            158742)
; [eval] diz.Half_adder_m != null
; [eval] |diz.Half_adder_m.Main_process_state| == 1
; [eval] |diz.Half_adder_m.Main_process_state|
(push) ; 10
(assert (not (= (Seq_length __flatten_10__14@70@03) 1)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2705
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      197
;  :arith-assert-upper      130
;  :arith-conflicts         29
;  :arith-eq-adapter        96
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               92
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              223
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1475
;  :mk-clause               323
;  :num-allocs              3840780
;  :num-checks              188
;  :propagations            184
;  :quant-instantiations    115
;  :rlimit-count            158816)
(assert (= (Seq_length __flatten_10__14@70@03) 1))
; [eval] |diz.Half_adder_m.Main_event_state| == 2
; [eval] |diz.Half_adder_m.Main_event_state|
(push) ; 10
(assert (not (= (Seq_length __flatten_13__17@73@03) 2)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2706
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      198
;  :arith-assert-upper      131
;  :arith-conflicts         29
;  :arith-eq-adapter        98
;  :arith-fixed-eqs         61
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              223
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1481
;  :mk-clause               323
;  :num-allocs              3840780
;  :num-checks              189
;  :propagations            184
;  :quant-instantiations    115
;  :rlimit-count            158941)
(assert (= (Seq_length __flatten_13__17@73@03) 2))
; [eval] (forall i__20: Int :: { diz.Half_adder_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__20] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|)
(declare-const i__20@77@03 Int)
(push) ; 10
; [eval] 0 <= i__20 && i__20 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__20] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.Half_adder_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 11
; [then-branch: 49 | 0 <= i__20@77@03 | live]
; [else-branch: 49 | !(0 <= i__20@77@03) | live]
(push) ; 12
; [then-branch: 49 | 0 <= i__20@77@03]
(assert (<= 0 i__20@77@03))
; [eval] i__20 < |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_process_state|
(pop) ; 12
(push) ; 12
; [else-branch: 49 | !(0 <= i__20@77@03)]
(assert (not (<= 0 i__20@77@03)))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(push) ; 11
; [then-branch: 50 | i__20@77@03 < |__flatten_10__14@70@03| && 0 <= i__20@77@03 | live]
; [else-branch: 50 | !(i__20@77@03 < |__flatten_10__14@70@03| && 0 <= i__20@77@03) | live]
(push) ; 12
; [then-branch: 50 | i__20@77@03 < |__flatten_10__14@70@03| && 0 <= i__20@77@03]
(assert (and (< i__20@77@03 (Seq_length __flatten_10__14@70@03)) (<= 0 i__20@77@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__20] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__20] == -1
; [eval] diz.Half_adder_m.Main_process_state[i__20]
(push) ; 13
(assert (not (>= i__20@77@03 0)))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2708
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      200
;  :arith-assert-upper      133
;  :arith-conflicts         29
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         62
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              223
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1486
;  :mk-clause               323
;  :num-allocs              3840780
;  :num-checks              190
;  :propagations            184
;  :quant-instantiations    115
;  :rlimit-count            159132)
; [eval] -1
(push) ; 13
; [then-branch: 51 | __flatten_10__14@70@03[i__20@77@03] == -1 | live]
; [else-branch: 51 | __flatten_10__14@70@03[i__20@77@03] != -1 | live]
(push) ; 14
; [then-branch: 51 | __flatten_10__14@70@03[i__20@77@03] == -1]
(assert (= (Seq_index __flatten_10__14@70@03 i__20@77@03) (- 0 1)))
(pop) ; 14
(push) ; 14
; [else-branch: 51 | __flatten_10__14@70@03[i__20@77@03] != -1]
(assert (not (= (Seq_index __flatten_10__14@70@03 i__20@77@03) (- 0 1))))
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__20]
; [eval] diz.Half_adder_m.Main_process_state[i__20]
(push) ; 15
(assert (not (>= i__20@77@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2710
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      200
;  :arith-assert-upper      133
;  :arith-conflicts         29
;  :arith-eq-adapter        99
;  :arith-fixed-eqs         62
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              223
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1488
;  :mk-clause               323
;  :num-allocs              3840780
;  :num-checks              191
;  :propagations            184
;  :quant-instantiations    116
;  :rlimit-count            159290)
(push) ; 15
; [then-branch: 52 | 0 <= __flatten_10__14@70@03[i__20@77@03] | live]
; [else-branch: 52 | !(0 <= __flatten_10__14@70@03[i__20@77@03]) | live]
(push) ; 16
; [then-branch: 52 | 0 <= __flatten_10__14@70@03[i__20@77@03]]
(assert (<= 0 (Seq_index __flatten_10__14@70@03 i__20@77@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__20]
(push) ; 17
(assert (not (>= i__20@77@03 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2711
;  :arith-add-rows          17
;  :arith-assert-diseq      54
;  :arith-assert-lower      202
;  :arith-assert-upper      134
;  :arith-conflicts         29
;  :arith-eq-adapter        100
;  :arith-fixed-eqs         62
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               93
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              223
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1492
;  :mk-clause               323
;  :num-allocs              3840780
;  :num-checks              192
;  :propagations            184
;  :quant-instantiations    116
;  :rlimit-count            159367)
; [eval] |diz.Half_adder_m.Main_event_state|
(pop) ; 16
(push) ; 16
; [else-branch: 52 | !(0 <= __flatten_10__14@70@03[i__20@77@03])]
(assert (not (<= 0 (Seq_index __flatten_10__14@70@03 i__20@77@03))))
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
(push) ; 12
; [else-branch: 50 | !(i__20@77@03 < |__flatten_10__14@70@03| && 0 <= i__20@77@03)]
(assert (not
  (and (< i__20@77@03 (Seq_length __flatten_10__14@70@03)) (<= 0 i__20@77@03))))
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(pop) ; 10
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 10
(assert (not (forall ((i__20@77@03 Int)) (!
  (implies
    (and (< i__20@77@03 (Seq_length __flatten_10__14@70@03)) (<= 0 i__20@77@03))
    (or
      (= (Seq_index __flatten_10__14@70@03 i__20@77@03) (- 0 1))
      (and
        (<
          (Seq_index __flatten_10__14@70@03 i__20@77@03)
          (Seq_length __flatten_13__17@73@03))
        (<= 0 (Seq_index __flatten_10__14@70@03 i__20@77@03)))))
  :pattern ((Seq_index __flatten_10__14@70@03 i__20@77@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      56
;  :arith-assert-lower      203
;  :arith-assert-upper      136
;  :arith-conflicts         29
;  :arith-eq-adapter        103
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               94
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1508
;  :mk-clause               350
;  :num-allocs              3840780
;  :num-checks              193
;  :propagations            190
;  :quant-instantiations    117
;  :rlimit-count            159777)
(assert (forall ((i__20@77@03 Int)) (!
  (implies
    (and (< i__20@77@03 (Seq_length __flatten_10__14@70@03)) (<= 0 i__20@77@03))
    (or
      (= (Seq_index __flatten_10__14@70@03 i__20@77@03) (- 0 1))
      (and
        (<
          (Seq_index __flatten_10__14@70@03 i__20@77@03)
          (Seq_length __flatten_13__17@73@03))
        (<= 0 (Seq_index __flatten_10__14@70@03 i__20@77@03)))))
  :pattern ((Seq_index __flatten_10__14@70@03 i__20@77@03))
  :qid |prog.l<no position>|)))
(declare-const $k@78@03 $Perm)
(assert ($Perm.isReadVar $k@78@03 $Perm.Write))
(push) ; 10
(assert (not (or (= $k@78@03 $Perm.No) (< $Perm.No $k@78@03))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      205
;  :arith-assert-upper      137
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               95
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1513
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              194
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160248)
(set-option :timeout 10)
(push) ; 10
(assert (not (not (= $k@61@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      205
;  :arith-assert-upper      137
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               95
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1513
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              195
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160259)
(assert (< $k@78@03 $k@61@03))
(assert (<= $Perm.No (- $k@61@03 $k@78@03)))
(assert (<= (- $k@61@03 $k@78@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@61@03 $k@78@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)) $Ref.null))))
; [eval] diz.Half_adder_m.Main_half != null
(push) ; 10
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               96
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1516
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              196
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160467)
(push) ; 10
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               97
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1516
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              197
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160515)
(push) ; 10
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               98
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1516
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              198
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160563)
(push) ; 10
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               99
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1516
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              199
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160611)
(push) ; 10
(assert (not (=
  diz@2@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               99
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1516
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              200
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160622)
(push) ; 10
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               100
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1516
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              201
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160670)
(push) ; 10
(assert (not (=
  diz@2@03
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@59@03)))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               100
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1516
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              202
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160681)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               100
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1516
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              203
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160694)
(set-option :timeout 10)
(push) ; 10
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2715
;  :arith-add-rows          17
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            41
;  :binary-propagations     7
;  :conflicts               101
;  :datatype-accessor-ax    202
;  :datatype-constructor-ax 542
;  :datatype-occurs-check   278
;  :datatype-splits         433
;  :decisions               486
;  :del-clause              250
;  :final-checks            61
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1516
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              204
;  :propagations            191
;  :quant-instantiations    117
;  :rlimit-count            160742)
(push) ; 10
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2819
;  :arith-add-rows          19
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               101
;  :datatype-accessor-ax    206
;  :datatype-constructor-ax 574
;  :datatype-occurs-check   290
;  :datatype-splits         462
;  :decisions               515
;  :del-clause              250
;  :final-checks            64
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1546
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              205
;  :propagations            203
;  :quant-instantiations    119
;  :rlimit-count            161679
;  :time                    0.00)
; [eval] diz.Half_adder_m.Main_half == diz
(push) ; 10
(assert (not (< $Perm.No $k@61@03)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2819
;  :arith-add-rows          19
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               102
;  :datatype-accessor-ax    206
;  :datatype-constructor-ax 574
;  :datatype-occurs-check   290
;  :datatype-splits         462
;  :decisions               515
;  :del-clause              250
;  :final-checks            64
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1546
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              206
;  :propagations            203
;  :quant-instantiations    119
;  :rlimit-count            161727)
(set-option :timeout 0)
(push) ; 10
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               2819
;  :arith-add-rows          19
;  :arith-assert-diseq      57
;  :arith-assert-lower      207
;  :arith-assert-upper      138
;  :arith-conflicts         29
;  :arith-eq-adapter        104
;  :arith-fixed-eqs         63
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               102
;  :datatype-accessor-ax    206
;  :datatype-constructor-ax 574
;  :datatype-occurs-check   290
;  :datatype-splits         462
;  :decisions               515
;  :del-clause              250
;  :final-checks            64
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1546
;  :mk-clause               352
;  :num-allocs              3840780
;  :num-checks              207
;  :propagations            203
;  :quant-instantiations    119
;  :rlimit-count            161740)
; Loop head block: Execute statements of loop head block (in invariant state)
(push) ; 10
(assert ($Perm.isReadVar $k@76@03 $Perm.Write))
(assert (= $t@74@03 ($Snap.combine ($Snap.first $t@74@03) ($Snap.second $t@74@03))))
(assert (=
  ($Snap.second $t@74@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@74@03))
    ($Snap.second ($Snap.second $t@74@03)))))
(assert (= ($Snap.first ($Snap.second $t@74@03)) $Snap.unit))
(assert (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second $t@74@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@74@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@74@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
  $Snap.unit))
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
  $Snap.unit))
(assert (forall ((i__20@75@03 Int)) (!
  (implies
    (and
      (<
        i__20@75@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
      (<= 0 i__20@75@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          i__20@75@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i__20@75@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i__20@75@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i__20@75@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))
(assert (<= $Perm.No $k@76@03))
(assert (<= $k@76@03 $Perm.Write))
(assert (implies
  (< $Perm.No $k@76@03)
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
  $Snap.unit))
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
  $Snap.unit))
(assert (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
  diz@2@03))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))))))
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))
  $Snap.unit))
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))))))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
(set-option :timeout 10)
(check-sat)
; unknown
; Loop head block: Follow loop-internal edges
; [eval] diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[1] != -2
; [eval] diz.Half_adder_m.Main_process_state[0] != -1
; [eval] diz.Half_adder_m.Main_process_state[0]
(set-option :timeout 0)
(push) ; 11
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3279
;  :arith-add-rows          19
;  :arith-assert-diseq      58
;  :arith-assert-lower      213
;  :arith-assert-upper      142
;  :arith-conflicts         29
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         63
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               103
;  :datatype-accessor-ax    233
;  :datatype-constructor-ax 678
;  :datatype-occurs-check   318
;  :datatype-splits         540
;  :decisions               611
;  :del-clause              254
;  :final-checks            70
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1676
;  :mk-clause               357
;  :num-allocs              3840780
;  :num-checks              210
;  :propagations            229
;  :quant-instantiations    131
;  :rlimit-count            166841)
; [eval] -1
(push) ; 11
; [then-branch: 53 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1 | live]
; [else-branch: 53 | First:(Second:(Second:(Second:($t@74@03))))[0] == -1 | live]
(push) ; 12
; [then-branch: 53 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      0)
    (- 0 1))))
(pop) ; 12
(push) ; 12
; [else-branch: 53 | First:(Second:(Second:(Second:($t@74@03))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    0)
  (- 0 1)))
; [eval] diz.Half_adder_m.Main_event_state[1] != -2
; [eval] diz.Half_adder_m.Main_event_state[1]
(push) ; 13
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3280
;  :arith-add-rows          19
;  :arith-assert-diseq      58
;  :arith-assert-lower      213
;  :arith-assert-upper      142
;  :arith-conflicts         29
;  :arith-eq-adapter        107
;  :arith-fixed-eqs         63
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               103
;  :datatype-accessor-ax    233
;  :datatype-constructor-ax 678
;  :datatype-occurs-check   318
;  :datatype-splits         540
;  :decisions               611
;  :del-clause              254
;  :final-checks            70
;  :max-generation          2
;  :max-memory              4.39
;  :memory                  4.39
;  :mk-bool-var             1677
;  :mk-clause               357
;  :num-allocs              3840780
;  :num-checks              211
;  :propagations            229
;  :quant-instantiations    131
;  :rlimit-count            166999)
; [eval] -2
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 11
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
          1)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3475
;  :arith-add-rows          19
;  :arith-assert-diseq      59
;  :arith-assert-lower      216
;  :arith-assert-upper      143
;  :arith-conflicts         29
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         63
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               105
;  :datatype-accessor-ax    240
;  :datatype-constructor-ax 737
;  :datatype-occurs-check   338
;  :datatype-splits         583
;  :decisions               665
;  :del-clause              261
;  :final-checks            74
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1738
;  :mk-clause               364
;  :num-allocs              3998257
;  :num-checks              212
;  :propagations            244
;  :quant-instantiations    134
;  :rlimit-count            168605
;  :time                    0.00)
(push) ; 11
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
        1)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3623
;  :arith-add-rows          19
;  :arith-assert-diseq      59
;  :arith-assert-lower      216
;  :arith-assert-upper      143
;  :arith-conflicts         29
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         63
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               105
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              261
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1780
;  :mk-clause               364
;  :num-allocs              3998257
;  :num-checks              213
;  :propagations            257
;  :quant-instantiations    136
;  :rlimit-count            169869
;  :time                    0.00)
; [then-branch: 54 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@74@03))))))[1] != -2 | live]
; [else-branch: 54 | !(First:(Second:(Second:(Second:($t@74@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@74@03))))))[1] != -2) | live]
(push) ; 11
; [then-branch: 54 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@74@03))))))[1] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
        1)
      (- 0 2)))))
; [exec]
; exhale acc(Main_lock_held_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
; [exec]
; fold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
; [eval] diz != null
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@79@03 Int)
(push) ; 12
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 13
; [then-branch: 55 | 0 <= i@79@03 | live]
; [else-branch: 55 | !(0 <= i@79@03) | live]
(push) ; 14
; [then-branch: 55 | 0 <= i@79@03]
(assert (<= 0 i@79@03))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 14
(push) ; 14
; [else-branch: 55 | !(0 <= i@79@03)]
(assert (not (<= 0 i@79@03)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(push) ; 13
; [then-branch: 56 | i@79@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i@79@03 | live]
; [else-branch: 56 | !(i@79@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i@79@03) | live]
(push) ; 14
; [then-branch: 56 | i@79@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i@79@03]
(assert (and
  (<
    i@79@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
  (<= 0 i@79@03)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 15
(assert (not (>= i@79@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3624
;  :arith-add-rows          19
;  :arith-assert-diseq      59
;  :arith-assert-lower      217
;  :arith-assert-upper      144
;  :arith-conflicts         29
;  :arith-eq-adapter        108
;  :arith-fixed-eqs         64
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               105
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              261
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1784
;  :mk-clause               365
;  :num-allocs              3998257
;  :num-checks              214
;  :propagations            257
;  :quant-instantiations    136
;  :rlimit-count            170239)
; [eval] -1
(push) ; 15
; [then-branch: 57 | First:(Second:(Second:(Second:($t@74@03))))[i@79@03] == -1 | live]
; [else-branch: 57 | First:(Second:(Second:(Second:($t@74@03))))[i@79@03] != -1 | live]
(push) ; 16
; [then-branch: 57 | First:(Second:(Second:(Second:($t@74@03))))[i@79@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i@79@03)
  (- 0 1)))
(pop) ; 16
(push) ; 16
; [else-branch: 57 | First:(Second:(Second:(Second:($t@74@03))))[i@79@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      i@79@03)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 17
(assert (not (>= i@79@03 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3626
;  :arith-add-rows          19
;  :arith-assert-diseq      61
;  :arith-assert-lower      220
;  :arith-assert-upper      145
;  :arith-conflicts         29
;  :arith-eq-adapter        109
;  :arith-fixed-eqs         64
;  :arith-pivots            42
;  :binary-propagations     7
;  :conflicts               105
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              261
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1790
;  :mk-clause               369
;  :num-allocs              3998257
;  :num-checks              215
;  :propagations            259
;  :quant-instantiations    137
;  :rlimit-count            170455)
(push) ; 17
; [then-branch: 58 | 0 <= First:(Second:(Second:(Second:($t@74@03))))[i@79@03] | live]
; [else-branch: 58 | !(0 <= First:(Second:(Second:(Second:($t@74@03))))[i@79@03]) | live]
(push) ; 18
; [then-branch: 58 | 0 <= First:(Second:(Second:(Second:($t@74@03))))[i@79@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i@79@03)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 19
(assert (not (>= i@79@03 0)))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      61
;  :arith-assert-lower      222
;  :arith-assert-upper      146
;  :arith-conflicts         29
;  :arith-eq-adapter        110
;  :arith-fixed-eqs         65
;  :arith-pivots            44
;  :binary-propagations     7
;  :conflicts               105
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              261
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1794
;  :mk-clause               369
;  :num-allocs              3998257
;  :num-checks              216
;  :propagations            259
;  :quant-instantiations    137
;  :rlimit-count            170596)
; [eval] |diz.Main_event_state|
(pop) ; 18
(push) ; 18
; [else-branch: 58 | !(0 <= First:(Second:(Second:(Second:($t@74@03))))[i@79@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      i@79@03))))
(pop) ; 18
(pop) ; 17
; Joined path conditions
; Joined path conditions
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 56 | !(i@79@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i@79@03)]
(assert (not
  (and
    (<
      i@79@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
    (<= 0 i@79@03))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 12
(assert (not (forall ((i@79@03 Int)) (!
  (implies
    (and
      (<
        i@79@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
      (<= 0 i@79@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          i@79@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i@79@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i@79@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i@79@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      62
;  :arith-assert-lower      223
;  :arith-assert-upper      147
;  :arith-conflicts         29
;  :arith-eq-adapter        111
;  :arith-fixed-eqs         66
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               106
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1802
;  :mk-clause               381
;  :num-allocs              3998257
;  :num-checks              217
;  :propagations            261
;  :quant-instantiations    138
;  :rlimit-count            171045)
(assert (forall ((i@79@03 Int)) (!
  (implies
    (and
      (<
        i@79@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
      (<= 0 i@79@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          i@79@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i@79@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i@79@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i@79@03))
  :qid |prog.l<no position>|)))
(declare-const $k@80@03 $Perm)
(assert ($Perm.isReadVar $k@80@03 $Perm.Write))
(push) ; 12
(assert (not (or (= $k@80@03 $Perm.No) (< $Perm.No $k@80@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      225
;  :arith-assert-upper      148
;  :arith-conflicts         29
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         66
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               107
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1807
;  :mk-clause               383
;  :num-allocs              3998257
;  :num-checks              218
;  :propagations            262
;  :quant-instantiations    138
;  :rlimit-count            171605)
(set-option :timeout 10)
(push) ; 12
(assert (not (not (= $k@76@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      225
;  :arith-assert-upper      148
;  :arith-conflicts         29
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         66
;  :arith-pivots            45
;  :binary-propagations     7
;  :conflicts               107
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1807
;  :mk-clause               383
;  :num-allocs              3998257
;  :num-checks              219
;  :propagations            262
;  :quant-instantiations    138
;  :rlimit-count            171616)
(assert (< $k@80@03 $k@76@03))
(assert (<= $Perm.No (- $k@76@03 $k@80@03)))
(assert (<= (- $k@76@03 $k@80@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@76@03 $k@80@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) $Ref.null))))
; [eval] diz.Main_half != null
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      227
;  :arith-assert-upper      149
;  :arith-conflicts         29
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         66
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               108
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1810
;  :mk-clause               383
;  :num-allocs              3998257
;  :num-checks              220
;  :propagations            262
;  :quant-instantiations    138
;  :rlimit-count            171830)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      227
;  :arith-assert-upper      149
;  :arith-conflicts         29
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         66
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               109
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1810
;  :mk-clause               383
;  :num-allocs              3998257
;  :num-checks              221
;  :propagations            262
;  :quant-instantiations    138
;  :rlimit-count            171878)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      227
;  :arith-assert-upper      149
;  :arith-conflicts         29
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         66
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               110
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1810
;  :mk-clause               383
;  :num-allocs              3998257
;  :num-checks              222
;  :propagations            262
;  :quant-instantiations    138
;  :rlimit-count            171926)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      227
;  :arith-assert-upper      149
;  :arith-conflicts         29
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         66
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               111
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1810
;  :mk-clause               383
;  :num-allocs              3998257
;  :num-checks              223
;  :propagations            262
;  :quant-instantiations    138
;  :rlimit-count            171974)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      227
;  :arith-assert-upper      149
;  :arith-conflicts         29
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         66
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               112
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1810
;  :mk-clause               383
;  :num-allocs              3998257
;  :num-checks              224
;  :propagations            262
;  :quant-instantiations    138
;  :rlimit-count            172022)
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      227
;  :arith-assert-upper      149
;  :arith-conflicts         29
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         66
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               112
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1810
;  :mk-clause               383
;  :num-allocs              3998257
;  :num-checks              225
;  :propagations            262
;  :quant-instantiations    138
;  :rlimit-count            172035)
(set-option :timeout 10)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3628
;  :arith-add-rows          19
;  :arith-assert-diseq      63
;  :arith-assert-lower      227
;  :arith-assert-upper      149
;  :arith-conflicts         29
;  :arith-eq-adapter        112
;  :arith-fixed-eqs         66
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               113
;  :datatype-accessor-ax    245
;  :datatype-constructor-ax 779
;  :datatype-occurs-check   352
;  :datatype-splits         622
;  :decisions               703
;  :del-clause              277
;  :final-checks            77
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1810
;  :mk-clause               383
;  :num-allocs              3998257
;  :num-checks              226
;  :propagations            262
;  :quant-instantiations    138
;  :rlimit-count            172083)
(push) ; 12
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               3823
;  :arith-add-rows          19
;  :arith-assert-diseq      64
;  :arith-assert-lower      230
;  :arith-assert-upper      150
;  :arith-conflicts         29
;  :arith-eq-adapter        113
;  :arith-fixed-eqs         66
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               115
;  :datatype-accessor-ax    252
;  :datatype-constructor-ax 838
;  :datatype-occurs-check   372
;  :datatype-splits         665
;  :decisions               757
;  :del-clause              283
;  :final-checks            81
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1869
;  :mk-clause               389
;  :num-allocs              3998257
;  :num-checks              227
;  :propagations            277
;  :quant-instantiations    142
;  :rlimit-count            173481
;  :time                    0.00)
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger ($Snap.combine
  $Snap.unit
  ($Snap.combine
    $Snap.unit
    ($Snap.combine
      $Snap.unit
      ($Snap.combine
        ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03))))
        ($Snap.combine
          $Snap.unit
          ($Snap.combine
            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))
            ($Snap.combine
              $Snap.unit
              ($Snap.combine
                $Snap.unit
                ($Snap.combine
                  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
                  ($Snap.combine
                    $Snap.unit
                    ($Snap.combine
                      ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
                      ($Snap.combine
                        ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))
                        ($Snap.combine
                          ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))))
                          ($Snap.combine
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))
                            ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))))))))))))))) ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) globals@3@03))
; [exec]
; exhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
; [exec]
; inhale acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
(declare-const $t@81@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; [exec]
; unfold acc(Main_lock_invariant_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
(assert (= $t@81@03 ($Snap.combine ($Snap.first $t@81@03) ($Snap.second $t@81@03))))
(assert (= ($Snap.first $t@81@03) $Snap.unit))
; [eval] diz != null
(assert (=
  ($Snap.second $t@81@03)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@81@03))
    ($Snap.second ($Snap.second $t@81@03)))))
(assert (= ($Snap.first ($Snap.second $t@81@03)) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second $t@81@03))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@81@03)))
    ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@81@03))) $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@81@03)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
  $Snap.unit))
; [eval] |diz.Main_process_state| == 1
; [eval] |diz.Main_process_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))
  1))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
  $Snap.unit))
; [eval] |diz.Main_event_state| == 2
; [eval] |diz.Main_event_state|
(assert (=
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))
  2))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))
  $Snap.unit))
; [eval] (forall i: Int :: { diz.Main_process_state[i] } 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|)
(declare-const i@82@03 Int)
(push) ; 12
; [eval] 0 <= i && i < |diz.Main_process_state| ==> diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= i && i < |diz.Main_process_state|
; [eval] 0 <= i
(push) ; 13
; [then-branch: 59 | 0 <= i@82@03 | live]
; [else-branch: 59 | !(0 <= i@82@03) | live]
(push) ; 14
; [then-branch: 59 | 0 <= i@82@03]
(assert (<= 0 i@82@03))
; [eval] i < |diz.Main_process_state|
; [eval] |diz.Main_process_state|
(pop) ; 14
(push) ; 14
; [else-branch: 59 | !(0 <= i@82@03)]
(assert (not (<= 0 i@82@03)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(push) ; 13
; [then-branch: 60 | i@82@03 < |First:(Second:(Second:(Second:($t@81@03))))| && 0 <= i@82@03 | live]
; [else-branch: 60 | !(i@82@03 < |First:(Second:(Second:(Second:($t@81@03))))| && 0 <= i@82@03) | live]
(push) ; 14
; [then-branch: 60 | i@82@03 < |First:(Second:(Second:(Second:($t@81@03))))| && 0 <= i@82@03]
(assert (and
  (<
    i@82@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
  (<= 0 i@82@03)))
; [eval] diz.Main_process_state[i] == -1 || 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i] == -1
; [eval] diz.Main_process_state[i]
(set-option :timeout 0)
(push) ; 15
(assert (not (>= i@82@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4104
;  :arith-add-rows          19
;  :arith-assert-diseq      65
;  :arith-assert-lower      238
;  :arith-assert-upper      154
;  :arith-conflicts         29
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         67
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               117
;  :datatype-accessor-ax    281
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              289
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1955
;  :mk-clause               395
;  :num-allocs              3998257
;  :num-checks              229
;  :propagations            292
;  :quant-instantiations    150
;  :rlimit-count            176753)
; [eval] -1
(push) ; 15
; [then-branch: 61 | First:(Second:(Second:(Second:($t@81@03))))[i@82@03] == -1 | live]
; [else-branch: 61 | First:(Second:(Second:(Second:($t@81@03))))[i@82@03] != -1 | live]
(push) ; 16
; [then-branch: 61 | First:(Second:(Second:(Second:($t@81@03))))[i@82@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
    i@82@03)
  (- 0 1)))
(pop) ; 16
(push) ; 16
; [else-branch: 61 | First:(Second:(Second:(Second:($t@81@03))))[i@82@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
      i@82@03)
    (- 0 1))))
; [eval] 0 <= diz.Main_process_state[i] && diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] 0 <= diz.Main_process_state[i]
; [eval] diz.Main_process_state[i]
(push) ; 17
(assert (not (>= i@82@03 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4104
;  :arith-add-rows          19
;  :arith-assert-diseq      65
;  :arith-assert-lower      238
;  :arith-assert-upper      154
;  :arith-conflicts         29
;  :arith-eq-adapter        116
;  :arith-fixed-eqs         67
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               117
;  :datatype-accessor-ax    281
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              289
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1956
;  :mk-clause               395
;  :num-allocs              3998257
;  :num-checks              230
;  :propagations            292
;  :quant-instantiations    150
;  :rlimit-count            176928)
(push) ; 17
; [then-branch: 62 | 0 <= First:(Second:(Second:(Second:($t@81@03))))[i@82@03] | live]
; [else-branch: 62 | !(0 <= First:(Second:(Second:(Second:($t@81@03))))[i@82@03]) | live]
(push) ; 18
; [then-branch: 62 | 0 <= First:(Second:(Second:(Second:($t@81@03))))[i@82@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
    i@82@03)))
; [eval] diz.Main_process_state[i] < |diz.Main_event_state|
; [eval] diz.Main_process_state[i]
(push) ; 19
(assert (not (>= i@82@03 0)))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4104
;  :arith-add-rows          19
;  :arith-assert-diseq      66
;  :arith-assert-lower      241
;  :arith-assert-upper      154
;  :arith-conflicts         29
;  :arith-eq-adapter        117
;  :arith-fixed-eqs         67
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               117
;  :datatype-accessor-ax    281
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              289
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1959
;  :mk-clause               396
;  :num-allocs              3998257
;  :num-checks              231
;  :propagations            292
;  :quant-instantiations    150
;  :rlimit-count            177051)
; [eval] |diz.Main_event_state|
(pop) ; 18
(push) ; 18
; [else-branch: 62 | !(0 <= First:(Second:(Second:(Second:($t@81@03))))[i@82@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
      i@82@03))))
(pop) ; 18
(pop) ; 17
; Joined path conditions
; Joined path conditions
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 60 | !(i@82@03 < |First:(Second:(Second:(Second:($t@81@03))))| && 0 <= i@82@03)]
(assert (not
  (and
    (<
      i@82@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
    (<= 0 i@82@03))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((i@82@03 Int)) (!
  (implies
    (and
      (<
        i@82@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
      (<= 0 i@82@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
          i@82@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
            i@82@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
            i@82@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
    i@82@03))
  :qid |prog.l<no position>|)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))))
(declare-const $k@83@03 $Perm)
(assert ($Perm.isReadVar $k@83@03 $Perm.Write))
(push) ; 12
(assert (not (or (= $k@83@03 $Perm.No) (< $Perm.No $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4109
;  :arith-add-rows          19
;  :arith-assert-diseq      67
;  :arith-assert-lower      243
;  :arith-assert-upper      155
;  :arith-conflicts         29
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         67
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               118
;  :datatype-accessor-ax    282
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              290
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1965
;  :mk-clause               398
;  :num-allocs              3998257
;  :num-checks              232
;  :propagations            293
;  :quant-instantiations    150
;  :rlimit-count            177820)
(declare-const $t@84@03 $Ref)
(assert (and
  (implies
    (< $Perm.No (- $k@76@03 $k@80@03))
    (=
      $t@84@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))
  (implies
    (< $Perm.No $k@83@03)
    (=
      $t@84@03
      ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))))))
(assert (<= $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03)))
(assert (<= (+ (- $k@76@03 $k@80@03) $k@83@03) $Perm.Write))
(assert (implies
  (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) $Ref.null))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))
  $Snap.unit))
; [eval] diz.Main_half != null
(set-option :timeout 10)
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4119
;  :arith-add-rows          20
;  :arith-assert-diseq      67
;  :arith-assert-lower      244
;  :arith-assert-upper      157
;  :arith-conflicts         30
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         68
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               119
;  :datatype-accessor-ax    283
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              290
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1973
;  :mk-clause               398
;  :num-allocs              3998257
;  :num-checks              233
;  :propagations            293
;  :quant-instantiations    151
;  :rlimit-count            178406)
(assert (not (= $t@84@03 $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))))))
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4124
;  :arith-add-rows          20
;  :arith-assert-diseq      67
;  :arith-assert-lower      244
;  :arith-assert-upper      158
;  :arith-conflicts         31
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         69
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               120
;  :datatype-accessor-ax    284
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              290
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1975
;  :mk-clause               398
;  :num-allocs              3998257
;  :num-checks              234
;  :propagations            293
;  :quant-instantiations    151
;  :rlimit-count            178701)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))))))))
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4129
;  :arith-add-rows          20
;  :arith-assert-diseq      67
;  :arith-assert-lower      244
;  :arith-assert-upper      159
;  :arith-conflicts         32
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         70
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               121
;  :datatype-accessor-ax    285
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              290
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1977
;  :mk-clause               398
;  :num-allocs              3998257
;  :num-checks              235
;  :propagations            293
;  :quant-instantiations    151
;  :rlimit-count            178988)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))))))))
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4134
;  :arith-add-rows          20
;  :arith-assert-diseq      67
;  :arith-assert-lower      244
;  :arith-assert-upper      160
;  :arith-conflicts         33
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         71
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               122
;  :datatype-accessor-ax    286
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              290
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1979
;  :mk-clause               398
;  :num-allocs              3998257
;  :num-checks              236
;  :propagations            293
;  :quant-instantiations    151
;  :rlimit-count            179285)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03))))))))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))))))))))
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4139
;  :arith-add-rows          20
;  :arith-assert-diseq      67
;  :arith-assert-lower      244
;  :arith-assert-upper      161
;  :arith-conflicts         34
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         72
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               123
;  :datatype-accessor-ax    287
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              290
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1981
;  :mk-clause               398
;  :num-allocs              3998257
;  :num-checks              237
;  :propagations            293
;  :quant-instantiations    151
;  :rlimit-count            179592)
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4139
;  :arith-add-rows          20
;  :arith-assert-diseq      67
;  :arith-assert-lower      244
;  :arith-assert-upper      162
;  :arith-conflicts         35
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         73
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               124
;  :datatype-accessor-ax    287
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              290
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1982
;  :mk-clause               398
;  :num-allocs              3998257
;  :num-checks              238
;  :propagations            293
;  :quant-instantiations    151
;  :rlimit-count            179670)
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4139
;  :arith-add-rows          20
;  :arith-assert-diseq      67
;  :arith-assert-lower      244
;  :arith-assert-upper      162
;  :arith-conflicts         35
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         73
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               124
;  :datatype-accessor-ax    287
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              290
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1982
;  :mk-clause               398
;  :num-allocs              3998257
;  :num-checks              239
;  :propagations            293
;  :quant-instantiations    151
;  :rlimit-count            179683)
(set-option :timeout 10)
(push) ; 12
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
  $t@84@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4139
;  :arith-add-rows          20
;  :arith-assert-diseq      67
;  :arith-assert-lower      244
;  :arith-assert-upper      162
;  :arith-conflicts         35
;  :arith-eq-adapter        118
;  :arith-fixed-eqs         73
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               124
;  :datatype-accessor-ax    287
;  :datatype-constructor-ax 897
;  :datatype-occurs-check   434
;  :datatype-splits         708
;  :decisions               811
;  :del-clause              290
;  :final-checks            85
;  :max-generation          2
;  :max-memory              4.49
;  :memory                  4.49
;  :mk-bool-var             1982
;  :mk-clause               398
;  :num-allocs              3998257
;  :num-checks              240
;  :propagations            293
;  :quant-instantiations    151
;  :rlimit-count            179694)
(assert (=
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))))))))
  ($SortWrappers.$SnapToBool ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))))))))))
; State saturation: after unfold
(set-option :timeout 40)
(check-sat)
; unknown
(assert (Main_lock_invariant_EncodedGlobalVariables%trigger $t@81@03 ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) globals@3@03))
; [exec]
; inhale acc(Main_lock_held_EncodedGlobalVariables(diz.Half_adder_m, globals), write)
(declare-const $t@85@03 $Snap)
; State saturation: after inhale
(set-option :timeout 20)
(check-sat)
; unknown
; Loop head block: Re-establish invariant
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4709
;  :arith-add-rows          20
;  :arith-assert-diseq      69
;  :arith-assert-lower      250
;  :arith-assert-upper      164
;  :arith-conflicts         35
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         73
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               129
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              300
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2114
;  :mk-clause               411
;  :num-allocs              4164245
;  :num-checks              243
;  :propagations            334
;  :quant-instantiations    160
;  :rlimit-count            183348)
; [eval] diz.Half_adder_m != null
; [eval] |diz.Half_adder_m.Main_process_state| == 1
; [eval] |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_event_state| == 2
; [eval] |diz.Half_adder_m.Main_event_state|
; [eval] (forall i__20: Int :: { diz.Half_adder_m.Main_process_state[i__20] } 0 <= i__20 && i__20 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__20] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|)
(declare-const i__20@86@03 Int)
(push) ; 12
; [eval] 0 <= i__20 && i__20 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__20] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= i__20 && i__20 < |diz.Half_adder_m.Main_process_state|
; [eval] 0 <= i__20
(push) ; 13
; [then-branch: 63 | 0 <= i__20@86@03 | live]
; [else-branch: 63 | !(0 <= i__20@86@03) | live]
(push) ; 14
; [then-branch: 63 | 0 <= i__20@86@03]
(assert (<= 0 i__20@86@03))
; [eval] i__20 < |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_process_state|
(pop) ; 14
(push) ; 14
; [else-branch: 63 | !(0 <= i__20@86@03)]
(assert (not (<= 0 i__20@86@03)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(push) ; 13
; [then-branch: 64 | i__20@86@03 < |First:(Second:(Second:(Second:($t@81@03))))| && 0 <= i__20@86@03 | live]
; [else-branch: 64 | !(i__20@86@03 < |First:(Second:(Second:(Second:($t@81@03))))| && 0 <= i__20@86@03) | live]
(push) ; 14
; [then-branch: 64 | i__20@86@03 < |First:(Second:(Second:(Second:($t@81@03))))| && 0 <= i__20@86@03]
(assert (and
  (<
    i__20@86@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
  (<= 0 i__20@86@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__20] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__20] == -1
; [eval] diz.Half_adder_m.Main_process_state[i__20]
(push) ; 15
(assert (not (>= i__20@86@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4710
;  :arith-add-rows          20
;  :arith-assert-diseq      69
;  :arith-assert-lower      251
;  :arith-assert-upper      165
;  :arith-conflicts         35
;  :arith-eq-adapter        120
;  :arith-fixed-eqs         74
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               129
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              300
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2116
;  :mk-clause               411
;  :num-allocs              4164245
;  :num-checks              244
;  :propagations            334
;  :quant-instantiations    160
;  :rlimit-count            183488)
; [eval] -1
(push) ; 15
; [then-branch: 65 | First:(Second:(Second:(Second:($t@81@03))))[i__20@86@03] == -1 | live]
; [else-branch: 65 | First:(Second:(Second:(Second:($t@81@03))))[i__20@86@03] != -1 | live]
(push) ; 16
; [then-branch: 65 | First:(Second:(Second:(Second:($t@81@03))))[i__20@86@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
    i__20@86@03)
  (- 0 1)))
(pop) ; 16
(push) ; 16
; [else-branch: 65 | First:(Second:(Second:(Second:($t@81@03))))[i__20@86@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
      i__20@86@03)
    (- 0 1))))
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__20] && diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__20]
; [eval] diz.Half_adder_m.Main_process_state[i__20]
(push) ; 17
(assert (not (>= i__20@86@03 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4712
;  :arith-add-rows          20
;  :arith-assert-diseq      71
;  :arith-assert-lower      254
;  :arith-assert-upper      166
;  :arith-conflicts         35
;  :arith-eq-adapter        121
;  :arith-fixed-eqs         74
;  :arith-pivots            46
;  :binary-propagations     7
;  :conflicts               129
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              300
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2123
;  :mk-clause               421
;  :num-allocs              4164245
;  :num-checks              245
;  :propagations            339
;  :quant-instantiations    161
;  :rlimit-count            183719)
(push) ; 17
; [then-branch: 66 | 0 <= First:(Second:(Second:(Second:($t@81@03))))[i__20@86@03] | live]
; [else-branch: 66 | !(0 <= First:(Second:(Second:(Second:($t@81@03))))[i__20@86@03]) | live]
(push) ; 18
; [then-branch: 66 | 0 <= First:(Second:(Second:(Second:($t@81@03))))[i__20@86@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
    i__20@86@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__20] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__20]
(push) ; 19
(assert (not (>= i__20@86@03 0)))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4714
;  :arith-add-rows          20
;  :arith-assert-diseq      71
;  :arith-assert-lower      256
;  :arith-assert-upper      167
;  :arith-conflicts         35
;  :arith-eq-adapter        122
;  :arith-fixed-eqs         75
;  :arith-pivots            48
;  :binary-propagations     7
;  :conflicts               129
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              300
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2127
;  :mk-clause               421
;  :num-allocs              4164245
;  :num-checks              246
;  :propagations            339
;  :quant-instantiations    161
;  :rlimit-count            183860)
; [eval] |diz.Half_adder_m.Main_event_state|
(pop) ; 18
(push) ; 18
; [else-branch: 66 | !(0 <= First:(Second:(Second:(Second:($t@81@03))))[i__20@86@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
      i__20@86@03))))
(pop) ; 18
(pop) ; 17
; Joined path conditions
; Joined path conditions
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 64 | !(i__20@86@03 < |First:(Second:(Second:(Second:($t@81@03))))| && 0 <= i__20@86@03)]
(assert (not
  (and
    (<
      i__20@86@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
    (<= 0 i__20@86@03))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 12
(assert (not (forall ((i__20@86@03 Int)) (!
  (implies
    (and
      (<
        i__20@86@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
      (<= 0 i__20@86@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
          i__20@86@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
            i__20@86@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
            i__20@86@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
    i__20@86@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4714
;  :arith-add-rows          20
;  :arith-assert-diseq      73
;  :arith-assert-lower      257
;  :arith-assert-upper      168
;  :arith-conflicts         35
;  :arith-eq-adapter        123
;  :arith-fixed-eqs         76
;  :arith-pivots            49
;  :binary-propagations     7
;  :conflicts               130
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              324
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2135
;  :mk-clause               435
;  :num-allocs              4164245
;  :num-checks              247
;  :propagations            341
;  :quant-instantiations    162
;  :rlimit-count            184309)
(assert (forall ((i__20@86@03 Int)) (!
  (implies
    (and
      (<
        i__20@86@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))
      (<= 0 i__20@86@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
          i__20@86@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
            i__20@86@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
            i__20@86@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@81@03)))))
    i__20@86@03))
  :qid |prog.l<no position>|)))
(declare-const $k@87@03 $Perm)
(assert ($Perm.isReadVar $k@87@03 $Perm.Write))
(push) ; 12
(assert (not (or (= $k@87@03 $Perm.No) (< $Perm.No $k@87@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4714
;  :arith-add-rows          20
;  :arith-assert-diseq      74
;  :arith-assert-lower      259
;  :arith-assert-upper      169
;  :arith-conflicts         35
;  :arith-eq-adapter        124
;  :arith-fixed-eqs         76
;  :arith-pivots            49
;  :binary-propagations     7
;  :conflicts               131
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              324
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2140
;  :mk-clause               437
;  :num-allocs              4164245
;  :num-checks              248
;  :propagations            342
;  :quant-instantiations    162
;  :rlimit-count            184869)
(set-option :timeout 10)
(push) ; 12
(assert (not (not (= (+ (- $k@76@03 $k@80@03) $k@83@03) $Perm.No))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4715
;  :arith-add-rows          20
;  :arith-assert-diseq      74
;  :arith-assert-lower      259
;  :arith-assert-upper      170
;  :arith-conflicts         36
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         76
;  :arith-pivots            49
;  :binary-propagations     7
;  :conflicts               132
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              326
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2142
;  :mk-clause               439
;  :num-allocs              4164245
;  :num-checks              249
;  :propagations            343
;  :quant-instantiations    162
;  :rlimit-count            184947)
(assert (< $k@87@03 (+ (- $k@76@03 $k@80@03) $k@83@03)))
(assert (<= $Perm.No (- (+ (- $k@76@03 $k@80@03) $k@83@03) $k@87@03)))
(assert (<= (- (+ (- $k@76@03 $k@80@03) $k@83@03) $k@87@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- (+ (- $k@76@03 $k@80@03) $k@83@03) $k@87@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) $Ref.null))))
; [eval] diz.Half_adder_m.Main_half != null
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4715
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      261
;  :arith-assert-upper      172
;  :arith-conflicts         37
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         77
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               133
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              326
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2146
;  :mk-clause               439
;  :num-allocs              4164245
;  :num-checks              250
;  :propagations            343
;  :quant-instantiations    162
;  :rlimit-count            185219)
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4715
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      261
;  :arith-assert-upper      173
;  :arith-conflicts         38
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         78
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               134
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              326
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2147
;  :mk-clause               439
;  :num-allocs              4164245
;  :num-checks              251
;  :propagations            343
;  :quant-instantiations    162
;  :rlimit-count            185297)
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4715
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      261
;  :arith-assert-upper      174
;  :arith-conflicts         39
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         79
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               135
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              326
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2148
;  :mk-clause               439
;  :num-allocs              4164245
;  :num-checks              252
;  :propagations            343
;  :quant-instantiations    162
;  :rlimit-count            185375)
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4715
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      261
;  :arith-assert-upper      175
;  :arith-conflicts         40
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         80
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               136
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              326
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2149
;  :mk-clause               439
;  :num-allocs              4164245
;  :num-checks              253
;  :propagations            343
;  :quant-instantiations    162
;  :rlimit-count            185453)
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4715
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      261
;  :arith-assert-upper      176
;  :arith-conflicts         41
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         81
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               137
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              326
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2150
;  :mk-clause               439
;  :num-allocs              4164245
;  :num-checks              254
;  :propagations            343
;  :quant-instantiations    162
;  :rlimit-count            185531)
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4715
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      261
;  :arith-assert-upper      176
;  :arith-conflicts         41
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         81
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               137
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              326
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2150
;  :mk-clause               439
;  :num-allocs              4164245
;  :num-checks              255
;  :propagations            343
;  :quant-instantiations    162
;  :rlimit-count            185544)
(set-option :timeout 10)
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4715
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      261
;  :arith-assert-upper      177
;  :arith-conflicts         42
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         82
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               138
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              326
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2151
;  :mk-clause               439
;  :num-allocs              4164245
;  :num-checks              256
;  :propagations            343
;  :quant-instantiations    162
;  :rlimit-count            185622)
(push) ; 12
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03))))))))))
  $t@84@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4715
;  :arith-add-rows          21
;  :arith-assert-diseq      74
;  :arith-assert-lower      261
;  :arith-assert-upper      177
;  :arith-conflicts         42
;  :arith-eq-adapter        125
;  :arith-fixed-eqs         82
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               138
;  :datatype-accessor-ax    313
;  :datatype-constructor-ax 1054
;  :datatype-occurs-check   546
;  :datatype-splits         826
;  :decisions               946
;  :del-clause              326
;  :final-checks            92
;  :max-generation          2
;  :max-memory              4.59
;  :memory                  4.59
;  :mk-bool-var             2151
;  :mk-clause               439
;  :num-allocs              4164245
;  :num-checks              257
;  :propagations            343
;  :quant-instantiations    162
;  :rlimit-count            185633)
(push) ; 12
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4943
;  :arith-add-rows          21
;  :arith-assert-diseq      75
;  :arith-assert-lower      264
;  :arith-assert-upper      178
;  :arith-conflicts         42
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         82
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               138
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 1116
;  :datatype-occurs-check   600
;  :datatype-splits         885
;  :decisions               998
;  :del-clause              330
;  :final-checks            95
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2202
;  :mk-clause               443
;  :num-allocs              4335493
;  :num-checks              258
;  :propagations            365
;  :quant-instantiations    166
;  :rlimit-count            187088
;  :time                    0.00)
; [eval] diz.Half_adder_m.Main_half == diz
(push) ; 12
(assert (not (< $Perm.No (+ (- $k@76@03 $k@80@03) $k@83@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4943
;  :arith-add-rows          21
;  :arith-assert-diseq      75
;  :arith-assert-lower      264
;  :arith-assert-upper      179
;  :arith-conflicts         43
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         83
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               139
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 1116
;  :datatype-occurs-check   600
;  :datatype-splits         885
;  :decisions               998
;  :del-clause              330
;  :final-checks            95
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2203
;  :mk-clause               443
;  :num-allocs              4335493
;  :num-checks              259
;  :propagations            365
;  :quant-instantiations    166
;  :rlimit-count            187166)
(set-option :timeout 0)
(push) ; 12
(assert (not (= $t@84@03 diz@2@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4943
;  :arith-add-rows          21
;  :arith-assert-diseq      75
;  :arith-assert-lower      264
;  :arith-assert-upper      179
;  :arith-conflicts         43
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         83
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               139
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 1116
;  :datatype-occurs-check   600
;  :datatype-splits         885
;  :decisions               998
;  :del-clause              330
;  :final-checks            95
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2203
;  :mk-clause               443
;  :num-allocs              4335493
;  :num-checks              260
;  :propagations            365
;  :quant-instantiations    166
;  :rlimit-count            187177)
(assert (= $t@84@03 diz@2@03))
(push) ; 12
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               4943
;  :arith-add-rows          21
;  :arith-assert-diseq      75
;  :arith-assert-lower      264
;  :arith-assert-upper      179
;  :arith-conflicts         43
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         83
;  :arith-pivots            50
;  :binary-propagations     7
;  :conflicts               139
;  :datatype-accessor-ax    325
;  :datatype-constructor-ax 1116
;  :datatype-occurs-check   600
;  :datatype-splits         885
;  :decisions               998
;  :del-clause              330
;  :final-checks            95
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2203
;  :mk-clause               443
;  :num-allocs              4335493
;  :num-checks              261
;  :propagations            365
;  :quant-instantiations    166
;  :rlimit-count            187193)
(pop) ; 11
(push) ; 11
; [else-branch: 54 | !(First:(Second:(Second:(Second:($t@74@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@74@03))))))[1] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
          1)
        (- 0 2))))))
(pop) ; 11
(set-option :timeout 10)
(push) ; 11
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03)))))
(check-sat)
; unknown
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5108
;  :arith-add-rows          21
;  :arith-assert-diseq      75
;  :arith-assert-lower      264
;  :arith-assert-upper      179
;  :arith-conflicts         43
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         83
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               140
;  :datatype-accessor-ax    331
;  :datatype-constructor-ax 1165
;  :datatype-occurs-check   615
;  :datatype-splits         926
;  :decisions               1042
;  :del-clause              341
;  :final-checks            98
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2249
;  :mk-clause               444
;  :num-allocs              4335493
;  :num-checks              262
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            188481
;  :time                    0.00)
; [eval] !(diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[1] != -2)
; [eval] diz.Half_adder_m.Main_process_state[0] != -1 || diz.Half_adder_m.Main_event_state[1] != -2
; [eval] diz.Half_adder_m.Main_process_state[0] != -1
; [eval] diz.Half_adder_m.Main_process_state[0]
(set-option :timeout 0)
(push) ; 11
(assert (not (<
  0
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
(check-sat)
; unsat
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5108
;  :arith-add-rows          21
;  :arith-assert-diseq      75
;  :arith-assert-lower      264
;  :arith-assert-upper      179
;  :arith-conflicts         43
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         83
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               140
;  :datatype-accessor-ax    331
;  :datatype-constructor-ax 1165
;  :datatype-occurs-check   615
;  :datatype-splits         926
;  :decisions               1042
;  :del-clause              341
;  :final-checks            98
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2249
;  :mk-clause               444
;  :num-allocs              4335493
;  :num-checks              263
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            188496)
; [eval] -1
(push) ; 11
; [then-branch: 67 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1 | live]
; [else-branch: 67 | First:(Second:(Second:(Second:($t@74@03))))[0] == -1 | live]
(push) ; 12
; [then-branch: 67 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      0)
    (- 0 1))))
(pop) ; 12
(push) ; 12
; [else-branch: 67 | First:(Second:(Second:(Second:($t@74@03))))[0] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    0)
  (- 0 1)))
; [eval] diz.Half_adder_m.Main_event_state[1] != -2
; [eval] diz.Half_adder_m.Main_event_state[1]
(push) ; 13
(assert (not (<
  1
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))))
(check-sat)
; unsat
(pop) ; 13
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5109
;  :arith-add-rows          21
;  :arith-assert-diseq      75
;  :arith-assert-lower      264
;  :arith-assert-upper      179
;  :arith-conflicts         43
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         83
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               140
;  :datatype-accessor-ax    331
;  :datatype-constructor-ax 1165
;  :datatype-occurs-check   615
;  :datatype-splits         926
;  :decisions               1042
;  :del-clause              341
;  :final-checks            98
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2250
;  :mk-clause               444
;  :num-allocs              4335493
;  :num-checks              264
;  :propagations            378
;  :quant-instantiations    168
;  :rlimit-count            188654)
; [eval] -2
(pop) ; 12
(pop) ; 11
; Joined path conditions
; Joined path conditions
(set-option :timeout 10)
(push) ; 11
(assert (not (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
        1)
      (- 0 2))))))
(check-sat)
; unknown
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5257
;  :arith-add-rows          21
;  :arith-assert-diseq      75
;  :arith-assert-lower      264
;  :arith-assert-upper      179
;  :arith-conflicts         43
;  :arith-eq-adapter        126
;  :arith-fixed-eqs         83
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               140
;  :datatype-accessor-ax    336
;  :datatype-constructor-ax 1207
;  :datatype-occurs-check   629
;  :datatype-splits         965
;  :decisions               1080
;  :del-clause              341
;  :final-checks            101
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2292
;  :mk-clause               444
;  :num-allocs              4335493
;  :num-checks              265
;  :propagations            391
;  :quant-instantiations    170
;  :rlimit-count            189918
;  :time                    0.00)
(push) ; 11
(assert (not (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
          1)
        (- 0 2)))))))
(check-sat)
; unknown
(pop) ; 11
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5452
;  :arith-add-rows          21
;  :arith-assert-diseq      76
;  :arith-assert-lower      267
;  :arith-assert-upper      180
;  :arith-conflicts         43
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         83
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               142
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              348
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2353
;  :mk-clause               451
;  :num-allocs              4335493
;  :num-checks              266
;  :propagations            406
;  :quant-instantiations    173
;  :rlimit-count            191498
;  :time                    0.00)
; [then-branch: 68 | !(First:(Second:(Second:(Second:($t@74@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@74@03))))))[1] != -2) | live]
; [else-branch: 68 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@74@03))))))[1] != -2 | live]
(push) ; 11
; [then-branch: 68 | !(First:(Second:(Second:(Second:($t@74@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@74@03))))))[1] != -2)]
(assert (not
  (or
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          0)
        (- 0 1)))
    (not
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
          1)
        (- 0 2))))))
; Loop head block: Re-establish invariant
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5454
;  :arith-add-rows          21
;  :arith-assert-diseq      76
;  :arith-assert-lower      267
;  :arith-assert-upper      180
;  :arith-conflicts         43
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         83
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               142
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              348
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2355
;  :mk-clause               451
;  :num-allocs              4335493
;  :num-checks              267
;  :propagations            406
;  :quant-instantiations    173
;  :rlimit-count            191715)
; [eval] diz.Half_adder_m != null
; [eval] |diz.Half_adder_m.Main_process_state| == 1
; [eval] |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_event_state| == 2
; [eval] |diz.Half_adder_m.Main_event_state|
; [eval] (forall i__19: Int :: { diz.Half_adder_m.Main_process_state[i__19] } 0 <= i__19 && i__19 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__19] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|)
(declare-const i__19@88@03 Int)
(push) ; 12
; [eval] 0 <= i__19 && i__19 < |diz.Half_adder_m.Main_process_state| ==> diz.Half_adder_m.Main_process_state[i__19] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= i__19 && i__19 < |diz.Half_adder_m.Main_process_state|
; [eval] 0 <= i__19
(push) ; 13
; [then-branch: 69 | 0 <= i__19@88@03 | live]
; [else-branch: 69 | !(0 <= i__19@88@03) | live]
(push) ; 14
; [then-branch: 69 | 0 <= i__19@88@03]
(assert (<= 0 i__19@88@03))
; [eval] i__19 < |diz.Half_adder_m.Main_process_state|
; [eval] |diz.Half_adder_m.Main_process_state|
(pop) ; 14
(push) ; 14
; [else-branch: 69 | !(0 <= i__19@88@03)]
(assert (not (<= 0 i__19@88@03)))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(push) ; 13
; [then-branch: 70 | i__19@88@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i__19@88@03 | live]
; [else-branch: 70 | !(i__19@88@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i__19@88@03) | live]
(push) ; 14
; [then-branch: 70 | i__19@88@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i__19@88@03]
(assert (and
  (<
    i__19@88@03
    (Seq_length
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
  (<= 0 i__19@88@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__19] == -1 || 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__19] == -1
; [eval] diz.Half_adder_m.Main_process_state[i__19]
(push) ; 15
(assert (not (>= i__19@88@03 0)))
(check-sat)
; unsat
(pop) ; 15
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5455
;  :arith-add-rows          21
;  :arith-assert-diseq      76
;  :arith-assert-lower      268
;  :arith-assert-upper      181
;  :arith-conflicts         43
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         84
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               142
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              348
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2357
;  :mk-clause               451
;  :num-allocs              4335493
;  :num-checks              268
;  :propagations            406
;  :quant-instantiations    173
;  :rlimit-count            191855)
; [eval] -1
(push) ; 15
; [then-branch: 71 | First:(Second:(Second:(Second:($t@74@03))))[i__19@88@03] == -1 | live]
; [else-branch: 71 | First:(Second:(Second:(Second:($t@74@03))))[i__19@88@03] != -1 | live]
(push) ; 16
; [then-branch: 71 | First:(Second:(Second:(Second:($t@74@03))))[i__19@88@03] == -1]
(assert (=
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i__19@88@03)
  (- 0 1)))
(pop) ; 16
(push) ; 16
; [else-branch: 71 | First:(Second:(Second:(Second:($t@74@03))))[i__19@88@03] != -1]
(assert (not
  (=
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      i__19@88@03)
    (- 0 1))))
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__19] && diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] 0 <= diz.Half_adder_m.Main_process_state[i__19]
; [eval] diz.Half_adder_m.Main_process_state[i__19]
(push) ; 17
(assert (not (>= i__19@88@03 0)))
(check-sat)
; unsat
(pop) ; 17
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      76
;  :arith-assert-lower      268
;  :arith-assert-upper      181
;  :arith-conflicts         43
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         84
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               143
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              348
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2358
;  :mk-clause               451
;  :num-allocs              4335493
;  :num-checks              269
;  :propagations            406
;  :quant-instantiations    173
;  :rlimit-count            192023)
(push) ; 17
; [then-branch: 72 | 0 <= First:(Second:(Second:(Second:($t@74@03))))[i__19@88@03] | live]
; [else-branch: 72 | !(0 <= First:(Second:(Second:(Second:($t@74@03))))[i__19@88@03]) | live]
(push) ; 18
; [then-branch: 72 | 0 <= First:(Second:(Second:(Second:($t@74@03))))[i__19@88@03]]
(assert (<=
  0
  (Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i__19@88@03)))
; [eval] diz.Half_adder_m.Main_process_state[i__19] < |diz.Half_adder_m.Main_event_state|
; [eval] diz.Half_adder_m.Main_process_state[i__19]
(push) ; 19
(assert (not (>= i__19@88@03 0)))
(check-sat)
; unsat
(pop) ; 19
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      76
;  :arith-assert-lower      268
;  :arith-assert-upper      181
;  :arith-conflicts         43
;  :arith-eq-adapter        127
;  :arith-fixed-eqs         84
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               143
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              348
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2359
;  :mk-clause               451
;  :num-allocs              4335493
;  :num-checks              270
;  :propagations            406
;  :quant-instantiations    173
;  :rlimit-count            192128)
; [eval] |diz.Half_adder_m.Main_event_state|
(pop) ; 18
(push) ; 18
; [else-branch: 72 | !(0 <= First:(Second:(Second:(Second:($t@74@03))))[i__19@88@03])]
(assert (not
  (<=
    0
    (Seq_index
      ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
      i__19@88@03))))
(pop) ; 18
(pop) ; 17
; Joined path conditions
; Joined path conditions
(pop) ; 16
(pop) ; 15
; Joined path conditions
; Joined path conditions
(pop) ; 14
(push) ; 14
; [else-branch: 70 | !(i__19@88@03 < |First:(Second:(Second:(Second:($t@74@03))))| && 0 <= i__19@88@03)]
(assert (not
  (and
    (<
      i__19@88@03
      (Seq_length
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
    (<= 0 i__19@88@03))))
(pop) ; 14
(pop) ; 13
; Joined path conditions
; Joined path conditions
(pop) ; 12
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 12
(assert (not (forall ((i__19@88@03 Int)) (!
  (implies
    (and
      (<
        i__19@88@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
      (<= 0 i__19@88@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          i__19@88@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i__19@88@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i__19@88@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i__19@88@03))
  :qid |prog.l<no position>|))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      78
;  :arith-assert-lower      269
;  :arith-assert-upper      182
;  :arith-conflicts         43
;  :arith-eq-adapter        128
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               144
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2367
;  :mk-clause               465
;  :num-allocs              4335493
;  :num-checks              271
;  :propagations            408
;  :quant-instantiations    174
;  :rlimit-count            192571)
(assert (forall ((i__19@88@03 Int)) (!
  (implies
    (and
      (<
        i__19@88@03
        (Seq_length
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
      (<= 0 i__19@88@03))
    (or
      (=
        (Seq_index
          ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
          i__19@88@03)
        (- 0 1))
      (and
        (<
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i__19@88@03)
          (Seq_length
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))))
        (<=
          0
          (Seq_index
            ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
            i__19@88@03)))))
  :pattern ((Seq_index
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
    i__19@88@03))
  :qid |prog.l<no position>|)))
(declare-const $k@89@03 $Perm)
(assert ($Perm.isReadVar $k@89@03 $Perm.Write))
(push) ; 12
(assert (not (or (= $k@89@03 $Perm.No) (< $Perm.No $k@89@03))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      183
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               145
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2372
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              272
;  :propagations            409
;  :quant-instantiations    174
;  :rlimit-count            193133)
(set-option :timeout 10)
(push) ; 12
(assert (not (not (= $k@76@03 $Perm.No))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      271
;  :arith-assert-upper      183
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               145
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2372
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              273
;  :propagations            409
;  :quant-instantiations    174
;  :rlimit-count            193144)
(assert (< $k@89@03 $k@76@03))
(assert (<= $Perm.No (- $k@76@03 $k@89@03)))
(assert (<= (- $k@76@03 $k@89@03) $Perm.Write))
(assert (implies
  (< $Perm.No (- $k@76@03 $k@89@03))
  (not (= ($SortWrappers.$SnapTo$Ref ($Snap.first $t@74@03)) $Ref.null))))
; [eval] diz.Half_adder_m.Main_half != null
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               146
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2375
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              274
;  :propagations            409
;  :quant-instantiations    174
;  :rlimit-count            193352)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               147
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2375
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              275
;  :propagations            409
;  :quant-instantiations    174
;  :rlimit-count            193400)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               148
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2375
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              276
;  :propagations            409
;  :quant-instantiations    174
;  :rlimit-count            193448)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               149
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2375
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              277
;  :propagations            409
;  :quant-instantiations    174
;  :rlimit-count            193496)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               150
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2375
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              278
;  :propagations            409
;  :quant-instantiations    174
;  :rlimit-count            193544)
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               150
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2375
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              279
;  :propagations            409
;  :quant-instantiations    174
;  :rlimit-count            193557)
(set-option :timeout 10)
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5456
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               151
;  :datatype-accessor-ax    343
;  :datatype-constructor-ax 1266
;  :datatype-occurs-check   649
;  :datatype-splits         1008
;  :decisions               1134
;  :del-clause              362
;  :final-checks            105
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2375
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              280
;  :propagations            409
;  :quant-instantiations    174
;  :rlimit-count            193605)
(push) ; 12
(assert (not (= (/ (to_real 1) (to_real 2)) $Perm.No)))
(check-sat)
; unknown
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5602
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               151
;  :datatype-accessor-ax    348
;  :datatype-constructor-ax 1308
;  :datatype-occurs-check   663
;  :datatype-splits         1047
;  :decisions               1172
;  :del-clause              362
;  :final-checks            108
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2415
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              281
;  :propagations            422
;  :quant-instantiations    176
;  :rlimit-count            194687
;  :time                    0.00)
; [eval] diz.Half_adder_m.Main_half == diz
(push) ; 12
(assert (not (< $Perm.No $k@76@03)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5602
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               152
;  :datatype-accessor-ax    348
;  :datatype-constructor-ax 1308
;  :datatype-occurs-check   663
;  :datatype-splits         1047
;  :decisions               1172
;  :del-clause              362
;  :final-checks            108
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2415
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              282
;  :propagations            422
;  :quant-instantiations    176
;  :rlimit-count            194735)
(set-option :timeout 0)
(push) ; 12
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5602
;  :arith-add-rows          21
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            52
;  :binary-propagations     7
;  :conflicts               152
;  :datatype-accessor-ax    348
;  :datatype-constructor-ax 1308
;  :datatype-occurs-check   663
;  :datatype-splits         1047
;  :decisions               1172
;  :del-clause              362
;  :final-checks            108
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.68
;  :mk-bool-var             2415
;  :mk-clause               467
;  :num-allocs              4335493
;  :num-checks              283
;  :propagations            422
;  :quant-instantiations    176
;  :rlimit-count            194748)
(pop) ; 11
(push) ; 11
; [else-branch: 68 | First:(Second:(Second:(Second:($t@74@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@74@03))))))[1] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@74@03)))))))
        1)
      (- 0 2)))))
(pop) ; 11
(pop) ; 10
(pop) ; 9
(pop) ; 8
(set-option :timeout 10)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03)))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5737
;  :arith-add-rows          23
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            55
;  :binary-propagations     7
;  :conflicts               153
;  :datatype-accessor-ax    353
;  :datatype-constructor-ax 1351
;  :datatype-occurs-check   675
;  :datatype-splits         1080
;  :decisions               1210
;  :del-clause              423
;  :final-checks            111
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.59
;  :mk-bool-var             2451
;  :mk-clause               468
;  :num-allocs              4513797
;  :num-checks              284
;  :propagations            426
;  :quant-instantiations    176
;  :rlimit-count            195887
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@35@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               5901
;  :arith-add-rows          23
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            55
;  :binary-propagations     7
;  :conflicts               154
;  :datatype-accessor-ax    362
;  :datatype-constructor-ax 1399
;  :datatype-occurs-check   691
;  :datatype-splits         1135
;  :decisions               1249
;  :del-clause              424
;  :final-checks            115
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.59
;  :mk-bool-var             2508
;  :mk-clause               469
;  :num-allocs              4513797
;  :num-checks              285
;  :propagations            434
;  :quant-instantiations    176
;  :rlimit-count            196976
;  :time                    0.00)
(push) ; 8
(assert (not (=
  ($SortWrappers.$SnapTo$Ref ($Snap.first $t@59@03))
  ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.second $t@4@03))))))
(check-sat)
; unknown
(pop) ; 8
; 0.00s
; (get-info :all-statistics)
(get-info :all-statistics)
; (:added-eqs               6082
;  :arith-add-rows          23
;  :arith-assert-diseq      79
;  :arith-assert-lower      273
;  :arith-assert-upper      184
;  :arith-conflicts         43
;  :arith-eq-adapter        129
;  :arith-fixed-eqs         85
;  :arith-pivots            55
;  :binary-propagations     7
;  :conflicts               155
;  :datatype-accessor-ax    371
;  :datatype-constructor-ax 1454
;  :datatype-occurs-check   707
;  :datatype-splits         1190
;  :decisions               1295
;  :del-clause              425
;  :final-checks            119
;  :max-generation          2
;  :max-memory              4.68
;  :memory                  4.59
;  :mk-bool-var             2565
;  :mk-clause               470
;  :num-allocs              4513797
;  :num-checks              286
;  :propagations            442
;  :quant-instantiations    176
;  :rlimit-count            198160
;  :time                    0.00)
; [eval] !true
; [then-branch: 73 | False | dead]
; [else-branch: 73 | True | live]
(push) ; 8
; [else-branch: 73 | True]
(pop) ; 8
(pop) ; 7
(pop) ; 6
(pop) ; 5
(push) ; 5
; [else-branch: 29 | First:(Second:(Second:(Second:($t@35@03))))[0] != -1 || First:(Second:(Second:(Second:(Second:(Second:($t@35@03))))))[0] != -2]
(assert (or
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))
        0)
      (- 0 1)))
  (not
    (=
      (Seq_index
        ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@35@03)))))))
        0)
      (- 0 2)))))
(pop) ; 5
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
