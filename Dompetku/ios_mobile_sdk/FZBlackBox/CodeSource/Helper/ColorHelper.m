//
//  ColorHelper
//  flashiz_ios_core_ui
//
//  Created by Yvan Moté on 17/12/13.
//  retainright (c) 2013 Flashiz. All rights reserved.
//

#import "ColorHelper.h"

#import "FZUIColorCreateMethods.h"
#import "ColorsConstants.h"

#import "FZDefaultTemplateColor.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface ColorHelper()

@end

@implementation ColorHelper

static ColorHelper *sharedInstance = nil;

static UIColor *blackColor = nil;
static UIColor *whiteColor = nil;


static UIColor *mainOneColor = nil;
static UIColor *mainTwoColor = nil;
static UIColor *mainThreeColor = nil;
static UIColor *transferOneColor = nil;
static UIColor *transferTwoColor = nil;
static UIColor *rewardsOneColor = nil;
static UIColor *rewardsThreeColor = nil;
static UIColor *monochromeOneColor = nil;
static UIColor *monochromeTwoColor = nil;
static UIColor *monochromeThreeColor = nil;

#pragma mark - PaymentTopupViewController
static UIColor *paymentTopupViewController_lblAutomaticRefill_textColor = nil;
static UIColor *paymentTopupViewController_autoButton_titleColor = nil;
static UIColor *paymentTopupViewController_aButton_titleColor = nil;
static UIColor *paymentTopupViewController_viewChooseCard_backgroundColor = nil;
static UIColor *paymentTopupViewController_viewRefill_backgroundColor = nil;
static UIColor *paymentTopupViewController_refillButton_backgroundColor = nil;
static UIColor *paymentTopupViewController_autoButton_backgroundColor = nil;
static UIColor *paymentTopupViewController_creditCardButton_backgroundColor = nil;
static UIColor *paymentTopupViewController_viewAutomaticRefill_backgroundColor = nil;
static UIColor *paymentTopupViewController_header_backgroundColor = nil;
static UIColor *paymentTopupViewController_lblAmount_textColor = nil;
static UIColor *paymentTopupViewController_viewChooseCard_selected_backgroundColor = nil;
static UIColor *paymentTopupViewController_creditCardButton_selected_titleColor = nil;
static UIColor *paymentTopupViewController_refillButton_highlighted_backgroundColor = nil;
static UIColor *paymentTopupViewController_refillButton_titleColor = nil;
static UIColor *paymentTopupViewController_refillButton_highlighted_titleColor = nil;
static UIColor *paymentTopupViewController_refillButton_unvalid_titleColor = nil;
static UIColor *paymentTopupViewController_refillButton_unvalid_backgroundColor = nil;
static UIColor *paymentTopupViewController_creditCardButton_selected_backgroundColor = nil;
static UIColor *paymentTopupViewController_viewRefill_unvalid_backgroundColor = nil;

#pragma mark - CardListViewController
static UIColor *cardListViewController_backgroundColor = nil;
static UIColor *cardListViewController_viewValidate_backgroundColor = nil;
static UIColor *cardListViewController_btnValidate_backgroundColor = nil;
static UIColor *cardListViewController_btnValidate_highlighted_backgroundColor = nil;
static UIColor *cardListViewController_btnValidate_highlighted_textColor = nil;


#pragma mark - BankAccountExpiredCell
static UIColor *bankAccountExpiredCell_backgroundColor = nil;
static UIColor *bankAccountExpiredCell_stringColor_backgroundColor = nil;
static UIColor *bankAccountExpiredCell_lblCardExpired_textColor = nil;
static UIColor *bankAccountExpiredCell_btnRight_titleColor = nil;
static UIColor *bankAccountExpiredCell_btnRight_borderColor = nil;
static UIColor *bankAccountExpiredCell_btnRight_backgroundColor = nil;
static UIColor *bankAccountExpiredCell_btnLeft_backgroundColor = nil;
static UIColor *bankAccountExpiredCell_btnLeft_highlighted_titleColor = nil;
static UIColor *bankAccountExpiredCell_btnRight_highlighted_titleColor = nil;
static UIColor *bankAccountExpiredCell_btnLeft_highlighted_backgroundColor = nil;
static UIColor *bankAccountExpiredCell_btnRight_highlighted_backgroundColor = nil;

#pragma mark - BankAccountCell
static UIColor *bankAccountCell_stringColorEditionMode_backgroundColor = nil;
static UIColor *bankAccountCell_stringColor_backgroundColor = nil;
static UIColor *bankAccountCell_lblCardNumber_textColor = nil;
static UIColor *bankAccountCell_lblCardExpired_textColor = nil;

#pragma mark - ActionSuccessfulViewController
static UIColor *actionSuccessfulViewController_fromCardList_backgroundColor = nil;
static UIColor *actionSuccessfulViewController_fromTopUp_backgroundColor = nil;

#pragma mark - MenuViewController
static UIColor *menuViewController_btnLogOff_backgroundColor = nil;
static UIColor *menuViewController_viewLogout_backgroundColor = nil;
static UIColor *menuViewController_tableview_inAccountListMode_backgroundColor = nil;
static UIColor *menuViewController_tableview_inAccountListMode_separatorColor = nil;
static UIColor *menuViewController_tableview_backgroundColor = nil;
static UIColor *menuViewController_tableview_separatorColor = nil;

#pragma mark - MenuUserCellManagement
static UIColor *menuUserCellManagement_myAccount_backgroundColor = nil;
static UIColor *menuUserCellManagement_myAccount_stringColor = nil;
static UIColor *menuUserCellManagement_home_stringColor = nil;
static UIColor *menuUserCellManagement_refill_stringColor = nil;
static UIColor *menuUserCellManagement_myInformations_stringColor = nil;
static UIColor *menuUserCellManagement_myCards_stringColor = nil;
static UIColor *menuUserCellManagement_security_stringColor = nil;
static UIColor *menuUserCellManagement_verifyAccount_stringColor = nil;

#pragma mark - MenuUserCell
static UIColor *menuUserCell_backgroundColor = nil;

#pragma mark - MenuSmallCell
static UIColor *menuSmallCell_version_backgroundColor = nil;
static UIColor *menuSmallCell_version_stringColor = nil;
static UIColor *menuSmallCell_backgroundColor = nil;
static UIColor *menuSmallCell_stringColor = nil;
static UIColor *menuSmallCell_contentView_backgroundColor = nil;
static UIColor *menuSmallCell_lbl_textColor = nil;

#pragma mark - MenuBigCell
static UIColor *menuBigCell_lbl_textColor = nil;

#pragma mark - TimeoutViewController
static UIColor *timeoutViewController_aButton_titleColor = nil;
static UIColor *timeoutViewController_viewChangePin_BackgroundColor = nil;
static UIColor *timeoutViewController_changePinButton_BackgroundColor = nil;
static UIColor *timeoutViewController_header_backgroundColor = nil;
static UIColor *timeoutViewController_changePinButton_highlighted_backgroundColor = nil;
static UIColor *timeoutViewController_changePinButton_titleColor = nil;
static UIColor *timeoutViewController_changePinButton_highlighted_titleColor = nil;
static UIColor *timeoutViewController_timeoutTitleLabel_textColor = nil;
static UIColor *timeoutViewController_timeoutDescriptionLabel_textColor = nil;

#pragma mark - TutorialViewController
static UIColor *tutorialViewController_viewBottom_backgroundColor = nil;

#pragma mark - UserInformationViewController
static UIColor *userInformationViewController_viewValidate_actived_backgroundColor = nil;
static UIColor *userInformationViewController_btnValidate_actived_titleColor = nil;
static UIColor *userInformationViewController_btnValidate_actived_backgroundColor = nil;
static UIColor *userInformationViewController_btnValidate_titleColor = nil;
static UIColor *userInformationViewController_btnValidate_backgroundColor = nil;
static UIColor *userInformationViewController_viewValidate_backgroundColor = nil;
static UIColor *userInformationViewController_header_backgroundColor = nil;
static UIColor *userInformationViewController_btnValidate_actived_highlighted_backgroundColor = nil;
static UIColor *userInformationViewController_btnValidate_actived_highlighted_titleColor = nil;

#pragma mark - PaymentCheckViewController
static UIColor *payButtonGradientOne = nil;
static UIColor *payButtonGradientTwo = nil;
static UIColor *payButtonGradientThree = nil;
static UIColor *paymentCheckViewController_view_backgroundColor = nil;
static UIColor *paymentCheckViewController_couponButton_titleColor = nil;
static UIColor *paymentCheckViewController_payButton_borderColor = nil;
static UIColor *paymentCheckViewController_payButton_titleColor = nil;
static UIColor *paymentCheckViewController_header_backgroundColor = nil;

#pragma mark - LoginViewController
static UIColor *loginViewController_headerView_backgroundColor = nil;
static UIColor *loginViewController_btnConnect_titleColor = nil;
static UIColor *loginViewController_bottomView_backgroundColor = nil;
static UIColor *loginViewController_btnLogin_backgroundColor = nil;
static UIColor *loginViewController_btnLogin_titleColor = nil;
static UIColor *loginViewController_btnForgottenPassword_titleColor = nil;
static UIColor *loginViewController_bottomView_valid_backgroundColor = nil;
static UIColor *loginViewController_btnLogin_valid_backgroundColor = nil;
static UIColor *loginViewController_btnLogin_valid_titleColor = nil;

#pragma mark - PinViewController
static UIColor *pinViewController_colorThree = nil;
static UIColor *pinViewController_textField_backgroundColor = nil;
static UIColor *pinViewController_textField_2_backgroundColor = nil;
static UIColor *pinViewController_gradient_top = nil;
static UIColor *pinViewController_gradient_bottom = nil;

#pragma mark - PaymentViewController
static UIColor *paymentViewController_header_backgroundColor = nil;
static UIColor *paymentViewController_btnSetUserInfos_highlighted_backgroundColor = nil;
static UIColor *paymentViewController_btnAddCreditCard_highlighted_backgroundColor = nil;
static UIColor *paymentViewController_btnSetUserInfos_titleColor = nil;
static UIColor *paymentViewController_btnSetUserInfos_highlighted_titleColor = nil;
static UIColor *paymentViewController_btnAddCreditCard_titleColor = nil;
static UIColor *paymentViewController_btnAddCreditCard_highlighted_titleColor = nil;

#pragma mark - CountryViewController
static UIColor *countryViewController_header_backgroundColor = nil;
static UIColor *countryViewController_tableview_separatorColor = nil;
static UIColor *countryViewController_textFieldCountryName_placeHolderColor = nil;

#pragma mark - RegisterQuestionsViewController
static UIColor *registerQuestionsViewController_tableview_separatorColor = nil;

#pragma mark - ActionSuccessfulAfterPaymentViewController
static UIColor *actionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor = nil;

#pragma mark - RewardsHomeViewController
static UIColor *rewardsHomeViewController_yourProgramsButton_backgroundColor = nil;
static UIColor *rewardsHomeViewController_yourProgramsButton_selected_backgroundColor = nil;
static UIColor *rewardsHomeViewController_allProgramsButton_backgroundColor = nil;
static UIColor *rewardsHomeViewController_allProgramsButton_selected_backgroundColor = nil;
static UIColor *rewardsHomeViewController_viewAccountBanner_textColor = nil;

#pragma mark - LoginCell
static UIColor *loginCell_textField_textColor = nil;

#pragma mark - TransferStep1ViewController
static UIColor *transferStep1ViewController_lblYourbalance_textColor = nil;
static UIColor *transferStep1ViewController_lblBalance_textColor = nil;
static UIColor *transferStep1ViewController_searchContactButton_backgroundColor = nil;
static UIColor *transferStep1ViewController_validateButton_backgroundColor = nil;
static UIColor *transferStep1ViewController_commentButton_backgroundColor = nil;
static UIColor *transferStep1ViewController_viewMail_backgroundColor = nil;
static UIColor *transferStep1ViewController_toLabel_textColor = nil;
static UIColor *transferStep1ViewController_mailTextField_textColor = nil;
static UIColor *transferStep1ViewController_toLabel_after_textColor = nil;
static UIColor *transferStep1ViewController_mailTextField_after_textColor = nil;
static UIColor *transferStep1ViewController_searchFriendMailLabel_backgroundColor = nil;
static UIColor *transferStep1ViewController_viewSearchContact_backgroundColor = nil;
static UIColor *transferStep1ViewController_searchContactButton_highlighted_backgroundColor = nil;
static UIColor *transferStep1ViewController_validateButton_highlighted_backgroundColor = nil;

#pragma mark - ResponseCell
static UIColor *responseCell_bgView_backgroundColor = nil;

#pragma mark - CountryCell
static UIColor *countryCell_bgView_backgroundColor = nil;

#pragma mark - HistoryDetailCell
static UIColor *historyDetailCell_indicatorColorView_pending_backgroundColor = nil;
static UIColor *historyDetailCell_lblAmount_pending_textColor = nil;
static UIColor *historyDetailCell_indicatorColorView_credit_backgroundColor = nil;
static UIColor *historyDetailCell_lblAmount_credit_textColor = nil;
static UIColor *historyDetailCell_indicatorColorView_debit_backgroundColor = nil;
static UIColor *historyDetailCell_lblAmount_debit_textColor = nil;
static UIColor *historyDetailCell_contentView_refused_backgroundColor = nil;
static UIColor *historyDetailCell_contentView_canceled_backgroundColor = nil;
static UIColor *historyDetailCell_pendingCreditorAcceptButton_backgroundColor = nil;
static UIColor *historyDetailCell_pendingCreditorCancelButton_backgroundColor = nil;
static UIColor *historyDetailCell_pendingDebitorCancelButton_backgroundColor = nil;
static UIColor *historyDetailCell_pendingCreditorActionView_backgroundColor = nil;
static UIColor *historyDetailCell_pendingDebitorActionView_backgroundColor = nil;
static UIColor *historyDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor = nil;
static UIColor *historyDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor = nil;
static UIColor *historyDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor = nil;

#pragma mark - SuscribeTextViewCell
static UIColor *suscribeTextViewCell_textField_textColor = nil;
static UIColor *suscribeTextViewCell_textField_placeHolderColor = nil;
static UIColor *suscribeTextViewCell_lbl_textColor = nil;

#pragma mark - SuscribeTextViewCellSegment
static UIColor *suscribeTextViewCellSegment_segmentedControl_tintColor = nil;

#pragma mark - SuscribeTextViewCellPicker
static UIColor *suscribeTextViewCellPicker_textField_backgroundColor = nil;

#pragma mark - RegisterUserViewController
static UIColor *registerUserViewController_lblSubNavigation_textColor = nil;
static UIColor *registerUserViewController_viewHeader_backgroundColor = nil;

#pragma mark - CustomTabBarViewController_btnPay_riddleColor
static UIColor *customTabBarViewController_btnPay_riddleColor = nil;

#pragma mark - ProgramTableViewCell
static UIColor *programTableViewCell_lblProgramName_odd_textColor = nil;
static UIColor *programTableViewCell_lblProgramName_odd_backgroundColor = nil;
static UIColor *programTableViewCell_lblMerchantName_odd_textColor = nil;
static UIColor *programTableViewCell_lblMerchantName_odd_backgroundColor = nil;
static UIColor *programTableViewCell_contentView_even_backgroundColor = nil;
static UIColor *programTableViewCell_lblProgramName_even_textColor = nil;
static UIColor *programTableViewCell_lblProgramName_even_backgroundColor = nil;
static UIColor *programTableViewCell_lblMerchantName_even_textColor = nil;
static UIColor *programTableViewCell_lblMerchantName_even_backgroundColor = nil;
static UIColor *programTableViewCell_imageCoupons_even_bacgroundColor = nil;
static UIColor *programTableViewCell_imageLogo_even_backgroundColor = nil;
static UIColor *programTableViewCell_lblNumberOfCoupons_even_backgroundColor = nil;
static UIColor *programTableViewCell_lblAmountOfACoupons_even_backgroundColor = nil;
static UIColor *programTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor = nil;
static UIColor *programTableViewCell_viewIndicationsCoupons_even_backgroundColor = nil;

