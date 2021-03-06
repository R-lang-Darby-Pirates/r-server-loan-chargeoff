
/****** Object:  Table [dbo].[loan_chargeoff_prediction_10k]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan_chargeoff_prediction_10k](
	[loanId] [int] NULL,
	[payment_date] [date] NULL,
	[PredictedLabel] [nvarchar](255) NULL,
	[Score.1] [float] NULL,
	[Probability.1] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_loan_chargeoff_prediction]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vw_loan_chargeoff_prediction]
as
select * from [loan_chargeoff_prediction_10k]
GO
/****** Object:  Table [dbo].[member_info_10k]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[member_info_10k](
	[memberId] [int] NULL,
	[residentialState] [nvarchar](4) NULL,
	[branch] [nvarchar](255) NULL,
	[annualIncome] [real] NULL,
	[yearsEmployment] [nvarchar](11) NULL,
	[homeOwnership] [nvarchar](10) NULL,
	[incomeVerified] [bit] NULL,
	[creditScore] [int] NULL,
	[dtiRatio] [real] NULL,
	[revolvingBalance] [real] NULL,
	[revolvingUtilizationRate] [real] NULL,
	[numDelinquency2Years] [int] NULL,
	[numDerogatoryRec] [int] NULL,
	[numInquiries6Mon] [int] NULL,
	[lengthCreditHistory] [int] NULL,
	[numOpenCreditLines] [int] NULL,
	[numTotalCreditLines] [int] NULL,
	[numChargeoff1year] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[payments_info_10k]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[payments_info_10k](
	[loanId] [int] NULL,
	[payment_date] [date] NULL,
	[payment] [real] NULL,
	[past_due] [real] NULL,
	[remain_balance] [real] NULL,
	[closed] [bit] NULL,
	[charged_off] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[loan_info_10k]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan_info_10k](
	[loanId] [int] NULL,
	[loan_open_date] [datetime] NULL,
	[memberId] [int] NULL,
	[loanAmount] [float] NULL,
	[interestRate] [float] NULL,
	[grade] [int] NULL,
	[term] [int] NULL,
	[installment] [float] NULL,
	[isJointApplication] [int] NULL,
	[purpose] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_loan_chargeoff_train_10k]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_loan_chargeoff_train_10k]
as
select t.loanId, t.payment_date, t.payment, t.past_due, t.remain_balance,
  l.loan_open_date, l.loanAmount,l.interestRate,l.grade,l.term,l.installment,l.isJointApplication,l.purpose,
  m.memberId,m.residentialState,m.branch,m.annualIncome,m.yearsEmployment,m.homeOwnership,m.incomeVerified,m.creditScore,m.dtiRatio,m.revolvingBalance,m.revolvingUtilizationRate,m.numDelinquency2Years,m.numDerogatoryRec,m.numInquiries6Mon,m.lengthCreditHistory,m.numOpenCreditLines,m.numTotalCreditLines,m.numChargeoff1year,
  ISNULL(t.payment_1, 0) payment_1,ISNULL(t.payment_2, 0) payment_2,ISNULL(t.payment_3, 0) payment_3,ISNULL(t.payment_4, 0) payment_4,ISNULL(t.payment_5, 0) payment_5, 
  ISNULL(t.past_due_1, 0) past_due_1,ISNULL(t.past_due_2, 0) past_due_2,ISNULL(t.past_due_3, 0) past_due_3,ISNULL(t.past_due_4, 0) past_due_4,ISNULL(t.past_due_5, 0) past_due_5,
  ISNULL(t.remain_balance_1, 0) remain_balance_1,ISNULL(t.remain_balance_2, 0) remain_balance_2,ISNULL(t.remain_balance_3, 0) remain_balance_3,ISNULL(t.remain_balance_4, 0) remain_balance_4,ISNULL(t.remain_balance_5, 0) remain_balance_5, t.charge_off
from 
(
select *, 
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 1 AND p1.loanId = p2.loanId) payment_1,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 2 AND p1.loanId = p2.loanId) payment_2,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 3 AND p1.loanId = p2.loanId) payment_3,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 4 AND p1.loanId = p2.loanId) payment_4,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 5 AND p1.loanId = p2.loanId) payment_5,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 1 AND p1.loanId = p2.loanId) past_due_1,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 2 AND p1.loanId = p2.loanId) past_due_2,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 3 AND p1.loanId = p2.loanId) past_due_3,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 4 AND p1.loanId = p2.loanId) past_due_4,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 5 AND p1.loanId = p2.loanId) past_due_5,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 1 AND p1.loanId = p2.loanId) remain_balance_1,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 2 AND p1.loanId = p2.loanId) remain_balance_2,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 3 AND p1.loanId = p2.loanId) remain_balance_3,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 4 AND p1.loanId = p2.loanId) remain_balance_4,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 5 AND p1.loanId = p2.loanId) remain_balance_5,
(select MAX(charged_off+0) from payments_info_10k p2 where DATEDIFF(month, p1.payment_date,p2.payment_date) IN (1,2,3) AND p1.loanId = p2.loanId) charge_off
from payments_info_10k p1 ) AS t inner join loan_info_10k l ON t.loanId = l.loanId inner join member_info_10k m ON l.memberId = m.memberId 
where t.charge_off IS NOT NULL
and ((payment_date between '2016-09-12' and '2016-12-12' and charge_off = 1) or (payment_date = '2017-01-12'));
GO
/****** Object:  View [dbo].[vw_loan_chargeoff_test_10k]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_loan_chargeoff_test_10k]
as
select t.loanId, t.payment_date, t.payment, t.past_due, t.remain_balance,
  l.loan_open_date, l.loanAmount,l.interestRate,l.grade,l.term,l.installment,l.isJointApplication,l.purpose,
  m.memberId,m.residentialState,m.branch,m.annualIncome,m.yearsEmployment,m.homeOwnership,m.incomeVerified,m.creditScore,m.dtiRatio,m.revolvingBalance,m.revolvingUtilizationRate,m.numDelinquency2Years,m.numDerogatoryRec,m.numInquiries6Mon,m.lengthCreditHistory,m.numOpenCreditLines,m.numTotalCreditLines,m.numChargeoff1year,
  ISNULL(t.payment_1, 0) payment_1,ISNULL(t.payment_2, 0) payment_2,ISNULL(t.payment_3, 0) payment_3,ISNULL(t.payment_4, 0) payment_4,ISNULL(t.payment_5, 0) payment_5, 
  ISNULL(t.past_due_1, 0) past_due_1,ISNULL(t.past_due_2, 0) past_due_2,ISNULL(t.past_due_3, 0) past_due_3,ISNULL(t.past_due_4, 0) past_due_4,ISNULL(t.past_due_5, 0) past_due_5,
  ISNULL(t.remain_balance_1, 0) remain_balance_1,ISNULL(t.remain_balance_2, 0) remain_balance_2,ISNULL(t.remain_balance_3, 0) remain_balance_3,ISNULL(t.remain_balance_4, 0) remain_balance_4,ISNULL(t.remain_balance_5, 0) remain_balance_5, t.charge_off
from 
(
select *, 
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 1 AND p1.loanId = p2.loanId) payment_1,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 2 AND p1.loanId = p2.loanId) payment_2,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 3 AND p1.loanId = p2.loanId) payment_3,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 4 AND p1.loanId = p2.loanId) payment_4,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 5 AND p1.loanId = p2.loanId) payment_5,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 1 AND p1.loanId = p2.loanId) past_due_1,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 2 AND p1.loanId = p2.loanId) past_due_2,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 3 AND p1.loanId = p2.loanId) past_due_3,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 4 AND p1.loanId = p2.loanId) past_due_4,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 5 AND p1.loanId = p2.loanId) past_due_5,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 1 AND p1.loanId = p2.loanId) remain_balance_1,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 2 AND p1.loanId = p2.loanId) remain_balance_2,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 3 AND p1.loanId = p2.loanId) remain_balance_3,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 4 AND p1.loanId = p2.loanId) remain_balance_4,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 5 AND p1.loanId = p2.loanId) remain_balance_5,
(select MAX(charged_off+0) from payments_info_10k p2 where DATEDIFF(month, p1.payment_date,p2.payment_date) IN (1,2,3) AND p1.loanId = p2.loanId) charge_off
from payments_info_10k p1 ) AS t inner join loan_info_10k l ON t.loanId = l.loanId inner join member_info_10k m ON l.memberId = m.memberId 
where t.charge_off IS NOT NULL
and payment_date = '2017-02-12';
GO
/****** Object:  View [dbo].[vw_loan_chargeoff_score_10k]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_loan_chargeoff_score_10k]
as
select t.loanId, t.payment_date, t.payment, t.past_due, t.remain_balance,
  l.loan_open_date, l.loanAmount,l.interestRate,l.grade,l.term,l.installment,l.isJointApplication,l.purpose,
  m.memberId,m.residentialState,m.branch,m.annualIncome,m.yearsEmployment,m.homeOwnership,m.incomeVerified,m.creditScore,m.dtiRatio,m.revolvingBalance,m.revolvingUtilizationRate,m.numDelinquency2Years,m.numDerogatoryRec,m.numInquiries6Mon,m.lengthCreditHistory,m.numOpenCreditLines,m.numTotalCreditLines,m.numChargeoff1year,
  ISNULL(t.payment_1, 0) payment_1,ISNULL(t.payment_2, 0) payment_2,ISNULL(t.payment_3, 0) payment_3,ISNULL(t.payment_4, 0) payment_4,ISNULL(t.payment_5, 0) payment_5, 
  ISNULL(t.past_due_1, 0) past_due_1,ISNULL(t.past_due_2, 0) past_due_2,ISNULL(t.past_due_3, 0) past_due_3,ISNULL(t.past_due_4, 0) past_due_4,ISNULL(t.past_due_5, 0) past_due_5,
  ISNULL(t.remain_balance_1, 0) remain_balance_1,ISNULL(t.remain_balance_2, 0) remain_balance_2,ISNULL(t.remain_balance_3, 0) remain_balance_3,ISNULL(t.remain_balance_4, 0) remain_balance_4,ISNULL(t.remain_balance_5, 0) remain_balance_5, NULL charge_off
from 
(
select *, 
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 1 AND p1.loanId = p2.loanId) payment_1,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 2 AND p1.loanId = p2.loanId) payment_2,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 3 AND p1.loanId = p2.loanId) payment_3,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 4 AND p1.loanId = p2.loanId) payment_4,
(select top 1 payment from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 5 AND p1.loanId = p2.loanId) payment_5,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 1 AND p1.loanId = p2.loanId) past_due_1,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 2 AND p1.loanId = p2.loanId) past_due_2,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 3 AND p1.loanId = p2.loanId) past_due_3,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 4 AND p1.loanId = p2.loanId) past_due_4,
(select top 1 past_due from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 5 AND p1.loanId = p2.loanId) past_due_5,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 1 AND p1.loanId = p2.loanId) remain_balance_1,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 2 AND p1.loanId = p2.loanId) remain_balance_2,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 3 AND p1.loanId = p2.loanId) remain_balance_3,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 4 AND p1.loanId = p2.loanId) remain_balance_4,
(select top 1 remain_balance from payments_info_10k p2 where DATEDIFF(month, p2.payment_date,p1.payment_date) = 5 AND p1.loanId = p2.loanId) remain_balance_5
from payments_info_10k p1 ) AS t inner join loan_info_10k l ON t.loanId = l.loanId inner join member_info_10k m ON l.memberId = m.memberId 
where payment_date > '2017-02-12';
GO
/****** Object:  Table [dbo].[loan_chargeoff_train_10k]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan_chargeoff_train_10k](
	[loanId] [int] NULL,
	[payment_date] [date] NULL,
	[payment] [real] NULL,
	[past_due] [real] NULL,
	[remain_balance] [real] NULL,
	[loan_open_date] [date] NULL,
	[loanAmount] [real] NULL,
	[interestRate] [real] NULL,
	[grade] [int] NULL,
	[term] [int] NULL,
	[installment] [real] NULL,
	[isJointApplication] [bit] NULL,
	[purpose] [nvarchar](255) NULL,
	[memberId] [int] NULL,
	[residentialState] [nvarchar](4) NULL,
	[branch] [nvarchar](255) NULL,
	[annualIncome] [real] NULL,
	[yearsEmployment] [nvarchar](11) NULL,
	[homeOwnership] [nvarchar](10) NULL,
	[incomeVerified] [bit] NULL,
	[creditScore] [int] NULL,
	[dtiRatio] [real] NULL,
	[revolvingBalance] [real] NULL,
	[revolvingUtilizationRate] [real] NULL,
	[numDelinquency2Years] [int] NULL,
	[numDerogatoryRec] [int] NULL,
	[numInquiries6Mon] [int] NULL,
	[lengthCreditHistory] [int] NULL,
	[numOpenCreditLines] [int] NULL,
	[numTotalCreditLines] [int] NULL,
	[numChargeoff1year] [int] NULL,
	[payment_1] [real] NOT NULL,
	[payment_2] [real] NOT NULL,
	[payment_3] [real] NOT NULL,
	[payment_4] [real] NOT NULL,
	[payment_5] [real] NOT NULL,
	[past_due_1] [real] NOT NULL,
	[past_due_2] [real] NOT NULL,
	[past_due_3] [real] NOT NULL,
	[past_due_4] [real] NOT NULL,
	[past_due_5] [real] NOT NULL,
	[remain_balance_1] [real] NOT NULL,
	[remain_balance_2] [real] NOT NULL,
	[remain_balance_3] [real] NOT NULL,
	[remain_balance_4] [real] NOT NULL,
	[remain_balance_5] [real] NOT NULL,
	[charge_off] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_loan_chargeoff_train]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_loan_chargeoff_train]
as
select * from [loan_chargeoff_train_10k]
GO
/****** Object:  Table [dbo].[loan_chargeoff_score_10k]    Script Date: 3/1/2018 11:12:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan_chargeoff_score_10k](
	[loanId] [int] NULL,
	[payment_date] [date] NULL,
	[payment] [real] NULL,
	[past_due] [real] NULL,
	[remain_balance] [real] NULL,
	[loan_open_date] [date] NULL,
	[loanAmount] [real] NULL,
	[interestRate] [real] NULL,
	[grade] [int] NULL,
	[term] [int] NULL,
	[installment] [real] NULL,
	[isJointApplication] [bit] NULL,
	[purpose] [nvarchar](255) NULL,
	[memberId] [int] NULL,
	[residentialState] [nvarchar](4) NULL,
	[branch] [nvarchar](255) NULL,
	[annualIncome] [real] NULL,
	[yearsEmployment] [nvarchar](11) NULL,
	[homeOwnership] [nvarchar](10) NULL,
	[incomeVerified] [bit] NULL,
	[creditScore] [int] NULL,
	[dtiRatio] [real] NULL,
	[revolvingBalance] [real] NULL,
	[revolvingUtilizationRate] [real] NULL,
	[numDelinquency2Years] [int] NULL,
	[numDerogatoryRec] [int] NULL,
	[numInquiries6Mon] [int] NULL,
	[lengthCreditHistory] [int] NULL,
	[numOpenCreditLines] [int] NULL,
	[numTotalCreditLines] [int] NULL,
	[numChargeoff1year] [int] NULL,
	[payment_1] [real] NOT NULL,
	[payment_2] [real] NOT NULL,
	[payment_3] [real] NOT NULL,
	[payment_4] [real] NOT NULL,
	[payment_5] [real] NOT NULL,
	[past_due_1] [real] NOT NULL,
	[past_due_2] [real] NOT NULL,
	[past_due_3] [real] NOT NULL,
	[past_due_4] [real] NOT NULL,
	[past_due_5] [real] NOT NULL,
	[remain_balance_1] [real] NOT NULL,
	[remain_balance_2] [real] NOT NULL,
	[remain_balance_3] [real] NOT NULL,
	[remain_balance_4] [real] NOT NULL,
	[remain_balance_5] [real] NOT NULL,
	[charge_off] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_loan_chargeoff_score]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_loan_chargeoff_score]
as
select * from [loan_chargeoff_score_10k]
GO
/****** Object:  Table [dbo].[loan_chargeoff_eval_score_10k]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan_chargeoff_eval_score_10k](
	[loanId] [int] NULL,
	[payment_date] [float] NULL,
	[charge_off] [int] NULL,
	[PredictedLabel] [nvarchar](255) NULL,
	[Score.1] [float] NULL,
	[Probability.1] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[loan_chargeoff_models_10k]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan_chargeoff_models_10k](
	[model_name] [nvarchar](30) NOT NULL,
	[training_ts] [datetime] NULL,
	[model] [varbinary](max) NOT NULL,
	[auc] [real] NULL,
	[accuracy] [real] NULL,
	[precision] [real] NULL,
	[recall] [real] NULL,
	[f1score] [real] NULL,
	[selected_features] [nvarchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[model_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[loan_chargeoff_prediction_10k_R]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan_chargeoff_prediction_10k_R](
	[loanId] [int] NULL,
	[payment_date] [float] NULL,
	[PredictedLabel] [nvarchar](255) NULL,
	[Score.1] [float] NULL,
	[Probability.1] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[loan_chargeoff_test_10k]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan_chargeoff_test_10k](
	[loanId] [int] NULL,
	[payment_date] [date] NULL,
	[payment] [real] NULL,
	[past_due] [real] NULL,
	[remain_balance] [real] NULL,
	[loan_open_date] [date] NULL,
	[loanAmount] [real] NULL,
	[interestRate] [real] NULL,
	[grade] [int] NULL,
	[term] [int] NULL,
	[installment] [real] NULL,
	[isJointApplication] [bit] NULL,
	[purpose] [nvarchar](255) NULL,
	[memberId] [int] NULL,
	[residentialState] [nvarchar](4) NULL,
	[branch] [nvarchar](255) NULL,
	[annualIncome] [real] NULL,
	[yearsEmployment] [nvarchar](11) NULL,
	[homeOwnership] [nvarchar](10) NULL,
	[incomeVerified] [bit] NULL,
	[creditScore] [int] NULL,
	[dtiRatio] [real] NULL,
	[revolvingBalance] [real] NULL,
	[revolvingUtilizationRate] [real] NULL,
	[numDelinquency2Years] [int] NULL,
	[numDerogatoryRec] [int] NULL,
	[numInquiries6Mon] [int] NULL,
	[lengthCreditHistory] [int] NULL,
	[numOpenCreditLines] [int] NULL,
	[numTotalCreditLines] [int] NULL,
	[numChargeoff1year] [int] NULL,
	[payment_1] [real] NOT NULL,
	[payment_2] [real] NOT NULL,
	[payment_3] [real] NOT NULL,
	[payment_4] [real] NOT NULL,
	[payment_5] [real] NOT NULL,
	[past_due_1] [real] NOT NULL,
	[past_due_2] [real] NOT NULL,
	[past_due_3] [real] NOT NULL,
	[past_due_4] [real] NOT NULL,
	[past_due_5] [real] NOT NULL,
	[remain_balance_1] [real] NOT NULL,
	[remain_balance_2] [real] NOT NULL,
	[remain_balance_3] [real] NOT NULL,
	[remain_balance_4] [real] NOT NULL,
	[remain_balance_5] [real] NOT NULL,
	[charge_off] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[loan_info_100k]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loan_info_100k](
	[loanId] [int] NULL,
	[loan_open_date] [date] NULL,
	[memberId] [int] NULL,
	[loanAmount] [real] NULL,
	[interestRate] [real] NULL,
	[grade] [int] NULL,
	[term] [int] NULL,
	[installment] [real] NULL,
	[isJointApplication] [bit] NULL,
	[purpose] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[member_info_100k]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[member_info_100k](
	[memberId] [int] NULL,
	[residentialState] [nvarchar](4) NULL,
	[branch] [nvarchar](255) NULL,
	[annualIncome] [real] NULL,
	[yearsEmployment] [nvarchar](11) NULL,
	[homeOwnership] [nvarchar](10) NULL,
	[incomeVerified] [bit] NULL,
	[creditScore] [int] NULL,
	[dtiRatio] [real] NULL,
	[revolvingBalance] [real] NULL,
	[revolvingUtilizationRate] [real] NULL,
	[numDelinquency2Years] [int] NULL,
	[numDerogatoryRec] [int] NULL,
	[numInquiries6Mon] [int] NULL,
	[lengthCreditHistory] [int] NULL,
	[numOpenCreditLines] [int] NULL,
	[numTotalCreditLines] [int] NULL,
	[numChargeoff1year] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[payments_info_100k]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[payments_info_100k](
	[loanId] [int] NULL,
	[payment_date] [date] NULL,
	[payment] [real] NULL,
	[past_due] [real] NULL,
	[remain_balance] [real] NULL,
	[closed] [bit] NULL,
	[charged_off] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[loan_chargeoff_models_10k] ADD  DEFAULT ('default model') FOR [model_name]
GO
ALTER TABLE [dbo].[loan_chargeoff_models_10k] ADD  DEFAULT (getdate()) FOR [training_ts]
GO
/****** Object:  StoredProcedure [dbo].[Initial_Run_Once_R]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Initial_Run_Once_R]

as


DECLARE
@trainingTable varchar(100) = 'loan_chargeoff_train_10k',
@testTable varchar(100) = 'loan_chargeoff_test_10k',
@evalScoreTable varchar(100) = 'loan_chargeoff_eval_score_10k',
@scoreTable varchar(100) = 'loan_chargeoff_score_10k',
@modelTable varchar(100) = 'loan_chargeoff_models_10k',
@predictionTable varchar(100) = 'loan_chargeoff_prediction_10k',
@selectedFeaturesTable varchar(100) = 'selected_features_10k',
@dbName varchar(100) =  (SELECT DB_Name()),
@ModelName varchar(100),
@ConnectionString varchar(100)  = 'Driver=SQL Server;Server=LOCALHOST;Database=<dbName>;Trusted_Connection=True;'


SET @ConnectionString = REPLACE(@ConnectionString,'<dbName>',@dbName)


TRUNCATE TABLE dbo.loan_chargeoff_train_10k INSERT INTO dbo.loan_chargeoff_train_10k SELECT * FROM dbo.vw_loan_chargeoff_train_10k

TRUNCATE TABLE loan_chargeoff_test_10k INSERT INTO dbo.loan_chargeoff_test_10k SELECT * FROM dbo.vw_loan_chargeoff_test_10k

TRUNCATE TABLE loan_chargeoff_score_10k INSERT INTO dbo.loan_chargeoff_score_10k SELECT * FROM dbo.vw_loan_chargeoff_score_10k



EXEC train_model @trainingTable, @testTable, @evalScoreTable, @modelTable, 'logistic_reg',  @ConnectionString

EXEC train_model @trainingTable, @testTable, @evalScoreTable, @modelTable, 'fast_linear',  @ConnectionString

EXEC train_model @trainingTable, @testTable, @evalScoreTable, @modelTable, 'fast_trees',  @ConnectionString

EXEC train_model @trainingTable, @testTable, @evalScoreTable, @modelTable, 'fast_forest',  @ConnectionString

EXEC train_model @trainingTable, @testTable, @evalScoreTable, @modelTable, 'neural_net',  @ConnectionString


SET @ModelName = (select top 1 model_name from loan_chargeoff_models_10k where f1score in (select max(f1score) from loan_chargeoff_models_10k))

EXEC predict_chargeoff @scoreTable, @predictionTable, @modelTable
GO
/****** Object:  StoredProcedure [dbo].[predict_chargeoff]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
 * Stored Procedure to do batch scoring using the 'best model' based on f1score.
 * Parameters:
 *            @score_table - Table with data to score/make prediction on
 *            @score_prediction_table - Table to store predictions
 *            @models_table - Table which has serialized binary models stored along with evaluation stats (during training step)
 *            @connectionString - connection string to connect to the database for use in the R script
 */
