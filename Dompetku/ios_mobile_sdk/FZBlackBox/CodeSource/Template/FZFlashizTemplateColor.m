//
//  FZFlashizTemplateColor.m
//  FZApp
//
//  Created by Matthieu Barile on 17/04/2014.
//  Copyright (c) 2014 flashiz. All rights reserved.
//

#import "FZFlashizTemplateColor.h"

#import <FZBlackBox/FZUIColorCreateMethods.h>

#pragma mark - Colors from the guideline
static NSString *kBlack = @"#000000";
static NSString *kWhite = @"#ffffff";
static NSString *kMainOne = @"#4ea9c6";
static NSString *kMainTwo = @"#2f8ca5";
static NSString *kMainThree = @"#1b6d83";
static NSString *kTransferOne = @"#f8616a";
static NSString *kTransferTwo = @"#9d1111";
static NSString *kRewardsOne = @"#00b6ac";
//static NSString *kRewardsTwo = @"#01a39a";//not used
static NSString *kRewardsThree = @"#008e7c";
static NSString *kMonochromeOne = @"#efeeee";
static NSString *kMonochromeTwo = @"#dad9d9";
static NSString *kMonochromeThree = @"#454545";

@implementation FZFlashizTemplateColor

- (UIColor *)blackColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}
- (UIColor *)whiteColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)blackColorWithAlpha:(CGFloat)alpha {
    return [FZUIColorCreateMethods colorWithKey:kBlack alpha:alpha];
}
- (UIColor *)whiteColorWithAlpha:(CGFloat)alpha {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:alpha];
}
- (UIColor *)mainOneColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)mainTwoColor {
	return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)mainThreeColor {
	return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)transferOneColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferTwoColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)rewardsOneColor {
	return [FZUIColorCreateMethods colorWithKey:kRewardsOne alpha:1.0f];
}
- (UIColor *)rewardsThreeColor {
	return [FZUIColorCreateMethods colorWithKey:kRewardsThree alpha:1.0f];
}
- (UIColor *)monochromeOneColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}
- (UIColor *)monochromeTwoColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)monochromeThreeColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}

#pragma mark - PaymentTopupViewController
- (UIColor *)paymentTopupViewController_lblAutomaticRefill_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_autoButton_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_aButton_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_viewChooseCard_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_viewRefill_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_refillButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_autoButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_creditCardButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_viewAutomaticRefill_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_header_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_lblAmount_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#383838" alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_viewChooseCard_selected_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_creditCardButton_selected_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_refillButton_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_refillButton_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_refillButton_highlighted_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_refillButton_unvalid_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_refillButton_unvalid_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_creditCardButton_selected_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)paymentTopupViewController_viewRefill_unvalid_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}

#pragma mark - CardListViewController
- (UIColor *)cardListViewController_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}
- (UIColor *)cardListViewController_viewValidate_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)cardListViewController_btnValidate_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)cardListViewController_btnValidate_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)cardListViewController_btnValidate_highlighted_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - BankAccountExpiredCell
- (UIColor *)bankAccountExpiredCell_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_stringColor_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#7d0004" alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_lblCardExpired_textColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_btnRight_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_btnRight_borderColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_btnRight_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_btnLeft_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_btnLeft_highlighted_titleColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_btnRight_highlighted_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_btnLeft_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#720c0c" alpha:1.0f];
}
- (UIColor *)bankAccountExpiredCell_btnRight_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}

#pragma mark - BankAccountCell
- (UIColor *)bankAccountCell_stringColorEditionMode_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#b4b2b2" alpha:1.0f];
}
- (UIColor *)bankAccountCell_stringColor_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)bankAccountCell_lblCardNumber_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)bankAccountCell_lblCardExpired_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}