#pragma mark - HistoryViewController
static UIColor *historyViewController_allButton_borderColor = nil;
static UIColor *historyViewController_allButton_backgroundColor = nil;
static UIColor *historyViewController_outputButton_titleColor = nil;
static UIColor *historyViewController_outputButton_borderColor = nil;
static UIColor *historyViewController_inputButton_titleColor = nil;
static UIColor *historyViewController_inputButton_borderColor = nil;
static UIColor *historyViewController_pendingButton_titleColor = nil;
static UIColor *historyViewController_pendingButton_borderColor = nil;
static UIColor *historyViewController_contentView_backgroundColor = nil;
static UIColor *historyViewController_header_backgroundColor = nil;

#pragma mark - TransferReceiveStep1ViewController
static UIColor *transferReceiveStep1ViewController_lblYourBalance_textColor = nil;
static UIColor *transferReceiveStep1ViewController_lblBalance_textColor = nil;
static UIColor *transferReceiveStep1ViewController_header_backgroundColor = nil;
static UIColor *transferReceiveStep1ViewController_viewDescription_backgroundColor = nil;
static UIColor *transferReceiveStep1ViewController_lblAmount_textColor = nil;
static UIColor *transferReceiveStep1ViewController_lblCurrencyBefore_textColor = nil;
static UIColor *transferReceiveStep1ViewController_amountTextField_textColor = nil;
static UIColor *transferReceiveStep1ViewController_lblCurrencyAfter_textColor = nil;
static UIColor *transferReceiveStep1ViewController_lblDescription_textColor = nil;

#pragma mark - TransferReceiveStep2ViewController
static UIColor *transferReceiveStep2ViewController_header_backgroundColor = nil;

#pragma mark - ValidatorViewController
static UIColor *validatorViewController_view_backgroundColor = nil;
static UIColor *validatorViewController_btnSecond_borderColor = nil;
static UIColor *validatorViewController_lblFirst_mode1_textColor = nil;
static UIColor *validatorViewController_btnFirst_mode1_backgroundColor = nil;
static UIColor *validatorViewController_btnFirst_mode1_titleColor = nil;
static UIColor *validatorViewController_btnFirst_mode1_highlighted_titleColor = nil;
static UIColor *validatorViewController_lblFirst_mode2_textColor = nil;
static UIColor *validatorViewController_btnFirst_mode2_backgroundColor = nil;
static UIColor *validatorViewController_btnFirst_mode2_titleColor = nil;
static UIColor *validatorViewController_btnSecond_mode2_titleColor = nil;
static UIColor *validatorViewController_btnSecond_mode2_backgroundColor = nil;
static UIColor *validatorViewController_lblFirst_mode3_textColor = nil;
static UIColor *validatorViewController_btnFirst_mode3_backgroundColor = nil;
static UIColor *validatorViewController_btnFirst_mode3_titleColor = nil;
static UIColor *validatorViewController_btnSecond_mode3_titleColor = nil;
static UIColor *validatorViewController_btnSecond_mode3_backgroundColor = nil;
static UIColor *validatorViewController_btnSecond_mode2_highlighted_backgroundColor = nil;
static UIColor *validatorViewController_btnSecond_mode2_highlighted_titleColor = nil;
static UIColor *validatorViewController_btnFirst_mode3_highlighted_backgroundColor = nil;
static UIColor *validatorViewController_btnFirst_mode3_highlighted_titleColor = nil;
static UIColor *validatorViewController_btnSecond_mode3_highlighted_titleColor = nil;
static UIColor *validatorViewController_btnSecond_mode3_highlighted_backgroundColor = nil;

#pragma mark - InitialViewController
static UIColor *initialViewController_viewMiddle_backgroundColor = nil;
static UIColor *initialViewController_viewBottom_backgroundColor = nil;
static UIColor *initialViewController_btnCreateAccount_backgroundColor = nil;
static UIColor *initialViewController_btnCreateAccount_highlighted_backgroundColor = nil;
static UIColor *initialViewController_btnLogin_titleColor = nil;
static UIColor *initialViewController_btnCreateAccount_highlighted_titleColor = nil;

#pragma mark - PaymentViewController
static UIColor *paymentViewController_viewBackgroundSetUserInfos_backgroundColor = nil;
static UIColor *paymentViewController_btnSetUserInfos_backgroundColor = nil;
static UIColor *paymentViewController_viewBackgroundAddCreditCard_backgroundColor = nil;
static UIColor *paymentViewController_btnAddCreditCard_backgroundColor = nil;

#pragma mark - YourLoyaltyProgramsViewController
static UIColor *yourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor = nil;

#pragma mark - YourLoyaltyProgramDetailsViewController
static UIColor *yourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor = nil;

#pragma mark - LoyaltyProgramDetailsViewController
static UIColor *loyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor = nil;

#pragma mark - RegisterResponseViewController
static UIColor *registerResponseViewController_btnValidate_backgroundColor = nil;
static UIColor *registerResponseViewController_viewValidate_backgroundColor = nil;
static UIColor *registerResponseViewController_btnValidate_titleColor = nil;
static UIColor *registerResponseViewController_btnValidate_highlighted_titleColor = nil;
static UIColor *registerResponseViewController_btnValidate_highlighted_backgroundColor = nil;
static UIColor *registerResponseViewController_viewBottom_unvalid_backgroundColor = nil;
static UIColor *registerResponseViewController_btnValidate_unvalid_backgroundColor = nil;
static UIColor *registerResponseViewController_btnValidate_unvalid_titleColor = nil;
static UIColor *registerResponseViewController_textfield_placeholderColor = nil;
static UIColor *registerResponseViewController_textField_textColor = nil;

#pragma mark - RegisterCaptchaViewController
static UIColor *registerCaptchaViewController_btnValidate_bacgroundColor = nil;
static UIColor *registerCaptchaViewController_viewBottom_bacgroundColor = nil;

#pragma mark - TransferHomeViewController
static UIColor *transferHomeViewController_lblReceive_textColor = nil;
static UIColor *transferHomeViewController_lblSend_textColor = nil;

#pragma mark - ForgottenPasswordSendMailViewController
static UIColor *forgottenPasswordSendMailViewController_viewSubNavigation_backgroundColor = nil;
static UIColor *forgottenPasswordSendMailViewController_lblSubNavigation_textColor = nil;
static UIColor *forgottenPasswordSendMailViewController_viewBottom_backgroundColor = nil;
static UIColor *forgottenPasswordSendMailViewController_btnValidate_titleColor = nil;
static UIColor *forgottenPasswordSendMailViewController_btnValidate_backgroundColor = nil;
static UIColor *forgottenPasswordSendMailViewController_viewBottom_valid_backgroundColor = nil;
static UIColor *forgottenPasswordSendMailViewController_btnValidate_valid_titleColor = nil;
static UIColor *forgottenPasswordSendMailViewController_btnValidate_valid_backgroundColor = nil;

#pragma mark - ForgottenPasswordSecretAnswerViewController
static UIColor *forgottenPasswordSecretAnswerViewController_viewNavigation_backgroundColor = nil;
static UIColor *forgottenPasswordSecretAnswerViewController_lblNavigation_textColor = nil;
static UIColor *forgottenPasswordSecretAnswerViewController_viewQuestion_backgroundColor = nil;
static UIColor *forgottenPasswordSecretAnswerViewController_lblQuestion_textColor = nil;
static UIColor *forgottenPasswordSecretAnswerViewController_viewBottom_backgroundColor = nil;
static UIColor *forgottenPasswordSecretAnswerViewController_btnValidate_backgroundColor = nil;
static UIColor *forgottenPasswordSecretAnswerViewController_viewBottom_valid_backgroundColor = nil;
static UIColor *forgottenPasswordSecretAnswerViewController_btnValidate_valid_backgroundColor = nil;
static UIColor *forgottenPasswordSecretAnswerViewController_viewBottom_bad_backgroundColor = nil;
static UIColor *forgottenPasswordSecretAnswerViewController_btnValidate_bad_backgroundColor = nil;

#pragma mark - ForgottenPasswordNewPasswordViewController
static UIColor *forgottenPasswordNewPasswordViewController_viewNavigation_backgroundColor = nil;
static UIColor *forgottenPasswordNewPasswordViewController_lblNavigation_textColor = nil;
static UIColor *forgottenPasswordNewPasswordViewController_viewInstructions_backgroundColor = nil;
static UIColor *forgottenPasswordNewPasswordViewController_lblInstructions_textColor = nil;
static UIColor *forgottenPasswordNewPasswordViewController_viewBottom_backgroundColor = nil;
static UIColor *forgottenPasswordNewPasswordViewController_btnValidate_backgroundColor = nil;
static UIColor *forgottenPasswordNewPasswordViewController_viewBottom_valid_backgroundColor = nil;
static UIColor *forgottenPasswordNewPasswordViewController_btnValidate_valid_backgroundColor = nil;

#pragma mark - AccountBannerViewController
static UIColor *accountBannerViewController_lblYourBalance_textColor = nil;
static UIColor *accountBannerViewController_lblCurrentBalance_textColor = nil;

+ (ColorHelper*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ColorHelper alloc] init];
    });
    
    return [[sharedInstance retain]autorelease];
}

