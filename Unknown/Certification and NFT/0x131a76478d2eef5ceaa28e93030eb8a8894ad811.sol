['contract AbstractDaoChallenge {\n', '\tfunction isMember (DaoAccount account, address allegedOwnerAddress) returns (bool);\n', '}\n', '\n', 'contract DaoAccount\n', '{\n', '\t/**************************\n', '\t\t\t    Constants\n', '\t***************************/\n', '\n', '\t/**************************\n', '\t\t\t\t\tEvents\n', '\t***************************/\n', '\n', '\t// No events\n', '\n', '\t/**************************\n', '\t     Public variables\n', '\t***************************/\n', '\n', '\n', '\t/**************************\n', '\t     Private variables\n', '\t***************************/\n', '\n', '\tuint256 tokenBalance; // number of tokens in this account\n', '  address owner;        // owner of the otkens\n', '\taddress daoChallenge; // the DaoChallenge this account belongs to\n', '\tuint256 tokenPrice;\n', '\n', '  // Owner of the challenge with backdoor access.\n', '  // Remove for a real DAO contract:\n', '  address challengeOwner;\n', '\n', '\t/**************************\n', '\t\t\t     Modifiers\n', '\t***************************/\n', '\n', '\tmodifier noEther() {if (msg.value > 0) throw; _}\n', '\n', '\tmodifier onlyOwner() {if (owner != msg.sender) throw; _}\n', '\n', '\tmodifier onlyDaoChallenge() {if (daoChallenge != msg.sender) throw; _}\n', '\n', '\tmodifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}\n', '\n', '\t/**************************\n', '\t Constructor and fallback\n', '\t**************************/\n', '\n', '  function DaoAccount (address _owner, uint256 _tokenPrice, address _challengeOwner) noEther {\n', '    owner = _owner;\n', '\t\ttokenPrice = _tokenPrice;\n', '    daoChallenge = msg.sender;\n', '\t\ttokenBalance = 0;\n', '\n', '    // Remove for a real DAO contract:\n', '    challengeOwner = _challengeOwner;\n', '\t}\n', '\n', '\tfunction () {\n', '\t\tthrow;\n', '\t}\n', '\n', '\t/**************************\n', '\t     Private functions\n', '\t***************************/\n', '\n', '\t/**************************\n', '\t\t\t Public functions\n', '\t***************************/\n', '\n', '\tfunction getOwnerAddress() constant returns (address ownerAddress) {\n', '\t\treturn owner;\n', '\t}\n', '\n', '\tfunction getTokenBalance() constant returns (uint256 tokens) {\n', '\t\treturn tokenBalance;\n', '\t}\n', '\n', '\tfunction buyTokens() onlyDaoChallenge returns (uint256 tokens) {\n', '\t\tuint256 amount = msg.value;\n', '\n', '\t\t// No free tokens:\n', '\t\tif (amount == 0) throw;\n', '\n', '\t\t// No fractional tokens:\n', '\t\tif (amount % tokenPrice != 0) throw;\n', '\n', '\t\ttokens = amount / tokenPrice;\n', '\n', '\t\ttokenBalance += tokens;\n', '\n', '\t\treturn tokens;\n', '\t}\n', '\n', '\tfunction withdraw(uint256 tokens) noEther onlyDaoChallenge {\n', '\t\tif (tokens == 0 || tokenBalance == 0 || tokenBalance < tokens) throw;\n', '\t\ttokenBalance -= tokens;\n', '\t\tif(!owner.call.value(tokens * tokenPrice)()) throw;\n', '\t}\n', '\n', '\tfunction transfer(uint256 tokens, DaoAccount recipient) noEther onlyDaoChallenge {\n', '\t\tif (tokens == 0 || tokenBalance == 0 || tokenBalance < tokens) throw;\n', '\t\ttokenBalance -= tokens;\n', '\t\trecipient.receiveTokens.value(tokens * tokenPrice)(tokens);\n', '\t}\n', '\n', '\tfunction receiveTokens(uint256 tokens) {\n', '\t\t// Check that the sender is a DaoAccount and belongs to our DaoChallenge\n', '\t\tDaoAccount sender = DaoAccount(msg.sender);\n', '\t\tif (!AbstractDaoChallenge(daoChallenge).isMember(sender, sender.getOwnerAddress())) throw;\n', '\n', '\t\tuint256 amount = msg.value;\n', '\n', '\t\t// No zero transfer:\n', '\t\tif (amount == 0) throw;\n', '\n', '\t\tif (amount / tokenPrice != tokens) throw;\n', '\n', '\t\ttokenBalance += tokens;\n', '\t}\n', '\n', "\t// The owner of the challenge can terminate it. Don't use this in a real DAO.\n", '\tfunction terminate() noEther onlyChallengeOwner {\n', '\t\tsuicide(challengeOwner);\n', '\t}\n', '}\n', 'contract DaoChallenge\n', '{\n', '\t/**************************\n', '\t\t\t\t\tConstants\n', '\t***************************/\n', '\n', '\n', '\t/**************************\n', '\t\t\t\t\tEvents\n', '\t***************************/\n', '\n', '\tevent notifyTerminate(uint256 finalBalance);\n', '\tevent notifyTokenIssued(uint256 n, uint256 price, uint deadline);\n', '\n', '\tevent notifyNewAccount(address owner, address account);\n', '\tevent notifyBuyToken(address owner, uint256 tokens, uint256 price);\n', '\tevent notifyWithdraw(address owner, uint256 tokens);\n', '\tevent notifyTransfer(address owner, address recipient, uint256 tokens);\n', '\n', '\t/**************************\n', '\t     Public variables\n', '\t***************************/\n', '\n', '\t// For the current token issue:\n', '\tuint public tokenIssueDeadline = now;\n', '\tuint256 public tokensIssued = 0;\n', '\tuint256 public tokensToIssue = 0;\n', '\tuint256 public tokenPrice = 1000000000000000; // 1 finney\n', '\n', '\tmapping (address => DaoAccount) public daoAccounts;\n', '\n', '\t/**************************\n', '\t\t\t Private variables\n', '\t***************************/\n', '\n', "\t// Owner of the challenge; a real DAO doesn't an owner.\n", '\taddress challengeOwner;\n', '\n', '\t/**************************\n', '\t\t\t\t\t Modifiers\n', '\t***************************/\n', '\n', '\tmodifier noEther() {if (msg.value > 0) throw; _}\n', '\n', '\tmodifier onlyChallengeOwner() {if (challengeOwner != msg.sender) throw; _}\n', '\n', '\t/**************************\n', '\t Constructor and fallback\n', '\t**************************/\n', '\n', '\tfunction DaoChallenge () {\n', "\t\tchallengeOwner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.\n", '\t}\n', '\n', '\tfunction () noEther {\n', '\t}\n', '\n', '\t/**************************\n', '\t     Private functions\n', '\t***************************/\n', '\n', '\tfunction accountFor (address accountOwner, bool createNew) private returns (DaoAccount) {\n', '\t\tDaoAccount account = daoAccounts[accountOwner];\n', '\n', '\t\tif(account == DaoAccount(0x00) && createNew) {\n', '\t\t\taccount = new DaoAccount(accountOwner, tokenPrice, challengeOwner);\n', '\t\t\tdaoAccounts[accountOwner] = account;\n', '\t\t\tnotifyNewAccount(accountOwner, address(account));\n', '\t\t}\n', '\n', '\t\treturn account;\n', '\t}\n', '\n', '\t/**************************\n', '\t     Public functions\n', '\t***************************/\n', '\n', '\tfunction createAccount () {\n', '\t\taccountFor(msg.sender, true);\n', '\t}\n', '\n', '\t// Check if a given account belongs to this DaoChallenge.\n', '\tfunction isMember (DaoAccount account, address allegedOwnerAddress) returns (bool) {\n', '\t\tif (account == DaoAccount(0x00)) return false;\n', '\t\tif (allegedOwnerAddress == 0x00) return false;\n', '\t\tif (daoAccounts[allegedOwnerAddress] == DaoAccount(0x00)) return false;\n', '\t\t// allegedOwnerAddress is passed in for performance reasons, but not trusted\n', '\t\tif (daoAccounts[allegedOwnerAddress] != account) return false;\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction getTokenBalance () constant noEther returns (uint256 tokens) {\n', '\t\tDaoAccount account = accountFor(msg.sender, false);\n', '\t\tif (account == DaoAccount(0x00)) return 0;\n', '\t\treturn account.getTokenBalance();\n', '\t}\n', '\n', '\t// n: max number of tokens to be issued\n', '\t// price: in szabo, e.g. 1 finney = 1,000 szabo = 0.001 ether\n', '\t// deadline: unix timestamp in seconds\n', '\tfunction issueTokens (uint256 n, uint256 price, uint deadline) noEther onlyChallengeOwner {\n', '\t\t// Only allow one issuing at a time:\n', '\t\tif (now < tokenIssueDeadline) throw;\n', '\n', "\t\t// Deadline can't be in the past:\n", '\t\tif (deadline < now) throw;\n', '\n', '\t\t// Issue at least 1 token\n', '\t\tif (n == 0) throw;\n', '\n', '\t\ttokenPrice = price * 1000000000000;\n', '\t\ttokenIssueDeadline = deadline;\n', '\t\ttokensToIssue = n;\n', '\t\ttokensIssued = 0;\n', '\n', '\t\tnotifyTokenIssued(n, price, deadline);\n', '\t}\n', '\n', '\tfunction buyTokens () returns (uint256 tokens) {\n', '\t\ttokens = msg.value / tokenPrice;\n', '\n', '\t\tif (now > tokenIssueDeadline) throw;\n', '\t\tif (tokensIssued >= tokensToIssue) throw;\n', '\n', '\t\t// This hopefully prevents issuing too many tokens\n', "\t\t// if there's a race condition:\n", '\t\ttokensIssued += tokens;\n', '\t\tif (tokensIssued > tokensToIssue) throw;\n', '\n', '\t  DaoAccount account = accountFor(msg.sender, true);\n', '\t\tif (account.buyTokens.value(msg.value)() != tokens) throw;\n', '\n', '\t\tnotifyBuyToken(msg.sender, tokens, msg.value);\n', '\t\treturn tokens;\n', ' \t}\n', '\n', '\tfunction withdraw(uint256 tokens) noEther {\n', '\t\tDaoAccount account = accountFor(msg.sender, false);\n', '\t\tif (account == DaoAccount(0x00)) throw;\n', '\n', '\t\taccount.withdraw(tokens);\n', '\t\tnotifyWithdraw(msg.sender, tokens);\n', '\t}\n', '\n', '\tfunction transfer(uint256 tokens, address recipient) noEther {\n', '\t\tDaoAccount account = accountFor(msg.sender, false);\n', '\t\tif (account == DaoAccount(0x00)) throw;\n', '\n', '\t\tDaoAccount recipientAcc = accountFor(recipient, false);\n', '\t\tif (recipientAcc == DaoAccount(0x00)) throw;\n', '\n', '\t\taccount.transfer(tokens, recipientAcc);\n', '\t\tnotifyTransfer(msg.sender, recipient, tokens);\n', '\t}\n', '\n', "\t// The owner of the challenge can terminate it. Don't use this in a real DAO.\n", '\tfunction terminate() noEther onlyChallengeOwner {\n', '\t\tnotifyTerminate(this.balance);\n', '\t\tsuicide(challengeOwner);\n', '\t}\n', '}']