#pragma mark - ActionSuccessfulViewController
- (UIColor *)actionSuccessfulViewController_fromCardList_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kRewardsOne alpha:1.0f];
}
- (UIColor *)actionSuccessfulViewController_fromTopUp_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - MenuViewController
- (UIColor *)menuViewController_btnLogOff_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)menuViewController_viewLogout_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)menuViewController_tableview_inAccountListMode_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#555555" alpha:1.0f];
}
- (UIColor *)menuViewController_tableview_inAccountListMode_separatorColor {
	return [FZUIColorCreateMethods colorWithKey:@"#383838" alpha:1.0f];
}
- (UIColor *)menuViewController_tableview_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)menuViewController_tableview_separatorColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}

#pragma mark - MenuUserCellManagement
- (UIColor *)menuUserCellManagement_myAccount_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)menuUserCellManagement_myAccount_stringColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)menuUserCellManagement_home_stringColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)menuUserCellManagement_refill_stringColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)menuUserCellManagement_myInformations_stringColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ff0078" alpha:1.0f];
}
- (UIColor *)menuUserCellManagement_myCards_stringColor {
	return [FZUIColorCreateMethods colorWithKey:@"#f58a64" alpha:1.0f];
}
- (UIColor *)menuUserCellManagement_security_stringColor {
	return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}
- (UIColor *)menuUserCellManagement_verifyAccount_stringColor {
	return [FZUIColorCreateMethods colorWithKey:kRewardsThree alpha:1.0f];
}

#pragma mark - MenuUserCell
- (UIColor *)menuUserCell_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#555555" alpha:1.0f];
}

#pragma mark - MenuSmallCell
- (UIColor *)menuSmallCell_version_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)menuSmallCell_version_stringColor {
	return [FZUIColorCreateMethods colorWithKey:@"#e8e9ea" alpha:1.0f];
}
- (UIColor *)menuSmallCell_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)menuSmallCell_stringColor {
	return [FZUIColorCreateMethods colorWithKey:@"#383838" alpha:1.0f];
}
- (UIColor *)menuSmallCell_contentView_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)menuSmallCell_lbl_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}

#pragma mark - MenuBigCell
- (UIColor *)menuBigCell_lbl_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#171717" alpha:1.0f];
}

#pragma mark - TimeoutViewController
- (UIColor *)timeoutViewController_aButton_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)timeoutViewController_viewChangePin_BackgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)timeoutViewController_changePinButton_BackgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)timeoutViewController_header_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}
- (UIColor *)timeoutViewController_changePinButton_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)timeoutViewController_changePinButton_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)timeoutViewController_changePinButton_highlighted_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)timeoutViewController_timeoutTitleLabel_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)timeoutViewController_timeoutDescriptionLabel_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}

#pragma mark - TutorialViewController
- (UIColor *)tutorialViewController_viewBottom_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - UserInformationViewController
- (UIColor *)userInformationViewController_viewValidate_actived_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)userInformationViewController_btnValidate_actived_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)userInformationViewController_btnValidate_actived_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)userInformationViewController_btnValidate_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}
- (UIColor *)userInformationViewController_btnValidate_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)userInformationViewController_viewValidate_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}
- (UIColor *)userInformationViewController_header_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}
- (UIColor *)userInformationViewController_btnValidate_actived_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)userInformationViewController_btnValidate_actived_highlighted_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - PaymentCheckViewController
- (UIColor *)payButtonGradientOne {
	return [FZUIColorCreateMethods colorWithKey:@"#23d0da" alpha:1.0f];
}
- (UIColor *)payButtonGradientTwo {
	return [FZUIColorCreateMethods colorWithKey:@"#449eb6" alpha:1.0f];
}
- (UIColor *)payButtonGradientThree {
	return [FZUIColorCreateMethods colorWithKey:@"#07adeb" alpha:1.0f];
}
- (UIColor *)paymentCheckViewController_view_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#1aabde" alpha:1.0f];
}
- (UIColor *)paymentCheckViewController_couponButton_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)paymentCheckViewController_payButton_borderColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)paymentCheckViewController_payButton_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)paymentCheckViewController_header_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}