- (void)cleanInstance
{
    blackColor = nil;
    whiteColor = nil;
    
    mainOneColor = nil;
    mainTwoColor = nil;
    mainThreeColor = nil;
    transferOneColor = nil;
    transferTwoColor = nil;
    rewardsOneColor = nil;
    rewardsThreeColor = nil;
    monochromeOneColor = nil;
    monochromeTwoColor = nil;
    monochromeThreeColor = nil;
    
#pragma mark - PaymentTopupViewController
    paymentTopupViewController_lblAutomaticRefill_textColor = nil;
    paymentTopupViewController_autoButton_titleColor = nil;
    paymentTopupViewController_aButton_titleColor = nil;
    paymentTopupViewController_viewChooseCard_backgroundColor = nil;
    paymentTopupViewController_viewRefill_backgroundColor = nil;
    paymentTopupViewController_refillButton_backgroundColor = nil;
    paymentTopupViewController_autoButton_backgroundColor = nil;
    paymentTopupViewController_creditCardButton_backgroundColor = nil;
    paymentTopupViewController_viewAutomaticRefill_backgroundColor = nil;
    paymentTopupViewController_header_backgroundColor = nil;
    paymentTopupViewController_lblAmount_textColor = nil;
    paymentTopupViewController_viewChooseCard_selected_backgroundColor = nil;
    paymentTopupViewController_creditCardButton_selected_titleColor = nil;
    paymentTopupViewController_refillButton_highlighted_backgroundColor = nil;
    paymentTopupViewController_refillButton_titleColor = nil;
    paymentTopupViewController_refillButton_highlighted_titleColor = nil;
    paymentTopupViewController_refillButton_unvalid_titleColor = nil;
    paymentTopupViewController_refillButton_unvalid_backgroundColor = nil;
    paymentTopupViewController_creditCardButton_selected_backgroundColor = nil;
    paymentTopupViewController_viewRefill_unvalid_backgroundColor = nil;
    
#pragma mark - CardListViewController
    cardListViewController_backgroundColor = nil;
    cardListViewController_viewValidate_backgroundColor = nil;
    cardListViewController_btnValidate_backgroundColor = nil;
    cardListViewController_btnValidate_highlighted_backgroundColor = nil;
    cardListViewController_btnValidate_highlighted_textColor = nil;
    
#pragma mark - BankAccountExpiredCell
    bankAccountExpiredCell_backgroundColor = nil;
    bankAccountExpiredCell_stringColor_backgroundColor = nil;
    bankAccountExpiredCell_lblCardExpired_textColor = nil;
    bankAccountExpiredCell_btnRight_titleColor = nil;
    bankAccountExpiredCell_btnRight_borderColor = nil;
    bankAccountExpiredCell_btnRight_backgroundColor = nil;
    bankAccountExpiredCell_btnLeft_backgroundColor = nil;
    bankAccountExpiredCell_btnLeft_highlighted_titleColor = nil;
    bankAccountExpiredCell_btnRight_highlighted_titleColor = nil;
    bankAccountExpiredCell_btnLeft_highlighted_backgroundColor = nil;
    bankAccountExpiredCell_btnRight_highlighted_backgroundColor = nil;
    
#pragma mark - BankAccountCell
    bankAccountCell_stringColorEditionMode_backgroundColor = nil;
    bankAccountCell_stringColor_backgroundColor = nil;
    bankAccountCell_lblCardNumber_textColor = nil;
    bankAccountCell_lblCardExpired_textColor = nil;
    
#pragma mark - ActionSuccessfulViewController
    actionSuccessfulViewController_fromCardList_backgroundColor = nil;
    actionSuccessfulViewController_fromTopUp_backgroundColor = nil;
    
#pragma mark - MenuViewController
    menuViewController_btnLogOff_backgroundColor = nil;
    menuViewController_viewLogout_backgroundColor = nil;
    menuViewController_tableview_inAccountListMode_backgroundColor = nil;
    menuViewController_tableview_inAccountListMode_separatorColor = nil;
    menuViewController_tableview_backgroundColor = nil;
    menuViewController_tableview_separatorColor = nil;
    
#pragma mark - MenuUserCellManagement
    menuUserCellManagement_myAccount_backgroundColor = nil;
    menuUserCellManagement_myAccount_stringColor = nil;
    menuUserCellManagement_home_stringColor = nil;
    menuUserCellManagement_refill_stringColor = nil;
    menuUserCellManagement_myInformations_stringColor = nil;
    menuUserCellManagement_myCards_stringColor = nil;
    menuUserCellManagement_security_stringColor = nil;
    menuUserCellManagement_verifyAccount_stringColor = nil;
    
#pragma mark - MenuUserCell
    menuUserCell_backgroundColor = nil;
    
#pragma mark - MenuSmallCell
    menuSmallCell_version_backgroundColor = nil;
    menuSmallCell_version_stringColor = nil;
    menuSmallCell_backgroundColor = nil;
    menuSmallCell_stringColor = nil;
    menuSmallCell_contentView_backgroundColor = nil;
    menuSmallCell_lbl_textColor = nil;
    
#pragma mark - MenuBigCell
    menuBigCell_lbl_textColor = nil;
    
#pragma mark - TimeoutViewController
    timeoutViewController_aButton_titleColor = nil;
    timeoutViewController_viewChangePin_BackgroundColor = nil;
    timeoutViewController_changePinButton_BackgroundColor = nil;
    timeoutViewController_header_backgroundColor = nil;
    timeoutViewController_changePinButton_highlighted_backgroundColor = nil;
    timeoutViewController_changePinButton_titleColor = nil;
    timeoutViewController_changePinButton_highlighted_titleColor = nil;
    timeoutViewController_timeoutTitleLabel_textColor = nil;
    timeoutViewController_timeoutDescriptionLabel_textColor = nil;
    
#pragma mark - TutorialViewController
    tutorialViewController_viewBottom_backgroundColor = nil;
    
#pragma mark - UserInformationViewController
    userInformationViewController_viewValidate_actived_backgroundColor = nil;
    userInformationViewController_btnValidate_actived_titleColor = nil;
    userInformationViewController_btnValidate_actived_backgroundColor = nil;
    userInformationViewController_btnValidate_titleColor = nil;
    userInformationViewController_btnValidate_backgroundColor = nil;
    userInformationViewController_viewValidate_backgroundColor = nil;
    userInformationViewController_header_backgroundColor = nil;
    userInformationViewController_btnValidate_actived_highlighted_backgroundColor = nil;
    userInformationViewController_btnValidate_actived_highlighted_titleColor = nil;
    
#pragma mark - PaymentCheckViewController
    payButtonGradientOne = nil;
    payButtonGradientTwo = nil;
    payButtonGradientThree = nil;
    paymentCheckViewController_view_backgroundColor = nil;
    paymentCheckViewController_couponButton_titleColor = nil;
    paymentCheckViewController_payButton_borderColor = nil;
    paymentCheckViewController_payButton_titleColor = nil;
    paymentCheckViewController_header_backgroundColor = nil;
    
#pragma mark - LoginViewController
    loginViewController_headerView_backgroundColor = nil;
    loginViewController_btnConnect_titleColor = nil;
    loginViewController_bottomView_backgroundColor = nil;
    loginViewController_btnLogin_backgroundColor = nil;
    loginViewController_btnLogin_titleColor = nil;
    loginViewController_btnForgottenPassword_titleColor = nil;
    loginViewController_bottomView_valid_backgroundColor = nil;
    loginViewController_btnLogin_valid_backgroundColor = nil;
    loginViewController_btnLogin_valid_titleColor = nil;
    
#pragma mark - PinViewController
    pinViewController_colorThree = nil;
    pinViewController_textField_backgroundColor = nil;
    pinViewController_textField_2_backgroundColor = nil;
    pinViewController_gradient_top = nil;
    pinViewController_gradient_bottom = nil;
    
#pragma mark - PaymentViewController
    paymentViewController_header_backgroundColor = nil;
    paymentViewController_btnSetUserInfos_highlighted_backgroundColor = nil;
    paymentViewController_btnAddCreditCard_highlighted_backgroundColor = nil;
    paymentViewController_btnSetUserInfos_titleColor = nil;
    paymentViewController_btnSetUserInfos_highlighted_titleColor = nil;
    paymentViewController_btnAddCreditCard_titleColor = nil;
    paymentViewController_btnAddCreditCard_highlighted_titleColor = nil;
    
#pragma mark - CountryViewController
    countryViewController_header_backgroundColor = nil;
    countryViewController_tableview_separatorColor = nil;
    countryViewController_textFieldCountryName_placeHolderColor = nil;
    
#pragma mark - RegisterQuestionsViewController
    registerQuestionsViewController_tableview_separatorColor = nil;
    
#pragma mark - ActionSuccessfulAfterPaymentViewController
    actionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor = nil;
    
#pragma mark - RewardsHomeViewController
    rewardsHomeViewController_yourProgramsButton_backgroundColor = nil;
    rewardsHomeViewController_yourProgramsButton_selected_backgroundColor = nil;
    rewardsHomeViewController_allProgramsButton_backgroundColor = nil;
    rewardsHomeViewController_allProgramsButton_selected_backgroundColor = nil;
    rewardsHomeViewController_viewAccountBanner_textColor = nil;
    
#pragma mark - LoginCell
    loginCell_textField_textColor = nil;
    
#pragma mark - TransferStep1ViewController
    transferStep1ViewController_lblYourbalance_textColor = nil;
    transferStep1ViewController_lblBalance_textColor = nil;
    transferStep1ViewController_searchContactButton_backgroundColor = nil;
    transferStep1ViewController_validateButton_backgroundColor = nil;
    transferStep1ViewController_commentButton_backgroundColor = nil;
    transferStep1ViewController_viewMail_backgroundColor = nil;
    transferStep1ViewController_toLabel_textColor = nil;
    transferStep1ViewController_mailTextField_textColor = nil;
    transferStep1ViewController_toLabel_after_textColor = nil;
    transferStep1ViewController_mailTextField_after_textColor = nil;
    transferStep1ViewController_searchFriendMailLabel_backgroundColor = nil;
    transferStep1ViewController_viewSearchContact_backgroundColor = nil;
    transferStep1ViewController_searchContactButton_highlighted_backgroundColor = nil;
    transferStep1ViewController_validateButton_highlighted_backgroundColor = nil;
    
#pragma mark - ResponseCell
    responseCell_bgView_backgroundColor = nil;
    
#pragma mark - CountryCell
    countryCell_bgView_backgroundColor = nil;
    
#pragma mark - HistoryDetailCell
    historyDetailCell_indicatorColorView_pending_backgroundColor = nil;
    historyDetailCell_lblAmount_pending_textColor = nil;
    historyDetailCell_indicatorColorView_credit_backgroundColor = nil;
    historyDetailCell_lblAmount_credit_textColor = nil;
    historyDetailCell_indicatorColorView_debit_backgroundColor = nil;
    historyDetailCell_lblAmount_debit_textColor = nil;
    historyDetailCell_contentView_refused_backgroundColor = nil;
    historyDetailCell_contentView_canceled_backgroundColor = nil;
    historyDetailCell_pendingCreditorAcceptButton_backgroundColor = nil;
    historyDetailCell_pendingCreditorCancelButton_backgroundColor = nil;
    historyDetailCell_pendingDebitorCancelButton_backgroundColor = nil;
    historyDetailCell_pendingCreditorActionView_backgroundColor = nil;
    historyDetailCell_pendingDebitorActionView_backgroundColor = nil;
    historyDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor = nil;
    historyDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor = nil;
    historyDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor = nil;
    
#pragma mark - SuscribeTextViewCell
    suscribeTextViewCell_textField_textColor = nil;
    suscribeTextViewCell_textField_placeHolderColor = nil;
    suscribeTextViewCell_lbl_textColor = nil;
    
#pragma mark - SuscribeTextViewCellSegment
    suscribeTextViewCellSegment_segmentedControl_tintColor = nil;
    
#pragma mark - SuscribeTextViewCellPicker
    suscribeTextViewCellPicker_textField_backgroundColor = nil;
    
#pragma mark - RegisterUserViewController
    registerUserViewController_lblSubNavigation_textColor = nil;
    registerUserViewController_viewHeader_backgroundColor = nil;
    
#pragma mark - CustomTabBarViewController_btnPay_riddleColor
    customTabBarViewController_btnPay_riddleColor = nil;
    
#pragma mark - ProgramTableViewCell
    programTableViewCell_lblProgramName_odd_textColor = nil;
    programTableViewCell_lblProgramName_odd_backgroundColor = nil;
    programTableViewCell_lblMerchantName_odd_textColor = nil;
    programTableViewCell_lblMerchantName_odd_backgroundColor = nil;
    programTableViewCell_contentView_even_backgroundColor = nil;
    programTableViewCell_lblProgramName_even_textColor = nil;
    programTableViewCell_lblProgramName_even_backgroundColor = nil;
    programTableViewCell_lblMerchantName_even_textColor = nil;
    programTableViewCell_lblMerchantName_even_backgroundColor = nil;
    programTableViewCell_imageCoupons_even_bacgroundColor = nil;
    programTableViewCell_imageLogo_even_backgroundColor = nil;
    programTableViewCell_lblNumberOfCoupons_even_backgroundColor = nil;
    programTableViewCell_lblAmountOfACoupons_even_backgroundColor = nil;
    programTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor = nil;
    programTableViewCell_viewIndicationsCoupons_even_backgroundColor = nil;
    
#pragma mark - HistoryViewController
    historyViewController_allButton_borderColor = nil;
    historyViewController_allButton_backgroundColor = nil;
    historyViewController_outputButton_titleColor = nil;
    historyViewController_outputButton_borderColor = nil;
    historyViewController_inputButton_titleColor = nil;
    historyViewController_inputButton_borderColor = nil;
    historyViewController_pendingButton_titleColor = nil;
    historyViewController_pendingButton_borderColor = nil;
    historyViewController_contentView_backgroundColor = nil;
    historyViewController_header_backgroundColor = nil;
    
#pragma mark - TransferReceiveStep1ViewController
    transferReceiveStep1ViewController_lblYourBalance_textColor = nil;
    transferReceiveStep1ViewController_lblBalance_textColor = nil;
    transferReceiveStep1ViewController_header_backgroundColor = nil;
    transferReceiveStep1ViewController_viewDescription_backgroundColor = nil;
    transferReceiveStep1ViewController_lblAmount_textColor = nil;
    transferReceiveStep1ViewController_lblCurrencyBefore_textColor = nil;
    transferReceiveStep1ViewController_amountTextField_textColor = nil;
    transferReceiveStep1ViewController_lblCurrencyAfter_textColor = nil;
    transferReceiveStep1ViewController_lblDescription_textColor = nil;
    
#pragma mark - TransferReceiveStep2ViewController
    transferReceiveStep2ViewController_header_backgroundColor = nil;
    
#pragma mark - ValidatorViewController
    validatorViewController_view_backgroundColor = nil;
    validatorViewController_btnSecond_borderColor = nil;
    validatorViewController_lblFirst_mode1_textColor = nil;
    validatorViewController_btnFirst_mode1_backgroundColor = nil;
    validatorViewController_btnFirst_mode1_highlighted_backgroundColor = nil;
    validatorViewController_btnFirst_mode1_titleColor = nil;
    validatorViewController_btnFirst_mode1_highlighted_titleColor = nil;
    validatorViewController_lblFirst_mode2_textColor = nil;
    validatorViewController_btnFirst_mode2_backgroundColor = nil;
    validatorViewController_btnFirst_mode2_titleColor = nil;
    validatorViewController_btnSecond_mode2_titleColor = nil;
    validatorViewController_btnSecond_mode2_backgroundColor = nil;
    validatorViewController_lblFirst_mode3_textColor = nil;
    validatorViewController_btnFirst_mode3_backgroundColor = nil;
    validatorViewController_btnFirst_mode3_titleColor = nil;
    validatorViewController_btnSecond_mode3_titleColor = nil;
    validatorViewController_btnSecond_mode3_backgroundColor = nil;
    validatorViewController_btnSecond_mode2_highlighted_backgroundColor = nil;
    validatorViewController_btnSecond_mode2_highlighted_titleColor = nil;
    validatorViewController_btnFirst_mode3_highlighted_backgroundColor = nil;
    validatorViewController_btnFirst_mode3_highlighted_titleColor = nil;
    validatorViewController_btnSecond_mode3_highlighted_titleColor = nil;
    validatorViewController_btnSecond_mode3_highlighted_backgroundColor = nil;
    
#pragma mark - InitialViewController
    initialViewController_viewMiddle_backgroundColor = nil;
    initialViewController_viewBottom_backgroundColor = nil;
    initialViewController_btnCreateAccount_backgroundColor = nil;
    initialViewController_btnCreateAccount_highlighted_backgroundColor = nil;
    initialViewController_btnLogin_titleColor = nil;
    initialViewController_btnCreateAccount_highlighted_titleColor = nil;
    
#pragma mark - PaymentViewController
    paymentViewController_viewBackgroundSetUserInfos_backgroundColor = nil;
    paymentViewController_btnSetUserInfos_backgroundColor = nil;
    paymentViewController_viewBackgroundAddCreditCard_backgroundColor = nil;
    paymentViewController_btnAddCreditCard_backgroundColor = nil;
    
#pragma mark - YourLoyaltyProgramsViewController
    yourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor = nil;
    
#pragma mark - YourLoyaltyProgramDetailsViewController
    yourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor = nil;
    
#pragma mark - LoyaltyProgramDetailsViewController
    loyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor = nil;
    
#pragma mark - RegisterResponseViewController
    registerResponseViewController_btnValidate_backgroundColor = nil;
    registerResponseViewController_viewValidate_backgroundColor = nil;
    registerResponseViewController_btnValidate_titleColor = nil;
    registerResponseViewController_btnValidate_highlighted_titleColor = nil;
    registerResponseViewController_btnValidate_highlighted_backgroundColor = nil;
    registerResponseViewController_viewBottom_unvalid_backgroundColor = nil;
    registerResponseViewController_btnValidate_unvalid_backgroundColor = nil;
    registerResponseViewController_btnValidate_unvalid_titleColor = nil;
    registerResponseViewController_textfield_placeholderColor = nil;
    registerResponseViewController_textField_textColor = nil;
    
#pragma mark - RegisterCaptchaViewController
    registerCaptchaViewController_btnValidate_bacgroundColor = nil;
    registerCaptchaViewController_viewBottom_bacgroundColor = nil;
    
#pragma mark - TransferHomeViewController
    transferHomeViewController_lblReceive_textColor = nil;
    transferHomeViewController_lblSend_textColor = nil;
    
#pragma mark - ForgottenPasswordSendMailViewController
    forgottenPasswordSendMailViewController_viewSubNavigation_backgroundColor = nil;
    forgottenPasswordSendMailViewController_lblSubNavigation_textColor = nil;
    forgottenPasswordSendMailViewController_viewBottom_backgroundColor = nil;
    forgottenPasswordSendMailViewController_btnValidate_titleColor = nil;
    forgottenPasswordSendMailViewController_btnValidate_backgroundColor = nil;
    forgottenPasswordSendMailViewController_viewBottom_valid_backgroundColor = nil;
    forgottenPasswordSendMailViewController_btnValidate_valid_titleColor = nil;
    forgottenPasswordSendMailViewController_btnValidate_valid_backgroundColor = nil;
    
#pragma mark - ForgottenPasswordSecretAnswerViewController
    forgottenPasswordSecretAnswerViewController_viewNavigation_backgroundColor = nil;
    forgottenPasswordSecretAnswerViewController_lblNavigation_textColor = nil;
    forgottenPasswordSecretAnswerViewController_viewQuestion_backgroundColor = nil;
    forgottenPasswordSecretAnswerViewController_lblQuestion_textColor = nil;
    forgottenPasswordSecretAnswerViewController_viewBottom_backgroundColor = nil;
    forgottenPasswordSecretAnswerViewController_btnValidate_backgroundColor = nil;
    forgottenPasswordSecretAnswerViewController_viewBottom_valid_backgroundColor = nil;
    forgottenPasswordSecretAnswerViewController_btnValidate_valid_backgroundColor = nil;
    forgottenPasswordSecretAnswerViewController_viewBottom_bad_backgroundColor = nil;
    forgottenPasswordSecretAnswerViewController_btnValidate_bad_backgroundColor = nil;
    
#pragma mark - ForgottenPasswordNewPasswordViewController
    forgottenPasswordNewPasswordViewController_viewNavigation_backgroundColor = nil;
    forgottenPasswordNewPasswordViewController_lblNavigation_textColor = nil;
    forgottenPasswordNewPasswordViewController_viewInstructions_backgroundColor = nil;
    forgottenPasswordNewPasswordViewController_lblInstructions_textColor = nil;
    forgottenPasswordNewPasswordViewController_viewBottom_backgroundColor = nil;
    forgottenPasswordNewPasswordViewController_btnValidate_backgroundColor = nil;
    forgottenPasswordNewPasswordViewController_viewBottom_valid_backgroundColor = nil;
    forgottenPasswordNewPasswordViewController_btnValidate_valid_backgroundColor = nil;
    
#pragma mark - AccountBannerViewController
    accountBannerViewController_lblYourBalance_textColor = nil;
    accountBannerViewController_lblCurrentBalance_textColor = nil;
}

