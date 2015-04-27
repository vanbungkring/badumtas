//
//  ColorsConstants.m
//  iMobey
//
//  Created by Matthieu Barile on 10/12/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "ColorsConstants.h"

#pragma mark - Colors from the guideline
#define kBlack @"#000000";
#define kWhite @"#ffffff";
#define kMainOne @"#4ea9c6";
#define kMainTwo @"#2f8ca5";
#define kMainThree @"#1b6d83";
#define kTransferOne @"#f8616a";
#define kTransferTwo @"#9d1111";
#define kRewardsOne @"#00b6ac";
#define kRewardsTwo @"#01a39a";//not used
#define kRewardsThree @"#008e7c";
#define kMonochromeOne @"#efeeee";
#define kMonochromeTwo @"#dad9d9";
#define kMonochromeThree @"#454545";

@implementation ColorsConstants

CGFloat const kAlphaOpaque = 1.0f;

NSString * const _kBlack = kBlack;
NSString * const _kWhite = kWhite;
NSString * const _kMainOne = kMainOne;
NSString * const _kMainTwo = kMainTwo;
NSString * const _kMainThree = kMainThree;
NSString * const _kTransferOne = kTransferOne;
NSString * const _kTransferTwo = kTransferTwo;
NSString * const _kRewardsOne = kRewardsOne;
NSString * const _kRewardsThree = kRewardsThree;
NSString * const _kMonochromeOne = kMonochromeOne;
NSString * const _kMonochromeTwo = kMonochromeTwo;
NSString * const _kMonochromeThree = kMonochromeThree;

//other colors

#pragma mark - PaymentTopupViewController 
NSString * const kPaymentTopupViewController_lblAutomaticRefill_textColor = kMonochromeThree;
NSString * const kPaymentTopupViewController_autoButton_titleColor = kMonochromeThree;
NSString * const kPaymentTopupViewController_aButton_titleColor = kMainOne;
NSString * const kPaymentTopupViewController_viewChooseCard_backgroundColor = kMainOne;
NSString * const kPaymentTopupViewController_viewRefill_backgroundColor = kMainOne;
NSString * const kPaymentTopupViewController_refillButton_backgroundColor = kMainTwo;
NSString * const kPaymentTopupViewController_autoButton_backgroundColor = kWhite;
NSString * const kPaymentTopupViewController_creditCardButton_backgroundColor = kMainOne;
NSString * const kPaymentTopupViewController_viewAutomaticRefill_backgroundColor = kWhite;
NSString * const kPaymentTopupViewController_header_backgroundColor = kBlack;
NSString * const kPaymentTopupViewController_lblAmount_textColor = @"#383838";
NSString * const kPaymentTopupViewController_viewChooseCard_selected_backgroundColor = kMonochromeTwo;
NSString * const kPaymentTopupViewController_creditCardButton_selected_titleColor = kMonochromeThree;
NSString * const kPaymentTopupViewController_refillButton_highlighted_backgroundColor = kMainThree;
NSString * const kPaymentTopupViewController_refillButton_titleColor = kWhite;
NSString * const kPaymentTopupViewController_refillButton_highlighted_titleColor = kMainOne;
NSString * const kPaymentTopupViewController_refillButton_unvalid_titleColor = kMonochromeOne;
NSString * const kPaymentTopupViewController_refillButton_unvalid_backgroundColor = kMonochromeTwo;
NSString * const kPaymentTopupViewController_creditCardButton_selected_backgroundColor = kMonochromeTwo;
NSString * const kPaymentTopupViewController_viewRefill_unvalid_backgroundColor = kMonochromeOne;

#pragma mark - CardListViewController 
NSString * const kCardListViewController_backgroundColor = kBlack;
NSString * const kCardListViewController_viewValidate_backgroundColor = kMainOne; //kBackgroundLight
NSString * const kCardListViewController_btnValidate_backgroundColor = kMainTwo;
NSString * const kCardListViewController_btnValidate_highlighted_backgroundColor = kMainThree;
NSString * const kCardListViewController_btnValidate_highlighted_textColor = kMainOne;