#pragma mark - LoginViewController
- (UIColor *)loginViewController_headerView_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#dad9d9" alpha:1.0f];
}
- (UIColor *)loginViewController_btnConnect_titleColor {
	return [FZUIColorCreateMethods colorWithKey:@"#454545" alpha:1.0f];
}
- (UIColor *)loginViewController_bottomView_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#efeeee" alpha:1.0f];
}
- (UIColor *)loginViewController_btnLogin_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#dad9d9" alpha:1.0f];
}
- (UIColor *)loginViewController_btnLogin_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)loginViewController_btnForgottenPassword_titleColor {
	return [FZUIColorCreateMethods colorWithKey:@"#454545" alpha:1.0f];
}
- (UIColor *)loginViewController_bottomView_valid_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#4ea9c6" alpha:1.0f];
}
- (UIColor *)loginViewController_btnLogin_valid_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#2f8ca5" alpha:1.0f];
}
- (UIColor *)loginViewController_btnLogin_valid_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}

#pragma mark - PinViewController
- (UIColor *)pinViewController_colorThree {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}
- (UIColor *)pinViewController_textField_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)pinViewController_textField_2_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)pinViewController_gradient_top {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)pinViewController_gradient_bottom {
	return [FZUIColorCreateMethods colorWithKey:@"#009fe3" alpha:1.0f];
}

#pragma mark - PaymentViewController
- (UIColor *)paymentViewController_header_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)paymentViewController_btnSetUserInfos_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)paymentViewController_btnAddCreditCard_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)paymentViewController_btnSetUserInfos_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)paymentViewController_btnSetUserInfos_highlighted_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)paymentViewController_btnAddCreditCard_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)paymentViewController_btnAddCreditCard_highlighted_titleColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)paymentViewController_viewBackgroundSetUserInfos_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#ff0078" alpha:1.0f];
}
- (UIColor *)paymentViewController_btnSetUserInfos_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#ff0078" alpha:1.0f];
}
- (UIColor *)paymentViewController_viewBackgroundAddCreditCard_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#f58a64" alpha:1.0f];
}
- (UIColor *)paymentViewController_btnAddCreditCard_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#f58a64" alpha:1.0f];
}

#pragma mark - CountryViewController
- (UIColor *)countryViewController_header_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}
- (UIColor *)countryViewController_tableview_separatorColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}
- (UIColor *)countryViewController_textFieldCountryName_placeHolderColor {
	return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}

#pragma mark - RegisterQuestionsViewController
- (UIColor *)registerQuestionsViewController_tableview_separatorColor {
	return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}

#pragma mark - ActionSuccessfulAfterPaymentViewController
- (UIColor *)actionSuccessfulAfterPaymentViewController_progressCircle_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#94e0dc" alpha:1.0f];
}

#pragma mark - RewardsHomeViewController
- (UIColor *)rewardsHomeViewController_yourProgramsButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)rewardsHomeViewController_yourProgramsButton_selected_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#007d76" alpha:1.0f];
}
- (UIColor *)rewardsHomeViewController_allProgramsButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)rewardsHomeViewController_allProgramsButton_selected_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#007d76" alpha:1.0f];
}
- (UIColor *)rewardsHomeViewController_viewAccountBanner_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}

#pragma mark - LoginCell
- (UIColor *)loginCell_textField_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - TransferStep1ViewController
- (UIColor *)transferStep1ViewController_lblYourbalance_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_lblBalance_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_searchContactButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_validateButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_commentButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_viewMail_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_toLabel_textColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_mailTextField_textColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_toLabel_after_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#555555" alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_mailTextField_after_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#555555" alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_searchFriendMailLabel_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_viewSearchContact_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_searchContactButton_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}
- (UIColor *)transferStep1ViewController_validateButton_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kTransferTwo alpha:1.0f];
}

