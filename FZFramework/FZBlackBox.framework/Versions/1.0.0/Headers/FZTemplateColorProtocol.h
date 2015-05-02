//
//  FZTemplateColorProtocol.h
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/16/14.
//  Copyright (c) 2014 FLASHiZ. All rights reserved.
//

//FW
#include <UIKit/UIColor.h>

@protocol FZTemplateColorProtocol <NSObject>

#pragma mark - Colors from the guideline

- (UIColor *)blackColor;

- (UIColor *)blackColorWithAlpha:(CGFloat)alpha;

- (UIColor *)whiteColor;
- (UIColor *)whiteColorWithAlpha:(CGFloat)alpha;

- (UIColor *)mainOneColor;
- (UIColor *)mainTwoColor;
- (UIColor *)mainThreeColor;
- (UIColor *)transferOneColor;
- (UIColor *)transferTwoColor;
- (UIColor *)rewardsOneColor;
- (UIColor *)rewardsThreeColor;
- (UIColor *)monochromeOneColor;
- (UIColor *)monochromeTwoColor;
- (UIColor *)monochromeThreeColor;

#pragma mark - PaymentTopupViewController
- (UIColor *)paymentTopupViewController_lblAutomaticRefill_textColor;
- (UIColor *)paymentTopupViewController_autoButton_titleColor;
- (UIColor *)paymentTopupViewController_aButton_titleColor;
- (UIColor *)paymentTopupViewController_viewChooseCard_backgroundColor;
- (UIColor *)paymentTopupViewController_viewRefill_backgroundColor;
- (UIColor *)paymentTopupViewController_refillButton_backgroundColor;
- (UIColor *)paymentTopupViewController_autoButton_backgroundColor;
- (UIColor *)paymentTopupViewController_creditCardButton_backgroundColor;
- (UIColor *)paymentTopupViewController_viewAutomaticRefill_backgroundColor;
- (UIColor *)paymentTopupViewController_header_backgroundColor;
- (UIColor *)paymentTopupViewController_lblAmount_textColor;
- (UIColor *)paymentTopupViewController_viewChooseCard_selected_backgroundColor;
- (UIColor *)paymentTopupViewController_creditCardButton_selected_titleColor;
- (UIColor *)paymentTopupViewController_refillButton_highlighted_backgroundColor;
- (UIColor *)paymentTopupViewController_refillButton_highlighted_titleColor;
- (UIColor *)paymentTopupViewController_refillButton_titleColor;
- (UIColor *)paymentTopupViewController_refillButton_unvalid_titleColor;
- (UIColor *)paymentTopupViewController_refillButton_unvalid_backgroundColor;
- (UIColor *)paymentTopupViewController_creditCardButton_selected_backgroundColor;
- (UIColor *)paymentTopupViewController_viewRefill_unvalid_backgroundColor;

#pragma mark - CardListViewController
- (UIColor *)cardListViewController_backgroundColor;
- (UIColor *)cardListViewController_viewValidate_backgroundColor;
- (UIColor *)cardListViewController_btnValidate_backgroundColor;
- (UIColor *)cardListViewController_btnValidate_highlighted_backgroundColor;
- (UIColor *)cardListViewController_btnValidate_highlighted_textColor;

#pragma mark - BankAccountExpiredCell
- (UIColor *)bankAccountExpiredCell_backgroundColor;
- (UIColor *)bankAccountExpiredCell_stringColor_backgroundColor;
- (UIColor *)bankAccountExpiredCell_lblCardExpired_textColor;
- (UIColor *)bankAccountExpiredCell_btnRight_titleColor;
- (UIColor *)bankAccountExpiredCell_btnRight_borderColor;
- (UIColor *)bankAccountExpiredCell_btnRight_backgroundColor;
- (UIColor *)bankAccountExpiredCell_btnLeft_backgroundColor;
- (UIColor *)bankAccountExpiredCell_btnLeft_highlighted_titleColor;
- (UIColor *)bankAccountExpiredCell_btnRight_highlighted_titleColor;
- (UIColor *)bankAccountExpiredCell_btnLeft_highlighted_backgroundColor;
- (UIColor *)bankAccountExpiredCell_btnRight_highlighted_backgroundColor;