#pragma mark - BankAccountExpiredCell 
NSString * const kBankAccountExpiredCell_backgroundColor = @"#ff0013"; //kBankAccountExpiredCellThree
NSString * const kBankAccountExpiredCell_stringColor_backgroundColor = @"#7d0004"; //kBankAccountExpiredCellTwo
NSString * const kBankAccountExpiredCell_lblCardExpired_textColor = kTransferTwo; //kBankAccountExpiredCellOne
NSString * const kBankAccountExpiredCell_btnRight_titleColor = kTransferTwo; //kBankAccountExpiredCellFour
NSString * const kBankAccountExpiredCell_btnRight_borderColor = kTransferTwo; //kBankAccountExpiredCellFour
NSString * const kBankAccountExpiredCell_btnRight_backgroundColor = @"#ff0013"; //kBankAccountExpiredCellThree
NSString * const kBankAccountExpiredCell_btnLeft_backgroundColor = kTransferTwo; //kBankAccountExpiredCellTwo
NSString * const kBankAccountExpiredCell_btnLeft_highlighted_titleColor = @"#ff0013";
NSString * const kBankAccountExpiredCell_btnRight_highlighted_titleColor = kWhite;
NSString * const kBankAccountExpiredCell_btnLeft_highlighted_backgroundColor = @"#720c0c";
NSString * const kBankAccountExpiredCell_btnRight_highlighted_backgroundColor = kTransferTwo;

#pragma mark - BankAccountCell 
NSString * const kBankAccountCell_stringColorEditionMode_backgroundColor = @"#b4b2b2"; //kHistoryDetailCellThree
NSString * const kBankAccountCell_stringColor_backgroundColor = kMainTwo;
NSString * const kBankAccountCell_lblCardNumber_textColor = kMainOne;
NSString * const kBankAccountCell_lblCardExpired_textColor = @"#7d7d7d";

#pragma mark - ActionSuccessfulViewController 
NSString * const kActionSuccessfulViewController_fromCardList_backgroundColor = kRewardsOne;
NSString * const kActionSuccessfulViewController_fromTopUp_backgroundColor = kMainOne;

#pragma mark - MenuViewController 
NSString * const kMenuViewController_btnLogOff_backgroundColor = kTransferTwo; //kBackgroundSixteen
NSString * const kMenuViewController_viewLogout_backgroundColor = @"#ff0013"; //kBackgroundSeventeen
NSString * const kMenuViewController_tableview_inAccountListMode_backgroundColor = @"#555555";
NSString * const kMenuViewController_tableview_inAccountListMode_separatorColor = @"#383838"; //kBackgroundEighteen
NSString * const kMenuViewController_tableview_backgroundColor = kMonochromeThree;
NSString * const kMenuViewController_tableview_separatorColor = kBlack; //kSeparatorOne

#pragma mark - MenuUserCellManagement 
NSString * const kMenuUserCellManagement_myAccount_backgroundColor = kMonochromeThree;// kMonochromeTwo;
NSString * const kMenuUserCellManagement_myAccount_stringColor = kMonochromeThree;
NSString * const kMenuUserCellManagement_home_stringColor = kTransferOne;
NSString * const kMenuUserCellManagement_refill_stringColor = kMainOne;
NSString * const kMenuUserCellManagement_myInformations_stringColor = @"#ff0078"; //kTextSix
NSString * const kMenuUserCellManagement_myCards_stringColor = @"#f58a64"; //kTextSeven
NSString * const kMenuUserCellManagement_security_stringColor = @"#7d7d7d"; //kTextEight
NSString * const kMenuUserCellManagement_verifyAccount_stringColor = kRewardsThree;

#pragma mark - MenuUserCell 
NSString * const kMenuUserCell_backgroundColor = @"#555555";

