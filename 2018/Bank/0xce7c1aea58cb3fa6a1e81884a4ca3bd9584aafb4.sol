['pragma solidity ^0.4.21;\n', '\n', '\n', '\n', 'contract POOHMOWHALE \n', '{\n', '    \n', '    /**\n', '     * Modifiers\n', '     */\n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier notPOOH(address aContract)\n', '    {\n', '        require(aContract != address(poohContract));\n', '        _;\n', '    }\n', '   \n', '    /**\n', '     * Events\n', '     */\n', '    event Deposit(uint256 amount, address depositer);\n', '    event Purchase(uint256 amountSpent, uint256 tokensReceived);\n', '    event Sell();\n', '    event Payout(uint256 amount, address creditor);\n', '    event Transfer(uint256 amount, address paidTo);\n', '\n', '   /**\n', '     * Global Variables\n', '     */\n', '    address owner;\n', '    address game;\n', '    bool payDoublr;\n', '    uint256 tokenBalance;\n', '    POOH poohContract;\n', '    DOUBLR doublr;\n', '    \n', '    /**\n', '     * Constructor\n', '     */\n', '    constructor() \n', '    public \n', '    {\n', '        owner = msg.sender;\n', '        poohContract = POOH(address(0x4C29d75cc423E8Adaa3839892feb66977e295829));\n', '        doublr = DOUBLR(address(0xd69b75D5Dc270E4F6cD664Ac2354d12423C5AE9e));\n', '        tokenBalance = 0;\n', '        payDoublr = true;\n', '    }\n', '    \n', '    function() payable public \n', '    {\n', '        donate();\n', '    }\n', '     \n', '    /**\n', '     * Only way to give POOHMOWHALE ETH is via by using fallback\n', '     */\n', '    function donate() \n', '    internal \n', '    {\n', '        //You have to send more than 1000000 wei\n', '        require(msg.value > 1000000 wei);\n', '        uint256 ethToTransfer = address(this).balance;\n', '\n', '        //if we are in doublr-mode, pay the assigned doublr\n', '        if(payDoublr)\n', '        {\n', '            if(ethToTransfer > 0)\n', '            {\n', '                address(doublr).transfer(ethToTransfer - 1000000);\n', '                doublr.payout.gas(1000000)();\n', '            }\n', '        }\n', '        else\n', '        {\n', '            uint256 PoohEthInContract = address(poohContract).balance;\n', '           \n', '            // if POOH contract balance is less than 5 ETH, POOH is dead and there&#39;s no use pumping it\n', '            if(PoohEthInContract < 5 ether)\n', '            {\n', '\n', '                poohContract.exit();\n', '                tokenBalance = 0;\n', '                \n', '                owner.transfer(ethToTransfer);\n', '                emit Transfer(ethToTransfer, address(owner));\n', '            }\n', '\n', '            //let&#39;s buy/sell tokens to give dividends to POOH tokenholders\n', '            else\n', '            {\n', '                tokenBalance = myTokens();\n', '                 //if token balance is greater than 0, sell and rebuy \n', '                if(tokenBalance > 0)\n', '                {\n', '                    poohContract.exit();\n', '                    tokenBalance = 0;\n', '\n', '                    if(ethToTransfer > 0)\n', '                    {\n', '                        poohContract.buy.value(ethToTransfer)(0x0);\n', '                    }\n', '                    else\n', '                    {\n', '                        poohContract.buy.value(msg.value)(0x0);\n', '\n', '                    }\n', '       \n', '                }\n', '                else\n', '                {   \n', '                    //we have no tokens, let&#39;s buy some if we have eth\n', '                    if(ethToTransfer > 0)\n', '                    {\n', '                        poohContract.buy.value(ethToTransfer)(0x0);\n', '                        tokenBalance = myTokens();\n', '                        //Emit a deposit event.\n', '                        emit Deposit(msg.value, msg.sender);\n', '                    }\n', '                }\n', '            }\n', '        }\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Number of tokens the contract owns.\n', '     */\n', '    function myTokens() \n', '    public \n', '    view \n', '    returns(uint256)\n', '    {\n', '        return poohContract.myTokens();\n', '    }\n', '    \n', '    /**\n', '     * Number of dividends owed to the contract.\n', '     */\n', '    function myDividends() \n', '    public \n', '    view \n', '    returns(uint256)\n', '    {\n', '        return poohContract.myDividends(true);\n', '    }\n', '\n', '    /**\n', '     * ETH balance of contract\n', '     */\n', '    function ethBalance() \n', '    public \n', '    view \n', '    returns (uint256)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '\n', '    /**\n', '     * Address of game contract that ETH gets sent to\n', '     */\n', '    function assignedDoublrContract() \n', '    public \n', '    view \n', '    returns (address)\n', '    {\n', '        return address(doublr);\n', '    }\n', '    \n', '    /**\n', '     * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.\n', '     */\n', '    function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) \n', '    public \n', '    onlyOwner() \n', '    notPOOH(tokenAddress) \n', '    returns (bool success) \n', '    {\n', '        return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);\n', '    }\n', '    \n', '     /**\n', '     * Owner can update which Doublr the POOHMOWHALE pays to\n', '     */\n', '    function changeDoublr(address doublrAddress) \n', '    public\n', '    onlyOwner()\n', '    {\n', '        doublr = DOUBLR(doublrAddress);\n', '    }\n', '\n', '    /**\n', '     * Owner can update POOHMOWHALE to stop paying doublr and act as whale\n', '     */\n', '    function switchToWhaleMode(bool answer)\n', '    public\n', '    onlyOwner()\n', '    {\n', '        payDoublr = answer;\n', '    }\n', '}\n', '\n', '//Define the POOH token for the POOHMOWHALE\n', 'contract POOH \n', '{\n', '    function buy(address) public payable returns(uint256);\n', '    function sell(uint256) public;\n', '    function withdraw() public;\n', '    function myTokens() public view returns(uint256);\n', '    function myDividends(bool) public view returns(uint256);\n', '    function exit() public;\n', '    function totalEthereumBalance() public view returns(uint);\n', '}\n', '\n', '\n', '//Define the Doublr contract for the POOHMOWHALE\n', 'contract DOUBLR\n', '{\n', '    function payout() public; \n', '    function myDividends() public view returns(uint256);\n', '    function withdraw() public;\n', '}\n', '\n', '//Define ERC20Interface.transfer, so POOHMOWHALE can transfer tokens accidently sent to it.\n', 'contract ERC20Interface \n', '{\n', '    function transfer(address to, uint256 tokens) \n', '    public \n', '    returns (bool success);\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '\n', '\n', 'contract POOHMOWHALE \n', '{\n', '    \n', '    /**\n', '     * Modifiers\n', '     */\n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    \n', '    modifier notPOOH(address aContract)\n', '    {\n', '        require(aContract != address(poohContract));\n', '        _;\n', '    }\n', '   \n', '    /**\n', '     * Events\n', '     */\n', '    event Deposit(uint256 amount, address depositer);\n', '    event Purchase(uint256 amountSpent, uint256 tokensReceived);\n', '    event Sell();\n', '    event Payout(uint256 amount, address creditor);\n', '    event Transfer(uint256 amount, address paidTo);\n', '\n', '   /**\n', '     * Global Variables\n', '     */\n', '    address owner;\n', '    address game;\n', '    bool payDoublr;\n', '    uint256 tokenBalance;\n', '    POOH poohContract;\n', '    DOUBLR doublr;\n', '    \n', '    /**\n', '     * Constructor\n', '     */\n', '    constructor() \n', '    public \n', '    {\n', '        owner = msg.sender;\n', '        poohContract = POOH(address(0x4C29d75cc423E8Adaa3839892feb66977e295829));\n', '        doublr = DOUBLR(address(0xd69b75D5Dc270E4F6cD664Ac2354d12423C5AE9e));\n', '        tokenBalance = 0;\n', '        payDoublr = true;\n', '    }\n', '    \n', '    function() payable public \n', '    {\n', '        donate();\n', '    }\n', '     \n', '    /**\n', '     * Only way to give POOHMOWHALE ETH is via by using fallback\n', '     */\n', '    function donate() \n', '    internal \n', '    {\n', '        //You have to send more than 1000000 wei\n', '        require(msg.value > 1000000 wei);\n', '        uint256 ethToTransfer = address(this).balance;\n', '\n', '        //if we are in doublr-mode, pay the assigned doublr\n', '        if(payDoublr)\n', '        {\n', '            if(ethToTransfer > 0)\n', '            {\n', '                address(doublr).transfer(ethToTransfer - 1000000);\n', '                doublr.payout.gas(1000000)();\n', '            }\n', '        }\n', '        else\n', '        {\n', '            uint256 PoohEthInContract = address(poohContract).balance;\n', '           \n', "            // if POOH contract balance is less than 5 ETH, POOH is dead and there's no use pumping it\n", '            if(PoohEthInContract < 5 ether)\n', '            {\n', '\n', '                poohContract.exit();\n', '                tokenBalance = 0;\n', '                \n', '                owner.transfer(ethToTransfer);\n', '                emit Transfer(ethToTransfer, address(owner));\n', '            }\n', '\n', "            //let's buy/sell tokens to give dividends to POOH tokenholders\n", '            else\n', '            {\n', '                tokenBalance = myTokens();\n', '                 //if token balance is greater than 0, sell and rebuy \n', '                if(tokenBalance > 0)\n', '                {\n', '                    poohContract.exit();\n', '                    tokenBalance = 0;\n', '\n', '                    if(ethToTransfer > 0)\n', '                    {\n', '                        poohContract.buy.value(ethToTransfer)(0x0);\n', '                    }\n', '                    else\n', '                    {\n', '                        poohContract.buy.value(msg.value)(0x0);\n', '\n', '                    }\n', '       \n', '                }\n', '                else\n', '                {   \n', "                    //we have no tokens, let's buy some if we have eth\n", '                    if(ethToTransfer > 0)\n', '                    {\n', '                        poohContract.buy.value(ethToTransfer)(0x0);\n', '                        tokenBalance = myTokens();\n', '                        //Emit a deposit event.\n', '                        emit Deposit(msg.value, msg.sender);\n', '                    }\n', '                }\n', '            }\n', '        }\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Number of tokens the contract owns.\n', '     */\n', '    function myTokens() \n', '    public \n', '    view \n', '    returns(uint256)\n', '    {\n', '        return poohContract.myTokens();\n', '    }\n', '    \n', '    /**\n', '     * Number of dividends owed to the contract.\n', '     */\n', '    function myDividends() \n', '    public \n', '    view \n', '    returns(uint256)\n', '    {\n', '        return poohContract.myDividends(true);\n', '    }\n', '\n', '    /**\n', '     * ETH balance of contract\n', '     */\n', '    function ethBalance() \n', '    public \n', '    view \n', '    returns (uint256)\n', '    {\n', '        return address(this).balance;\n', '    }\n', '\n', '    /**\n', '     * Address of game contract that ETH gets sent to\n', '     */\n', '    function assignedDoublrContract() \n', '    public \n', '    view \n', '    returns (address)\n', '    {\n', '        return address(doublr);\n', '    }\n', '    \n', '    /**\n', '     * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.\n', '     */\n', '    function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) \n', '    public \n', '    onlyOwner() \n', '    notPOOH(tokenAddress) \n', '    returns (bool success) \n', '    {\n', '        return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);\n', '    }\n', '    \n', '     /**\n', '     * Owner can update which Doublr the POOHMOWHALE pays to\n', '     */\n', '    function changeDoublr(address doublrAddress) \n', '    public\n', '    onlyOwner()\n', '    {\n', '        doublr = DOUBLR(doublrAddress);\n', '    }\n', '\n', '    /**\n', '     * Owner can update POOHMOWHALE to stop paying doublr and act as whale\n', '     */\n', '    function switchToWhaleMode(bool answer)\n', '    public\n', '    onlyOwner()\n', '    {\n', '        payDoublr = answer;\n', '    }\n', '}\n', '\n', '//Define the POOH token for the POOHMOWHALE\n', 'contract POOH \n', '{\n', '    function buy(address) public payable returns(uint256);\n', '    function sell(uint256) public;\n', '    function withdraw() public;\n', '    function myTokens() public view returns(uint256);\n', '    function myDividends(bool) public view returns(uint256);\n', '    function exit() public;\n', '    function totalEthereumBalance() public view returns(uint);\n', '}\n', '\n', '\n', '//Define the Doublr contract for the POOHMOWHALE\n', 'contract DOUBLR\n', '{\n', '    function payout() public; \n', '    function myDividends() public view returns(uint256);\n', '    function withdraw() public;\n', '}\n', '\n', '//Define ERC20Interface.transfer, so POOHMOWHALE can transfer tokens accidently sent to it.\n', 'contract ERC20Interface \n', '{\n', '    function transfer(address to, uint256 tokens) \n', '    public \n', '    returns (bool success);\n', '}']
