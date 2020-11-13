import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mycleanarchitecture/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = new NetworkInfoImpl(mockDataConnectionChecker);
  });
  group('isConnected', () {
    test('should forward to the call to DataConnectionChecker.hasConnction',
        () async {
      // arrange

      // to not duplicate test to check the case of there is no internet connection
      // we just wanna check that this method returns the connection any way

      final testHasConnection = Future.value(true);

      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((realInvocation) => testHasConnection);
      // act
      final result = networkInfoImpl.isConnected;
      // assert
      verify(mockDataConnectionChecker.hasConnection);

      expect(result, testHasConnection);
    });
  });
}