#pragma mark - MenuSmallCell 
NSString * const kMenuSmallCell_version_backgroundColor = kMonochromeTwo;
NSString * const kMenuSmallCell_version_stringColor = @"#e8e9ea"; //kBackgroundNineteen
NSString * const kMenuSmallCell_backgroundColor = kMonochromeTwo; //kBackgroundNineteen
NSString * const kMenuSmallCell_stringColor = @"#383838";
NSString * const kMenuSmallCell_contentView_backgroundColor = kMonochromeTwo; //kBackgroundTwentySix
NSString * const kMenuSmallCell_lbl_textColor = kMonochromeThree;

#pragma mark - MenuBigCell
NSString * const kMenuBigCell_lbl_textColor = @"#171717";

#pragma mark - TimeoutViewController 
NSString * const kTimeoutViewController_aButton_titleColor = kMainOne;
NSString * const kTimeoutViewController_viewChangePin_BackgroundColor = kMainOne;
NSString * const kTimeoutViewController_changePinButton_BackgroundColor = kMainTwo;
NSString * const kTimeoutViewController_header_backgroundColor = kBlack;
NSString * const kTimeoutViewController_changePinButton_highlighted_backgroundColor = kMainThree;
NSString * const kTimeoutViewController_changePinButton_titleColor = kWhite;
NSString * const kTimeoutViewController_changePinButton_highlighted_titleColor = kMainOne;
NSString * const kTimeoutViewController_timeoutTitleLabel_textColor = kMonochromeThree;
NSString * const kTimeoutViewController_timeoutDescriptionLabel_textColor = kMonochromeThree;

#pragma mark - TutorialViewController 
NSString * const kTutorialViewController_viewBottom_backgroundColor = kMainOne; //kBackgroundTwelve

#pragma mark - UserInformationViewController 
NSString * const kUserInformationViewController_viewValidate_actived_backgroundColor = kMainOne;
NSString * const kUserInformationViewController_btnValidate_actived_titleColor = kWhite;
NSString * const kUserInformationViewController_btnValidate_actived_backgroundColor = kMainTwo;
NSString * const kUserInformationViewController_btnValidate_titleColor = kMonochromeOne;
NSString * const kUserInformationViewController_btnValidate_backgroundColor = kMonochromeTwo;
NSString * const kUserInformationViewController_viewValidate_backgroundColor = kMonochromeOne;
NSString * const kUserInformationViewController_header_backgroundColor = kBlack;
NSString * const kUserInformationViewController_btnValidate_actived_highlighted_backgroundColor = kMainThree;
NSString * const kUserInformationViewController_btnValidate_actived_highlighted_titleColor = kMainOne;

#pragma mark - PaymentCheckViewController 
NSString * const kPayButtonGradientOne = @"#23d0da";
NSString * const kPayButtonGradientTwo = @"#449eb6";
NSString * const kPayButtonGradientThree= @"#07adeb";
NSString * const kPaymentCheckViewController_view_backgroundColor = @"#1aabde";
NSString * const kPaymentCheckViewController_couponButton_titleColor = kMainTwo;
NSString * const kPaymentCheckViewController_payButton_borderColor = kWhite;
NSString * const kPaymentCheckViewController_payButton_titleColor = kWhite;
NSString * const kPaymentCheckViewController_header_backgroundColor = kBlack;

#pragma mark - LoginViewController
NSString * const kLoginViewController_headerView_backgroundColor = @"#dad9d9";
NSString * const kLoginViewController_btnConnect_titleColor = @"#454545";
NSString * const kLoginViewController_bottomView_backgroundColor = @"#efeeee";
NSString * const kLoginViewController_btnLogin_backgroundColor = @"#dad9d9";
NSString * const kLoginViewController_btnLogin_titleColor = kWhite;
NSString * const kLoginViewController_btnForgottenPassword_titleColor = @"#454545";

NSString * const kLoginViewController_bottomView_valid_backgroundColor = @"#4ea9c6";
NSString * const kLoginViewController_btnLogin_valid_backgroundColor = @"#2f8ca5";
NSString * const kLoginViewController_btnLogin_valid_titleColor = kWhite;

