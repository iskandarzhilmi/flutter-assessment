import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_concept/cubit/counter_cubit.dart';
import 'package:test/test.dart';

void main() {
  final CounterState counterState1 = CounterState(counterValue: 1);
  final CounterState counterState2 = CounterState(counterValue: 1);
  print(counterState1 == counterState2);

  group('CounterCubit', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = CounterCubit();
    });
    tearDown(() {
      counterCubit.close();
    });

    test(
        'the intial state for the CounterCubit is CounterState(counterValue:0)',
        () {
      expect(counterCubit, CounterState(counterValue: 0));
    });

    blocTest(
      'The cubit should emit a CounterState(counterValue:1,wasIncremented:true) when cubit.increment() is called.',
      build: () => counterCubit,
      act: (cubit) => cubit.increment(),
      expect: [],
    );
  });
}