#pragma mark - ResponseCell
- (UIColor *)responseCell_bgView_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - CountryCell
- (UIColor *)countryCell_bgView_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - HistoryDetailCell
- (UIColor *)historyDetailCell_indicatorColorView_pending_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}
- (UIColor *)historyDetailCell_lblAmount_pending_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}
- (UIColor *)historyDetailCell_indicatorColorView_credit_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#33b94c" alpha:1.0f];
}
- (UIColor *)historyDetailCell_lblAmount_credit_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#33b94c" alpha:1.0f];
}
- (UIColor *)historyDetailCell_indicatorColorView_debit_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)historyDetailCell_lblAmount_debit_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)historyDetailCell_contentView_refused_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ababab" alpha:1.0f];
}
- (UIColor *)historyDetailCell_contentView_canceled_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ababab" alpha:1.0f];
}
- (UIColor *)historyDetailCell_pendingCreditorAcceptButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#33b94c" alpha:1.0f];
}
- (UIColor *)historyDetailCell_pendingCreditorCancelButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#9d1111" alpha:1.0f];
}
- (UIColor *)historyDetailCell_pendingDebitorCancelButton_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#9d1111" alpha:1.0f];
}
- (UIColor *)historyDetailCell_pendingCreditorActionView_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#383838" alpha:1.0f];
}
- (UIColor *)historyDetailCell_pendingDebitorActionView_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)historyDetailCell_pendingCreditorAcceptButton_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#187f2c" alpha:1.0f];
}
- (UIColor *)historyDetailCell_pendingCreditorCancelButton_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#720c0c" alpha:1.0f];
}
- (UIColor *)historyDetailCell_pendingDebitorCancelButton_highlighted_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:@"#720c0c" alpha:1.0f];
}

#pragma mark - SuscribeTextViewCell
- (UIColor *)suscribeTextViewCell_textField_textColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)suscribeTextViewCell_textField_placeHolderColor {
	return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)suscribeTextViewCell_lbl_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#171717" alpha:1.0f];
}

#pragma mark - SuscribeTextViewCellSegment
- (UIColor *)suscribeTextViewCellSegment_segmentedControl_tintColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - SuscribeTextViewCellPicker
- (UIColor *)suscribeTextViewCellPicker_textField_backgroundColor {
	return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - RegisterUserViewController
- (UIColor *)registerUserViewController_lblSubNavigation_textColor {
	return [FZUIColorCreateMethods colorWithKey:@"#ffffff" alpha:1.0f];
}
- (UIColor *)registerUserViewController_viewHeader_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}

#pragma mark - CustomTabBarViewController_btnPay_riddleColor
- (UIColor *)customTabBarViewController_btnPay_riddleColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - ProgramTableViewCell
- (UIColor *)programTableViewCell_lblProgramName_odd_textColor {
    return [FZUIColorCreateMethods colorWithKey:@"#383838" alpha:1.0f];
}
- (UIColor *)programTableViewCell_lblProgramName_odd_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)programTableViewCell_lblMerchantName_odd_textColor {
    return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}
- (UIColor *)programTableViewCell_lblMerchantName_odd_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)programTableViewCell_contentView_even_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)programTableViewCell_lblProgramName_even_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)programTableViewCell_lblProgramName_even_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)programTableViewCell_lblMerchantName_even_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)programTableViewCell_lblMerchantName_even_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)programTableViewCell_imageCoupons_even_bacgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)programTableViewCell_imageLogo_even_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)programTableViewCell_lblNumberOfCoupons_even_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)programTableViewCell_lblAmountOfACoupons_even_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)programTableViewCell_viewIndicationsPointsAndPercent_even_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}
- (UIColor *)programTableViewCell_viewIndicationsCoupons_even_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#0cc3b9" alpha:1.0f];
}