#pragma mark - BankAccountCell
- (UIColor *)bankAccountCell_stringColorEditionMode_backgroundColor;
- (UIColor *)bankAccountCell_stringColor_backgroundColor;
- (UIColor *)bankAccountCell_lblCardNumber_textColor;
- (UIColor *)bankAccountCell_lblCardExpired_textColor;

#pragma mark - ActionSuccessfulViewController
- (UIColor *)actionSuccessfulViewController_fromCardList_backgroundColor;
- (UIColor *)actionSuccessfulViewController_fromTopUp_backgroundColor;

#pragma mark - MenuViewController
- (UIColor *)menuViewController_btnLogOff_backgroundColor;
- (UIColor *)menuViewController_viewLogout_backgroundColor;
- (UIColor *)menuViewController_tableview_inAccountListMode_backgroundColor;
- (UIColor *)menuViewController_tableview_inAccountListMode_separatorColor;
- (UIColor *)menuViewController_tableview_backgroundColor;
- (UIColor *)menuViewController_tableview_separatorColor;

#pragma mark - MenuUserCellManagement
- (UIColor *)menuUserCellManagement_myAccount_backgroundColor;
- (UIColor *)menuUserCellManagement_myAccount_stringColor;
- (UIColor *)menuUserCellManagement_home_stringColor;
- (UIColor *)menuUserCellManagement_refill_stringColor;
- (UIColor *)menuUserCellManagement_myInformations_stringColor;
- (UIColor *)menuUserCellManagement_myCards_stringColor;
- (UIColor *)menuUserCellManagement_security_stringColor;
- (UIColor *)menuUserCellManagement_verifyAccount_stringColor;

#pragma mark - MenuUserCell
- (UIColor *)menuUserCell_backgroundColor;

#pragma mark - MenuSmallCell
- (UIColor *)menuSmallCell_version_backgroundColor;
- (UIColor *)menuSmallCell_version_stringColor;
- (UIColor *)menuSmallCell_backgroundColor;
- (UIColor *)menuSmallCell_stringColor;
- (UIColor *)menuSmallCell_contentView_backgroundColor;
- (UIColor *)menuSmallCell_lbl_textColor;

#pragma mark - MenuBigCell
- (UIColor *)menuBigCell_lbl_textColor;

#pragma mark - TimeoutViewController
- (UIColor *)timeoutViewController_aButton_titleColor;
- (UIColor *)timeoutViewController_viewChangePin_BackgroundColor;
- (UIColor *)timeoutViewController_changePinButton_BackgroundColor;
- (UIColor *)timeoutViewController_header_backgroundColor;
- (UIColor *)timeoutViewController_changePinButton_highlighted_backgroundColor;
- (UIColor *)timeoutViewController_changePinButton_titleColor;
- (UIColor *)timeoutViewController_changePinButton_highlighted_titleColor;
- (UIColor *)timeoutViewController_timeoutTitleLabel_textColor;
- (UIColor *)timeoutViewController_timeoutDescriptionLabel_textColor;

#pragma mark - TutorialViewController
- (UIColor *)tutorialViewController_viewBottom_backgroundColor;

#pragma mark - UserInformationViewController
- (UIColor *)userInformationViewController_viewValidate_actived_backgroundColor;
- (UIColor *)userInformationViewController_btnValidate_actived_titleColor;
- (UIColor *)userInformationViewController_btnValidate_actived_backgroundColor;
- (UIColor *)userInformationViewController_btnValidate_titleColor;
- (UIColor *)userInformationViewController_btnValidate_backgroundColor;
- (UIColor *)userInformationViewController_viewValidate_backgroundColor;
- (UIColor *)userInformationViewController_header_backgroundColor;
- (UIColor *)userInformationViewController_btnValidate_actived_highlighted_backgroundColor;
- (UIColor *)userInformationViewController_btnValidate_actived_highlighted_titleColor;

