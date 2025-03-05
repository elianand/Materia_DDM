import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scada_app/presentation/viewmodels/notifiers/create_account_notifier.dart';


import '../../data/repositories/company_repository_impl.dart';
import '../../data/repositories/machine_record_repository_impl.dart';
import '../../data/repositories/machine_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/sources/local/company_local_data_source.dart';
import '../../data/sources/local/machine_local_data_source.dart';
import '../../data/sources/local/machine_record_local_data_source.dart';
import '../../data/sources/local/user_local_data_source.dart';
import '../../data/sources/remote/firebase_company_data_source.dart';
import '../../data/sources/remote/firebase_machine_data_source.dart';
import '../../data/sources/remote/firebase_machine_record_data_source.dart';
import '../../data/sources/remote/firebase_user_data_source.dart';
import '../../domain/repositories/company_repository.dart';
import '../../domain/repositories/machine_record_repository.dart';
import '../../domain/repositories/machines_repository.dart';
import '../../domain/repositories/users_repository.dart';
import '../../domain/usecases/company_usecases.dart';
import '../../domain/usecases/machine_record_usecases.dart';
import '../../domain/usecases/machine_usecases.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../presentation/viewmodels/notifiers/company_notifier.dart';
import '../../presentation/viewmodels/notifiers/device_config_notifier.dart';
import '../../presentation/viewmodels/notifiers/machine_detail_notifier.dart';
import '../../presentation/viewmodels/notifiers/machine_list_notifier.dart';
import '../../presentation/viewmodels/notifiers/user_detail_notifier.dart';
import '../../presentation/viewmodels/state/company_state.dart';
import '../../presentation/viewmodels/state/create_account_state.dart';
import '../../presentation/viewmodels/state/device_config_state.dart';
import '../../presentation/viewmodels/state/machine_detail_state.dart';
import '../../presentation/viewmodels/state/machine_list_state.dart';
import '../../presentation/viewmodels/state/user_detail_state.dart';
import 'app_theme.dart';
import '../../presentation/viewmodels/notifiers/login_notifier.dart';
import '../../presentation/viewmodels/notifiers/logout_notifier.dart';
import '../../presentation/viewmodels/notifiers/machine_type_notifier.dart';
import '../../presentation/viewmodels/state/login_state.dart';
import '../../presentation/viewmodels/state/logout_state.dart';
import '../../presentation/viewmodels/state/machine_type_state.dart';


//    -----------     FIREBASE      -------------------
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseFireStorangeProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});
//    -----------     FIREBASE      -------------------





//   ------------     ENCRYPTED   ---------------
final encryptedSharedPreferencesProvider = Provider<EncryptedSharedPreferences>((ref) {
  return EncryptedSharedPreferences();
});
//   ------------     ENCRYPTED   ---------------




//   ------------     USER REPOSITORY   ---------------
// Firebase
final firebaseUserDataSourceProvider = Provider<FirebaseUserDataSource>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firebaseFirestoreProvider);
  return FirebaseUserDataSource(auth, firestore);
});

// Local
final localUserDataSourceProvider = Provider<LocalUserDataSource>((ref) {
  final encrypPrefs = ref.read(encryptedSharedPreferencesProvider);
  return LocalUserDataSource(encrypPrefs);
});

// Repo
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseDataSource = ref.read(firebaseUserDataSourceProvider);
  final localDataSource = ref.watch(localUserDataSourceProvider);
  return UserRepositoryImpl(firebaseDataSource, localDataSource);
});
//   ------------     USER REPOSITORY   ---------------



//   ------------     COMPANY REPOSITORY   ---------------

// Firebase
final firebaseCompanyDataSourceProvider = Provider<FirebaseCompanyDataSource>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return FirebaseCompanyDataSource(firestore);
});

// Local
final localCompanyDataSourceProvider = Provider<LocalCompanyDataSource>((ref) {
  return LocalCompanyDataSource();
});

// Repo
final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  final firebaseDataSource = ref.read(firebaseCompanyDataSourceProvider);
  final localDataSource = ref.watch(localCompanyDataSourceProvider);
  return CompanyRepositoryImpl(firebaseDataSource, localDataSource);
});
//   ------------     COMPANY REPOSITORY   ---------------



//   ------------     MACHINE REPOSITORY   ---------------

// Firebase
final firebaseMachineDataSourceProvider = Provider<FirebaseMachineDataSource>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  final firestorange = ref.read(firebaseFireStorangeProvider);
  return FirebaseMachineDataSource(firestore, firestorange);
});

// Local
final localMachineDataSourceProvider = Provider<LocalMachineDataSource>((ref) {
  return LocalMachineDataSource();
});

// Repo
final machineRepositoryProvider = Provider<MachineRepository>((ref) {
  final firebaseDataSource = ref.read(firebaseMachineDataSourceProvider);
  final localDataSource = ref.watch(localMachineDataSourceProvider);
  return MachineRepositoryImpl(firebaseDataSource, localDataSource);
});
//   ------------     MACHINE REPOSITORY   ---------------