CREATE PROCEDURE [dbo].[predict_chargeoff] @score_table nvarchar(100), @score_prediction_table nvarchar(100), @models_table nvarchar(100)

AS
BEGIN

    DECLARE @best_model_query nvarchar(300), @param_def nvarchar(100), @spees_model_param_def nvarchar(100)
    DECLARE @bestmodel varbinary(max)
    DECLARE @ins_cmd nvarchar(max)
    DECLARE @inquery nvarchar(max) = N'SELECT * from ' + @score_table
    SET @best_model_query = 'select top 1 @p_best_model = model from ' + @models_table + ' where f1score in (select max(f1score) from ' + @models_table + ')'
    SET @param_def = N'@p_best_model varbinary(max) OUTPUT';

    EXEC sp_executesql @best_model_query, @param_def, @p_best_model=@bestmodel OUTPUT;

    SET @spees_model_param_def = N'@p_bestmodel varbinary(max)'
    SET @ins_cmd = 'INSERT INTO ' + @score_prediction_table + ' ([loanId], [payment_date], [PredictedLabel], [Score.1], [Probability.1])
    EXEC sp_execute_external_script @language = N''R'',
                    @script = N''
library(RevoScaleR)
library(MicrosoftML)
# Get best_model.
best_model <- unserialize(best_model_raw)
i <- sapply(InputDataSet, is.factor)
InputDataSet[i] <- lapply(InputDataSet[i], as.character)

