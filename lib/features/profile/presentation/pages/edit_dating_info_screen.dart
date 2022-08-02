import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:redting/features/profile/domain/models/user_profile.dart';
import 'package:redting/features/profile/presentation/components/screen_containers/edit_profile_container.dart';
import 'package:redting/features/profile/presentation/state/user_profile_bloc.dart';

class EditDatingInfoScreen extends StatefulWidget {
  const EditDatingInfoScreen({Key? key}) : super(key: key);

  @override
  State<EditDatingInfoScreen> createState() => _EditDatingInfoScreenState();
}

class _EditDatingInfoScreenState extends State<EditDatingInfoScreen> {
  late UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    RouteSettings? settings = ModalRoute.of(context)?.settings;
    if (settings != null && settings.arguments is UserProfile) {
      userProfile = settings.arguments as UserProfile;
    }
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
        lazy: false,
        create: (BuildContext blocProviderContext) =>
            GetIt.instance<UserProfileBloc>(),
        child: BlocListener<UserProfileBloc, UserProfileState>(
            listener: _listenToStateChange,
            child: BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (blocContext, state) {
              if (state is UserProfileInitialState) {
                _onInitState(blocContext);
              }

              return EditProfileContainer(
                  onSaveProfile: () {
                    _onSaveProfile(blocContext);
                  },
                  child: const SizedBox.shrink());
            })));
  }

  void _listenToStateChange(BuildContext context, UserProfileState state) {}

  void _onInitState(BuildContext blocContext) {}

  void _onSaveProfile(BuildContext blocContext) {}
}