#pragma mark - PinViewController 
NSString * const kPinViewController_colorThree = kMonochromeOne;
NSString * const kPinViewController_textField_backgroundColor = kMonochromeTwo;
NSString * const kPinViewController_textField_2_backgroundColor = kMainOne ; //kBackgroundTwenty
NSString * const kPinViewController_gradient_top = kMainOne;
NSString * const kPinViewController_gradient_bottom = @"#009fe3";
    
#pragma mark - PaymentViewController 
NSString * const kPaymentViewController_header_backgroundColor = kMainOne ; //kBackgroundTwelve
NSString * const kPaymentViewController_btnSetUserInfos_highlighted_backgroundColor = kMainThree;
NSString * const kPaymentViewController_btnAddCreditCard_highlighted_backgroundColor = kMainThree;
NSString * const kPaymentViewController_btnSetUserInfos_titleColor = kWhite;
NSString * const kPaymentViewController_btnSetUserInfos_highlighted_titleColor = kMainOne;
NSString * const kPaymentViewController_btnAddCreditCard_titleColor = kWhite;
NSString * const kPaymentViewController_btnAddCreditCard_highlighted_titleColor = kMainOne;

#pragma mark - CountryViewController 
NSString * const kCountryViewController_header_backgroundColor = kBlack;
NSString * const kCountryViewController_tableview_separatorColor = kBlack; //kSeparatorTwo
NSString * const kCountryViewController_textFieldCountryName_placeHolderColor = @"#7d7d7d"; //kBackgroundSeven

#pragma mark - RegisterQuestionsViewController 
NSString * const kRegisterQuestionsViewController_tableview_separatorColor = kBlack; //kSeparatorTwo

#pragma mark - ActionSuccessfulAfterPaymentViewController 
NSString * const kActionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor = @"#94e0dc"; //kProgressCircleBackground

#pragma mark - RewardsHomeViewController 
NSString * const kRewardsHomeViewController_yourProgramsButton_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyFour
NSString * const kRewardsHomeViewController_yourProgramsButton_selected_backgroundColor = @"#007d76"; //kBackgroundTwentyThree
NSString * const kRewardsHomeViewController_allProgramsButton_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyFour
NSString * const kRewardsHomeViewController_allProgramsButton_selected_backgroundColor = @"#007d76"; //kBackgroundTwentyThree
NSString * const kRewardsHomeViewController_viewAccountBanner_textColor = @"#7d7d7d";

#pragma mark - LoginCell 
NSString * const kLoginCell_textField_textColor = kMainOne; //kBackgroundLight

#pragma mark - TransferStep1ViewController 
NSString * const kTransferStep1ViewController_lblYourbalance_textColor = kMonochromeThree; //kTextTwo
NSString * const kTransferStep1ViewController_lblBalance_textColor = kMonochromeThree; //kTextTwo
NSString * const kTransferStep1ViewController_searchContactButton_backgroundColor = kTransferTwo; //kBackgroundNine
NSString * const kTransferStep1ViewController_validateButton_backgroundColor = kTransferTwo; //kBackgroundNine
NSString * const kTransferStep1ViewController_commentButton_backgroundColor = kTransferTwo; //kBackgroundNine
NSString * const kTransferStep1ViewController_viewMail_backgroundColor = kMonochromeTwo; //kTextTwo
NSString * const kTransferStep1ViewController_toLabel_textColor = kTransferOne; //kTextOne
NSString * const kTransferStep1ViewController_mailTextField_textColor = kTransferOne; //kTextOne
NSString * const kTransferStep1ViewController_toLabel_after_textColor = @"#555555"; //kTextOne
NSString * const kTransferStep1ViewController_mailTextField_after_textColor = @"#555555"; //kTextOne
NSString * const kTransferStep1ViewController_searchFriendMailLabel_backgroundColor = kWhite;
NSString * const kTransferStep1ViewController_viewSearchContact_backgroundColor = kTransferOne;
NSString * const kTransferStep1ViewController_searchContactButton_highlighted_backgroundColor = kTransferTwo;
NSString * const kTransferStep1ViewController_validateButton_highlighted_backgroundColor = kTransferTwo;