//   ------------     MACHINE RECORDs REPOSITORY   ---------------

// Firebase
final firebaseMachineRecordDataSourceProvider = Provider<FirebaseMachineRecordDataSource>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return FirebaseMachineRecordDataSource(firestore);
});

// Local
final localMachineRecordDataSourceProvider = Provider<LocalMachineRecordDataSource>((ref) {
  return LocalMachineRecordDataSource();
});

// Repo
final machineRecordRepositoryProvider = Provider<MachineRecordRepository>((ref) {
  final firebaseDataSource = ref.read(firebaseMachineRecordDataSourceProvider);
  final localDataSource = ref.watch(localMachineRecordDataSourceProvider);
  return MachineRecordRepositoryImpl(firebaseDataSource, localDataSource);
});
//   ------------      MACHINE RECORDs REPOSITORY   ---------------





final userLoginWithCredentialsProvider = Provider<UserLoginWithCredentials>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UserLoginWithCredentials(repository);
});

final checkUserSessionProvider = Provider<CheckUserSession>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return CheckUserSession(repository);
});

final needCreateAccountProvider = Provider<NeedCreateAccount>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return NeedCreateAccount(repository);
});

final saveUserCredentialsProvider = Provider<SaveUserCredentials>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return SaveUserCredentials(repository);
});

final saveCredentialsOldAccountProvider = Provider<SaveCredentialsOldAccount>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return SaveCredentialsOldAccount(repository);
});

final createUserWithCredentialsProvider = Provider<CreateUserWithCredentials>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return CreateUserWithCredentials(repository);
});

final getUserDataProvider = Provider<GetUserData>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserData(repository);
});

final isUserAdminLvlProvider = Provider<IsUserAdminLvl>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return IsUserAdminLvl(repository);
});

final userLogoutProvider = Provider<UserLogout>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UserLogout(repository);
});




///     --------------       COMPANY      --------------------------
final getUserCompanyProvider = Provider<GetUserCompany>((ref) {
  final compRepo = ref.read(companyRepositoryProvider);
  final userRepo = ref.read(userRepositoryProvider);
  return GetUserCompany(compRepo, userRepo);
});
///     --------------       COMPANY      --------------------------



///     --------------       MACHINES      --------------------------
final getMachineListProvider = Provider<GetMachineList>((ref) {
  final machineRepo = ref.read(machineRepositoryProvider);
  final userRepo = ref.read(userRepositoryProvider);
  return GetMachineList(machineRepo, userRepo);
});

final getMachineByIdWithDetailsProvider = Provider<GetMachineByIdWithDetails>((ref) {
  final machineRepo = ref.read(machineRepositoryProvider);
  final machineRecordRepo = ref.read(machineRecordRepositoryProvider);
  return GetMachineByIdWithDetails(machineRepo, machineRecordRepo);
});

final setImageToMachineIdProvider = Provider<SetImageToMachineId>((ref) {
  final machineRepo = ref.read(machineRepositoryProvider);
  return SetImageToMachineId(machineRepo);
});

final setMachineAttachByIdProvider = Provider<SetMachineAttachById>((ref) {
  final machineRepo = ref.read(machineRepositoryProvider);
  return SetMachineAttachById(machineRepo);
});
///     --------------       MACHINES      --------------------------


///     --------------       MACHINE RECORDS      --------------------------

final getMachineStatusByIdProvider = Provider<GetMachineStatusById>((ref) {
  final machineRecordRepo = ref.read(machineRecordRepositoryProvider);
  return GetMachineStatusById(machineRecordRepo);
});


///     --------------       MACHINE RECORDS      --------------------------

final machineTypeProvider = AutoDisposeNotifierProvider<MachineTypeNotifier, MachineTypeState>(MachineTypeNotifier.new);
final machineListProvider = AutoDisposeNotifierProvider<MachineListNotifier, MachineListState>(MachineListNotifier.new);
final machineDetailProvider = AutoDisposeNotifierProvider<MachineDetailNotifier, MachineDetailState>(MachineDetailNotifier.new);
final companyProvider = AutoDisposeNotifierProvider<CompanyNotifier, CompanyState>(CompanyNotifier.new);
final deviceConfigProvider = AutoDisposeNotifierProvider<DeviceConfigNotifier, DeviceConfigState>(DeviceConfigNotifier.new);


final loginProvider = AutoDisposeNotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);
final logoutProvider = AutoDisposeNotifierProvider<LogoutNotifier, LogoutState>(LogoutNotifier.new);
final createAccountProvider = AutoDisposeNotifierProvider<CreateAccountNotifier, CreateAccountState>(CreateAccountNotifier.new);
final userDetailProvider = AutoDisposeNotifierProvider<UserDetailNotifier, UserDetailState>(UserDetailNotifier.new);

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

/*
final appControllerProvider = ChangeNotifierProvider<AppController>((ref) {
  return AppController();
});

*/
