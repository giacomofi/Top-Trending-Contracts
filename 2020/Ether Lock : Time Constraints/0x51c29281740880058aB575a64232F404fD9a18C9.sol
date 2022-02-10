['/*\n', ' * \n', ' *   Bank Of Ethereum - investment platform based on ETH blockchain smart-contract technology. Safe and legit!\n', ' *\n', ' *   ┌───────────────────────────────────────────────────────────────────────┐  \n', ' *   │   Website: https://bankofethereum.org                                 │\n', ' *   │                                                                       │  \n', ' *   │   Telegram Support Account: https://t.me/bankofethereum_support       |\n', ' *   │   Telegram Public Group: https://t.me/bankofethereum_group            |\n', ' *   │   Telegram News Channel: https://t.me/bankofethereum_news             |\n', ' *   |                                                                       |\n', ' *   |   Twitter: https://twitter.com/BankEthereum                           |\n', ' *   |   E-mail: support@bankofethereum.org                                  |\n', ' *   └───────────────────────────────────────────────────────────────────────┘ \n', ' *\n', ' *   [USAGE INSTRUCTION]\n', ' *\n', ' *   1) Connect using ETH browser extension MetaMask or the MetaMask/Coinbase wallet mobile app .\n', ' *   2) Send any ETH amount (0.05 minimum) using our website invest button.\n', ' *   3) Wait for your earnings.\n', ' *   4) Withdraw earnings any time using our website "Withdraw" button.\n', ' *\n', ' *   [INVESTMENT CONDITIONS]\n', ' * \n', ' *   - Basic interest rate: +1% every 24 hours (+0.0416% hourly)\n', ' *   - Personal hold-bonus: +0.1% for every 24 hours without withdraw \n', ' *   - Contract total amount bonus: +0.1% for every 100 ETH on platform address balance \n', ' * \n', ' *   - Minimal deposit: 0.05 ETH, no maximal limit\n', ' *   - Total income: 200% (deposit included)\n', ' *   - Earnings every moment, withdraw any time\n', ' * \n', ' *   [AFFILIATE PROGRAM]\n', ' *\n', ' *   Share your referral link with your partners and get additional bonuses.\n', ' *   - 3-level referral commission: 5% - 2% - 0.5%\n', ' *\n', ' *   [FUNDS DISTRIBUTION]\n', ' *\n', ' *   - 82.5% Platform main balance, participants payouts\n', ' *   - 8% Advertising and promotion expenses\n', ' *   - 7.5% Affiliate program bonuses\n', ' *   - 2% Support work, technical functioning, administration fee\n', ' *\n', ' *   ────────────────────────────────────────────────────────────────────────\n', ' *\n', ' * \n', ' *\n', ' *\n', ' */\n', '\n', 'pragma solidity 0.5.10;\n', '\n', 'contract BankOfEthereum {\n', '\tusing SafeMath for uint256;\n', '\tuint256 constant public INVEST_MIN_AMOUNT = 0.05 ether;\n', '\tuint256 constant public BASE_PERCENT = 10;\n', '\tuint256[] public REFERRAL_PERCENTS = [50, 20, 5];\n', '\tuint256 constant public MARKETING_FEE = 80;\n', '\tuint256 constant public PROJECT_FEE = 20;\n', '\tuint256 constant public PERCENTS_DIVIDER = 1000;\n', '\tuint256 constant public CONTRACT_BALANCE_STEP = 100 ether;\n', '\tuint256 constant public TIME_STEP = 1 days;\n', '\n', '\tuint256 public totalUsers;\n', '\tuint256 public totalInvested;\n', '\tuint256 public totalWithdrawn;\n', '\tuint256 public totalDeposits;\n', '\n', '\taddress payable public marketingAddress;\n', '\taddress payable public adminAddress;\n', '\n', '\tstruct Deposit {\n', '\t\tuint256 amount;\n', '\t\tuint256 withdrawn;\n', '\t\tuint256 start;\n', '\t}\n', '\n', '\tstruct User {\n', '\t\tDeposit[] deposits;\n', '\t\tuint256 checkpoint;\n', '\t\taddress referrer;\n', '\t\tuint256 bonus;\n', '\t\tuint256 level1;\n', '\t\tuint256 level2;\n', '\t\tuint256 level3;\n', '\t}\n', '\n', '\tmapping (address => User) internal users;\n', '\n', '\tevent Newbie(address user);\n', '\tevent NewDeposit(address indexed user, uint256 amount);\n', '\tevent Withdrawn(address indexed user, uint256 amount);\n', '\tevent RefBonus(address indexed referrer, address indexed referral, uint256 indexed level, uint256 amount);\n', '\tevent FeePayed(address indexed user, uint256 totalAmount);\n', '\n', '\tconstructor(address payable marketingAddr, address payable adminAddr) public {\n', '\t\trequire(!isContract(marketingAddr) && !isContract(adminAddr));\n', '\t\tmarketingAddress = marketingAddr;\n', '\t\tadminAddress = adminAddr;\n', '\t}\n', '\n', '\tfunction invest(address referrer) public payable {\n', '\t\trequire(msg.value >= INVEST_MIN_AMOUNT);\n', '\n', '\t\tmarketingAddress.transfer(msg.value.mul(MARKETING_FEE).div(PERCENTS_DIVIDER));\n', '\t\tadminAddress.transfer(msg.value.mul(PROJECT_FEE).div(PERCENTS_DIVIDER));\n', '\t\temit FeePayed(msg.sender, msg.value.mul(MARKETING_FEE.add(PROJECT_FEE)).div(PERCENTS_DIVIDER));\n', '\n', '\t\tUser storage user = users[msg.sender];\n', '\t\t\n', '\t\tif (user.referrer == address(0) && users[referrer].deposits.length > 0 && referrer != msg.sender) {\n', '\t\t\tuser.referrer = referrer;\n', '\t\t}\n', '\n', '\t\tif (user.referrer != address(0)) {\n', '\n', '\t\t\taddress upline = user.referrer;\n', '\t\t\tfor (uint256 i = 0; i < 3; i++) {\n', '\t\t\t\tif (upline != address(0)) {\n', '\t\t\t\t\tuint256 amount = msg.value.mul(REFERRAL_PERCENTS[i]).div(PERCENTS_DIVIDER);\n', '\t\t\t\t\tusers[upline].bonus = users[upline].bonus.add(amount);\n', '\t\t\t\t\tif(i == 0){\n', '\t\t\t\t\t\tusers[upline].level1 = users[upline].level1.add(1);\t\n', '\t\t\t\t\t} else if(i == 1){\n', '\t\t\t\t\t\tusers[upline].level2 = users[upline].level2.add(1);\t\n', '\t\t\t\t\t} else if(i == 2){\n', '\t\t\t\t\t\tusers[upline].level3 = users[upline].level3.add(1);\t\n', '\t\t\t\t\t}\n', '\t\t\t\t\temit RefBonus(upline, msg.sender, i, amount);\n', '\t\t\t\t\tupline = users[upline].referrer;\n', '\t\t\t\t} else break;\n', '\t\t\t}\n', '\n', '\t\t}\n', '\n', '\t\tif (user.deposits.length == 0) {\n', '\t\t\tuser.checkpoint = block.timestamp;\n', '\t\t\ttotalUsers = totalUsers.add(1);\n', '\t\t\temit Newbie(msg.sender);\n', '\t\t}\n', '\n', '\t\tuser.deposits.push(Deposit(msg.value, 0, block.timestamp));\n', '\n', '\t\ttotalInvested = totalInvested.add(msg.value);\n', '\t\ttotalDeposits = totalDeposits.add(1);\n', '\n', '\t\temit NewDeposit(msg.sender, msg.value);\n', '\n', '\t}\n', '\n', '\tfunction withdraw() public {\n', '\t\tUser storage user = users[msg.sender];\n', '\n', '\t\tuint256 userPercentRate = getUserPercentRate(msg.sender);\n', '\n', '\t\tuint256 totalAmount;\n', '\t\tuint256 dividends;\n', '\n', '\t\tfor (uint256 i = 0; i < user.deposits.length; i++) {\n', '\n', '\t\t\tif (user.deposits[i].withdrawn < user.deposits[i].amount.mul(2)) {\n', '\n', '\t\t\t\tif (user.deposits[i].start > user.checkpoint) {\n', '\n', '\t\t\t\t\tdividends = (user.deposits[i].amount.mul(userPercentRate).div(PERCENTS_DIVIDER))\n', '\t\t\t\t\t\t.mul(block.timestamp.sub(user.deposits[i].start))\n', '\t\t\t\t\t\t.div(TIME_STEP);\n', '\n', '\t\t\t\t} else {\n', '\n', '\t\t\t\t\tdividends = (user.deposits[i].amount.mul(userPercentRate).div(PERCENTS_DIVIDER))\n', '\t\t\t\t\t\t.mul(block.timestamp.sub(user.checkpoint))\n', '\t\t\t\t\t\t.div(TIME_STEP);\n', '\n', '\t\t\t\t}\n', '\n', '\t\t\t\tif (user.deposits[i].withdrawn.add(dividends) > user.deposits[i].amount.mul(2)) {\n', '\t\t\t\t\tdividends = (user.deposits[i].amount.mul(2)).sub(user.deposits[i].withdrawn);\n', '\t\t\t\t}\n', '\n', '\t\t\t\tuser.deposits[i].withdrawn = user.deposits[i].withdrawn.add(dividends); /// changing of storage data\n', '\t\t\t\ttotalAmount = totalAmount.add(dividends);\n', '\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tuint256 referralBonus = getUserReferralBonus(msg.sender);\n', '\t\tif (referralBonus > 0) {\n', '\t\t\ttotalAmount = totalAmount.add(referralBonus);\n', '\t\t\tuser.bonus = 0;\n', '\t\t}\n', '\n', '\t\trequire(totalAmount > 0, "User has no dividends");\n', '\n', '\t\tuint256 contractBalance = address(this).balance;\n', '\t\tif (contractBalance < totalAmount) {\n', '\t\t\ttotalAmount = contractBalance;\n', '\t\t}\n', '\n', '\t\tuser.checkpoint = block.timestamp;\n', '\n', '\t\tmsg.sender.transfer(totalAmount);\n', '\n', '\t\ttotalWithdrawn = totalWithdrawn.add(totalAmount);\n', '\n', '\t\temit Withdrawn(msg.sender, totalAmount);\n', '\n', '\t}\n', '\n', '\tfunction getContractBalance() public view returns (uint256) {\n', '\t\treturn address(this).balance;\n', '\t}\n', '\n', '\tfunction getContractBalanceRate() public view returns (uint256) {\n', '\t\tuint256 contractBalance = address(this).balance;\n', '\t\tuint256 contractBalancePercent = contractBalance.div(CONTRACT_BALANCE_STEP);\n', '\t\treturn BASE_PERCENT.add(contractBalancePercent);\n', '\t}\n', '\n', '\tfunction getUserPercentRate(address userAddress) public view returns (uint256) {\n', '\t\tUser storage user = users[userAddress];\n', '\n', '\t\tuint256 contractBalanceRate = getContractBalanceRate();\n', '\t\tif (isActive(userAddress)) {\n', '\t\t\tuint256 timeMultiplier = (now.sub(user.checkpoint)).div(TIME_STEP);\n', '\t\t\treturn contractBalanceRate.add(timeMultiplier);\n', '\t\t} else {\n', '\t\t\treturn contractBalanceRate;\n', '\t\t}\n', '\t}\n', '\n', '\tfunction getUserDividends(address userAddress) public view returns (uint256) {\n', '\t\tUser storage user = users[userAddress];\n', '\n', '\t\tuint256 userPercentRate = getUserPercentRate(userAddress);\n', '\n', '\t\tuint256 totalDividends;\n', '\t\tuint256 dividends;\n', '\n', '\t\tfor (uint256 i = 0; i < user.deposits.length; i++) {\n', '\n', '\t\t\tif (user.deposits[i].withdrawn < user.deposits[i].amount.mul(2)) {\n', '\n', '\t\t\t\tif (user.deposits[i].start > user.checkpoint) {\n', '\n', '\t\t\t\t\tdividends = (user.deposits[i].amount.mul(userPercentRate).div(PERCENTS_DIVIDER))\n', '\t\t\t\t\t\t.mul(block.timestamp.sub(user.deposits[i].start))\n', '\t\t\t\t\t\t.div(TIME_STEP);\n', '\n', '\t\t\t\t} else {\n', '\n', '\t\t\t\t\tdividends = (user.deposits[i].amount.mul(userPercentRate).div(PERCENTS_DIVIDER))\n', '\t\t\t\t\t\t.mul(block.timestamp.sub(user.checkpoint))\n', '\t\t\t\t\t\t.div(TIME_STEP);\n', '\n', '\t\t\t\t}\n', '\n', '\t\t\t\tif (user.deposits[i].withdrawn.add(dividends) > user.deposits[i].amount.mul(2)) {\n', '\t\t\t\t\tdividends = (user.deposits[i].amount.mul(2)).sub(user.deposits[i].withdrawn);\n', '\t\t\t\t}\n', '\n', '\t\t\t\ttotalDividends = totalDividends.add(dividends);\n', '\n', '\t\t\t\t/// no update of withdrawn because that is view function\n', '\n', '\t\t\t}\n', '\n', '\t\t}\n', '\n', '\t\treturn totalDividends;\n', '\t}\n', '\n', '\tfunction getUserCheckpoint(address userAddress) public view returns(uint256) {\n', '\t\treturn users[userAddress].checkpoint;\n', '\t}\n', '\n', '\tfunction getUserReferrer(address userAddress) public view returns(address) {\n', '\t\treturn users[userAddress].referrer;\n', '\t}\n', '\n', '\tfunction getUserReferralBonus(address userAddress) public view returns(uint256) {\n', '\t\treturn users[userAddress].bonus;\n', '\t}\n', '\n', '\tfunction getUserAvailable(address userAddress) public view returns(uint256) {\n', '\t\treturn getUserReferralBonus(userAddress).add(getUserDividends(userAddress));\n', '\t}\n', '\n', '\tfunction isActive(address userAddress) public view returns (bool) {\n', '\t\tUser storage user = users[userAddress];\n', '\n', '\t\tif (user.deposits.length > 0) {\n', '\t\t\tif (user.deposits[user.deposits.length-1].withdrawn < user.deposits[user.deposits.length-1].amount.mul(2)) {\n', '\t\t\t\treturn true;\n', '\t\t\t}\n', '\t\t}\n', '\t}\n', '\n', '\tfunction getUserDepositInfo(address userAddress, uint256 index) public view returns(uint256, uint256, uint256) {\n', '\t    User storage user = users[userAddress];\n', '\n', '\t\treturn (user.deposits[index].amount, user.deposits[index].withdrawn, user.deposits[index].start);\n', '\t}\n', '\n', '\tfunction getUserAmountOfDeposits(address userAddress) public view returns(uint256) {\n', '\t\treturn users[userAddress].deposits.length;\n', '\t}\n', '\n', '\tfunction getUserDownlineCount(address userAddress) public view returns(uint256, uint256, uint256) {\n', '\t\treturn (users[userAddress].level1, users[userAddress].level2, users[userAddress].level3);\n', '\t}\n', '\n', '\n', '\tfunction getUserTotalDeposits(address userAddress) public view returns(uint256) {\n', '\t    User storage user = users[userAddress];\n', '\n', '\t\tuint256 amount;\n', '\n', '\t\tfor (uint256 i = 0; i < user.deposits.length; i++) {\n', '\t\t\tamount = amount.add(user.deposits[i].amount);\n', '\t\t}\n', '\n', '\t\treturn amount;\n', '\t}\n', '\n', '\tfunction getUserTotalWithdrawn(address userAddress) public view returns(uint256) {\n', '\t    User storage user = users[userAddress];\n', '\n', '\t\tuint256 amount;\n', '\n', '\t\tfor (uint256 i = 0; i < user.deposits.length; i++) {\n', '\t\t\tamount = amount.add(user.deposits[i].withdrawn);\n', '\t\t}\n', '\n', '\t\treturn amount;\n', '\t}\n', '\n', '\tfunction isContract(address addr) internal view returns (bool) {\n', '        uint size;\n', '        assembly { size := extcodesize(addr) }\n', '        return size > 0;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '\t\trequire(msg.sender == adminAddress);\n', '\t\t_;\n', '    }\n', '\n', '\tmodifier onlyProjectLevel() {\n', '        require(\n', '\t\t\tmsg.sender == marketingAddress ||\n', '\t\t\tmsg.sender == adminAddress\n', '\t\t\t);\n', '\t\t_;\n', '    }\n', '\n', '\tfunction setMarketingAddress( address payable _newMarketingAddress) public onlyProjectLevel {\n', '\t\trequire(_newMarketingAddress != address(0));\n', '\t\tmarketingAddress = _newMarketingAddress;\n', '    }\n', '\n', '\tfunction setAdminAddress( address payable _newAdminAddress) public onlyAdmin {\n', '\t\trequire(_newAdminAddress != address(0));\n', '\t\tadminAddress = _newAdminAddress;\n', '    }\n', '\n', '   \n', '   \n', '\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '}']