#pragma mark - ResponseCell
NSString * const kResponseCell_bgView_backgroundColor = kMainOne; //kBackgroundTwentyTwo

#pragma mark - CountryCell 
NSString * const kCountryCell_bgView_backgroundColor = kMainOne; //kBackgroundTwentyTwo

#pragma mark - HistoryDetailCell 
NSString * const kHistoryDetailCell_indicatorColorView_pending_backgroundColor = @"#7d7d7d"; //kHistoryDetailCellThree
NSString * const kHistoryDetailCell_lblAmount_pending_textColor = @"#7d7d7d"; //kHistoryDetailCellThree
NSString * const kHistoryDetailCell_indicatorColorView_credit_backgroundColor = @"#33b94c"; //kHistoryDetailCellTwo
NSString * const kHistoryDetailCell_lblAmount_credit_textColor = @"#33b94c"; //kHistoryDetailCellTwo
NSString * const kHistoryDetailCell_indicatorColorView_debit_backgroundColor = @"#ff0013"; //kHistoryDetailCellOne
NSString * const kHistoryDetailCell_lblAmount_debit_textColor = @"#ff0013"; //kHistoryDetailCellOne
NSString * const kHistoryDetailCell_contentView_refused_backgroundColor = @"#ababab"; //lightGrayColor
NSString * const kHistoryDetailCell_contentView_canceled_backgroundColor = @"#ababab"; //lightGrayColor
NSString * const kHistoryDetailCell_pendingCreditorAcceptButton_backgroundColor = @"#33b94c";
NSString * const kHistoryDetailCell_pendingCreditorCancelButton_backgroundColor = @"#9d1111";
NSString * const kHistoryDetailCell_pendingDebitorCancelButton_backgroundColor = @"#9d1111";
NSString * const kHistoryDetailCell_pendingCreditorActionView_backgroundColor = @"#383838";
NSString * const kHistoryDetailCell_pendingDebitorActionView_backgroundColor = @"#ff0013";
NSString * const kHistoryDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor = @"#187f2c";
NSString * const kHistoryDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor = @"#720c0c";
NSString * const kHistoryDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor = @"#720c0c";

#pragma mark - SuscribeTextViewCell 
NSString * const kSuscribeTextViewCell_textField_textColor = kMainOne; //kBackgroundOne
NSString * const kSuscribeTextViewCell_textField_placeHolderColor = kMonochromeTwo;
NSString * const kSuscribeTextViewCell_lbl_textColor = @"#171717";

#pragma mark - SuscribeTextViewCellSegment
NSString * const kSuscribeTextViewCellSegment_segmentedControl_tintColor = kMainOne; //kBackgroundOne

#pragma mark - SuscribeTextViewCellPicker
NSString * const kSuscribeTextViewCellPicker_textField_backgroundColor = kMainOne; //kBackgroundOne

#pragma mark - RegisterUserViewController
NSString * const kRegisterUserViewController_lblSubNavigation_textColor = @"#ffffff";//kRegisterUserViewControllerLabelSubNanvigation
NSString * const kRegisterUserViewController_viewHeader_backgroundColor = kMonochromeOne; //@"#6a6e70";

#pragma mark - CustomTabBarViewController_btnPay_riddleColor
NSString * const kCustomTabBarViewController_btnPay_riddleColor = kMainOne; //kBackgroundTwelve

