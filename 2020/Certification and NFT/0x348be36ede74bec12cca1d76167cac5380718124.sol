['pragma solidity >=0.4.26;\n', '\n', '\n', '\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IKyberNetworkProxy {\n', '    function maxGasPrice() external view returns(uint);\n', '    function getUserCapInWei(address user) external view returns(uint);\n', '    function getUserCapInTokenWei(address user, ERC20 token) external view returns(uint);\n', '    function enabled() external view returns(bool);\n', '    function info(bytes32 id) external view returns(uint);\n', '    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view returns (uint expectedRate, uint slippageRate);\n', '    function tradeWithHint(ERC20 src, uint srcAmount, ERC20 dest, address destAddress, uint maxDestAmount, uint minConversionRate, address walletId, bytes  hint) external payable returns(uint);\n', '    function swapEtherToToken(ERC20 token, uint minRate) external payable returns (uint);\n', '    function swapTokenToEther(ERC20 token, uint tokenQty, uint minRate) external returns (uint);\n', '}\n', '\n', 'contract IUniswapExchange {\n', '    // Address of ERC20 token sold on this exchange\n', '    function tokenAddress() external view returns (address token);\n', '    // Address of Uniswap Factory\n', '    function factoryAddress() external view returns (address factory);\n', '    // Provide Liquidity\n', '    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);\n', '    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);\n', '    // Get Prices\n', '    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);\n', '    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);\n', '    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);\n', '    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);\n', '    // Trade ETH to ERC20\n', '    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);\n', '    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);\n', '    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);\n', '    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);\n', '    // Trade ERC20 to ETH\n', '    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);\n', '    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);\n', '    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);\n', '    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);\n', '    // Trade ERC20 to ERC20\n', '    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);\n', '    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);\n', '    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);\n', '    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);\n', '    // Trade ERC20 to Custom Pool\n', '    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);\n', '    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);\n', '    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);\n', '    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);\n', '    // ERC20 comaptibility for liquidity tokens\n', '    bytes32 public name;\n', '    bytes32 public symbol;\n', '    uint256 public decimals;\n', '    function transfer(address _to, uint256 _value) external returns (bool);\n', '    function transferFrom(address _from, address _to, uint256 value) external returns (bool);\n', '    function approve(address _spender, uint256 _value) external returns (bool);\n', '    function allowance(address _owner, address _spender) external view returns (uint256);\n', '    function balanceOf(address _owner) external view returns (uint256);\n', '    function totalSupply() external view returns (uint256);\n', '    // Never use\n', '    function setup(address token_addr) external;\n', '}\n', 'interface IWETH {\n', '  function deposit() external payable;\n', '  function withdraw(uint wad) external;\n', '  function totalSupply() external view returns (uint);\n', '  function approve(address guy, uint wad) external returns (bool);\n', '  function transfer(address dst, uint wad) external returns (bool);\n', '  function transferFrom(address src, address dst, uint wad) external returns (bool);\n', '  function () external payable;\n', '}\n', '\n', 'interface IUniswapFactory {\n', '    function createExchange(address token) external returns (address exchange);\n', '    function getExchange(address token) external view returns (address exchange);\n', '    function getToken(address exchange) external view returns (address token);\n', '    function getTokenWithId(uint256 tokenId) external view returns (address token);\n', '    function initializeFactory(address template) external;\n', '}\n', '\n', 'interface ERC20 {\n', '    function totalSupply() external view returns (uint supply);\n', '    function balanceOf(address _owner) external view returns (uint balance);\n', '    function transfer(address _to, uint _value) external returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) external returns (bool success);\n', '    function approve(address _spender, uint _value) external returns (bool success);\n', '    function allowance(address _owner, address _spender) external view returns (uint remaining);\n', '    function decimals() external view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'contract IERC20Token {\n', '    function name() public view returns (string memory) {this;}\n', '    function symbol() public view returns (string memory) {this;}\n', '    function decimals() public view returns (uint8) {this;}\n', '    function totalSupply() public view returns (uint256) {this;}\n', '    function balanceOf(address _owner) public view returns (uint256) {_owner; this;}\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'interface OrFeedInterface {\n', '  function getExchangeRate ( string fromSymbol, string toSymbol, string  venue, uint256 amount ) external view returns ( uint256 );\n', '  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );\n', '  function getTokenAddress ( string  symbol ) external view returns ( address );\n', '  function getSynthBytes32 ( string  symbol ) external view returns ( bytes32 );\n', '  function getForexAddress ( string  symbol ) external view returns ( address );\n', '  function arb(address fundsReturnToAddress, address liquidityProviderContractAddress, string[] tokens,  uint256 amount, string[] exchanges) payable external returns (bool);\n', '}\n', '\n', 'interface IContractRegistry {\n', '    function addressOf(bytes32 _contractName) external view returns (address);\n', '}\n', '\n', 'interface IBancorNetwork {\n', '    function getReturnByPath(address[]  _path, uint256 _amount) external view returns (uint256, uint256);\n', '    function convert2(address[] _path, uint256 _amount,\n', '        uint256 _minReturn,\n', '        address _affiliateAccount,\n', '        uint256 _affiliateFee\n', '    ) public payable returns (uint256);\n', '\n', '    function claimAndConvert2(\n', '        address[] _path,\n', '        uint256 _amount,\n', '        uint256 _minReturn,\n', '        address _affiliateAccount,\n', '        uint256 _affiliateFee\n', '    ) public returns (uint256);\n', '}\n', 'interface IBancorNetworkPathFinder {\n', '    function generatePath(address _sourceToken, address _targetToken) external view returns (address[]);\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal view returns(uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal view returns(uint256) {\n', '        assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal view returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal view returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract TradeScanner {\n', '\n', '    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);\n', '    IKyberNetworkProxy public proxy = IKyberNetworkProxy(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);\n', '    OrFeedInterface orfeed= OrFeedInterface(0x8316b082621cfedab95bf4a44a1d4b64a6ffc336);\n', ' //  address daiAddress = 0x6b175474e89094c44da98b954eedeac495271d0f;\n', '   \n', '    bytes  PERM_HINT = "PERM";\n', '    address owner;\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            throw;\n', '        }\n', '        _;\n', '    }\n', '\n', '    constructor(){\n', '     owner = msg.sender;\n', '    }\n', '\n', '    function () external payable  {\n', '\n', '    }\n', '\n', '\n', '    function getPriceByActionAndProvider(string _fromToken, string _toToken, string _actionAndExchange, uint256 _amount) view public returns (uint256){\n', '       uint256 currentPrice =  orfeed.getExchangeRate(_fromToken, _toToken, _actionAndExchange, _amount);\n', '        return currentPrice;\n', '    }\n', '\n', '\n', '      \n', '}']