#pragma mark - PaymentCheckViewController
- (UIColor *)payButtonGradientOne;
- (UIColor *)payButtonGradientTwo;
- (UIColor *)payButtonGradientTwoWithAlpha:(CGFloat)alpha;
- (UIColor *)payButtonGradientThree;
- (UIColor *)paymentCheckViewController_view_backgroundColor;
- (UIColor *)paymentCheckViewController_couponButton_titleColor;
- (UIColor *)paymentCheckViewController_payButton_borderColor;
- (UIColor *)paymentCheckViewController_payButton_titleColor;
- (UIColor *)paymentCheckViewController_header_backgroundColor;

#pragma mark - LoginViewController
- (UIColor *)loginViewController_headerView_backgroundColor;
- (UIColor *)loginViewController_bottomView_backgroundColor;
- (UIColor *)loginViewController_btnLogin_backgroundColor;
- (UIColor *)loginViewController_btnLogin_titleColor;
- (UIColor *)loginViewController_btnConnect_titleColor;
- (UIColor *)loginViewController_btnForgottenPassword_titleColor;

- (UIColor *)loginViewController_bottomView_valid_backgroundColor;
- (UIColor *)loginViewController_btnLogin_valid_backgroundColor;
- (UIColor *)loginViewController_btnLogin_valid_titleColor;

#pragma mark - PinViewController
- (UIColor *)pinViewController_colorThree;
- (UIColor *)pinViewController_textField_backgroundColor;
- (UIColor *)pinViewController_textField_2_backgroundColor;
- (UIColor *)pinViewController_gradient_top;
- (UIColor *)pinViewController_gradient_bottom;

#pragma mark - PaymentViewController
- (UIColor *)paymentViewController_header_backgroundColor;
- (UIColor *)paymentViewController_btnSetUserInfos_highlighted_backgroundColor;
- (UIColor *)paymentViewController_btnAddCreditCard_highlighted_backgroundColor;
- (UIColor *)paymentViewController_btnSetUserInfos_titleColor;
- (UIColor *)paymentViewController_btnSetUserInfos_highlighted_titleColor;
- (UIColor *)paymentViewController_btnAddCreditCard_titleColor;
- (UIColor *)paymentViewController_btnAddCreditCard_highlighted_titleColor;

#pragma mark - CountryViewController

- (UIColor *)countryViewController_header_backgroundColor;
- (UIColor *)countryViewController_tableview_separatorColor;
- (UIColor *)countryViewController_textFieldCountryName_placeHolderColor;

#pragma mark - RegisterQuestionsViewController

- (UIColor *)registerQuestionsViewController_tableview_separatorColor;

#pragma mark - ActionSuccessfulAfterPaymentViewController

- (UIColor *)actionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor;

#pragma mark - RewardsHomeViewController

- (UIColor *)rewardsHomeViewController_yourProgramsButton_backgroundColor;
- (UIColor *)rewardsHomeViewController_yourProgramsButton_selected_backgroundColor;
- (UIColor *)rewardsHomeViewController_allProgramsButton_backgroundColor;
- (UIColor *)rewardsHomeViewController_allProgramsButton_selected_backgroundColor;
- (UIColor *)rewardsHomeViewController_viewAccountBanner_textColor;

#pragma mark - LoginCell

- (UIColor *)loginCell_textField_textColor;

#pragma mark - TransferStep1ViewController

- (UIColor *)transferStep1ViewController_lblYourbalance_textColor;
- (UIColor *)transferStep1ViewController_lblBalance_textColor;
- (UIColor *)transferStep1ViewController_searchContactButton_backgroundColor;
- (UIColor *)transferStep1ViewController_validateButton_backgroundColor;
- (UIColor *)transferStep1ViewController_commentButton_backgroundColor;
- (UIColor *)transferStep1ViewController_viewMail_backgroundColor;
- (UIColor *)transferStep1ViewController_toLabel_textColor;
- (UIColor *)transferStep1ViewController_mailTextField_textColor;
- (UIColor *)transferStep1ViewController_toLabel_after_textColor;
- (UIColor *)transferStep1ViewController_mailTextField_after_textColor;
- (UIColor *)transferStep1ViewController_viewSearchContact_backgroundColor;
- (UIColor *)transferStep1ViewController_searchFriendMailLabel_backgroundColor;
- (UIColor *)transferStep1ViewController_searchContactButton_highlighted_backgroundColor;
- (UIColor *)transferStep1ViewController_validateButton_highlighted_backgroundColor;