#pragma mark - HistoryViewController
- (UIColor *)historyViewController_allButton_borderColor {
    return [FZUIColorCreateMethods colorWithKey:@"#383838" alpha:1.0f];
}
- (UIColor *)historyViewController_allButton_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#383838" alpha:1.0f];
}
- (UIColor *)historyViewController_outputButton_titleColor {
    return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)historyViewController_outputButton_borderColor {
    return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)historyViewController_inputButton_titleColor {
    return [FZUIColorCreateMethods colorWithKey:@"#33b94c" alpha:1.0f];
}
- (UIColor *)historyViewController_inputButton_borderColor {
    return [FZUIColorCreateMethods colorWithKey:@"#33b94c" alpha:1.0f];
}
- (UIColor *)historyViewController_pendingButton_titleColor {
    return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}
- (UIColor *)historyViewController_pendingButton_borderColor {
    return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}
- (UIColor *)historyViewController_contentView_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}
- (UIColor *)historyViewController_header_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}

#pragma mark - TransferReceiveStep1ViewController
- (UIColor *)transferReceiveStep1ViewController_lblYourBalance_textColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)transferReceiveStep1ViewController_lblBalance_textColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)transferReceiveStep1ViewController_header_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferReceiveStep1ViewController_viewDescription_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferReceiveStep1ViewController_lblAmount_textColor {
    return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferReceiveStep1ViewController_lblCurrencyBefore_textColor {
    return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferReceiveStep1ViewController_amountTextField_textColor {
    return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferReceiveStep1ViewController_lblCurrencyAfter_textColor {
    return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}
- (UIColor *)transferReceiveStep1ViewController_lblDescription_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}

#pragma mark - TransferReceiveStep2ViewController
- (UIColor *)transferReceiveStep2ViewController_header_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kTransferOne alpha:1.0f];
}

#pragma mark - ValidatorViewController
- (UIColor *)validatorViewController_view_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)validatorViewController_btnSecond_borderColor {
    return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)validatorViewController_lblFirst_mode1_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode1_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#9d1111" alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode1_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode1_highlighted_titleColor {
    return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode1_highlighted_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#720c0c" alpha:1.0f];
}
- (UIColor *)validatorViewController_lblFirst_mode2_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode2_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#49a9c3" alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode2_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)validatorViewController_btnSecond_mode2_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)validatorViewController_btnSecond_mode2_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)validatorViewController_lblFirst_mode3_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode3_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode3_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)validatorViewController_btnSecond_mode3_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)validatorViewController_btnSecond_mode3_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)validatorViewController_btnSecond_mode2_highlighted_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)validatorViewController_btnSecond_mode2_highlighted_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode3_highlighted_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)validatorViewController_btnFirst_mode3_highlighted_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)validatorViewController_btnSecond_mode3_highlighted_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)validatorViewController_btnSecond_mode3_highlighted_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}

#pragma mark - InitialViewController
- (UIColor *)initialViewController_viewMiddle_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)initialViewController_viewBottom_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)initialViewController_btnCreateAccount_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)initialViewController_btnCreateAccount_highlighted_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)initialViewController_btnLogin_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeThree alpha:1.0f];
}
- (UIColor *)initialViewController_btnCreateAccount_highlighted_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - YourLoyaltyProgramsViewController
- (UIColor *)yourLoyaltyProgramsViewController_tableViewYourPrograms_separatorColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}

#pragma mark - YourLoyaltyProgramDetailsViewController
- (UIColor *)yourLoyaltyProgramDetailsViewController_btnDeleteLoyaltyCard_highlighted_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}

#pragma mark - LoyaltyProgramDetailsViewController
- (UIColor *)loyaltyProgramDetailsViewController_btnSuscribe_highlighted_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kRewardsThree alpha:1.0f];
}