-(void)loadTemplate:(FZDefaultTemplateColor*)aTemplate {
    
    blackColor = [[aTemplate blackColor]retain];
    whiteColor = [[aTemplate whiteColor]retain];
    mainOneColor = [[aTemplate mainOneColor]retain];
    mainTwoColor = [[aTemplate mainTwoColor]retain];
    mainThreeColor = [[aTemplate mainThreeColor]retain];
    transferOneColor = [[aTemplate transferOneColor]retain];
    transferTwoColor = [[aTemplate transferTwoColor]retain];
    rewardsOneColor = [[aTemplate rewardsOneColor]retain];
    rewardsThreeColor = [[aTemplate rewardsThreeColor]retain];
    monochromeOneColor = [[aTemplate monochromeOneColor]retain];
    monochromeTwoColor = [[aTemplate monochromeTwoColor]retain];
    monochromeThreeColor = [[aTemplate monochromeThreeColor]retain];
    
#pragma mark - PaymentTopupViewController
    paymentTopupViewController_lblAutomaticRefill_textColor = [[aTemplate paymentTopupViewController_lblAutomaticRefill_textColor]retain];
    paymentTopupViewController_autoButton_titleColor = [[aTemplate paymentTopupViewController_autoButton_titleColor]retain];
    paymentTopupViewController_aButton_titleColor = [[aTemplate paymentTopupViewController_aButton_titleColor]retain];
    paymentTopupViewController_viewChooseCard_backgroundColor = [[aTemplate paymentTopupViewController_viewChooseCard_backgroundColor]retain];
    paymentTopupViewController_viewRefill_backgroundColor = [[aTemplate paymentTopupViewController_viewRefill_backgroundColor]retain];
    paymentTopupViewController_refillButton_backgroundColor = [[aTemplate paymentTopupViewController_refillButton_backgroundColor]retain];
    paymentTopupViewController_autoButton_backgroundColor = [[aTemplate paymentTopupViewController_autoButton_backgroundColor]retain];
    paymentTopupViewController_creditCardButton_backgroundColor = [[aTemplate paymentTopupViewController_creditCardButton_backgroundColor]retain];
    paymentTopupViewController_viewAutomaticRefill_backgroundColor = [[aTemplate paymentTopupViewController_viewAutomaticRefill_backgroundColor]retain];
    paymentTopupViewController_header_backgroundColor = [[aTemplate paymentTopupViewController_header_backgroundColor]retain];
    paymentTopupViewController_lblAmount_textColor = [[aTemplate paymentTopupViewController_lblAmount_textColor]retain];
    paymentTopupViewController_viewChooseCard_selected_backgroundColor = [[aTemplate paymentTopupViewController_viewChooseCard_selected_backgroundColor]retain];
    paymentTopupViewController_creditCardButton_selected_titleColor = [[aTemplate paymentTopupViewController_creditCardButton_selected_titleColor]retain];
    paymentTopupViewController_refillButton_highlighted_backgroundColor = [[aTemplate paymentTopupViewController_refillButton_highlighted_backgroundColor]retain];
    paymentTopupViewController_refillButton_titleColor = [[aTemplate paymentTopupViewController_refillButton_titleColor]retain];
    paymentTopupViewController_refillButton_highlighted_titleColor = [[aTemplate paymentTopupViewController_refillButton_highlighted_titleColor]retain];
    paymentTopupViewController_refillButton_unvalid_titleColor = [[aTemplate paymentTopupViewController_refillButton_unvalid_titleColor]retain];
    paymentTopupViewController_refillButton_unvalid_backgroundColor = [[aTemplate paymentTopupViewController_refillButton_unvalid_backgroundColor]retain];
    paymentTopupViewController_creditCardButton_selected_backgroundColor = [[aTemplate paymentTopupViewController_creditCardButton_selected_backgroundColor]retain];
    paymentTopupViewController_viewRefill_unvalid_backgroundColor = [[aTemplate paymentTopupViewController_viewRefill_unvalid_backgroundColor]retain];
    
#pragma mark - CardListViewController
    cardListViewController_backgroundColor = [[aTemplate cardListViewController_backgroundColor]retain];
    cardListViewController_viewValidate_backgroundColor = [[aTemplate cardListViewController_viewValidate_backgroundColor]retain];
    cardListViewController_btnValidate_backgroundColor = [[aTemplate cardListViewController_btnValidate_backgroundColor]retain];
    cardListViewController_btnValidate_highlighted_backgroundColor = [[aTemplate cardListViewController_btnValidate_highlighted_backgroundColor]retain];
    cardListViewController_btnValidate_highlighted_textColor = [[aTemplate cardListViewController_btnValidate_highlighted_textColor]retain];
    
#pragma mark - BankAccountExpiredCell
    bankAccountExpiredCell_backgroundColor = [[aTemplate bankAccountExpiredCell_backgroundColor]retain];
    bankAccountExpiredCell_stringColor_backgroundColor = [[aTemplate bankAccountExpiredCell_stringColor_backgroundColor]retain];
    bankAccountExpiredCell_lblCardExpired_textColor = [[aTemplate bankAccountExpiredCell_lblCardExpired_textColor]retain];
    bankAccountExpiredCell_btnRight_titleColor = [[aTemplate bankAccountExpiredCell_btnRight_titleColor]retain];
    bankAccountExpiredCell_btnRight_borderColor = [[aTemplate bankAccountExpiredCell_btnRight_borderColor]retain];
    bankAccountExpiredCell_btnRight_backgroundColor = [[aTemplate bankAccountExpiredCell_btnRight_backgroundColor]retain];
    bankAccountExpiredCell_btnLeft_backgroundColor = [[aTemplate bankAccountExpiredCell_btnLeft_backgroundColor]retain];
    bankAccountExpiredCell_btnLeft_highlighted_titleColor = [[aTemplate bankAccountExpiredCell_btnLeft_highlighted_titleColor]retain];
    bankAccountExpiredCell_btnRight_highlighted_titleColor = [[aTemplate bankAccountExpiredCell_btnRight_highlighted_titleColor]retain];
    bankAccountExpiredCell_btnLeft_highlighted_backgroundColor = [[aTemplate bankAccountExpiredCell_btnLeft_highlighted_backgroundColor]retain];
    bankAccountExpiredCell_btnRight_highlighted_backgroundColor = [[aTemplate bankAccountExpiredCell_btnRight_highlighted_backgroundColor]retain];
    
#pragma mark - BankAccountCell
    bankAccountCell_stringColorEditionMode_backgroundColor = [[aTemplate bankAccountCell_stringColorEditionMode_backgroundColor]retain];
    bankAccountCell_stringColor_backgroundColor = [[aTemplate bankAccountCell_stringColor_backgroundColor]retain];
    bankAccountCell_lblCardNumber_textColor = [[aTemplate bankAccountCell_lblCardNumber_textColor]retain];
    bankAccountCell_lblCardExpired_textColor = [[aTemplate bankAccountCell_lblCardExpired_textColor]retain];
    
#pragma mark - ActionSuccessfulViewController
    actionSuccessfulViewController_fromCardList_backgroundColor = [[aTemplate actionSuccessfulViewController_fromCardList_backgroundColor]retain];
    actionSuccessfulViewController_fromTopUp_backgroundColor = [[aTemplate actionSuccessfulViewController_fromTopUp_backgroundColor]retain];
    
#pragma mark - MenuViewController
    menuViewController_btnLogOff_backgroundColor = [[aTemplate menuViewController_btnLogOff_backgroundColor]retain];
    menuViewController_viewLogout_backgroundColor = [[aTemplate menuViewController_viewLogout_backgroundColor]retain];
    menuViewController_tableview_inAccountListMode_backgroundColor = [[aTemplate menuViewController_tableview_inAccountListMode_backgroundColor]retain];
    menuViewController_tableview_inAccountListMode_separatorColor = [[aTemplate menuViewController_tableview_inAccountListMode_separatorColor]retain];
    menuViewController_tableview_backgroundColor = [[aTemplate menuViewController_tableview_backgroundColor]retain];
    menuViewController_tableview_separatorColor = [[aTemplate menuViewController_tableview_separatorColor]retain];
    
#pragma mark - MenuUserCellManagement
    menuUserCellManagement_myAccount_backgroundColor = [[aTemplate menuUserCellManagement_myAccount_backgroundColor]retain];
    menuUserCellManagement_myAccount_stringColor = [[aTemplate menuUserCellManagement_myAccount_stringColor]retain];
    menuUserCellManagement_home_stringColor = [[aTemplate menuUserCellManagement_home_stringColor]retain];
    menuUserCellManagement_refill_stringColor = [[aTemplate menuUserCellManagement_refill_stringColor]retain];
    menuUserCellManagement_myInformations_stringColor = [[aTemplate menuUserCellManagement_myInformations_stringColor]retain];
    menuUserCellManagement_myCards_stringColor = [[aTemplate menuUserCellManagement_myCards_stringColor]retain];
    menuUserCellManagement_security_stringColor = [[aTemplate menuUserCellManagement_security_stringColor]retain];
    menuUserCellManagement_verifyAccount_stringColor = [[aTemplate menuUserCellManagement_verifyAccount_stringColor]retain];
    
#pragma mark - MenuUserCell
    menuUserCell_backgroundColor = [[aTemplate menuUserCell_backgroundColor]retain];
    
#pragma mark - MenuSmallCell
    menuSmallCell_version_backgroundColor = [[aTemplate menuSmallCell_version_backgroundColor]retain];
    menuSmallCell_version_stringColor = [[aTemplate menuSmallCell_version_stringColor]retain];
    menuSmallCell_backgroundColor = [[aTemplate menuSmallCell_backgroundColor]retain];
    menuSmallCell_stringColor = [[aTemplate menuSmallCell_stringColor]retain];
    menuSmallCell_contentView_backgroundColor = [[aTemplate menuSmallCell_contentView_backgroundColor]retain];
    menuSmallCell_lbl_textColor = [[aTemplate menuSmallCell_lbl_textColor]retain];
    
#pragma mark - MenuBigCell
    menuBigCell_lbl_textColor = [[aTemplate menuBigCell_lbl_textColor]retain];
    
#pragma mark - TimeoutViewController
    timeoutViewController_aButton_titleColor = [[aTemplate timeoutViewController_aButton_titleColor]retain];
    timeoutViewController_viewChangePin_BackgroundColor = [[aTemplate timeoutViewController_viewChangePin_BackgroundColor]retain];
    timeoutViewController_changePinButton_BackgroundColor = [[aTemplate timeoutViewController_changePinButton_BackgroundColor]retain];
    timeoutViewController_header_backgroundColor = [[aTemplate timeoutViewController_header_backgroundColor]retain];
    timeoutViewController_changePinButton_highlighted_backgroundColor = [[aTemplate timeoutViewController_changePinButton_highlighted_backgroundColor]retain];
    timeoutViewController_changePinButton_titleColor = [[aTemplate timeoutViewController_changePinButton_titleColor]retain];
    timeoutViewController_changePinButton_highlighted_titleColor = [[aTemplate timeoutViewController_changePinButton_highlighted_titleColor]retain];
    timeoutViewController_timeoutTitleLabel_textColor = [[aTemplate timeoutViewController_timeoutTitleLabel_textColor]retain];
    timeoutViewController_timeoutDescriptionLabel_textColor = [[aTemplate timeoutViewController_timeoutDescriptionLabel_textColor]retain];
    
#pragma mark - TutorialViewController
    tutorialViewController_viewBottom_backgroundColor = [[aTemplate tutorialViewController_viewBottom_backgroundColor]retain];
    
#pragma mark - UserInformationViewController
    userInformationViewController_viewValidate_actived_backgroundColor = [[aTemplate userInformationViewController_viewValidate_actived_backgroundColor]retain];
    userInformationViewController_btnValidate_actived_titleColor = [[aTemplate userInformationViewController_btnValidate_actived_titleColor]retain];
    userInformationViewController_btnValidate_actived_backgroundColor = [[aTemplate userInformationViewController_btnValidate_actived_backgroundColor]retain];
    userInformationViewController_btnValidate_titleColor = [[aTemplate userInformationViewController_btnValidate_titleColor]retain];
    userInformationViewController_btnValidate_backgroundColor = [[aTemplate userInformationViewController_btnValidate_backgroundColor]retain];
    userInformationViewController_viewValidate_backgroundColor = [[aTemplate userInformationViewController_viewValidate_backgroundColor]retain];
    userInformationViewController_header_backgroundColor = [[aTemplate userInformationViewController_header_backgroundColor]retain];
    userInformationViewController_btnValidate_actived_highlighted_backgroundColor = [[aTemplate userInformationViewController_btnValidate_actived_highlighted_backgroundColor]retain];
    userInformationViewController_btnValidate_actived_highlighted_titleColor = [[aTemplate userInformationViewController_btnValidate_actived_highlighted_titleColor]retain];
    
#pragma mark - PaymentCheckViewController
    payButtonGradientOne = [[aTemplate payButtonGradientOne]retain];
    payButtonGradientTwo = [[aTemplate payButtonGradientTwo]retain];
    payButtonGradientThree = [[aTemplate payButtonGradientThree]retain];
    paymentCheckViewController_view_backgroundColor = [[aTemplate paymentCheckViewController_view_backgroundColor]retain];
    paymentCheckViewController_couponButton_titleColor = [[aTemplate paymentCheckViewController_couponButton_titleColor]retain];
    paymentCheckViewController_payButton_borderColor = [[aTemplate paymentCheckViewController_payButton_borderColor]retain];
    paymentCheckViewController_payButton_titleColor = [[aTemplate paymentCheckViewController_payButton_titleColor]retain];
    paymentCheckViewController_header_backgroundColor = [[aTemplate paymentCheckViewController_header_backgroundColor]retain];
    
#pragma mark - LoginViewController
    loginViewController_headerView_backgroundColor = [[aTemplate loginViewController_headerView_backgroundColor]retain];
    loginViewController_btnConnect_titleColor = [[aTemplate loginViewController_btnConnect_titleColor]retain];
    loginViewController_bottomView_backgroundColor = [[aTemplate loginViewController_bottomView_backgroundColor]retain];
    loginViewController_btnLogin_backgroundColor = [[aTemplate loginViewController_btnLogin_backgroundColor]retain];
    loginViewController_btnLogin_titleColor = [[aTemplate loginViewController_btnLogin_titleColor]retain];
    loginViewController_btnForgottenPassword_titleColor = [[aTemplate loginViewController_btnForgottenPassword_titleColor]retain];
    loginViewController_bottomView_valid_backgroundColor = [[aTemplate loginViewController_bottomView_valid_backgroundColor]retain];
    loginViewController_btnLogin_valid_backgroundColor = [[aTemplate loginViewController_btnLogin_valid_backgroundColor]retain];
    loginViewController_btnLogin_valid_titleColor = [[aTemplate loginViewController_btnLogin_valid_titleColor]retain];
    
#pragma mark - PinViewController
    pinViewController_colorThree = [[aTemplate pinViewController_colorThree]retain];
    pinViewController_textField_backgroundColor = [[aTemplate pinViewController_textField_backgroundColor]retain];
    pinViewController_textField_2_backgroundColor = [[aTemplate pinViewController_textField_2_backgroundColor]retain];
    pinViewController_gradient_top = [[aTemplate pinViewController_gradient_top]retain];
    pinViewController_gradient_bottom = [[aTemplate pinViewController_gradient_bottom]retain];
    
#pragma mark - PaymentViewController
    paymentViewController_header_backgroundColor = [[aTemplate paymentViewController_header_backgroundColor]retain];
    paymentViewController_btnSetUserInfos_highlighted_backgroundColor = [[aTemplate paymentViewController_btnSetUserInfos_highlighted_backgroundColor]retain];
    paymentViewController_btnAddCreditCard_highlighted_backgroundColor = [[aTemplate paymentViewController_btnAddCreditCard_highlighted_backgroundColor]retain];
    paymentViewController_btnSetUserInfos_titleColor = [[aTemplate paymentViewController_btnSetUserInfos_titleColor]retain];
    paymentViewController_btnSetUserInfos_highlighted_titleColor = [[aTemplate paymentViewController_btnSetUserInfos_highlighted_titleColor]retain];
    paymentViewController_btnAddCreditCard_titleColor = [[aTemplate paymentViewController_btnAddCreditCard_titleColor]retain];
    paymentViewController_btnAddCreditCard_highlighted_titleColor = [[aTemplate paymentViewController_btnAddCreditCard_highlighted_titleColor]retain];
    
#pragma mark - CountryViewController
    countryViewController_header_backgroundColor = [[aTemplate countryViewController_header_backgroundColor]retain];
    countryViewController_tableview_separatorColor = [[aTemplate countryViewController_tableview_separatorColor]retain];
    countryViewController_textFieldCountryName_placeHolderColor = [[aTemplate countryViewController_textFieldCountryName_placeHolderColor]retain];
    
#pragma mark - RegisterQuestionsViewController
    registerQuestionsViewController_tableview_separatorColor = [[aTemplate registerQuestionsViewController_tableview_separatorColor]retain];
    
#pragma mark - ActionSuccessfulAfterPaymentViewController
    actionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor = [[aTemplate actionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor]retain];
    
#pragma mark - RewardsHomeViewController
    rewardsHomeViewController_yourProgramsButton_backgroundColor = [[aTemplate rewardsHomeViewController_yourProgramsButton_backgroundColor]retain];
    rewardsHomeViewController_yourProgramsButton_selected_backgroundColor = [[aTemplate rewardsHomeViewController_yourProgramsButton_selected_backgroundColor]retain];
    rewardsHomeViewController_allProgramsButton_backgroundColor = [[aTemplate rewardsHomeViewController_allProgramsButton_backgroundColor]retain];
    rewardsHomeViewController_allProgramsButton_selected_backgroundColor = [[aTemplate rewardsHomeViewController_allProgramsButton_selected_backgroundColor]retain];
    rewardsHomeViewController_viewAccountBanner_textColor = [[aTemplate rewardsHomeViewController_viewAccountBanner_textColor]retain];
    
#pragma mark - LoginCell
    loginCell_textField_textColor = [[aTemplate loginCell_textField_textColor]retain];
    
#pragma mark - TransferStep1ViewController
    transferStep1ViewController_lblYourbalance_textColor = [[aTemplate transferStep1ViewController_lblYourbalance_textColor]retain];
    transferStep1ViewController_lblBalance_textColor = [[aTemplate transferStep1ViewController_lblBalance_textColor]retain];
    transferStep1ViewController_searchContactButton_backgroundColor = [[aTemplate transferStep1ViewController_searchContactButton_backgroundColor]retain];
    transferStep1ViewController_validateButton_backgroundColor = [[aTemplate transferStep1ViewController_validateButton_backgroundColor]retain];
    transferStep1ViewController_commentButton_backgroundColor = [[aTemplate transferStep1ViewController_commentButton_backgroundColor]retain];
    transferStep1ViewController_viewMail_backgroundColor = [[aTemplate transferStep1ViewController_viewMail_backgroundColor]retain];
    transferStep1ViewController_toLabel_textColor = [[aTemplate transferStep1ViewController_toLabel_textColor]retain];
    transferStep1ViewController_mailTextField_textColor = [[aTemplate transferStep1ViewController_mailTextField_textColor]retain];
    transferStep1ViewController_toLabel_after_textColor = [[aTemplate transferStep1ViewController_toLabel_after_textColor]retain];
    transferStep1ViewController_mailTextField_after_textColor = [[aTemplate transferStep1ViewController_mailTextField_after_textColor]retain];
    transferStep1ViewController_searchFriendMailLabel_backgroundColor = [[aTemplate transferStep1ViewController_searchFriendMailLabel_backgroundColor]retain];
    transferStep1ViewController_viewSearchContact_backgroundColor = [[aTemplate transferStep1ViewController_viewSearchContact_backgroundColor]retain];
    transferStep1ViewController_searchContactButton_highlighted_backgroundColor = [[aTemplate transferStep1ViewController_searchContactButton_highlighted_backgroundColor]retain];
    transferStep1ViewController_validateButton_highlighted_backgroundColor = [[aTemplate transferStep1ViewController_validateButton_highlighted_backgroundColor]retain];
    
#pragma mark - ResponseCell
    responseCell_bgView_backgroundColor = [[aTemplate responseCell_bgView_backgroundColor]retain];
    
#pragma mark - CountryCell
    countryCell_bgView_backgroundColor = [[aTemplate countryCell_bgView_backgroundColor]retain];
    
#pragma mark - HistoryDetailCell
    historyDetailCell_indicatorColorView_pending_backgroundColor = [[aTemplate historyDetailCell_indicatorColorView_pending_backgroundColor]retain];
    historyDetailCell_lblAmount_pending_textColor = [[aTemplate historyDetailCell_lblAmount_pending_textColor]retain];
    historyDetailCell_indicatorColorView_credit_backgroundColor = [[aTemplate historyDetailCell_indicatorColorView_credit_backgroundColor]retain];
    historyDetailCell_lblAmount_credit_textColor = [[aTemplate historyDetailCell_lblAmount_credit_textColor]retain];
    historyDetailCell_indicatorColorView_debit_backgroundColor = [[aTemplate historyDetailCell_indicatorColorView_debit_backgroundColor]retain];
    historyDetailCell_lblAmount_debit_textColor = [[aTemplate historyDetailCell_lblAmount_debit_textColor]retain];
    historyDetailCell_contentView_refused_backgroundColor = [[aTemplate historyDetailCell_contentView_refused_backgroundColor]retain];
    historyDetailCell_contentView_canceled_backgroundColor = [[aTemplate historyDetailCell_contentView_canceled_backgroundColor]retain];
    historyDetailCell_pendingCreditorAcceptButton_backgroundColor = [[aTemplate historyDetailCell_pendingCreditorAcceptButton_backgroundColor]retain];
    historyDetailCell_pendingCreditorCancelButton_backgroundColor = [[aTemplate historyDetailCell_pendingCreditorCancelButton_backgroundColor]retain];
    historyDetailCell_pendingDebitorCancelButton_backgroundColor = [[aTemplate historyDetailCell_pendingDebitorCancelButton_backgroundColor]retain];
    historyDetailCell_pendingCreditorActionView_backgroundColor = [[aTemplate historyDetailCell_pendingCreditorActionView_backgroundColor]retain];
    historyDetailCell_pendingDebitorActionView_backgroundColor = [[aTemplate historyDetailCell_pendingDebitorActionView_backgroundColor]retain];
    historyDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor = [[aTemplate historyDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor]retain];
    historyDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor = [[aTemplate historyDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor]retain];
    historyDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor = [[aTemplate historyDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor]retain];
    
#pragma mark - SuscribeTextViewCell
    suscribeTextViewCell_textField_textColor = [[aTemplate suscribeTextViewCell_textField_textColor]retain];
    suscribeTextViewCell_textField_placeHolderColor = [[aTemplate suscribeTextViewCell_textField_placeHolderColor]retain];
    suscribeTextViewCell_lbl_textColor = [[aTemplate suscribeTextViewCell_lbl_textColor]retain];
    
#pragma mark - SuscribeTextViewCellSegment
    suscribeTextViewCellSegment_segmentedControl_tintColor = [[aTemplate suscribeTextViewCellSegment_segmentedControl_tintColor]retain];
    
#pragma mark - SuscribeTextViewCellPicker
    suscribeTextViewCellPicker_textField_backgroundColor = [[aTemplate suscribeTextViewCellPicker_textField_backgroundColor]retain];
    
#pragma mark - RegisterUserViewController
    registerUserViewController_lblSubNavigation_textColor = [[aTemplate registerUserViewController_lblSubNavigation_textColor]retain];
    registerUserViewController_viewHeader_backgroundColor = [[aTemplate registerUserViewController_viewHeader_backgroundColor]retain];
    
#pragma mark - CustomTabBarViewController_btnPay_riddleColor
    customTabBarViewController_btnPay_riddleColor = [[aTemplate customTabBarViewController_btnPay_riddleColor]retain];
    
#pragma mark - ProgramTableViewCell
    programTableViewCell_lblProgramName_odd_textColor = [[aTemplate programTableViewCell_lblProgramName_odd_textColor]retain];
    programTableViewCell_lblProgramName_odd_backgroundColor = [[aTemplate programTableViewCell_lblProgramName_odd_backgroundColor]retain];
    programTableViewCell_lblMerchantName_odd_textColor = [[aTemplate programTableViewCell_lblMerchantName_odd_textColor]retain];
    programTableViewCell_lblMerchantName_odd_backgroundColor = [[aTemplate programTableViewCell_lblMerchantName_odd_backgroundColor]retain];
    programTableViewCell_contentView_even_backgroundColor = [[aTemplate programTableViewCell_contentView_even_backgroundColor]retain];
    programTableViewCell_lblProgramName_even_textColor = [[aTemplate programTableViewCell_lblProgramName_even_textColor]retain];
    programTableViewCell_lblProgramName_even_backgroundColor = [[aTemplate programTableViewCell_lblProgramName_even_backgroundColor]retain];
    programTableViewCell_lblMerchantName_even_textColor = [[aTemplate programTableViewCell_lblMerchantName_even_textColor]retain];
    programTableViewCell_lblMerchantName_even_backgroundColor = [[aTemplate programTableViewCell_lblMerchantName_even_backgroundColor]retain];
    programTableViewCell_imageCoupons_even_bacgroundColor = [[aTemplate programTableViewCell_imageCoupons_even_bacgroundColor]retain];
    programTableViewCell_imageLogo_even_backgroundColor = [[aTemplate programTableViewCell_imageLogo_even_backgroundColor]retain];
    programTableViewCell_lblNumberOfCoupons_even_backgroundColor = [[aTemplate programTableViewCell_lblNumberOfCoupons_even_backgroundColor]retain];
    programTableViewCell_lblAmountOfACoupons_even_backgroundColor = [[aTemplate programTableViewCell_lblAmountOfACoupons_even_backgroundColor]retain];
    programTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor = [[aTemplate programTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor]retain];
    programTableViewCell_viewIndicationsCoupons_even_backgroundColor = [[aTemplate programTableViewCell_viewIndicationsCoupons_even_backgroundColor]retain];
    
#pragma mark - HistoryViewController
    historyViewController_allButton_borderColor = [[aTemplate historyViewController_allButton_borderColor]retain];
    historyViewController_allButton_backgroundColor = [[aTemplate historyViewController_allButton_backgroundColor]retain];
    historyViewController_outputButton_titleColor = [[aTemplate historyViewController_outputButton_titleColor]retain];
    historyViewController_outputButton_borderColor = [[aTemplate historyViewController_outputButton_borderColor]retain];
    historyViewController_inputButton_titleColor = [[aTemplate historyViewController_inputButton_titleColor]retain];
    historyViewController_inputButton_borderColor = [[aTemplate historyViewController_inputButton_borderColor]retain];
    historyViewController_pendingButton_titleColor = [[aTemplate historyViewController_pendingButton_titleColor]retain];
    historyViewController_pendingButton_borderColor = [[aTemplate historyViewController_pendingButton_borderColor]retain];
    historyViewController_contentView_backgroundColor = [[aTemplate historyViewController_contentView_backgroundColor]retain];
    historyViewController_header_backgroundColor = [[aTemplate historyViewController_header_backgroundColor]retain];
    
#pragma mark - TransferReceiveStep1ViewController
    transferReceiveStep1ViewController_lblYourBalance_textColor = [[aTemplate transferReceiveStep1ViewController_lblYourBalance_textColor]retain];
    transferReceiveStep1ViewController_lblBalance_textColor = [[aTemplate transferReceiveStep1ViewController_lblBalance_textColor]retain];
    transferReceiveStep1ViewController_header_backgroundColor = [[aTemplate transferReceiveStep1ViewController_header_backgroundColor]retain];
    transferReceiveStep1ViewController_viewDescription_backgroundColor = [[aTemplate transferReceiveStep1ViewController_viewDescription_backgroundColor]retain];
    transferReceiveStep1ViewController_lblAmount_textColor = [[aTemplate transferReceiveStep1ViewController_lblAmount_textColor]retain];
    transferReceiveStep1ViewController_lblCurrencyBefore_textColor = [[aTemplate transferReceiveStep1ViewController_lblCurrencyBefore_textColor]retain];
    transferReceiveStep1ViewController_amountTextField_textColor = [[aTemplate transferReceiveStep1ViewController_amountTextField_textColor]retain];
    transferReceiveStep1ViewController_lblCurrencyAfter_textColor = [[aTemplate transferReceiveStep1ViewController_lblCurrencyAfter_textColor]retain];
    transferReceiveStep1ViewController_lblDescription_textColor = [[aTemplate transferReceiveStep1ViewController_lblDescription_textColor]retain];
    
#pragma mark - TransferReceiveStep2ViewController
    transferReceiveStep2ViewController_header_backgroundColor = [[aTemplate transferReceiveStep2ViewController_header_backgroundColor]retain];
    
#pragma mark - ValidatorViewController
    validatorViewController_view_backgroundColor = [[aTemplate validatorViewController_view_backgroundColor]retain];
    validatorViewController_btnSecond_borderColor = [[aTemplate validatorViewController_btnSecond_borderColor]retain];
    validatorViewController_lblFirst_mode1_textColor = [[aTemplate validatorViewController_lblFirst_mode1_textColor]retain];
    validatorViewController_btnFirst_mode1_backgroundColor = [[aTemplate validatorViewController_btnFirst_mode1_backgroundColor]retain];
    validatorViewController_btnFirst_mode1_titleColor = [[aTemplate validatorViewController_btnFirst_mode1_titleColor]retain];
    validatorViewController_btnFirst_mode1_highlighted_backgroundColor = [[aTemplate validatorViewController_btnFirst_mode1_highlighted_backgroundColor]retain];
    validatorViewController_btnFirst_mode1_highlighted_titleColor = [[aTemplate validatorViewController_btnFirst_mode1_highlighted_titleColor]retain];
    validatorViewController_lblFirst_mode2_textColor = [[aTemplate validatorViewController_lblFirst_mode2_textColor]retain];
    validatorViewController_btnFirst_mode2_backgroundColor = [[aTemplate validatorViewController_btnFirst_mode2_backgroundColor]retain];
    validatorViewController_btnFirst_mode2_titleColor = [[aTemplate validatorViewController_btnFirst_mode2_titleColor]retain];
    validatorViewController_btnSecond_mode2_titleColor = [[aTemplate validatorViewController_btnSecond_mode2_titleColor]retain];
    validatorViewController_btnSecond_mode2_backgroundColor = [[aTemplate validatorViewController_btnSecond_mode2_backgroundColor]retain];
    validatorViewController_lblFirst_mode3_textColor = [[aTemplate validatorViewController_lblFirst_mode3_textColor]retain];
    validatorViewController_btnFirst_mode3_backgroundColor = [[aTemplate validatorViewController_btnFirst_mode3_backgroundColor]retain];
    validatorViewController_btnFirst_mode3_titleColor = [[aTemplate validatorViewController_btnFirst_mode3_titleColor]retain];
    validatorViewController_btnSecond_mode3_titleColor = [[aTemplate validatorViewController_btnSecond_mode3_titleColor]retain];
    validatorViewController_btnSecond_mode3_backgroundColor = [[aTemplate validatorViewController_btnSecond_mode3_backgroundColor]retain];
    validatorViewController_btnSecond_mode2_highlighted_backgroundColor = [[aTemplate validatorViewController_btnSecond_mode2_highlighted_backgroundColor]retain];
    validatorViewController_btnSecond_mode2_highlighted_titleColor = [[aTemplate validatorViewController_btnSecond_mode2_highlighted_titleColor]retain];
    validatorViewController_btnFirst_mode3_highlighted_backgroundColor = [[aTemplate validatorViewController_btnFirst_mode3_highlighted_backgroundColor]retain];
    validatorViewController_btnFirst_mode3_highlighted_titleColor = [[aTemplate validatorViewController_btnFirst_mode3_highlighted_titleColor]retain];
    validatorViewController_btnSecond_mode3_highlighted_titleColor = [[aTemplate validatorViewController_btnSecond_mode3_highlighted_titleColor]retain];
    validatorViewController_btnSecond_mode3_highlighted_backgroundColor = [[aTemplate validatorViewController_btnSecond_mode3_highlighted_backgroundColor]retain];
    
#pragma mark - InitialViewController
    initialViewController_viewMiddle_backgroundColor = [[aTemplate initialViewController_viewMiddle_backgroundColor]retain];
    initialViewController_viewBottom_backgroundColor = [[aTemplate initialViewController_viewBottom_backgroundColor]retain];
    initialViewController_btnCreateAccount_backgroundColor = [[aTemplate initialViewController_btnCreateAccount_backgroundColor]retain];
    initialViewController_btnCreateAccount_highlighted_backgroundColor = [[aTemplate initialViewController_btnCreateAccount_highlighted_backgroundColor]retain];
    initialViewController_btnLogin_titleColor = [[aTemplate initialViewController_btnLogin_titleColor]retain];
    initialViewController_btnCreateAccount_highlighted_titleColor = [[aTemplate initialViewController_btnCreateAccount_highlighted_titleColor]retain];
    
#pragma mark - PaymentViewController
    paymentViewController_viewBackgroundSetUserInfos_backgroundColor = [[aTemplate paymentViewController_viewBackgroundSetUserInfos_backgroundColor]retain];
    paymentViewController_btnSetUserInfos_backgroundColor = [[aTemplate paymentViewController_btnSetUserInfos_backgroundColor]retain];
    paymentViewController_viewBackgroundAddCreditCard_backgroundColor = [[aTemplate paymentViewController_viewBackgroundAddCreditCard_backgroundColor]retain];
    paymentViewController_btnAddCreditCard_backgroundColor = [[aTemplate paymentViewController_btnAddCreditCard_backgroundColor]retain];
    
#pragma mark - YourLoyaltyProgramsViewController
    yourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor = [[aTemplate yourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor]retain];
    
#pragma mark - YourLoyaltyProgramDetailsViewController
    yourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor = [[aTemplate yourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor]retain];
    
#pragma mark - LoyaltyProgramDetailsViewController
    loyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor = [[aTemplate loyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor]retain];
    
#pragma mark - RegisterResponseViewController
    registerResponseViewController_btnValidate_backgroundColor = [[aTemplate registerResponseViewController_btnValidate_backgroundColor]retain];
    registerResponseViewController_viewValidate_backgroundColor = [[aTemplate registerResponseViewController_viewValidate_backgroundColor]retain];
    registerResponseViewController_btnValidate_titleColor = [[aTemplate registerResponseViewController_btnValidate_titleColor]retain];
    registerResponseViewController_btnValidate_highlighted_titleColor = [[aTemplate registerResponseViewController_btnValidate_highlighted_titleColor]retain];
    registerResponseViewController_btnValidate_highlighted_backgroundColor = [[aTemplate registerResponseViewController_btnValidate_highlighted_backgroundColor]retain];
    registerResponseViewController_viewBottom_unvalid_backgroundColor = [[aTemplate registerResponseViewController_viewBottom_unvalid_backgroundColor]retain];
    registerResponseViewController_btnValidate_unvalid_backgroundColor = [[aTemplate registerResponseViewController_btnValidate_unvalid_backgroundColor]retain];
    registerResponseViewController_btnValidate_unvalid_titleColor = [[aTemplate registerResponseViewController_btnValidate_unvalid_titleColor]retain];
    registerResponseViewController_textfield_placeholderColor = [[aTemplate registerResponseViewController_textfield_placeholderColor]retain];
    registerResponseViewController_textField_textColor = [[aTemplate registerResponseViewController_textField_textColor]retain];
    
#pragma mark - RegisterCaptchaViewController
    registerCaptchaViewController_btnValidate_bacgroundColor = [[aTemplate registerCaptchaViewController_btnValidate_bacgroundColor]retain];
    registerCaptchaViewController_viewBottom_bacgroundColor = [[aTemplate registerCaptchaViewController_viewBottom_bacgroundColor]retain];
    
#pragma mark - TransferHomeViewController
    transferHomeViewController_lblReceive_textColor = [[aTemplate transferHomeViewController_lblReceive_textColor]retain];
    transferHomeViewController_lblSend_textColor = [[aTemplate transferHomeViewController_lblSend_textColor]retain];
    
#pragma mark - ForgottenPasswordSendMailViewController
    forgottenPasswordSendMailViewController_viewSubNavigation_backgroundColor = [[aTemplate forgottenPasswordSendMailViewController_viewSubNavigation_backgroundColor]retain];
    forgottenPasswordSendMailViewController_lblSubNavigation_textColor = [[aTemplate forgottenPasswordSendMailViewController_lblSubNavigation_textColor]retain];
    forgottenPasswordSendMailViewController_viewBottom_backgroundColor = [[aTemplate forgottenPasswordSendMailViewController_viewBottom_backgroundColor]retain];
    forgottenPasswordSendMailViewController_btnValidate_titleColor = [[aTemplate forgottenPasswordSendMailViewController_btnValidate_titleColor]retain];
    forgottenPasswordSendMailViewController_btnValidate_backgroundColor = [[aTemplate forgottenPasswordSendMailViewController_btnValidate_backgroundColor]retain];
    forgottenPasswordSendMailViewController_viewBottom_valid_backgroundColor = [[aTemplate forgottenPasswordSendMailViewController_viewBottom_valid_backgroundColor]retain];
    forgottenPasswordSendMailViewController_btnValidate_valid_titleColor = [[aTemplate forgottenPasswordSendMailViewController_btnValidate_valid_titleColor]retain];
    forgottenPasswordSendMailViewController_btnValidate_valid_backgroundColor = [[aTemplate forgottenPasswordSendMailViewController_btnValidate_valid_backgroundColor]retain];
    
#pragma mark - ForgottenPasswordSecretAnswerViewController
    forgottenPasswordSecretAnswerViewController_viewNavigation_backgroundColor = [[aTemplate forgottenPasswordSecretAnswerViewController_viewNavigation_backgroundColor]retain];
    forgottenPasswordSecretAnswerViewController_lblNavigation_textColor = [[aTemplate forgottenPasswordSecretAnswerViewController_lblNavigation_textColor]retain];
    forgottenPasswordSecretAnswerViewController_viewQuestion_backgroundColor = [[aTemplate forgottenPasswordSecretAnswerViewController_viewQuestion_backgroundColor]retain];
    forgottenPasswordSecretAnswerViewController_lblQuestion_textColor = [[aTemplate forgottenPasswordSecretAnswerViewController_lblQuestion_textColor]retain];
    forgottenPasswordSecretAnswerViewController_viewBottom_backgroundColor = [[aTemplate forgottenPasswordSecretAnswerViewController_viewBottom_backgroundColor]retain];
    forgottenPasswordSecretAnswerViewController_btnValidate_backgroundColor = [[aTemplate forgottenPasswordSecretAnswerViewController_btnValidate_backgroundColor]retain];
    forgottenPasswordSecretAnswerViewController_viewBottom_valid_backgroundColor = [[aTemplate forgottenPasswordSecretAnswerViewController_viewBottom_valid_backgroundColor]retain];
    forgottenPasswordSecretAnswerViewController_btnValidate_valid_backgroundColor = [[aTemplate forgottenPasswordSecretAnswerViewController_btnValidate_valid_backgroundColor]retain];
    forgottenPasswordSecretAnswerViewController_viewBottom_bad_backgroundColor = [[aTemplate forgottenPasswordSecretAnswerViewController_viewBottom_bad_backgroundColor]retain];
    forgottenPasswordSecretAnswerViewController_btnValidate_bad_backgroundColor = [[aTemplate forgottenPasswordSecretAnswerViewController_btnValidate_bad_backgroundColor]retain];
    
#pragma mark - ForgottenPasswordNewPasswordViewController
    forgottenPasswordNewPasswordViewController_viewNavigation_backgroundColor = [[aTemplate forgottenPasswordNewPasswordViewController_viewNavigation_backgroundColor]retain];
    forgottenPasswordNewPasswordViewController_lblNavigation_textColor = [[aTemplate forgottenPasswordNewPasswordViewController_lblNavigation_textColor]retain];
    forgottenPasswordNewPasswordViewController_viewInstructions_backgroundColor = [[aTemplate forgottenPasswordNewPasswordViewController_viewInstructions_backgroundColor]retain];
    forgottenPasswordNewPasswordViewController_lblInstructions_textColor = [[aTemplate forgottenPasswordNewPasswordViewController_lblInstructions_textColor]retain];
    forgottenPasswordNewPasswordViewController_viewBottom_backgroundColor = [[aTemplate forgottenPasswordNewPasswordViewController_viewBottom_backgroundColor]retain];
    forgottenPasswordNewPasswordViewController_btnValidate_backgroundColor = [[aTemplate forgottenPasswordNewPasswordViewController_btnValidate_backgroundColor]retain];
    forgottenPasswordNewPasswordViewController_viewBottom_valid_backgroundColor = [[aTemplate forgottenPasswordNewPasswordViewController_viewBottom_valid_backgroundColor]retain];
    forgottenPasswordNewPasswordViewController_btnValidate_valid_backgroundColor = [[aTemplate forgottenPasswordNewPasswordViewController_btnValidate_valid_backgroundColor]retain];
    
#pragma mark - AccountBannerViewController
    accountBannerViewController_lblYourBalance_textColor = [[aTemplate accountBannerViewController_lblYourBalance_textColor]retain];
    accountBannerViewController_lblCurrentBalance_textColor = [[aTemplate accountBannerViewController_lblCurrentBalance_textColor]retain];
}