#pragma mark - ResponseCell

- (UIColor *)responseCell_bgView_backgroundColor;

#pragma mark - CountryCell

- (UIColor *)countryCell_bgView_backgroundColor;

#pragma mark - HistoryDetailCell

- (UIColor *)historyDetailCell_indicatorColorView_pending_backgroundColor;
- (UIColor *)historyDetailCell_lblAmount_pending_textColor;
- (UIColor *)historyDetailCell_indicatorColorView_credit_backgroundColor;
- (UIColor *)historyDetailCell_lblAmount_credit_textColor;
- (UIColor *)historyDetailCell_indicatorColorView_debit_backgroundColor;
- (UIColor *)historyDetailCell_lblAmount_debit_textColor;
- (UIColor *)historyDetailCell_contentView_refused_backgroundColor;
- (UIColor *)historyDetailCell_contentView_canceled_backgroundColor;
- (UIColor *)historyDetailCell_pendingCreditorAcceptButton_backgroundColor;
- (UIColor *)historyDetailCell_pendingCreditorCancelButton_backgroundColor;
- (UIColor *)historyDetailCell_pendingDebitorCancelButton_backgroundColor;
- (UIColor *)historyDetailCell_pendingCreditorActionView_backgroundColor;
- (UIColor *)historyDetailCell_pendingDebitorActionView_backgroundColor;
- (UIColor *)historyDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor;
- (UIColor *)historyDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor;
- (UIColor *)historyDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor;

#pragma mark - SuscribeTextViewCell

- (UIColor *)suscribeTextViewCell_textField_textColor;
- (UIColor *)suscribeTextViewCell_textField_placeHolderColor;
- (UIColor *)suscribeTextViewCell_lbl_textColor;

#pragma mark - SuscribeTextViewCellSegment

- (UIColor *)suscribeTextViewCellSegment_segmentedControl_tintColor;

#pragma mark - SuscribeTextViewCellPicker

- (UIColor *)suscribeTextViewCellPicker_textField_backgroundColor;

#pragma mark - RegisterUserViewController

- (UIColor *)registerUserViewController_lblSubNavigation_textColor;
- (UIColor *)registerUserViewController_viewHeader_backgroundColor;

#pragma mark - CustomTabBarViewController

- (UIColor *)customTabBarViewController_btnPay_riddleColor;

#pragma mark - ProgramTableViewCell

- (UIColor *)programTableViewCell_lblProgramName_odd_textColor;
- (UIColor *)programTableViewCell_lblProgramName_odd_backgroundColor;
- (UIColor *)programTableViewCell_lblMerchantName_odd_textColor;
- (UIColor *)programTableViewCell_lblMerchantName_odd_backgroundColor;
- (UIColor *)programTableViewCell_contentView_even_backgroundColor;
- (UIColor *)programTableViewCell_lblProgramName_even_textColor;
- (UIColor *)programTableViewCell_lblProgramName_even_backgroundColor;
- (UIColor *)programTableViewCell_lblMerchantName_even_textColor;
- (UIColor *)programTableViewCell_lblMerchantName_even_backgroundColor;
- (UIColor *)programTableViewCell_imageCoupons_even_bacgroundColor;
- (UIColor *)programTableViewCell_imageLogo_even_backgroundColor;
- (UIColor *)programTableViewCell_lblNumberOfCoupons_even_backgroundColor;
- (UIColor *)programTableViewCell_lblAmountOfACoupons_even_backgroundColor;
- (UIColor *)programTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor;
- (UIColor *)programTableViewCell_viewIndicationsCoupons_even_backgroundColor;

#pragma mark - HistoryViewController

