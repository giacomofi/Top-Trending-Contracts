['//dapp: https://etherscan.io/dapp/0x1603557c3f7197df2ecded659ad04fa72b1e1114#readContract\n', '//\n', '\n', 'pragma solidity >=0.4.26;\n', '\n', 'contract UniswapExchangeInterface {\n', '    // Address of ERC20 token sold on this exchange\n', '    function tokenAddress() external view returns (address token);\n', '    // Address of Uniswap Factory\n', '    function factoryAddress() external view returns (address factory);\n', '    // Provide Liquidity\n', '    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);\n', '    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);\n', '    // Get Prices\n', '    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);\n', '    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);\n', '    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);\n', '    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);\n', '    // Trade ETH to ERC20\n', '    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);\n', '    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);\n', '    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);\n', '    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);\n', '    // Trade ERC20 to ETH\n', '    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);\n', '    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);\n', '    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);\n', '    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);\n', '    // Trade ERC20 to ERC20\n', '    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);\n', '    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);\n', '    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);\n', '    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);\n', '    // Trade ERC20 to Custom Pool\n', '    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);\n', '    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);\n', '    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);\n', '    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);\n', '    // ERC20 comaptibility for liquidity tokens\n', '    bytes32 public name;\n', '    bytes32 public symbol;\n', '    uint256 public decimals;\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 value) external returns (bool);\n', '    function approve(address _spender, uint256 _value) external returns (bool);\n', '    function allowance(address _owner, address _spender) external view returns (uint256);\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function totalSupply() external view returns (uint256);\n', '    // Never use\n', '    function setup(address token_addr) external;\n', '}\n', '\n', 'interface ERC20 {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    function decimals() public view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/// @title Kyber Network interface\n', 'interface KyberNetworkProxyInterface {\n', '    function maxGasPrice() public view returns(uint);\n', '    function getUserCapInWei(address user) public view returns(uint);\n', '    function getUserCapInTokenWei(address user, ERC20 token) public view returns(uint);\n', '    function enabled() public view returns(bool);\n', '    function info(bytes32 id) public view returns(uint);\n', '\n', '    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) public view\n', '        returns (uint expectedRate, uint slippageRate);\n', '\n', '    function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount,\n', '        uint minConversionRate, address walletId, bytes hint) public payable returns(uint);\n', '\n', '    function swapEtherToToken(ERC20 token, uint minRate) public payable returns (uint);\n', '\n', '    function swapTokenToEther(ERC20 token, uint tokenQty, uint minRate) public returns (uint);\n', '\n', '\n', '}\n', '\n', 'interface OrFeedInterface {\n', '  function getExchangeRate ( string fromSymbol, string toSymbol, string venue, uint256 amount ) external view returns ( uint256 );\n', '  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );\n', '  function getTokenAddress ( string symbol ) external view returns ( address );\n', '  function getSynthBytes32 ( string symbol ) external view returns ( bytes32 );\n', '  function getForexAddress ( string symbol ) external view returns ( address );\n', '}\n', '\n', '\n', '\n', '\n', '\n', 'contract Trader{\n', '\n', '    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);\n', '    KyberNetworkProxyInterface public proxy = KyberNetworkProxyInterface(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);\n', '    OrFeedInterface orfeed= OrFeedInterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);\n', '    address saiAddress = 0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359;\n', '    bytes  PERM_HINT = "PERM";\n', '    address owner;\n', '\n', '\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '\n', '    constructor(){\n', '     owner = msg.sender;\n', '    }\n', '\n', '   function swapEtherToToken (KyberNetworkProxyInterface _kyberNetworkProxy, ERC20 token, address destAddress) internal{\n', '\n', '    uint minRate;\n', '    (, minRate) = _kyberNetworkProxy.getExpectedRate(ETH_TOKEN_ADDRESS, token, msg.value);\n', '\n', "    //will send back tokens to this contract's address\n", '    uint destAmount = _kyberNetworkProxy.swapEtherToToken.value(msg.value)(token, minRate);\n', '\n', '    //send received tokens to destination address\n', '   require(token.transfer(destAddress, destAmount));\n', '\n', '\n', '\n', '    }\n', '\n', '    function swapTokenToEther1 (KyberNetworkProxyInterface _kyberNetworkProxy, ERC20 token, uint tokenQty, address destAddress) internal returns (uint) {\n', '\n', '        uint minRate =1;\n', '        //(, minRate) = _kyberNetworkProxy.getExpectedRate(token, ETH_TOKEN_ADDRESS, tokenQty);\n', '\n', '        // Check that the token transferFrom has succeeded\n', '        token.transferFrom(msg.sender, this, tokenQty);\n', '\n', '        // Mitigate ERC20 Approve front-running attack, by initially setting\n', '        // allowance to 0\n', '\n', '       token.approve(proxy, 0);\n', '\n', '        // Approve tokens so network can take them during the swap\n', '       token.approve(address(proxy), tokenQty);\n', '\n', '\n', '       uint destAmount = proxy.tradeWithHint(ERC20(saiAddress), tokenQty, ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee), this, 8000000000000000000000000000000000000000000000000000000000000000, 0, 0x0000000000000000000000000000000000000004, PERM_HINT);\n', '\n', '    return destAmount;\n', '      //uint destAmount = proxy.swapTokenToEther(token, tokenQty, minRate);\n', '\n', '        // Send received ethers to destination address\n', '     //  destAddress.transfer(destAmount);\n', '    }\n', '\n', '    function swapTokenToEther2 (KyberNetworkProxyInterface _kyberNetworkProxy, ERC20 token, uint tokenQty, address destAddress, address tokenAddress) internal returns (uint) {\n', '\n', '        uint minRate =1;\n', '        //(, minRate) = _kyberNetworkProxy.getExpectedRate(token, ETH_TOKEN_ADDRESS, tokenQty);\n', '\n', '        // Check that the token transferFrom has succeeded\n', '        token.transferFrom(msg.sender, this, tokenQty);\n', '\n', '        // Mitigate ERC20 Approve front-running attack, by initially setting\n', '        // allowance to 0\n', '\n', '       token.approve(proxy, 0);\n', '\n', '        // Approve tokens so network can take them during the swap\n', '       token.approve(address(proxy), tokenQty);\n', '\n', '\n', '       uint destAmount = proxy.tradeWithHint(ERC20(tokenAddress), tokenQty, ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee), this, 8000000000000000000000000000000000000000000000000000000000000000, 0, 0x0000000000000000000000000000000000000004, PERM_HINT);\n', '\n', '    return destAmount;\n', '      //uint destAmount = proxy.swapTokenToEther(token, tokenQty, minRate);\n', '\n', '        // Send received ethers to destination address\n', '     //  destAddress.transfer(destAmount);\n', '    }\n', '\n', '     function kyberToUniSwapArb(address fromAddress, address uniSwapContract, uint theAmount) public payable onlyOwner returns (bool){\n', '\n', '        address theAddress = uniSwapContract;\n', '        UniswapExchangeInterface usi = UniswapExchangeInterface(theAddress);\n', '\n', '        ERC20 address1 = ERC20(fromAddress);\n', '\n', '       uint ethBack = swapTokenToEther1(proxy, address1 , theAmount, msg.sender);\n', '\n', '       usi.ethToTokenSwapInput.value(ethBack)(1, block.timestamp);\n', '\n', '        return true;\n', '    }\n', '\n', '    function kyberToUniSwapArb2(address fromAddress, address uniSwapContract, uint theAmount, address tokenAddress) public payable onlyOwner returns (bool){\n', '\n', '        address theAddress = uniSwapContract;\n', '        UniswapExchangeInterface usi = UniswapExchangeInterface(theAddress);\n', '\n', '        ERC20 address1 = ERC20(fromAddress);\n', '\n', '       uint ethBack = swapTokenToEther2(proxy, address1 , theAmount, msg.sender, tokenAddress);\n', '\n', '       usi.ethToTokenSwapInput.value(ethBack)(1, block.timestamp);\n', '\n', '        return true;\n', '    }\n', '\n', '\n', '    function () external payable  {\n', '\n', '    }\n', '\n', '    function withdrawETHAndTokens() onlyOwner{\n', '        msg.sender.send(address(this).balance);\n', '         ERC20 saiToken = ERC20(saiAddress);\n', '        uint256 currentTokenBalance = saiToken.balanceOf(this);\n', '        saiToken.transfer(msg.sender, currentTokenBalance);\n', '    }\n', '\n', '    function withdrawETHAndTokensParam(address tokenAddress) onlyOwner{\n', '        msg.sender.send(address(this).balance);\n', '         ERC20 token = ERC20(tokenAddress);\n', '        uint256 currentTokenBalance = token.balanceOf(this);\n', '        token.transfer(msg.sender, currentTokenBalance);\n', '    }\n', '\n', '    function getKyberSellPrice() constant returns (uint256){\n', '       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "SAI", "SELL-KYBER-EXCHANGE", 1000000000000000000);\n', '        return currentPrice;\n', '    }\n', '\n', '    function getUniswapBuyPrice() constant returns (uint256){\n', '       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "SAI", "BUY-UNISWAP-EXCHANGE", 1000000000000000000);\n', '        return currentPrice;\n', '    }\n', '\n', '    function getKyberBuyPrice() constant returns (uint256){\n', '       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "SAI", "BUY-KYBER-EXCHANGE", 1000000000000000000);\n', '        return currentPrice;\n', '    }\n', '\n', '    function getUniswapSellPrice() constant returns (uint256){\n', '       uint256 currentPrice =  orfeed.getExchangeRate("ETH", "SAI", "SELL-UNISWAP-EXCHANGE", 1000000000000000000);\n', '        return currentPrice;\n', '    }\n', '\n', '    function getOrfeedExchangeRate( string fromSymbol, string toSymbol, string venue, uint amount ) constant returns ( uint256 ){\n', '        uint256 currentPrice =  orfeed.getExchangeRate(fromSymbol, toSymbol, venue, amount);\n', '        return currentPrice;\n', '    }\n', '\n', '}']