#pragma mark - ProgramTableViewCell
NSString * const kProgramTableViewCell_lblProgramName_odd_textColor = @"#383838"; //kTextEleven
NSString * const kProgramTableViewCell_lblProgramName_odd_backgroundColor = kWhite; //whiteColor
NSString * const kProgramTableViewCell_lblMerchantName_odd_textColor = @"#7d7d7d"; //kTextTwelve
NSString * const kProgramTableViewCell_lblMerchantName_odd_backgroundColor= kWhite; //whiteColor
NSString * const kProgramTableViewCell_contentView_even_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyOne
NSString * const kProgramTableViewCell_lblProgramName_even_textColor = kWhite; //kTextEleven
NSString * const kProgramTableViewCell_lblProgramName_even_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyOne
NSString * const kProgramTableViewCell_lblMerchantName_even_textColor = kWhite; //kTextTen
NSString * const kProgramTableViewCell_lblMerchantName_even_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyOne
NSString * const kProgramTableViewCell_imageCoupons_even_bacgroundColor = @"#0cc3b9"; //kBackgroundTwentyOne
NSString * const kProgramTableViewCell_imageLogo_even_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyOne
NSString * const kProgramTableViewCell_lblNumberOfCoupons_even_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyOne
NSString * const kProgramTableViewCell_lblAmountOfACoupons_even_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyOne
NSString * const kProgramTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyOne
NSString * const kProgramTableViewCell_viewIndicationsCoupons_even_backgroundColor = @"#0cc3b9"; //kBackgroundTwentyOne

#pragma mark - HistoryViewController
NSString * const kHistoryViewController_allButton_borderColor = @"#383838"; //kTextEleven
NSString * const kHistoryViewController_allButton_backgroundColor = @"#383838"; //kTextEleven
NSString * const kHistoryViewController_outputButton_titleColor = @"#ff0013"; //kHistoryDetailCellOne
NSString * const kHistoryViewController_outputButton_borderColor = @"#ff0013"; //kHistoryDetailCellOne
NSString * const kHistoryViewController_inputButton_titleColor = @"#33b94c"; //kHistoryDetailCellTwo
NSString * const kHistoryViewController_inputButton_borderColor = @"#33b94c"; //kHistoryDetailCellTwo
NSString * const kHistoryViewController_pendingButton_titleColor = @"#7d7d7d"; //kHistoryDetailCellThree
NSString * const kHistoryViewController_pendingButton_borderColor = @"#7d7d7d"; //kHistoryDetailCellThree
NSString * const kHistoryViewController_contentView_backgroundColor = kMonochromeOne; //kBackgroundTwentyFive
NSString * const kHistoryViewController_header_backgroundColor = kBlack;

#pragma mark - TransferReceiveStep1ViewController
NSString * const kTransferReceiveStep1ViewController_lblYourBalance_textColor = kMonochromeTwo; //kTextTwo
NSString * const kTransferReceiveStep1ViewController_lblBalance_textColor = kMonochromeTwo; //kTextTwo
NSString * const kTransferReceiveStep1ViewController_header_backgroundColor = kTransferOne;
NSString * const kTransferReceiveStep1ViewController_viewDescription_backgroundColor = kTransferOne;
NSString * const kTransferReceiveStep1ViewController_lblAmount_textColor = kTransferOne;
NSString * const kTransferReceiveStep1ViewController_lblCurrencyBefore_textColor = kTransferOne;
NSString * const kTransferReceiveStep1ViewController_amountTextField_textColor = kTransferOne;
NSString * const kTransferReceiveStep1ViewController_lblCurrencyAfter_textColor = kTransferOne;
NSString * const kTransferReceiveStep1ViewController_lblDescription_textColor = kWhite;

#pragma mark - TransferReceiveStep2ViewController
NSString * const kTransferReceiveStep2ViewController_header_backgroundColor = kTransferOne;