OutputDataSet <- rxPredict(best_model, InputDataSet, extraVarsToWrite = c("loanId", "payment_date"), overwrite=TRUE)
OutputDataSet$payment_date = as.POSIXct(OutputDataSet$payment_date, origin="1970-01-01")
''
, @input_data_1 = N''' + @inquery + '''' +
', @params = N''@r_rowsPerRead int, @best_model_raw varbinary(max), @score_set nvarchar(100), @score_prediction nvarchar(100)'' 
, @best_model_raw = @p_bestmodel
, @r_rowsPerRead = 10000
, @score_set = N''' + @score_table + '''' +
', @score_prediction = N''' + @score_prediction_table + ''';';

EXEC sp_executeSQL @ins_cmd, @spees_model_param_def, @p_bestmodel = @bestmodel;
END
GO
/****** Object:  StoredProcedure [dbo].[predict_chargeoff_ondemand]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[predict_chargeoff_ondemand]
    @models_table nvarchar(100),
    @loanId int,
    @payment_date date,
    @payment real,
    @past_due real,
    @remain_balance real,
    @loan_open_date date,
    @loanAmount real,
    @interestRate real,
    @grade int,
    @term int,
    @installment real,
    @isJointApplication bit,
    @purpose nvarchar(255),
    @memberId int,
    @residentialState nvarchar(4),
    @branch nvarchar(255),
    @annualIncome real,
    @yearsEmployment nvarchar(11),
    @homeOwnership nvarchar(10),
    @incomeVerified bit,
    @creditScore int,
    @dtiRatio real,
    @revolvingBalance real,
    @revolvingUtilizationRate real,
    @numDelinquency2Years int,
    @numDerogatoryRec int,
    @numInquiries6Mon int,
    @lengthCreditHistory int,
    @numOpenCreditLines int,
    @numTotalCreditLines int,
    @numChargeoff1year int,
    @payment_1 real,
    @payment_2 real,
    @payment_3 real,
    @payment_4 real,
    @payment_5 real,
    @past_due_1 real,
    @past_due_2 real,
    @past_due_3 real,
    @past_due_4 real,
    @past_due_5 real,
    @remain_balance_1 real,
    @remain_balance_2 real,
    @remain_balance_3 real,
    @remain_balance_4 real,
    @remain_balance_5 real

AS
BEGIN

    DECLARE @best_model_query nvarchar(300), @param_def nvarchar(100)
    DECLARE @bestmodel varbinary(max)
    SET @best_model_query = 'select top 1 @p_best_model = model from ' + @models_table + ' where f1score in (select max(f1score) from ' + @models_table + ')'
    SET @param_def = N'@p_best_model varbinary(max) OUTPUT';
    EXEC sp_executesql @best_model_query, @param_def, @p_best_model=@bestmodel OUTPUT;
    DECLARE @inquery nvarchar(max) = N'SELECT @p_loanId  loanId 
      ,@p_payment_date payment_date
      ,@p_payment payment
      ,@p_past_due past_due
      ,@p_remain_balance remain_balance
      ,@p_loan_open_date loan_open_date
      ,@p_loanAmount loanAmount
      ,@p_interestRate interestRate
      ,@p_grade grade
      ,@p_term term
      ,@p_installment installment
      ,@p_isJointApplication isJointApplication
      ,@p_purpose purpose
      ,@p_memberId memberId
      ,@p_residentialState residentialState
      ,@p_branch branch
      ,@p_annualIncome annualIncome
      ,@p_yearsEmployment yearsEmployment
      ,@p_homeOwnership homeOwnership
      ,@p_incomeVerified incomeVerified
      ,@p_creditScore creditScore
      ,@p_dtiRatio dtiRatio
      ,@p_revolvingBalance revolvingBalance
      ,@p_revolvingUtilizationRate revolvingUtilizationRate
      ,@p_numDelinquency2Years numDelinquency2Years
      ,@p_numDerogatoryRec numDerogatoryRec
      ,@p_numInquiries6Mon numInquiries6Mon
      ,@p_lengthCreditHistory lengthCreditHistory
      ,@p_numOpenCreditLines numOpenCreditLines
      ,@p_numTotalCreditLines numTotalCreditLines
      ,@p_numChargeoff1year numChargeoff1year
      ,@p_payment_1 payment_1
      ,@p_payment_2 payment_2
      ,@p_payment_3 payment_3
      ,@p_payment_4 payment_4
      ,@p_payment_5 payment_5
      ,@p_past_due_1 past_due_1
      ,@p_past_due_2 past_due_2
      ,@p_past_due_3 past_due_3
      ,@p_past_due_4 past_due_4
      ,@p_past_due_5 past_due_5
      ,@p_remain_balance_1 remain_balance_1
      ,@p_remain_balance_2 remain_balance_2
      ,@p_remain_balance_3 remain_balance_3
      ,@p_remain_balance_4 remain_balance_4
      ,@p_remain_balance_5 remain_balance_5'
      
    EXEC sp_execute_external_script @language = N'R',
                    @script = N'
library(RevoScaleR)
library(MicrosoftML)
# Get best_model.
best_model <- unserialize(best_model)
# rxPredict has an issue currently where it needs the label column in source data set, working around for that
InputDataSet <- cbind(InputDataSet, charge_off=c(as.integer(NA)))
# convert implicit factors in InputDataSet to character as mlTransforms in the model for categorical variables do not like factors
i <- sapply(InputDataSet, is.factor)
InputDataSet[i] <- lapply(InputDataSet[i], as.character)
OutputDataSet <- rxPredict(best_model, InputDataSet, outData = NULL, extraVarsToWrite = c("loanId", "payment_date"))
# MicrosoftML has a known issue where it converts the date type to numeric which then gets translated as float by SQL Server
OutputDataSet$payment_date = as.POSIXct(OutputDataSet$payment_date, origin="1970-01-01")
'
, @input_data_1 = @inquery
, @params = N'@best_model varbinary(max), 
              @p_loanId int,
              @p_payment_date date,
              @p_payment real,
              @p_past_due real,
              @p_remain_balance real,
              @p_loan_open_date date,
              @p_loanAmount real,
              @p_interestRate real,
              @p_grade int,
              @p_term int,
              @p_installment real,
              @p_isJointApplication bit,
              @p_purpose nvarchar(255),
              @p_memberId int,
              @p_residentialState nvarchar(4),
              @p_branch nvarchar(255),
              @p_annualIncome real,
              @p_yearsEmployment nvarchar(11),
              @p_homeOwnership nvarchar(10),
              @p_incomeVerified bit,
              @p_creditScore int,
              @p_dtiRatio real,
              @p_revolvingBalance real,
              @p_revolvingUtilizationRate real,
              @p_numDelinquency2Years int,
              @p_numDerogatoryRec int,
              @p_numInquiries6Mon int,
              @p_lengthCreditHistory int,
              @p_numOpenCreditLines int,
              @p_numTotalCreditLines int,
              @p_numChargeoff1year int,
              @p_payment_1 real,
              @p_payment_2 real,
              @p_payment_3 real,
              @p_payment_4 real,
              @p_payment_5 real,
              @p_past_due_1 real,
              @p_past_due_2 real,
              @p_past_due_3 real,
              @p_past_due_4 real,
              @p_past_due_5 real,
              @p_remain_balance_1 real,
              @p_remain_balance_2 real,
              @p_remain_balance_3 real,
              @p_remain_balance_4 real,
              @p_remain_balance_5 real'
, @p_loanId=@loanId
, @p_payment_date=@payment_date
, @p_payment=@payment
, @p_past_due=@past_due
, @p_remain_balance=@remain_balance
, @p_loan_open_date=@loan_open_date
, @p_loanAmount=@loanAmount
, @p_interestRate=@interestRate
, @p_grade=@grade
, @p_term=@term
, @p_installment=@installment
, @p_isJointApplication=@isJointApplication
, @p_purpose=@purpose
, @p_memberId=@memberId
, @p_residentialState=@residentialState
, @p_branch=@branch
, @p_annualIncome=@annualIncome
, @p_yearsEmployment=@yearsEmployment
, @p_homeOwnership=@homeOwnership
, @p_incomeVerified=@incomeVerified
, @p_creditScore=@creditScore
, @p_dtiRatio=@dtiRatio
, @p_revolvingBalance=@revolvingBalance
, @p_revolvingUtilizationRate=@revolvingUtilizationRate
, @p_numDelinquency2Years=@numDelinquency2Years
, @p_numDerogatoryRec=@numDerogatoryRec
, @p_numInquiries6Mon=@numInquiries6Mon
, @p_lengthCreditHistory=@lengthCreditHistory
, @p_numOpenCreditLines=@numOpenCreditLines
, @p_numTotalCreditLines=@numTotalCreditLines
, @p_numChargeoff1year=@numChargeoff1year
, @p_payment_1=@payment_1
, @p_payment_2=@payment_2
, @p_payment_3=@payment_3
, @p_payment_4=@payment_4
, @p_payment_5=@payment_5
, @p_past_due_1=@past_due_1
, @p_past_due_2=@past_due_2
, @p_past_due_3=@past_due_3
, @p_past_due_4=@past_due_4
, @p_past_due_5=@past_due_5
, @p_remain_balance_1=@remain_balance_1
, @p_remain_balance_2=@remain_balance_2
, @p_remain_balance_3=@remain_balance_3
, @p_remain_balance_4=@remain_balance_4
, @p_remain_balance_5=@remain_balance_5
, @best_model = @bestmodel
WITH RESULT SETS (("loanId" int not null, "payment_date" date not null, "PredictedLabel" int not null, "Score.1" float not null, "Probability.1" float not null))
;
END
GO
/****** Object:  StoredProcedure [dbo].[train_model]    Script Date: 3/1/2018 11:12:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
 * Stored Procedure for training of models using MicrosoftML algorithms. This also evaluates the models and stores
 * the following stats along with serialized model binary, accuracy, auc, precision, recall, f1score.
 * The parameters can be tuned for various algorithms based on performance on your data.
 * Parameters:
 *            @training_set_table - training data table name
 *            @test_set_table - test data table name for model evaluation
 *            @scored_table - table to store scores in when doing model evaluation
 *            @model_table - table to store model in serialized binary format along with evaluation stats
 *            @model_alg - the algorithm to use for training the model.
 *                         Can be one of 'logistic_reg', 'fast_trees', 'fast_forest', 'fast_linear', 'neural_net'
 *            @connectionString - connection string to connect to the database for use in the R script
 */
CREATE PROCEDURE [dbo].[train_model] @training_set_table nvarchar(100), @test_set_table nvarchar(100), @scored_table nvarchar(100), @model_table nvarchar(100), @model_alg nvarchar(50), @connectionString nvarchar(300)
AS 
BEGIN

    DECLARE @payload varbinary(max), @selected_features nvarchar(1000), @auc real, @accuracy real, @precision real, @recall real, @f1score real;
    DECLARE @del_cmd nvarchar(300), @ins_cmd nvarchar(300), @param_def nvarchar(300);
    EXECUTE sp_execute_external_script @language = N'R',
                       @script = N' 
library(RevoScaleR)
library(MicrosoftML)
# model evaluation functions
model_eval_stats <- function(scored_data, label="charge_off", predicted_prob="Probability", predicted_label="PredictedLabel")
{
  roc <- rxRoc(label, grep(predicted_prob, names(scored_data), value=T), scored_data)
  auc <- rxAuc(roc)
  crosstab_formula <- as.formula(paste("~as.factor(", label, "):as.factor(", predicted_label, ")"))
  cross_tab <- rxCrossTabs(crosstab_formula, scored_data)
  conf_matrix <- cross_tab$counts[[1]]
  tn <- conf_matrix[1,1]
  fp <- conf_matrix[1,2]
  fn <- conf_matrix[2,1]
  tp <- conf_matrix[2,2]
  accuracy <- (tp + tn) / (tp + fn + fp + tn)
  precision <- tp/(tp+fp)
  recall <- tp / (tp+fn)
  f1score <- 2 * (precision * recall) / (precision + recall)
  return(list(auc=auc, accuracy=accuracy, precision = precision, recall=recall, f1score=f1score))
}
cc <- RxInSqlServer(connectionString = connection_string)
rxSetComputeContext(cc)
training_set <- RxSqlServerData(table=train_set, connectionString = connection_string)
testing_set <- RxSqlServerData(table=test_set, connectionString = connection_string)
scoring_set <- RxSqlServerData(table=score_set, connectionString = connection_string, overwrite=TRUE)
##########################################################################################################################################
## Training and evaluating model based on model selection
##########################################################################################################################################
features <- rxGetVarNames(training_set)
vars_to_remove <- c("memberId", "loanId", "payment_date", "loan_open_date", "charge_off")
feature_names <- features[!(features %in% vars_to_remove)]
model_formula <- as.formula(paste(paste("charge_off~"), paste(feature_names, collapse = "+")))
ml_trans <- list(categorical(vars = c("purpose", "residentialState", "branch", "homeOwnership", "yearsEmployment")),
                 selectFeatures(model_formula, mode = mutualInformation(numFeaturesToKeep = 100)))

if (model_name == "logistic_reg") {
    model <- rxLogisticRegression(formula = model_formula,
                      data = training_set,
                     mlTransforms = ml_trans)
} else if (model_name == "fast_trees") {
    model <- rxFastTrees(formula = model_formula,
                      data = training_set,
                     mlTransforms = ml_trans)
} else if (model_name == "fast_forest") {
    model <- rxFastForest(formula = model_formula,
                      data = training_set,
                     mlTransforms = ml_trans)
} else if (model_name == "fast_linear") {
    model <- rxFastLinear(formula = model_formula,
                      data = training_set,
                     mlTransforms = ml_trans)
} else if (model_name == "neural_net") {
    model <- rxNeuralNet(formula = model_formula,
                      data = training_set,
                     numIterations = 42,
                     optimizer = adaDeltaSgd(),
                     mlTransforms = ml_trans)
}
print("Done training.")

# selected features
features_to_remove <- c("(Bias)")
selected_features <- rxGetVarInfo(summary(model)$summary)
selected_feature_names <- names(selected_features)
selected_feature_filtered <- selected_feature_names[!(selected_feature_names %in% features_to_remove)]
selected_features_str <- paste(selected_feature_filtered, collapse=",")

# evaluate model
rxPredict(model, testing_set, outData = scoring_set, extraVarsToWrite = c("loanId", "payment_date", "charge_off"), overwrite=TRUE)
print("Done writing predictions for evaluation of model.")
model_stats <- model_eval_stats(scoring_set)
print(model_stats)
modelbin <- serialize(model, connection=NULL)
stat_auc <- model_stats[[1]]

stat_accuracy <- model_stats[[2]]
stat_precision <- model_stats[[3]]
stat_recall <- model_stats[[4]]
stat_f1score <- model_stats[[5]]
'
, @params = N'@model_name nvarchar(50), @connection_string nvarchar(300), @train_set nvarchar(100), @test_set nvarchar(100), @score_set nvarchar(100),
            @modelbin varbinary(max) OUTPUT, @selected_features_str nvarchar(1000) OUTPUT, @stat_auc real OUTPUT, @stat_accuracy real OUTPUT, @stat_precision real OUTPUT, @stat_recall real OUTPUT, @stat_f1score real OUTPUT'
, @model_name = @model_alg
, @connection_string = @connectionString
, @train_set = @training_set_table
, @test_set = @test_set_table
, @score_set = @scored_table
, @modelbin = @payload OUTPUT
, @selected_features_str = @selected_features OUTPUT
, @stat_auc = @auc OUTPUT
, @stat_accuracy = @accuracy OUTPUT
, @stat_precision = @precision OUTPUT
, @stat_recall = @recall OUTPUT
, @stat_f1score = @f1score OUTPUT;

SET @del_cmd = N'DELETE FROM ' + @model_table + N' WHERE model_name = ''' + @model_alg + ''''
EXEC sp_executesql @del_cmd;
SET @ins_cmd = N'INSERT INTO ' + @model_table + N' (model_name, model, selected_features, auc, accuracy, precision, recall, f1score) VALUES (''' + @model_alg + ''', @p_payload, @p_selected_features, @p_auc, @p_accuracy, @p_precision, @p_recall, @p_f1score)'
SET @param_def = N'@p_payload varbinary(max),
                   @p_selected_features nvarchar(1000),
                   @p_auc real,
                   @p_accuracy real,
                   @p_precision real,
                   @p_recall real,
                   @p_f1score real'
EXEC sp_executesql @ins_cmd, @param_def, 
                                @p_payload=@payload,
                                @p_selected_features=@selected_features,
                                @p_auc=@auc,
                                @p_accuracy=@accuracy,
                                @p_precision=@precision,
                                @p_recall=@recall,
                                @p_f1score=@f1score;

;
END
GO