- (UIColor *)historyViewController_allButton_borderColor;
- (UIColor *)historyViewController_allButton_backgroundColor;
- (UIColor *)historyViewController_outputButton_titleColor;
- (UIColor *)historyViewController_outputButton_borderColor;
- (UIColor *)historyViewController_inputButton_titleColor;
- (UIColor *)historyViewController_inputButton_borderColor;
- (UIColor *)historyViewController_pendingButton_titleColor;
- (UIColor *)historyViewController_pendingButton_borderColor;
- (UIColor *)historyViewController_contentView_backgroundColor;
- (UIColor *)historyViewController_header_backgroundColor;

#pragma mark - TransferReceiveStep1ViewController

- (UIColor *)transferReceiveStep1ViewController_lblYourBalance_textColor;
- (UIColor *)transferReceiveStep1ViewController_lblBalance_textColor;
- (UIColor *)transferReceiveStep1ViewController_header_backgroundColor;
- (UIColor *)transferReceiveStep1ViewController_viewDescription_backgroundColor;
- (UIColor *)transferReceiveStep1ViewController_lblAmount_textColor;
- (UIColor *)transferReceiveStep1ViewController_lblCurrencyBefore_textColor;
- (UIColor *)transferReceiveStep1ViewController_amountTextField_textColor;
- (UIColor *)transferReceiveStep1ViewController_lblCurrencyAfter_textColor;
- (UIColor *)transferReceiveStep1ViewController_lblDescription_textColor;

#pragma mark - TransferReceiveStep2ViewController

- (UIColor *)transferReceiveStep2ViewController_header_backgroundColor;

#pragma mark - ValidatorViewController

- (UIColor *)validatorViewController_view_backgroundColor;
- (UIColor *)validatorViewController_btnSecond_borderColor;
- (UIColor *)validatorViewController_lblFirst_mode1_textColor;
- (UIColor *)validatorViewController_btnFirst_mode1_backgroundColor;
- (UIColor *)validatorViewController_btnFirst_mode1_titleColor;
- (UIColor *)validatorViewController_lblFirst_mode2_textColor;
- (UIColor *)validatorViewController_btnFirst_mode2_backgroundColor;
- (UIColor *)validatorViewController_btnFirst_mode2_titleColor;
- (UIColor *)validatorViewController_btnSecond_mode2_titleColor;
- (UIColor *)validatorViewController_btnSecond_mode2_backgroundColor;
- (UIColor *)validatorViewController_lblFirst_mode3_textColor;
- (UIColor *)validatorViewController_btnFirst_mode3_backgroundColor;
- (UIColor *)validatorViewController_btnFirst_mode3_titleColor;
- (UIColor *)validatorViewController_btnSecond_mode3_titleColor;
- (UIColor *)validatorViewController_btnSecond_mode3_backgroundColor;
- (UIColor *)validatorViewController_btnSecond_mode2_highlighted_backgroundColor;
- (UIColor *)validatorViewController_btnSecond_mode2_highlighted_titleColor;
- (UIColor *)validatorViewController_btnFirst_mode3_highlighted_backgroundColor;
- (UIColor *)validatorViewController_btnFirst_mode3_highlighted_titleColor;
- (UIColor *)validatorViewController_btnSecond_mode3_highlighted_titleColor;
- (UIColor *)validatorViewController_btnSecond_mode3_highlighted_backgroundColor;

#pragma mark - InitialViewController

- (UIColor *)initialViewController_viewMiddle_backgroundColor;
- (UIColor *)initialViewController_viewBottom_backgroundColor;
- (UIColor *)initialViewController_btnCreateAccount_backgroundColor;
- (UIColor *)initialViewController_btnCreateAccount_highlighted_backgroundColor;
- (UIColor *)initialViewController_btnLogin_titleColor;
- (UIColor *)initialViewController_btnCreateAccount_highlighted_titleColor;

#pragma mark - PaymentViewController

- (UIColor *)paymentViewController_viewBackgroundSetUserInfos_backgroundColor;
- (UIColor *)paymentViewController_btnSetUserInfos_backgroundColor;
- (UIColor *)paymentViewController_viewBackgroundAddCreditCard_backgroundColor;
- (UIColor *)paymentViewController_btnAddCreditCard_backgroundColor;