-(void)setBlack:(UIColor*)color
{
    blackColor = color;
}

-(void)setWhite:(UIColor*)color
{
    whiteColor = color;
}

#pragma mark - Colors from the guideline
- (UIColor *)blackColor {
	return blackColor;
}
- (UIColor *)blackColorWithAlpha:(CGFloat)alpha {
	return [blackColor colorWithAlphaComponent:alpha];
}
- (UIColor *)whiteColor {
	return whiteColor;
}
- (UIColor *)whiteColorWithAlpha:(CGFloat)alpha {
	return [whiteColor colorWithAlphaComponent:alpha];
}
- (UIColor *)mainOneColor {
	return mainOneColor;
}
- (UIColor *)mainTwoColor {
	return mainTwoColor;
}
- (UIColor *)mainThreeColor {
	return mainThreeColor;
}
- (UIColor *)transferOneColor {
	return transferOneColor;
}
- (UIColor *)transferTwoColor {
	return transferTwoColor;
}
- (UIColor *)rewardsOneColor {
	return rewardsOneColor;
}
- (UIColor *)rewardsThreeColor {
	return rewardsThreeColor;
}
- (UIColor *)monochromeOneColor {
	return monochromeOneColor;
}
- (UIColor *)monochromeTwoColor {
	return monochromeTwoColor;
}
- (UIColor *)monochromeThreeColor {
	return monochromeThreeColor;
}

