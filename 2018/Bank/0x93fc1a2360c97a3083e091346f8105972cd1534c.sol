['pragma solidity ^0.4.21;\n', '\n', '/* This contract is the Proof of Community whale contract that will buy and sell tokens to share dividends to token holders.\n', '   This contract can also handle multiple games to donate ETH to it, which will be needed for future game developement.\n', '\n', '    Kenny - Solidity developer\n', '\tBungalogic - website developer, concept and design, graphics. \n', '\n', '\n', '   该合同是社区鲸鱼合同的证明，它将购买和出售代币以向代币持有者分享股息。\n', '   该合同还可以处理多个游戏以向其捐赠ETH，这将是未来游戏开发所需要的。  \n', '\n', '   Kenny  -  Solidity开发人员\n', '   Bungalogic  - 网站开发人员，概念和设计，图形。\n', '*/\n', '\n', '\n', '\n', 'contract Kujira \n', '{ \n', '    /*\n', '      Modifiers\n', '      修饰符\n', '     */\n', '\n', '    // Only the people that published this contract\n', '    // 只有发布此合同的人才\n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner || msg.sender == owner2);\n', '        _;\n', '    }\n', '    \n', '    // Only PoC token contract\n', '    // 只有PoC令牌合同\n', '    modifier notPoC(address aContract)\n', '    {\n', '        require(aContract != address(pocContract));\n', '        _;\n', '    }\n', '   \n', '    /*\n', '      Events\n', '      活动\n', '     */\n', '    event Deposit(uint256 amount, address depositer);\n', '    event Purchase(uint256 amountSpent, uint256 tokensReceived);\n', '    event Sell();\n', '    event Payout(uint256 amount, address creditor);\n', '    event Transfer(uint256 amount, address paidTo);\n', '\n', '   /**\n', '      Global Variables\n', '      全局变量\n', '     */\n', '    address owner;\n', '    address owner2;\n', '    PoC pocContract;\n', '    uint256 tokenBalance;\n', '   \n', '    \n', '    /*\n', '       Constructor\n', '       施工人\n', '     */\n', '    constructor(address owner2Address) \n', '    public \n', '    {\n', '        owner = msg.sender;\n', '        owner2 = owner2Address;\n', '        pocContract = PoC(address(0x1739e311ddBf1efdFbc39b74526Fd8b600755ADa));\n', '        tokenBalance = 0;\n', '    }\n', '    \n', '    function() payable public { }\n', '     \n', '    /*\n', '      Only way to give contract ETH and have it immediately use it, is by using donate function\n', '      给合同ETH并让它立即使用的唯一方法是使用捐赠功能\n', '     */\n', '    function donate() \n', '    public payable \n', '    {\n', '        //You have to send more than 1000000 wei\n', '        //你必须发送超过1000000 wei\n', '        require(msg.value > 1000000 wei);\n', '        uint256 ethToTransfer = address(this).balance;\n', '        uint256 PoCEthInContract = address(pocContract).balance;\n', '       \n', '        // if PoC contract balance is less than 5 ETH, PoC is dead and there is no reason to pump it\n', '        // 如果PoC合同余额低于5 ETH，PoC已经死亡，没有理由将其泵出\n', '        if(PoCEthInContract < 5 ether)\n', '        {\n', '            pocContract.exit();\n', '            tokenBalance = 0;\n', '            ethToTransfer = address(this).balance;\n', '\n', '            owner.transfer(ethToTransfer);\n', '            emit Transfer(ethToTransfer, address(owner));\n', '        }\n', '\n', '        // let&#39;s buy and sell tokens to give dividends to PoC tokenholders\n', '        // 让我们买卖代币给PoC代币持有人分红\n', '        else\n', '        {\n', '            tokenBalance = myTokens();\n', '\n', '             // if token balance is greater than 0, sell and rebuy \n', '             // 如果令牌余额大于0，则出售并重新购买\n', '\n', '            if(tokenBalance > 0)\n', '            {\n', '                pocContract.exit();\n', '                tokenBalance = 0; \n', '\n', '                ethToTransfer = address(this).balance;\n', '\n', '                if(ethToTransfer > 0)\n', '                {\n', '                    pocContract.buy.value(ethToTransfer)(0x0);\n', '                }\n', '                else\n', '                {\n', '                    pocContract.buy.value(msg.value)(0x0);\n', '                }\n', '            }\n', '            else\n', '            {   \n', '                // we have no tokens, let&#39;s buy some if we have ETH balance\n', '                // 我们没有代币，如果我们有ETH余额，我们就买一些\n', '                if(ethToTransfer > 0)\n', '                {\n', '                    pocContract.buy.value(ethToTransfer)(0x0);\n', '                    tokenBalance = myTokens();\n', '                    emit Deposit(msg.value, msg.sender);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    \n', '    /**\n', '       Number of tokens the contract owns.\n', '       合同拥有的代币数量。\n', '     */\n', '    function myTokens() \n', '    public \n', '    view \n', '    returns(uint256)\n', '    {\n', '        return pocContract.myTokens();\n', '    }\n', '    \n', '    /**\n', '       Number of dividends owed to the contract.\n', '       欠合同的股息数量。\n', '     */\n', '    function myDividends() \n', '    public \n', '    view \n', '    returns(uint256)\n', '    {\n', '        return pocContract.myDividends(true);\n', '    }\n', '\n', '    /**\n', '       ETH balance of contract\n', '       合约的ETH余额\n', '     */\n', '    function ethBalance() \n', '    public \n', '    view \n', '    returns (uint256)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '\n', '    /**\n', '       If someone sends tokens other than PoC tokens, the owner can return them.\n', '       如果有人发送除PoC令牌以外的令牌，则所有者可以退回它们。\n', '     */\n', '    function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) \n', '    public \n', '    onlyOwner() \n', '    notPoC(tokenAddress) \n', '    returns (bool success) \n', '    {\n', '        return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);\n', '    }\n', '    \n', '}\n', '\n', '// Define the PoC token for the contract\n', '// 为合同定义PoC令牌\n', 'contract PoC \n', '{\n', '    function buy(address) public payable returns(uint256);\n', '    function exit() public;\n', '    function myTokens() public view returns(uint256);\n', '    function myDividends(bool) public view returns(uint256);\n', '    function totalEthereumBalance() public view returns(uint);\n', '}\n', '\n', '// Define ERC20Interface.transfer, so contract can transfer tokens accidently sent to it.\n', '// 定义ERC20 Interface.transfer，因此合同可以转移意外发送给它的令牌。\n', 'contract ERC20Interface \n', '{\n', '    function transfer(address to, uint256 tokens) \n', '    public \n', '    returns (bool success);\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '/* This contract is the Proof of Community whale contract that will buy and sell tokens to share dividends to token holders.\n', '   This contract can also handle multiple games to donate ETH to it, which will be needed for future game developement.\n', '\n', '    Kenny - Solidity developer\n', '\tBungalogic - website developer, concept and design, graphics. \n', '\n', '\n', '   该合同是社区鲸鱼合同的证明，它将购买和出售代币以向代币持有者分享股息。\n', '   该合同还可以处理多个游戏以向其捐赠ETH，这将是未来游戏开发所需要的。  \n', '\n', '   Kenny  -  Solidity开发人员\n', '   Bungalogic  - 网站开发人员，概念和设计，图形。\n', '*/\n', '\n', '\n', '\n', 'contract Kujira \n', '{ \n', '    /*\n', '      Modifiers\n', '      修饰符\n', '     */\n', '\n', '    // Only the people that published this contract\n', '    // 只有发布此合同的人才\n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner || msg.sender == owner2);\n', '        _;\n', '    }\n', '    \n', '    // Only PoC token contract\n', '    // 只有PoC令牌合同\n', '    modifier notPoC(address aContract)\n', '    {\n', '        require(aContract != address(pocContract));\n', '        _;\n', '    }\n', '   \n', '    /*\n', '      Events\n', '      活动\n', '     */\n', '    event Deposit(uint256 amount, address depositer);\n', '    event Purchase(uint256 amountSpent, uint256 tokensReceived);\n', '    event Sell();\n', '    event Payout(uint256 amount, address creditor);\n', '    event Transfer(uint256 amount, address paidTo);\n', '\n', '   /**\n', '      Global Variables\n', '      全局变量\n', '     */\n', '    address owner;\n', '    address owner2;\n', '    PoC pocContract;\n', '    uint256 tokenBalance;\n', '   \n', '    \n', '    /*\n', '       Constructor\n', '       施工人\n', '     */\n', '    constructor(address owner2Address) \n', '    public \n', '    {\n', '        owner = msg.sender;\n', '        owner2 = owner2Address;\n', '        pocContract = PoC(address(0x1739e311ddBf1efdFbc39b74526Fd8b600755ADa));\n', '        tokenBalance = 0;\n', '    }\n', '    \n', '    function() payable public { }\n', '     \n', '    /*\n', '      Only way to give contract ETH and have it immediately use it, is by using donate function\n', '      给合同ETH并让它立即使用的唯一方法是使用捐赠功能\n', '     */\n', '    function donate() \n', '    public payable \n', '    {\n', '        //You have to send more than 1000000 wei\n', '        //你必须发送超过1000000 wei\n', '        require(msg.value > 1000000 wei);\n', '        uint256 ethToTransfer = address(this).balance;\n', '        uint256 PoCEthInContract = address(pocContract).balance;\n', '       \n', '        // if PoC contract balance is less than 5 ETH, PoC is dead and there is no reason to pump it\n', '        // 如果PoC合同余额低于5 ETH，PoC已经死亡，没有理由将其泵出\n', '        if(PoCEthInContract < 5 ether)\n', '        {\n', '            pocContract.exit();\n', '            tokenBalance = 0;\n', '            ethToTransfer = address(this).balance;\n', '\n', '            owner.transfer(ethToTransfer);\n', '            emit Transfer(ethToTransfer, address(owner));\n', '        }\n', '\n', "        // let's buy and sell tokens to give dividends to PoC tokenholders\n", '        // 让我们买卖代币给PoC代币持有人分红\n', '        else\n', '        {\n', '            tokenBalance = myTokens();\n', '\n', '             // if token balance is greater than 0, sell and rebuy \n', '             // 如果令牌余额大于0，则出售并重新购买\n', '\n', '            if(tokenBalance > 0)\n', '            {\n', '                pocContract.exit();\n', '                tokenBalance = 0; \n', '\n', '                ethToTransfer = address(this).balance;\n', '\n', '                if(ethToTransfer > 0)\n', '                {\n', '                    pocContract.buy.value(ethToTransfer)(0x0);\n', '                }\n', '                else\n', '                {\n', '                    pocContract.buy.value(msg.value)(0x0);\n', '                }\n', '            }\n', '            else\n', '            {   \n', "                // we have no tokens, let's buy some if we have ETH balance\n", '                // 我们没有代币，如果我们有ETH余额，我们就买一些\n', '                if(ethToTransfer > 0)\n', '                {\n', '                    pocContract.buy.value(ethToTransfer)(0x0);\n', '                    tokenBalance = myTokens();\n', '                    emit Deposit(msg.value, msg.sender);\n', '                }\n', '            }\n', '        }\n', '    }\n', '\n', '    \n', '    /**\n', '       Number of tokens the contract owns.\n', '       合同拥有的代币数量。\n', '     */\n', '    function myTokens() \n', '    public \n', '    view \n', '    returns(uint256)\n', '    {\n', '        return pocContract.myTokens();\n', '    }\n', '    \n', '    /**\n', '       Number of dividends owed to the contract.\n', '       欠合同的股息数量。\n', '     */\n', '    function myDividends() \n', '    public \n', '    view \n', '    returns(uint256)\n', '    {\n', '        return pocContract.myDividends(true);\n', '    }\n', '\n', '    /**\n', '       ETH balance of contract\n', '       合约的ETH余额\n', '     */\n', '    function ethBalance() \n', '    public \n', '    view \n', '    returns (uint256)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '\n', '    /**\n', '       If someone sends tokens other than PoC tokens, the owner can return them.\n', '       如果有人发送除PoC令牌以外的令牌，则所有者可以退回它们。\n', '     */\n', '    function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) \n', '    public \n', '    onlyOwner() \n', '    notPoC(tokenAddress) \n', '    returns (bool success) \n', '    {\n', '        return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);\n', '    }\n', '    \n', '}\n', '\n', '// Define the PoC token for the contract\n', '// 为合同定义PoC令牌\n', 'contract PoC \n', '{\n', '    function buy(address) public payable returns(uint256);\n', '    function exit() public;\n', '    function myTokens() public view returns(uint256);\n', '    function myDividends(bool) public view returns(uint256);\n', '    function totalEthereumBalance() public view returns(uint);\n', '}\n', '\n', '// Define ERC20Interface.transfer, so contract can transfer tokens accidently sent to it.\n', '// 定义ERC20 Interface.transfer，因此合同可以转移意外发送给它的令牌。\n', 'contract ERC20Interface \n', '{\n', '    function transfer(address to, uint256 tokens) \n', '    public \n', '    returns (bool success);\n', '}']