#pragma mark - YourLoyaltyProgramsViewController

- (UIColor *)yourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor;

#pragma mark - YourLoyaltyProgramDetailsViewController

- (UIColor *)yourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor;

#pragma mark - LoyaltyProgramDetailsViewController

- (UIColor *)loyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor;

#pragma mark - RegisterResponseViewController

- (UIColor *)registerResponseViewController_btnValidate_backgroundColor;
- (UIColor *)registerResponseViewController_viewValidate_backgroundColor;
- (UIColor *)registerResponseViewController_btnValidate_titleColor;
- (UIColor *)registerResponseViewController_btnValidate_highlighted_titleColor;
- (UIColor *)registerResponseViewController_btnValidate_highlighted_backgroundColor;
- (UIColor *)registerResponseViewController_viewBottom_unvalid_backgroundColor;
- (UIColor *)registerResponseViewController_btnValidate_unvalid_backgroundColor;
- (UIColor *)registerResponseViewController_btnValidate_unvalid_titleColor;
- (UIColor *)registerResponseViewController_textfield_placeholderColor;
- (UIColor *)registerResponseViewController_textField_textColor;

#pragma mark - RegisterCaptchaViewController

- (UIColor *)registerCaptchaViewController_btnValidate_bacgroundColor;
- (UIColor *)registerCaptchaViewController_viewBottom_bacgroundColor;

#pragma mark - TransferHomeViewController

- (UIColor *)transferHomeViewController_lblReceive_textColor;
- (UIColor *)transferHomeViewController_lblSend_textColor;

#pragma mark - ForgottenPasswordSendMailViewController

- (UIColor *)forgottenPasswordSendMailViewController_viewSubNavigation_backgroundColor;
- (UIColor *)forgottenPasswordSendMailViewController_lblSubNavigation_textColor;
- (UIColor *)forgottenPasswordSendMailViewController_viewBottom_backgroundColor;
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_titleColor;
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_backgroundColor;
- (UIColor *)forgottenPasswordSendMailViewController_viewBottom_valid_backgroundColor;
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_valid_titleColor;
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_valid_backgroundColor;

#pragma mark - ForgottenPasswordSecretAnswerViewController

- (UIColor *)forgottenPasswordSecretAnswerViewController_viewNavigation_backgroundColor;
- (UIColor *)forgottenPasswordSecretAnswerViewController_lblNavigation_textColor;
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewQuestion_backgroundColor;
- (UIColor *)forgottenPasswordSecretAnswerViewController_lblQuestion_textColor;
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewBottom_backgroundColor;
- (UIColor *)forgottenPasswordSecretAnswerViewController_btnValidate_backgroundColor;
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewBottom_valid_backgroundColor;
- (UIColor *)forgottenPasswordSecretAnswerViewController_btnValidate_valid_backgroundColor;
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewBottom_bad_backgroundColor;
- (UIColor *)forgottenPasswordSecretAnswerViewController_btnValidate_bad_backgroundColor;

#pragma mark - ForgottenPasswordNewPasswordViewController

- (UIColor *)forgottenPasswordNewPasswordViewController_viewNavigation_backgroundColor;
- (UIColor *)forgottenPasswordNewPasswordViewController_lblNavigation_textColor;
- (UIColor *)forgottenPasswordNewPasswordViewController_viewInstructions_backgroundColor;
- (UIColor *)forgottenPasswordNewPasswordViewController_lblInstructions_textColor;
- (UIColor *)forgottenPasswordNewPasswordViewController_viewBottom_backgroundColor;
- (UIColor *)forgottenPasswordNewPasswordViewController_btnValidate_backgroundColor;
- (UIColor *)forgottenPasswordNewPasswordViewController_viewBottom_valid_backgroundColor;
- (UIColor *)forgottenPasswordNewPasswordViewController_btnValidate_valid_backgroundColor;

#pragma mark - AccountBannerViewController

- (UIColor *)accountBannerViewController_lblYourBalance_textColor;
- (UIColor *)accountBannerViewController_lblCurrentBalance_textColor;

@end