#pragma mark - ValidatorViewController
NSString * const kValidatorViewController_view_backgroundColor = kMainOne; //kSkinBlue
NSString * const kValidatorViewController_btnSecond_borderColor = kMainTwo; //kBorderOne
NSString * const kValidatorViewController_lblFirst_mode1_textColor = kWhite;
NSString * const kValidatorViewController_btnFirst_mode1_backgroundColor = @"#9d1111";
NSString * const kValidatorViewController_btnFirst_mode1_titleColor = kWhite;
NSString * const kValidatorViewController_lblFirst_mode2_textColor = kWhite;
NSString * const kValidatorViewController_btnFirst_mode2_backgroundColor = @"#49a9c3";
NSString * const kValidatorViewController_btnFirst_mode2_titleColor = kWhite;
NSString * const kValidatorViewController_btnSecond_mode2_titleColor = kWhite;
NSString * const kValidatorViewController_btnSecond_mode2_backgroundColor = kMainTwo;
NSString * const kValidatorViewController_lblFirst_mode3_textColor = kWhite;
NSString * const kValidatorViewController_btnFirst_mode3_backgroundColor = kMainTwo;
NSString * const kValidatorViewController_btnFirst_mode3_titleColor = kWhite;
NSString * const kValidatorViewController_btnSecond_mode3_titleColor = kMainTwo;
NSString * const kValidatorViewController_btnSecond_mode3_backgroundColor = kMainOne;
NSString * const kValidatorViewController_btnSecond_mode2_highlighted_backgroundColor = kMainThree;
NSString * const kValidatorViewController_btnSecond_mode2_highlighted_titleColor = kMainOne;
NSString * const kValidatorViewController_btnFirst_mode3_highlighted_backgroundColor = kMainThree;
NSString * const kValidatorViewController_btnFirst_mode3_highlighted_titleColor = kMainOne;
NSString * const kValidatorViewController_btnSecond_mode3_highlighted_titleColor = kWhite;
NSString * const kValidatorViewController_btnSecond_mode3_highlighted_backgroundColor = kMainTwo;

#pragma mark - InitialViewController
NSString * const kInitialViewController_viewMiddle_backgroundColor = kMainOne; //kBackgroundLight
NSString * const kInitialViewController_viewBottom_backgroundColor = kMonochromeTwo; //kBackgroundFour
NSString * const kInitialViewController_btnCreateAccount_backgroundColor = kMainTwo; //kBackgroundThirteen
NSString * const kInitialViewController_btnCreateAccount_highlighted_backgroundColor = kMainThree;
NSString * const kInitialViewController_btnLogin_titleColor = kMonochromeThree; //kInicialVCBtnConnectText
NSString * const kinitialViewController_btnCreateAccount_highlighted_titleColor = kMainOne;

#pragma mark - PaymentViewController
NSString * const kPaymentViewController_viewBackgroundSetUserInfos_backgroundColor = kMainOne; //kBackgroundTwentySeven
NSString * const kPaymentViewController_btnSetUserInfos_backgroundColor = kMainOne; //kBackgroundTwentySeven
NSString * const kPaymentViewController_viewBackgroundAddCreditCard_backgroundColor = kMainOne; //kBackgroundTwentyEight
NSString * const kPaymentViewController_btnAddCreditCard_backgroundColor = kMainOne; //kBackgroundTwentyEight

#pragma mark - YourLoyaltyProgramsViewController
NSString * const kYourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor = kWhite;

#pragma mark - YourLoyaltyProgramDetailsViewController
NSString * const kYourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor = @"#7d7d7d";

#pragma mark - LoyaltyProgramDetailsViewController
NSString * const kLoyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor = kRewardsThree;

#pragma mark - RegisterResponseViewController
NSString * const kRegisterResponseViewController_btnValidate_backgroundColor = kMainTwo;
NSString * const kRegisterResponseViewController_viewValidate_backgroundColor = kMainOne;
NSString * const kRegisterResponseViewController_btnValidate_titleColor = kWhite;
NSString * const kRegisterResponseViewController_btnValidate_highlighted_titleColor = kMainOne;
NSString * const kRegisterResponseViewController_btnValidate_highlighted_backgroundColor = kMainThree;
NSString * const kRegisterResponseViewController_viewBottom_unvalid_backgroundColor = kMonochromeOne;
NSString * const kRegisterResponseViewController_btnValidate_unvalid_backgroundColor = kMonochromeTwo;
NSString * const kRegisterResponseViewController_btnValidate_unvalid_titleColor = kMonochromeOne;
NSString * const kRegisterResponseViewController_textfield_placeholderColor = kMonochromeTwo;
NSString * const kRegisterResponseViewController_textField_textColor = kMainOne;