#pragma mark - PaymentTopupViewController
- (UIColor *)paymentTopupViewController_lblAutomaticRefill_textColor {
	return paymentTopupViewController_lblAutomaticRefill_textColor;
}
- (UIColor *)paymentTopupViewController_autoButton_titleColor {
	return paymentTopupViewController_autoButton_titleColor;
}
- (UIColor *)paymentTopupViewController_aButton_titleColor {
	return paymentTopupViewController_aButton_titleColor;
}
- (UIColor *)paymentTopupViewController_viewChooseCard_backgroundColor {
	return paymentTopupViewController_viewChooseCard_backgroundColor;
}
- (UIColor *)paymentTopupViewController_viewRefill_backgroundColor {
	return paymentTopupViewController_viewRefill_backgroundColor;
}
- (UIColor *)paymentTopupViewController_refillButton_backgroundColor {
	return paymentTopupViewController_refillButton_backgroundColor;
}
- (UIColor *)paymentTopupViewController_autoButton_backgroundColor {
	return paymentTopupViewController_autoButton_backgroundColor;
}
- (UIColor *)paymentTopupViewController_creditCardButton_backgroundColor {
	return paymentTopupViewController_creditCardButton_backgroundColor;
}
- (UIColor *)paymentTopupViewController_viewAutomaticRefill_backgroundColor {
	return paymentTopupViewController_viewAutomaticRefill_backgroundColor;
}
- (UIColor *)paymentTopupViewController_header_backgroundColor {
	return paymentTopupViewController_header_backgroundColor;
}
- (UIColor *)paymentTopupViewController_lblAmount_textColor {
	return paymentTopupViewController_lblAmount_textColor;
}
- (UIColor *)paymentTopupViewController_viewChooseCard_selected_backgroundColor {
	return paymentTopupViewController_viewChooseCard_selected_backgroundColor;
}
- (UIColor *)paymentTopupViewController_creditCardButton_selected_titleColor {
	return paymentTopupViewController_creditCardButton_selected_titleColor;
}
- (UIColor *)paymentTopupViewController_refillButton_highlighted_backgroundColor {
	return paymentTopupViewController_refillButton_highlighted_backgroundColor;
}
- (UIColor *)paymentTopupViewController_refillButton_highlighted_titleColor {
	return paymentTopupViewController_refillButton_highlighted_titleColor;
}
- (UIColor *)paymentTopupViewController_refillButton_titleColor {
	return paymentTopupViewController_refillButton_titleColor;
}
- (UIColor *)paymentTopupViewController_refillButton_unvalid_titleColor {
	return paymentTopupViewController_refillButton_unvalid_titleColor;
}
- (UIColor *)paymentTopupViewController_refillButton_unvalid_backgroundColor {
	return paymentTopupViewController_refillButton_unvalid_backgroundColor;
}
- (UIColor *)paymentTopupViewController_creditCardButton_selected_backgroundColor {
	return paymentTopupViewController_creditCardButton_selected_backgroundColor;
}
- (UIColor *)paymentTopupViewController_viewRefill_unvalid_backgroundColor {
	return paymentTopupViewController_viewRefill_unvalid_backgroundColor;
}

#pragma mark - CardListViewController
- (UIColor *)cardListViewController_backgroundColor {
	return cardListViewController_backgroundColor;
}
- (UIColor *)cardListViewController_viewValidate_backgroundColor {
	return cardListViewController_viewValidate_backgroundColor;
}
- (UIColor *)cardListViewController_btnValidate_backgroundColor {
	return cardListViewController_btnValidate_backgroundColor;
}
- (UIColor *)cardListViewController_btnValidate_highlighted_backgroundColor {
	return cardListViewController_btnValidate_highlighted_backgroundColor;
}
- (UIColor *)cardListViewController_btnValidate_highlighted_textColor {
	return cardListViewController_btnValidate_highlighted_textColor;
}

#pragma mark - BankAccountExpiredCell
- (UIColor *)bankAccountExpiredCell_backgroundColor {
	return bankAccountExpiredCell_backgroundColor;
}
- (UIColor *)bankAccountExpiredCell_stringColor_backgroundColor {
	return bankAccountExpiredCell_stringColor_backgroundColor;
}
- (UIColor *)bankAccountExpiredCell_lblCardExpired_textColor {
	return bankAccountExpiredCell_lblCardExpired_textColor;
}
- (UIColor *)bankAccountExpiredCell_btnRight_titleColor {
	return bankAccountExpiredCell_btnRight_titleColor;
}
- (UIColor *)bankAccountExpiredCell_btnRight_borderColor {
	return bankAccountExpiredCell_btnRight_borderColor;
}
- (UIColor *)bankAccountExpiredCell_btnRight_backgroundColor {
	return bankAccountExpiredCell_btnRight_backgroundColor;
}
- (UIColor *)bankAccountExpiredCell_btnLeft_backgroundColor {
	return bankAccountExpiredCell_btnLeft_backgroundColor;
}
- (UIColor *)bankAccountExpiredCell_btnLeft_highlighted_titleColor {
	return bankAccountExpiredCell_btnLeft_highlighted_titleColor;
}
- (UIColor *)bankAccountExpiredCell_btnRight_highlighted_titleColor {
	return bankAccountExpiredCell_btnRight_highlighted_titleColor;
}
- (UIColor *)bankAccountExpiredCell_btnLeft_highlighted_backgroundColor {
	return bankAccountExpiredCell_btnLeft_highlighted_backgroundColor;
}
- (UIColor *)bankAccountExpiredCell_btnRight_highlighted_backgroundColor {
	return bankAccountExpiredCell_btnRight_highlighted_backgroundColor;
}

#pragma mark - BankAccountCell
- (UIColor *)bankAccountCell_stringColorEditionMode_backgroundColor {
	return bankAccountCell_stringColorEditionMode_backgroundColor;
}
- (UIColor *)bankAccountCell_stringColor_backgroundColor {
	return bankAccountCell_stringColor_backgroundColor;
}
- (UIColor *)bankAccountCell_lblCardNumber_textColor {
	return bankAccountCell_lblCardNumber_textColor;
}
- (UIColor *)bankAccountCell_lblCardExpired_textColor {
	return bankAccountCell_lblCardExpired_textColor;
}

#pragma mark - ActionSuccessfulViewController
- (UIColor *)actionSuccessfulViewController_fromCardList_backgroundColor {
	return actionSuccessfulViewController_fromCardList_backgroundColor;
}
- (UIColor *)actionSuccessfulViewController_fromTopUp_backgroundColor {
	return actionSuccessfulViewController_fromTopUp_backgroundColor;
}

#pragma mark - MenuViewController
- (UIColor *)menuViewController_btnLogOff_backgroundColor {
	return menuViewController_btnLogOff_backgroundColor;
}
- (UIColor *)menuViewController_viewLogout_backgroundColor {
	return menuViewController_viewLogout_backgroundColor;
}
- (UIColor *)menuViewController_tableview_inAccountListMode_backgroundColor {
	return menuViewController_tableview_inAccountListMode_backgroundColor;
}
- (UIColor *)menuViewController_tableview_inAccountListMode_separatorColor {
	return menuViewController_tableview_inAccountListMode_separatorColor;
}
- (UIColor *)menuViewController_tableview_backgroundColor {
	return menuViewController_tableview_backgroundColor;
}
- (UIColor *)menuViewController_tableview_separatorColor {
	return menuViewController_tableview_separatorColor;
}

#pragma mark - MenuUserCellManagement
- (UIColor *)menuUserCellManagement_myAccount_backgroundColor {
	return menuUserCellManagement_myAccount_backgroundColor;
}
- (UIColor *)menuUserCellManagement_myAccount_stringColor {
	return menuUserCellManagement_myAccount_stringColor;
}
- (UIColor *)menuUserCellManagement_home_stringColor {
	return menuUserCellManagement_home_stringColor;
}
- (UIColor *)menuUserCellManagement_refill_stringColor {
	return menuUserCellManagement_refill_stringColor;
}
- (UIColor *)menuUserCellManagement_myInformations_stringColor {
	return menuUserCellManagement_myInformations_stringColor;
}
- (UIColor *)menuUserCellManagement_myCards_stringColor {
	return menuUserCellManagement_myCards_stringColor;
}
- (UIColor *)menuUserCellManagement_security_stringColor {
	return menuUserCellManagement_security_stringColor;
}
- (UIColor *)menuUserCellManagement_verifyAccount_stringColor {
	return menuUserCellManagement_verifyAccount_stringColor;
}