#pragma mark - RegisterResponseViewController
- (UIColor *)registerResponseViewController_btnValidate_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainTwo alpha:1.0f];
}
- (UIColor *)registerResponseViewController_viewValidate_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)registerResponseViewController_btnValidate_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)registerResponseViewController_btnValidate_highlighted_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}
- (UIColor *)registerResponseViewController_btnValidate_highlighted_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMainThree alpha:1.0f];
}
- (UIColor *)registerResponseViewController_viewBottom_unvalid_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}
- (UIColor *)registerResponseViewController_btnValidate_unvalid_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)registerResponseViewController_btnValidate_unvalid_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeOne alpha:1.0f];
}
- (UIColor *)registerResponseViewController_textfield_placeholderColor {
    return [FZUIColorCreateMethods colorWithKey:kMonochromeTwo alpha:1.0f];
}
- (UIColor *)registerResponseViewController_textField_textColor {
    return [FZUIColorCreateMethods colorWithKey:kMainOne alpha:1.0f];
}

#pragma mark - RegisterCaptchaViewController
- (UIColor *)registerCaptchaViewController_btnValidate_bacgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#3d9bb3" alpha:1.0f];
}
- (UIColor *)registerCaptchaViewController_viewBottom_bacgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#48a8c3" alpha:1.0f];
}

#pragma mark - TransferHomeViewController
- (UIColor *)transferHomeViewController_lblReceive_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)transferHomeViewController_lblSend_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}

#pragma mark - ForgottenPasswordSendMailViewController
- (UIColor *)forgottenPasswordSendMailViewController_viewSubNavigation_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#dad9d9" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSendMailViewController_lblSubNavigation_textColor {
    return [FZUIColorCreateMethods colorWithKey:@"#454545" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSendMailViewController_viewBottom_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#efeeee" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#dad9d9" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSendMailViewController_viewBottom_valid_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#4ea9c6" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_valid_titleColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)forgottenPasswordSendMailViewController_btnValidate_valid_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#2f8ca5" alpha:1.0f];
}

#pragma mark - ForgottenPasswordSecretAnswerViewController
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewNavigation_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_lblNavigation_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewQuestion_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#efeeee" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_lblQuestion_textColor {
    return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewBottom_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#efeeee" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_btnValidate_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#dad9d9" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewBottom_valid_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#4ea9c6" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_btnValidate_valid_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#2f8ca5" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_viewBottom_bad_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#ff0013" alpha:1.0f];
}
- (UIColor *)forgottenPasswordSecretAnswerViewController_btnValidate_bad_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#9d1111" alpha:1.0f];
}

#pragma mark - ForgottenPasswordNewPasswordViewController
- (UIColor *)forgottenPasswordNewPasswordViewController_viewNavigation_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:kBlack alpha:1.0f];
}
- (UIColor *)forgottenPasswordNewPasswordViewController_lblNavigation_textColor {
    return [FZUIColorCreateMethods colorWithKey:kWhite alpha:1.0f];
}
- (UIColor *)forgottenPasswordNewPasswordViewController_viewInstructions_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#efeeee" alpha:1.0f];
}
- (UIColor *)forgottenPasswordNewPasswordViewController_lblInstructions_textColor {
    return [FZUIColorCreateMethods colorWithKey:@"#7d7d7d" alpha:1.0f];
}
- (UIColor *)forgottenPasswordNewPasswordViewController_viewBottom_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#efeeee" alpha:1.0f];
}
- (UIColor *)forgottenPasswordNewPasswordViewController_btnValidate_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#dad9d9" alpha:1.0f];
}
- (UIColor *)forgottenPasswordNewPasswordViewController_viewBottom_valid_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#4ea9c6" alpha:1.0f];
}
- (UIColor *)forgottenPasswordNewPasswordViewController_btnValidate_valid_backgroundColor {
    return [FZUIColorCreateMethods colorWithKey:@"#2f8ca5" alpha:1.0f];
}

#pragma mark - AccountBannerViewController
- (UIColor *)accountBannerViewController_lblYourBalance_textColor {
    return [FZUIColorCreateMethods colorWithKey:@"#383838" alpha:1.0f];
}
- (UIColor *)accountBannerViewController_lblCurrentBalance_textColor {
    return [FZUIColorCreateMethods colorWithKey:@"#383838" alpha:1.0f];
}

@end