#pragma mark - RegisterCaptchaViewController
NSString * const kRegisterCaptchaViewController_btnValidate_bacgroundColor = @"#3d9bb3";
NSString * const kRegisterCaptchaViewController_viewBottom_bacgroundColor = @"#48a8c3";

#pragma mark - TransferHomeViewController
NSString * const kTransferHomeViewController_lblReceive_textColor = kWhite;
NSString * const kTransferHomeViewController_lblSend_textColor = kWhite;

#pragma mark - ForgottenPasswordSendMailViewController
NSString * const kForgottenPasswordSendMailViewController_viewSubNavigation_backgroundColor = @"#dad9d9";
NSString * const kForgottenPasswordSendMailViewController_lblSubNavigation_textColor = @"#454545";
NSString * const kForgottenPasswordSendMailViewController_viewBottom_backgroundColor = @"#efeeee";
NSString * const kForgottenPasswordSendMailViewController_btnValidate_titleColor = kWhite;
NSString * const kForgottenPasswordSendMailViewController_btnValidate_backgroundColor = @"#dad9d9";
NSString * const kForgottenPasswordSendMailViewController_viewBottom_valid_backgroundColor = @"#4ea9c6";
NSString * const kForgottenPasswordSendMailViewController_btnValidate_valid_titleColor = kWhite;
NSString * const kForgottenPasswordSendMailViewController_btnValidate_valid_backgroundColor = @"#2f8ca5";

#pragma mark - ForgottenPasswordSecretAnswerViewController
NSString * const kForgottenPasswordSecretAnswerViewController_viewNavigation_backgroundColor = kBlack;
NSString * const kForgottenPasswordSecretAnswerViewController_lblNavigation_textColor = kWhite;
NSString * const kForgottenPasswordSecretAnswerViewController_viewQuestion_backgroundColor = @"#efeeee";
NSString * const kForgottenPasswordSecretAnswerViewController_lblQuestion_textColor = @"#7d7d7d";
NSString * const kForgottenPasswordSecretAnswerViewController_viewBottom_backgroundColor = @"#efeeee";
NSString * const kForgottenPasswordSecretAnswerViewController_btnValidate_backgroundColor = @"#dad9d9";
NSString * const kForgottenPasswordSecretAnswerViewController_viewBottom_valid_backgroundColor = @"#4ea9c6";
NSString * const kForgottenPasswordSecretAnswerViewController_btnValidate_valid_backgroundColor = @"#2f8ca5";
NSString * const kForgottenPasswordSecretAnswerViewController_viewBottom_bad_backgroundColor = @"#ff0013";
NSString * const kForgottenPasswordSecretAnswerViewController_btnValidate_bad_backgroundColor = @"#9d1111";

#pragma mark - ForgottenPasswordNewPasswordViewController
NSString * const kForgottenPasswordNewPasswordViewController_viewNavigation_backgroundColor = kBlack;
NSString * const kForgottenPasswordNewPasswordViewController_lblNavigation_textColor = kWhite;
NSString * const kForgottenPasswordNewPasswordViewController_viewInstructions_backgroundColor = @"#efeeee";
NSString * const kForgottenPasswordNewPasswordViewController_lblInstructions_textColor = @"#7d7d7d";
NSString * const kForgottenPasswordNewPasswordViewController_viewBottom_backgroundColor = @"#efeeee";
NSString * const kForgottenPasswordNewPasswordViewController_btnValidate_backgroundColor = @"#dad9d9";
NSString * const kForgottenPasswordNewPasswordViewController_viewBottom_valid_backgroundColor = @"#4ea9c6";
NSString * const kForgottenPasswordNewPasswordViewController_btnValidate_valid_backgroundColor = @"#2f8ca5";

#pragma mark - AccountBannerViewController
NSString * const kAccountBannerViewController_lblYourBalance_textColor = @"#383838";
NSString * const kAccountBannerViewController_lblCurrentBalance_textColor = @"#383838";

@end