#pragma mark - MenuUserCell
- (UIColor *)menuUserCell_backgroundColor {
	return menuUserCell_backgroundColor;
}

#pragma mark - MenuSmallCell
- (UIColor *)menuSmallCell_version_backgroundColor {
	return menuSmallCell_version_backgroundColor;
}
- (UIColor *)menuSmallCell_version_stringColor {
	return menuSmallCell_version_stringColor;
}
- (UIColor *)menuSmallCell_backgroundColor {
	return menuSmallCell_backgroundColor;
}
- (UIColor *)menuSmallCell_stringColor {
	return menuSmallCell_stringColor;
}
- (UIColor *)menuSmallCell_contentView_backgroundColor {
	return menuSmallCell_contentView_backgroundColor;
}
- (UIColor *)menuSmallCell_lbl_textColor {
	return menuSmallCell_lbl_textColor;
}

#pragma mark - MenuBigCell
- (UIColor *)menuBigCell_lbl_textColor {
	return menuBigCell_lbl_textColor;
}

#pragma mark - TimeoutViewController
- (UIColor *)timeoutViewController_aButton_titleColor {
	return timeoutViewController_aButton_titleColor;
}
- (UIColor *)timeoutViewController_viewChangePin_BackgroundColor {
	return timeoutViewController_viewChangePin_BackgroundColor;
}
- (UIColor *)timeoutViewController_changePinButton_BackgroundColor {
	return timeoutViewController_changePinButton_BackgroundColor;
}
- (UIColor *)timeoutViewController_header_backgroundColor {
	return timeoutViewController_header_backgroundColor;
}
- (UIColor *)timeoutViewController_changePinButton_highlighted_backgroundColor {
	return timeoutViewController_changePinButton_highlighted_backgroundColor;
}
- (UIColor *)timeoutViewController_changePinButton_titleColor {
	return timeoutViewController_changePinButton_titleColor;
}
- (UIColor *)timeoutViewController_changePinButton_highlighted_titleColor {
	return timeoutViewController_changePinButton_highlighted_titleColor;
}
- (UIColor *)timeoutViewController_timeoutTitleLabel_textColor {
	return timeoutViewController_timeoutTitleLabel_textColor;
}
- (UIColor *)timeoutViewController_timeoutDescriptionLabel_textColor {
	return timeoutViewController_timeoutDescriptionLabel_textColor;
}

#pragma mark - TutorialViewController
- (UIColor *)tutorialViewController_viewBottom_backgroundColor {
	return tutorialViewController_viewBottom_backgroundColor;
}

#pragma mark - UserInformationViewController
- (UIColor *)userInformationViewController_viewValidate_actived_backgroundColor {
	return userInformationViewController_viewValidate_actived_backgroundColor;
}
- (UIColor *)userInformationViewController_btnValidate_actived_titleColor {
	return userInformationViewController_btnValidate_actived_titleColor;
}
- (UIColor *)userInformationViewController_btnValidate_actived_backgroundColor {
	return userInformationViewController_btnValidate_actived_backgroundColor;
}
- (UIColor *)userInformationViewController_btnValidate_titleColor {
	return userInformationViewController_btnValidate_titleColor;
}
- (UIColor *)userInformationViewController_btnValidate_backgroundColor {
	return userInformationViewController_btnValidate_backgroundColor;
}
- (UIColor *)userInformationViewController_viewValidate_backgroundColor {
	return userInformationViewController_viewValidate_backgroundColor;
}
- (UIColor *)userInformationViewController_header_backgroundColor {
	return userInformationViewController_header_backgroundColor;
}
- (UIColor *)userInformationViewController_btnValidate_actived_highlighted_backgroundColor {
	return userInformationViewController_btnValidate_actived_highlighted_backgroundColor;
}
- (UIColor *)userInformationViewController_btnValidate_actived_highlighted_titleColor {
	return userInformationViewController_btnValidate_actived_highlighted_titleColor;
}

#pragma mark - PaymentCheckViewController
- (UIColor *)payButtonGradientOne {
	return payButtonGradientOne;
}

- (UIColor *)payButtonGradientTwo {
	return payButtonGradientTwo ;
}

- (UIColor *)payButtonGradientTwoWithAlpha:(CGFloat)alpha {
	return [payButtonGradientTwo colorWithAlphaComponent:alpha];
}
- (UIColor *)payButtonGradientThree {
	return payButtonGradientThree;
}
- (UIColor *)paymentCheckViewController_view_backgroundColor {
	return paymentCheckViewController_view_backgroundColor;
}
- (UIColor *)paymentCheckViewController_couponButton_titleColor {
	return paymentCheckViewController_couponButton_titleColor;
}
- (UIColor *)paymentCheckViewController_payButton_borderColor {
	return paymentCheckViewController_payButton_borderColor;
}
- (UIColor *)paymentCheckViewController_payButton_titleColor {
	return paymentCheckViewController_payButton_titleColor;
}
- (UIColor *)paymentCheckViewController_header_backgroundColor {
	return paymentCheckViewController_header_backgroundColor;
}

#pragma mark - LoginViewController
- (UIColor *)loginViewController_headerView_backgroundColor {
	return loginViewController_headerView_backgroundColor;
}
- (UIColor *)loginViewController_bottomView_backgroundColor {
	return loginViewController_bottomView_backgroundColor;
}
- (UIColor *)loginViewController_btnLogin_backgroundColor {
	return loginViewController_btnLogin_backgroundColor;
}
- (UIColor *)loginViewController_btnLogin_titleColor {
	return loginViewController_btnLogin_titleColor;
}
- (UIColor *)loginViewController_btnConnect_titleColor {
	return loginViewController_btnConnect_titleColor;
}
- (UIColor *)loginViewController_btnForgottenPassword_titleColor {
	return loginViewController_btnForgottenPassword_titleColor;
}
- (UIColor *)loginViewController_bottomView_valid_backgroundColor {
	return loginViewController_bottomView_valid_backgroundColor;
}
- (UIColor *)loginViewController_btnLogin_valid_backgroundColor {
	return loginViewController_btnLogin_valid_backgroundColor;
}
- (UIColor *)loginViewController_btnLogin_valid_titleColor {
	return loginViewController_btnLogin_valid_titleColor;
}

#pragma mark - PinViewController
- (UIColor *)pinViewController_colorThree {
	return pinViewController_colorThree
    ;
}
- (UIColor *)pinViewController_textField_backgroundColor {
	return pinViewController_textField_backgroundColor;
}
- (UIColor *)pinViewController_textField_2_backgroundColor {
	return pinViewController_textField_2_backgroundColor;
}
- (UIColor *)pinViewController_gradient_top {
	return pinViewController_gradient_top;
}
- (UIColor *)pinViewController_gradient_bottom {
	return pinViewController_gradient_bottom;
}

#pragma mark - PaymentViewController
- (UIColor *)paymentViewController_header_backgroundColor {
	return paymentViewController_header_backgroundColor;
}
- (UIColor *)paymentViewController_btnSetUserInfos_highlighted_backgroundColor {
	return paymentViewController_btnSetUserInfos_highlighted_backgroundColor;
}
- (UIColor *)paymentViewController_btnAddCreditCard_highlighted_backgroundColor {
	return paymentViewController_btnAddCreditCard_highlighted_backgroundColor;
}
- (UIColor *)paymentViewController_btnSetUserInfos_titleColor {
	return paymentViewController_btnSetUserInfos_titleColor;
}
- (UIColor *)paymentViewController_btnSetUserInfos_highlighted_titleColor {
	return paymentViewController_btnSetUserInfos_highlighted_titleColor;
}
- (UIColor *)paymentViewController_btnAddCreditCard_titleColor {
	return paymentViewController_btnAddCreditCard_titleColor;
}
- (UIColor *)paymentViewController_btnAddCreditCard_highlighted_titleColor {
	return paymentViewController_btnAddCreditCard_highlighted_titleColor;
}

#pragma mark - CountryViewController
- (UIColor *)countryViewController_header_backgroundColor {
	return countryViewController_header_backgroundColor;
}
- (UIColor *)countryViewController_tableview_separatorColor {
	return countryViewController_tableview_separatorColor;
}
- (UIColor *)countryViewController_textFieldCountryName_placeHolderColor {
	return countryViewController_textFieldCountryName_placeHolderColor;
}

#pragma mark - RegisterQuestionsViewController
- (UIColor *)registerQuestionsViewController_tableview_separatorColor {
	return registerQuestionsViewController_tableview_separatorColor;
}

#pragma mark - ActionSuccessfulAfterPaymentViewController
- (UIColor *)actionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor {
	return actionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor;
}

#pragma mark - RewardsHomeViewController
- (UIColor *)rewardsHomeViewController_yourProgramsButton_backgroundColor {
	return rewardsHomeViewController_yourProgramsButton_backgroundColor;
}
- (UIColor *)rewardsHomeViewController_yourProgramsButton_selected_backgroundColor {
	return rewardsHomeViewController_yourProgramsButton_selected_backgroundColor;
}
- (UIColor *)rewardsHomeViewController_allProgramsButton_backgroundColor {
	return rewardsHomeViewController_allProgramsButton_backgroundColor;
}
- (UIColor *)rewardsHomeViewController_allProgramsButton_selected_backgroundColor {
	return rewardsHomeViewController_allProgramsButton_selected_backgroundColor;
}
- (UIColor *)rewardsHomeViewController_viewAccountBanner_textColor {
	return rewardsHomeViewController_viewAccountBanner_textColor;
}

#pragma mark - LoginCell
- (UIColor *)loginCell_textField_textColor {
	return loginCell_textField_textColor;
}

#pragma mark - TransferStep1ViewController
- (UIColor *)transferStep1ViewController_lblYourbalance_textColor {
	return transferStep1ViewController_lblYourbalance_textColor;
}
- (UIColor *)transferStep1ViewController_lblBalance_textColor {
	return transferStep1ViewController_lblBalance_textColor;
}
- (UIColor *)transferStep1ViewController_searchContactButton_backgroundColor {
	return transferStep1ViewController_searchContactButton_backgroundColor;
}
- (UIColor *)transferStep1ViewController_validateButton_backgroundColor {
	return transferStep1ViewController_validateButton_backgroundColor;
}
- (UIColor *)transferStep1ViewController_commentButton_backgroundColor {
	return transferStep1ViewController_validateButton_backgroundColor;
}
- (UIColor *)transferStep1ViewController_viewMail_backgroundColor {
	return transferStep1ViewController_viewMail_backgroundColor;
}
- (UIColor *)transferStep1ViewController_toLabel_textColor {
	return transferStep1ViewController_toLabel_textColor;
}
- (UIColor *)transferStep1ViewController_mailTextField_textColor {
	return transferStep1ViewController_mailTextField_textColor;
}
- (UIColor *)transferStep1ViewController_toLabel_after_textColor {
	return transferStep1ViewController_toLabel_after_textColor;
}
- (UIColor *)transferStep1ViewController_mailTextField_after_textColor {
	return transferStep1ViewController_mailTextField_after_textColor;
}
- (UIColor *)transferStep1ViewController_viewSearchContact_backgroundColor {
	return transferStep1ViewController_viewSearchContact_backgroundColor;
}
- (UIColor *)transferStep1ViewController_searchFriendMailLabel_backgroundColor {
	return transferStep1ViewController_searchFriendMailLabel_backgroundColor;
}
- (UIColor *)transferStep1ViewController_searchContactButton_highlighted_backgroundColor {
	return transferStep1ViewController_searchContactButton_highlighted_backgroundColor;
}
- (UIColor *)transferStep1ViewController_validateButton_highlighted_backgroundColor {
	return transferStep1ViewController_validateButton_highlighted_backgroundColor;
}

#pragma mark - ResponseCell
- (UIColor *)responseCell_bgView_backgroundColor {
	return responseCell_bgView_backgroundColor;
}

#pragma mark - CountryCell
- (UIColor *)countryCell_bgView_backgroundColor {
	return countryCell_bgView_backgroundColor;
}

#pragma mark - HistoryDetailCell
- (UIColor *)historyDetailCell_indicatorColorView_pending_backgroundColor {
	return historyDetailCell_indicatorColorView_pending_backgroundColor;
}
- (UIColor *)historyDetailCell_lblAmount_pending_textColor {
	return historyDetailCell_lblAmount_pending_textColor;
}
- (UIColor *)historyDetailCell_indicatorColorView_credit_backgroundColor {
	return historyDetailCell_indicatorColorView_credit_backgroundColor;
}
- (UIColor *)historyDetailCell_lblAmount_credit_textColor {
	return historyDetailCell_lblAmount_credit_textColor;
}
- (UIColor *)historyDetailCell_indicatorColorView_debit_backgroundColor {
	return historyDetailCell_indicatorColorView_debit_backgroundColor;
}
- (UIColor *)historyDetailCell_lblAmount_debit_textColor {
	return historyDetailCell_lblAmount_debit_textColor;
}
- (UIColor *)historyDetailCell_contentView_refused_backgroundColor {
	return historyDetailCell_contentView_refused_backgroundColor;
}
- (UIColor *)historyDetailCell_contentView_canceled_backgroundColor {
	return historyDetailCell_contentView_canceled_backgroundColor;
}
- (UIColor *)historyDetailCell_pendingCreditorAcceptButton_backgroundColor {
	return historyDetailCell_pendingCreditorAcceptButton_backgroundColor;
}
- (UIColor *)historyDetailCell_pendingCreditorCancelButton_backgroundColor {
	return historyDetailCell_pendingCreditorCancelButton_backgroundColor;
}
- (UIColor *)historyDetailCell_pendingDebitorCancelButton_backgroundColor {
	return historyDetailCell_pendingDebitorCancelButton_backgroundColor;
}
- (UIColor *)historyDetailCell_pendingCreditorActionView_backgroundColor {
	return historyDetailCell_pendingCreditorActionView_backgroundColor;
}
- (UIColor *)historyDetailCell_pendingDebitorActionView_backgroundColor {
	return historyDetailCell_pendingDebitorActionView_backgroundColor;
}
- (UIColor *)historyDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor {
	return historyDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor;
}
- (UIColor *)historyDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor {
	return historyDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor;
}
- (UIColor *)historyDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor {
	return historyDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor;
}

#pragma mark - SuscribeTextViewCell
- (UIColor *)suscribeTextViewCell_textField_textColor {
	return suscribeTextViewCell_textField_textColor;
}
- (UIColor *)suscribeTextViewCell_textField_placeHolderColor {
	return suscribeTextViewCell_textField_placeHolderColor;
}
- (UIColor *)suscribeTextViewCell_lbl_textColor {
	return suscribeTextViewCell_lbl_textColor;
}

#pragma mark - SuscribeTextViewCellSegment
- (UIColor *)suscribeTextViewCellSegment_segmentedControl_tintColor {
	return suscribeTextViewCellSegment_segmentedControl_tintColor;
}

#pragma mark - SuscribeTextViewCellPicker
- (UIColor *)suscribeTextViewCellPicker_textField_backgroundColor {
	return suscribeTextViewCellPicker_textField_backgroundColor;
}

#pragma mark - RegisterUserViewController
- (UIColor *)registerUserViewController_lblSubNavigation_textColor {
	return registerUserViewController_lblSubNavigation_textColor;
}
- (UIColor *)registerUserViewController_viewHeader_backgroundColor {
	return registerUserViewController_viewHeader_backgroundColor;
}

#pragma mark - CustomTabBarViewController
- (UIColor *)customTabBarViewController_btnPay_riddleColor {
	return customTabBarViewController_btnPay_riddleColor;
}

