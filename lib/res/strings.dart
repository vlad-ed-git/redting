const appName = 'REDTING';
const appNameFirstWord = 'RED';
const appNameLastWord = 'TING';
const defaultIceBreaker = "Hi there. I’m vanilla! … Get it?";
const initAppErr = "Something went wrong! Please restart app";
const beAuthenticAlways = "Always Be your Authenticate self.";
//splash screen
const loadingAuthUser = 'Authenticating ...';
const loadingAuthUserErr =
    'Checking your auth status failed! Please restart the app';

//login screen
const loginTitle = "Login";
const phoneNumberLbl = "Your mobile number";
const phoneNumberErr = "Invalid mobile number";
const unknownCodeSendingErr = "Failed to send verification code!";
const loginBtn = 'Continue';
const phoneVerificationHint =
    "When you tap CONTINUE, RedTing will send a verification code via sms to your mobile number. Standard sms & data rates may apply. After verification you can then login. *You may be redirected to a browser, after completion, close browser to return here";
const enterCodeSentTo = 'Enter code sent to ';
const resendTxt = 'RESEND';
const changePhoneTxt = 'CHANGE PHONE NUMBER';
const signInTerms =
    "Depending on your location, it might take a minute for the code to reach your sms inbox. By tapping CONTINUE, you are agreeing to RedTing's terms and conditions. Click this message to review them first.";
const invalidVerificationCode =
    "The code you entered is invalid. Please try again";
const failedToVerifyUnknown =
    "Timeout or connection error occurred! Please resend code & verify again";
const failedToCacheAuthUser = "Failed to save your credentials! Please retry";

//profile screen
const createProfileError =
    "failed to create your profile! Please check your connection & retry";
const deleteProfileError =
    "failed to delete your profile! Please check your connection & retry";
const updateProfileError =
    "failed to update your profile! ! Please check your connection & retry";
const getProfileError =
    "failed to fetch your profile! Please check your connection & retry";
const nameHint = "Your name";
const titleLbl = "Title";
const titleHint = "art lover";
const bioLbl = "Bio";
const bioHint = "my friends say I am ...";
const gender = "Gender";
const maleGender = "Male";
const femaleGender = "Female";
const otherGenderHint = "I am ...";
const birthDay = "Birthday";
const birthDayHint = "Date of birth";

//profile photo
const uploadingPhotoErr = "Failed to update your profile photo";
const uploadingPhotoSuccess = "Profile photo updated";
const errPickingPhotoGallery =
    "Failed to pick profile photo.\nHave you provided REDTING with access to the gallery in settings?";

//CAMERA
const returnedVideoWasNullErr = "No video was received!";
const verificationVideoTitle = "REDTING Verification";
const verificationVideoInstructions =
    "Record a short clip (6 SECONDS MAX) of yourself saying the fun word below!";
const verificationVideoHint =
    "Only the first 6 seconds of the video will be taken.";
const verificationVideoInstructionsGotIt = "I'M READY";
const verificationVideoKeep = "KEEP";
const verificationVideoDelete = "RE TAKE";
const deletingVerificationVideoFailed =
    "failed to delete your verification video!";
const errorUploadingVerificationVideo =
    "Failed to upload your verification video! check your connection & retry";
const successUploadingVerificationVideo =
    "Your verification video has been saved";

//create profile
const createProfileBtn = "GET IN";
const createProfileOnGoing = "Creating profile...";
const createProfileSuccess = "Awesome! Your profile was created.";
const createProfileFail =
    "Failed to create your profile. Please check your connection & retry";
const userIdMissingDuringProfileCreateErr =
    "OOps! Looks like you are logged out! Please restart the app";
const emptyProfilePhotoErr = "A profile photo is required";
const noVerificationVideo = "A verification video is required";
const noGenderSpecified = "Please state your gender";
const bioIsEmptyErr = "Mmmh! That bio is too short it seems.";
const titleIsEmptyErr = "Please provide your title";
const titleIsTooLongErr = "Mmmh! Your title is too long. Please abbreviate it";
const bDayNotSet = "Your birthday is required. You must be at least 18 to join";
const nameMissingErr = "Please provide your name";

//dating profile
const uploadingDatingProfilePhotoErr =
    "Failed to upload your photo! Please try again.";
const deletingDatingProfilePhotoErr =
    "Failed to delete your RedTing profile photo! Please retry";
const setDatingInfoErr =
    "Failed to save your dating preferences! Please try again.";
const deleteDatingProfileErr =
    "Failed to delete your RedTing profile! Please retry";
const getDatingProfileErr = "Failed to get your RedTing profile! Please retry";
const updateDatingProfileErr =
    "Failed to update your RedTing profile! Please retry";
const ageRangeLbl = "AGE RANGE";
const mySexualityLbl = "I AM";
const showMeGendersAndPreferencesLbl = "SHOW ME";
const menLbl = "MEN";
const womenLbl = "WOMEN";
const allGendersLbl = "EVERYONE";
const mySexualOrientation = "MY SEXUAL ORIENTATION";
const makeMyOrientationPublicLbl = "Show my orientation on my profile";
const showMeMyOrientationOnly =
    "Only show me others of same sexual orientation";
const straightSexualOrientationLbl = "straight";
const questioningSexualOrientationLbl = "questioning";
const queerSexualOrientationLbl = "queer";
const panSexualSexualOrientationLbl = "pansexual";
const demiSexualSexualOrientationLbl = "demisexual";
const biSexualSexualOrientationLbl = "bisexual";
const asexualSexualOrientationLbl = "asexual";
const gaySexualOrientationLbl = "gay";
const createDatingProfileBtn = "ALL SET";
const datingProfilePicsMissingErr = 'Please add at least 3 photos';
const creatingDatingProfilePleaseWait = "just a bit ...";
const datingPicsHint =
    "*Show your face in some of these. Others will be able to see your verification video.";

//matching
const likingUserFailed =
    "OOps! Failed to like the user! Please check your internet connection";
const dislikingUserFailedErr = "Please check your internet connection";
const fetchingProfilesToMatchFailed =
    "REDTING couldn't load profiles! Please check your internet connection";
const likeStamp = "FIT";
const passStamp = "PASS";
const noMoreProfiles =
    "That's all the people we have currently.\nEnjoy chatting with your current matches.\nIn the meantime, please share your experience at RedTing today.";
const feedbackHint = "I like ... but I wish ...";
const submitFeedbackBtn = "submit";
const feedbackReceived = "Thank You! Your feedback helps RedTing get better.";
const feedbackNotSentErr = "Oops! Sorry, we could not get that! Please retry";
const verificationVideoWord = "VERIFICATION CODE: ";

//home
const homeDestinationLbl = "RedTing";
const myProfileDestinationLbl = "My Profile";
const myMatchesDestinationLbl = "Matched";

//chat
const errorSendingImageMessage = "Failed to send image";
const errorSendingTxtMessage = "Failed to send your message";

//editing profile
const editDatingPreferences = "Matching Preferences";
const editProfile = "Edit Profile";
const updateProfileSuccess = "Your changes have been saved";
const updateProfileFail = "Failed to save your changes";
const updateProfileBtn = "Update Profile";
const selectFromCountryLbl = "From Country";