#pragma mark - ProgramTableViewCell
- (UIColor *)programTableViewCell_lblProgramName_odd_textColor {
	return programTableViewCell_lblProgramName_odd_textColor;
}
- (UIColor *)programTableViewCell_lblProgramName_odd_backgroundColor {
	return programTableViewCell_lblProgramName_odd_backgroundColor;
}
- (UIColor *)programTableViewCell_lblMerchantName_odd_textColor {
	return programTableViewCell_lblMerchantName_odd_textColor;
}
- (UIColor *)programTableViewCell_lblMerchantName_odd_backgroundColor {
	return programTableViewCell_lblMerchantName_odd_backgroundColor;
}
- (UIColor *)programTableViewCell_contentView_even_backgroundColor {
	return programTableViewCell_contentView_even_backgroundColor;
}
- (UIColor *)programTableViewCell_lblProgramName_even_textColor {
	return programTableViewCell_lblProgramName_even_textColor;
}
- (UIColor *)programTableViewCell_lblProgramName_even_backgroundColor {
	return programTableViewCell_lblProgramName_even_backgroundColor;
}
- (UIColor *)programTableViewCell_lblMerchantName_even_textColor {
	return programTableViewCell_lblMerchantName_even_textColor;
}
- (UIColor *)programTableViewCell_lblMerchantName_even_backgroundColor {
	return programTableViewCell_lblMerchantName_even_backgroundColor;
}
- (UIColor *)programTableViewCell_imageCoupons_even_bacgroundColor {
	return programTableViewCell_imageCoupons_even_bacgroundColor;
}
- (UIColor *)programTableViewCell_imageLogo_even_backgroundColor {
	return programTableViewCell_imageLogo_even_backgroundColor;
}
- (UIColor *)programTableViewCell_lblNumberOfCoupons_even_backgroundColor {
	return programTableViewCell_lblNumberOfCoupons_even_backgroundColor;
}
- (UIColor *)programTableViewCell_lblAmountOfACoupons_even_backgroundColor {
	return programTableViewCell_lblAmountOfACoupons_even_backgroundColor;
}
- (UIColor *)programTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor {
	return programTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor;
}
- (UIColor *)programTableViewCell_viewIndicationsCoupons_even_backgroundColor {
	return programTableViewCell_viewIndicationsCoupons_even_backgroundColor;
}

#pragma mark - HistoryViewController
- (UIColor *)historyViewController_allButton_borderColor {
	return historyViewController_allButton_borderColor;
}
- (UIColor *)historyViewController_allButton_backgroundColor {
	return historyViewController_allButton_backgroundColor;
}
- (UIColor *)historyViewController_outputButton_titleColor {
	return historyViewController_outputButton_titleColor;
}
- (UIColor *)historyViewController_outputButton_borderColor {
	return historyViewController_outputButton_borderColor;
}
- (UIColor *)historyViewController_inputButton_titleColor {
	return historyViewController_inputButton_titleColor;
}
- (UIColor *)historyViewController_inputButton_borderColor {
	return historyViewController_inputButton_borderColor;
}
- (UIColor *)historyViewController_pendingButton_titleColor {
	return historyViewController_pendingButton_titleColor;
}
- (UIColor *)historyViewController_pendingButton_borderColor {
	return historyViewController_pendingButton_borderColor;
}
- (UIColor *)historyViewController_contentView_backgroundColor {
	return historyViewController_contentView_backgroundColor;
}
- (UIColor *)historyViewController_header_backgroundColor {
	return historyViewController_header_backgroundColor;
}

#pragma mark - TransferReceiveStep1ViewController
- (UIColor *)transferReceiveStep1ViewController_lblYourBalance_textColor {
	return transferReceiveStep1ViewController_lblYourBalance_textColor;
}
- (UIColor *)transferReceiveStep1ViewController_lblBalance_textColor {
	return transferReceiveStep1ViewController_lblBalance_textColor;
}
- (UIColor *)transferReceiveStep1ViewController_header_backgroundColor {
	return transferReceiveStep1ViewController_header_backgroundColor;
}
- (UIColor *)transferReceiveStep1ViewController_viewDescription_backgroundColor {
	return transferReceiveStep1ViewController_viewDescription_backgroundColor;
}
- (UIColor *)transferReceiveStep1ViewController_lblAmount_textColor {
	return transferReceiveStep1ViewController_lblAmount_textColor;
}
- (UIColor *)transferReceiveStep1ViewController_lblCurrencyBefore_textColor {
	return transferReceiveStep1ViewController_lblCurrencyBefore_textColor;
}
- (UIColor *)transferReceiveStep1ViewController_amountTextField_textColor {
	return transferReceiveStep1ViewController_amountTextField_textColor;
}
- (UIColor *)transferReceiveStep1ViewController_lblCurrencyAfter_textColor {
	return transferReceiveStep1ViewController_lblCurrencyAfter_textColor;
}
- (UIColor *)transferReceiveStep1ViewController_lblDescription_textColor {
	return transferReceiveStep1ViewController_lblDescription_textColor;
}

#pragma mark - TransferReceiveStep2ViewController
- (UIColor *)transferReceiveStep2ViewController_header_backgroundColor {
	return transferReceiveStep2ViewController_header_backgroundColor;
}

#pragma mark - ValidatorViewController
- (UIColor *)validatorViewController_view_backgroundColor {
	return validatorViewController_view_backgroundColor;
}
- (UIColor *)validatorViewController_btnSecond_borderColor {
	return validatorViewController_btnSecond_borderColor;
}
- (UIColor *)validatorViewController_lblFirst_mode1_textColor {
	return validatorViewController_lblFirst_mode1_textColor;
}
- (UIColor *)validatorViewController_btnFirst_mode1_backgroundColor {
	return validatorViewController_btnFirst_mode1_backgroundColor;
}
- (UIColor *)validatorViewController_btnFirst_mode1_highlighted_backgroundColor {
	return validatorViewController_btnFirst_mode1_highlighted_backgroundColor;
}
- (UIColor *)validatorViewController_btnFirst_mode1_titleColor {
	return validatorViewController_btnFirst_mode1_titleColor;
}
- (UIColor *)validatorViewController_btnFirst_mode1_highlighted_titleColor {
	return validatorViewController_btnFirst_mode1_highlighted_titleColor;
}
- (UIColor *)validatorViewController_lblFirst_mode2_textColor {
	return validatorViewController_lblFirst_mode2_textColor;
}
- (UIColor *)validatorViewController_btnFirst_mode2_backgroundColor {
	return validatorViewController_btnFirst_mode2_backgroundColor;
}
- (UIColor *)validatorViewController_btnFirst_mode2_titleColor {
	return validatorViewController_btnFirst_mode2_titleColor;
}
- (UIColor *)validatorViewController_btnSecond_mode2_titleColor {
	return validatorViewController_btnSecond_mode2_titleColor;
}
- (UIColor *)validatorViewController_btnSecond_mode2_backgroundColor {
	return validatorViewController_btnSecond_mode2_backgroundColor;
}
- (UIColor *)validatorViewController_lblFirst_mode3_textColor {
	return validatorViewController_lblFirst_mode3_textColor;
}
- (UIColor *)validatorViewController_btnFirst_mode3_backgroundColor {
	return validatorViewController_btnFirst_mode3_backgroundColor;
}
- (UIColor *)validatorViewController_btnFirst_mode3_titleColor {
	return validatorViewController_btnFirst_mode3_titleColor;
}
- (UIColor *)validatorViewController_btnSecond_mode3_titleColor {
	return validatorViewController_btnSecond_mode3_titleColor;
}
- (UIColor *)validatorViewController_btnSecond_mode3_backgroundColor {
	return validatorViewController_btnSecond_mode3_backgroundColor;
}
- (UIColor *)validatorViewController_btnSecond_mode2_highlighted_backgroundColor {
	return validatorViewController_btnSecond_mode2_highlighted_backgroundColor;
}
- (UIColor *)validatorViewController_btnSecond_mode2_highlighted_titleColor {
	return validatorViewController_btnSecond_mode2_highlighted_titleColor;
}
- (UIColor *)validatorViewController_btnFirst_mode3_highlighted_backgroundColor {
	return validatorViewController_btnFirst_mode3_highlighted_backgroundColor;
}
- (UIColor *)validatorViewController_btnFirst_mode3_highlighted_titleColor {
	return validatorViewController_btnFirst_mode3_highlighted_titleColor;
}
- (UIColor *)validatorViewController_btnSecond_mode3_highlighted_titleColor {
	return validatorViewController_btnSecond_mode3_highlighted_titleColor;
}
- (UIColor *)validatorViewController_btnSecond_mode3_highlighted_backgroundColor {
	return validatorViewController_btnSecond_mode3_highlighted_backgroundColor;
}

#pragma mark - InitialViewController
- (UIColor *)initialViewController_viewMiddle_backgroundColor {
	return initialViewController_viewMiddle_backgroundColor;
}
- (UIColor *)initialViewController_viewBottom_backgroundColor {
	return initialViewController_viewBottom_backgroundColor;
}
- (UIColor *)initialViewController_btnCreateAccount_backgroundColor {
	return initialViewController_btnCreateAccount_backgroundColor;
}
- (UIColor *)initialViewController_btnCreateAccount_highlighted_backgroundColor {
	return initialViewController_btnCreateAccount_highlighted_backgroundColor;
}
- (UIColor *)initialViewController_btnLogin_titleColor {
	return initialViewController_btnLogin_titleColor;
}
- (UIColor *)initialViewController_btnCreateAccount_highlighted_titleColor {
	return initialViewController_btnCreateAccount_highlighted_titleColor;
}

#pragma mark - PaymentViewController
- (UIColor *)paymentViewController_viewBackgroundSetUserInfos_backgroundColor {
	return paymentViewController_viewBackgroundSetUserInfos_backgroundColor;
}
- (UIColor *)paymentViewController_btnSetUserInfos_backgroundColor {
	return paymentViewController_btnSetUserInfos_backgroundColor;
}
- (UIColor *)paymentViewController_viewBackgroundAddCreditCard_backgroundColor {
	return paymentViewController_viewBackgroundAddCreditCard_backgroundColor;
}
- (UIColor *)paymentViewController_btnAddCreditCard_backgroundColor {
	return paymentViewController_btnAddCreditCard_backgroundColor;
}

#pragma mark - YourLoyaltyProgramsViewController
- (UIColor *)yourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor {
	return yourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor;
}

#pragma mark - YourLoyaltyProgramDetailsViewController
- (UIColor *)yourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor {
	return yourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor;
}

#pragma mark - LoyaltyProgramDetailsViewController
- (UIColor *)loyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor {
	return loyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor;
}

#pragma mark - RegisterResponseViewController
- (UIColor *)registerResponseViewController_btnValidate_backgroundColor {
	return registerResponseViewController_btnValidate_backgroundColor;
}
- (UIColor *)registerResponseViewController_viewValidate_backgroundColor {
	return registerResponseViewController_viewValidate_backgroundColor;
}
- (UIColor *)registerResponseViewController_btnValidate_titleColor {
	return registerResponseViewController_btnValidate_titleColor;
}
- (UIColor *)registerResponseViewController_btnValidate_highlighted_titleColor {
	return registerResponseViewController_btnValidate_highlighted_titleColor;
}
- (UIColor *)registerResponseViewController_btnValidate_highlighted_backgroundColor {
	return registerResponseViewController_btnValidate_highlighted_backgroundColor;
}
- (UIColor *)registerResponseViewController_viewBottom_unvalid_backgroundColor {
	return registerResponseViewController_viewBottom_unvalid_backgroundColor;
}
- (UIColor *)registerResponseViewController_btnValidate_unvalid_backgroundColor {
	return registerResponseViewController_btnValidate_unvalid_backgroundColor;
}
- (UIColor *)registerResponseViewController_btnValidate_unvalid_titleColor {
	return registerResponseViewController_btnValidate_unvalid_titleColor;
}
- (UIColor *)registerResponseViewController_textfield_placeholderColor {
	return registerResponseViewController_textfield_placeholderColor;
}
- (UIColor *)registerResponseViewController_textField_textColor {
	return registerResponseViewController_textField_textColor;
}

#pragma mark - RegisterCaptchaViewController
- (UIColor *)registerCaptchaViewController_btnValidate_bacgroundColor {
	return registerCaptchaViewController_btnValidate_bacgroundColor;
}
- (UIColor *)registerCaptchaViewController_viewBottom_bacgroundColor {
	return registerCaptchaViewController_viewBottom_bacgroundColor;
}

#pragma mark - TransferHomeViewController
- (UIColor *)transferHomeViewController_lblReceive_textColor {
	return transferHomeViewController_lblReceive_textColor;
}
- (UIColor *)transferHomeViewController_lblSend_textColor {
	return transferHomeViewController_lblSend_textColor;
}

#pragma mark - ForgottenPasswordSendMailViewController
- (UIColor *)forgottenPasswordSendMailViewController_viewSubNavigation_backgroundColor {
	return forgottenPasswordSendMailViewController_viewSubNavigation_backgroundColor;
}
- (UIColor *)forgottenPasswordSendMailViewController_lblSubNavigation_textColor {
	return forgottenPasswordSendMailViewController_lblSubNavigation_textColor;
}
- (UIColor *)forgottenPasswordSendMailViewController_viewBottom_backgroundColor {
	return forgottenPasswordSendMailViewController_viewBottom_backgroundColor;
}
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_titleColor {
	return forgottenPasswordSendMailViewController_btnValidate_titleColor;
}
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_backgroundColor {
	return forgottenPasswordSendMailViewController_btnValidate_backgroundColor;
}
- (UIColor *)forgottenPasswordSendMailViewController_viewBottom_valid_backgroundColor {
	return forgottenPasswordSendMailViewController_viewBottom_valid_backgroundColor;
}
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_valid_titleColor {
	return forgottenPasswordSendMailViewController_btnValidate_valid_titleColor;
}
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_valid_backgroundColor {
	return forgottenPasswordSendMailViewController_btnValidate_valid_backgroundColor;
}

#pragma mark - ForgottenPasswordSecretAnswerViewController
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewNavigation_backgroundColor {
	return forgottenPasswordSecretAnswerViewController_viewNavigation_backgroundColor;
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_lblNavigation_textColor {
	return forgottenPasswordSecretAnswerViewController_lblNavigation_textColor;
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewQuestion_backgroundColor {
	return forgottenPasswordSecretAnswerViewController_viewQuestion_backgroundColor;
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_lblQuestion_textColor {
	return forgottenPasswordSecretAnswerViewController_lblQuestion_textColor;
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewBottom_backgroundColor {
	return forgottenPasswordSecretAnswerViewController_viewBottom_backgroundColor;
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_btnValidate_backgroundColor {
	return forgottenPasswordSecretAnswerViewController_btnValidate_backgroundColor;
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewBottom_valid_backgroundColor {
	return forgottenPasswordSecretAnswerViewController_viewBottom_valid_backgroundColor;
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_btnValidate_valid_backgroundColor {
	return forgottenPasswordSecretAnswerViewController_btnValidate_valid_backgroundColor;
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewBottom_bad_backgroundColor {
	return forgottenPasswordSecretAnswerViewController_viewBottom_bad_backgroundColor;
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_btnValidate_bad_backgroundColor {
	return forgottenPasswordSecretAnswerViewController_btnValidate_bad_backgroundColor;
}

#pragma mark - ForgottenPasswordNewPasswordViewController
- (UIColor *)forgottenPasswordNewPasswordViewController_viewNavigation_backgroundColor {
	return forgottenPasswordNewPasswordViewController_viewNavigation_backgroundColor;
}
- (UIColor *)forgottenPasswordNewPasswordViewController_lblNavigation_textColor {
	return forgottenPasswordNewPasswordViewController_lblNavigation_textColor;
}
- (UIColor *)forgottenPasswordNewPasswordViewController_viewInstructions_backgroundColor {
	return forgottenPasswordNewPasswordViewController_viewInstructions_backgroundColor;
}
- (UIColor *)forgottenPasswordNewPasswordViewController_lblInstructions_textColor {
	return forgottenPasswordNewPasswordViewController_lblInstructions_textColor;
}
- (UIColor *)forgottenPasswordNewPasswordViewController_viewBottom_backgroundColor {
	return forgottenPasswordNewPasswordViewController_viewBottom_backgroundColor;
}
- (UIColor *)forgottenPasswordNewPasswordViewController_btnValidate_backgroundColor {
	return forgottenPasswordNewPasswordViewController_btnValidate_backgroundColor;
}
- (UIColor *)forgottenPasswordNewPasswordViewController_viewBottom_valid_backgroundColor {
	return forgottenPasswordNewPasswordViewController_viewBottom_valid_backgroundColor;
}
- (UIColor *)forgottenPasswordNewPasswordViewController_btnValidate_valid_backgroundColor {
	return forgottenPasswordNewPasswordViewController_btnValidate_valid_backgroundColor;
}

#pragma mark - AccountBannerViewController
- (UIColor *)accountBannerViewController_lblYourBalance_textColor {
	return accountBannerViewController_lblYourBalance_textColor;
}
- (UIColor *)accountBannerViewController_lblCurrentBalance_textColor {
	return accountBannerViewController_lblCurrentBalance_textColor;
}


@end
