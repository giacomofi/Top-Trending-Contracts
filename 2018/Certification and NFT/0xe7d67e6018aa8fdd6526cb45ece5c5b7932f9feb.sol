['pragma solidity 0.4.24;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'library Utils {\n', '\n', '    uint  constant PRECISION = (10**18);\n', '    uint  constant MAX_DECIMALS = 18;\n', '\n', '    function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '        if( dstDecimals >= srcDecimals ) {\n', '            require((dstDecimals-srcDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate * (10**(dstDecimals-srcDecimals))) / PRECISION;\n', '        } else {\n', '            require((srcDecimals-dstDecimals) <= MAX_DECIMALS);\n', '            return (srcQty * rate) / (PRECISION * (10**(srcDecimals-dstDecimals)));\n', '        }\n', '    }\n', '\n', '    // function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {\n', '    //     if( srcDecimals >= dstDecimals ) {\n', '    //         require((srcDecimals-dstDecimals) <= MAX_DECIMALS);\n', '    //         return (PRECISION * dstQty * (10**(srcDecimals - dstDecimals))) / rate;\n', '    //     } else {\n', '    //         require((dstDecimals-srcDecimals) <= MAX_DECIMALS);\n', '    //         return (PRECISION * dstQty) / (rate * (10**(dstDecimals - srcDecimals)));\n', '    //     }\n', '    // }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'contract ERC20Extended is ERC20 {\n', '    uint256 public decimals;\n', '    string public name;\n', '    string public symbol;\n', '\n', '}\n', '\n', 'contract ComponentInterface {\n', '    string public name;\n', '    string public description;\n', '    string public category;\n', '    string public version;\n', '}\n', '\n', 'contract ExchangeInterface is ComponentInterface {\n', '    /*\n', '     * @dev Checks if a trading pair is available\n', '     * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee\n', '     * @param address _sourceAddress The token to sell for the destAddress.\n', '     * @param address _destAddress The token to buy with the source token.\n', '     * @param bytes32 _exchangeId The exchangeId to choose. If it&#39;s an empty string, then the exchange will be chosen automatically.\n', '     * @return boolean whether or not the trading pair is supported by this exchange provider\n', '     */\n', '    function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId)\n', '        external view returns(bool supported);\n', '\n', '    /*\n', '     * @dev Buy a single token with ETH.\n', '     * @param ERC20Extended _token The token to buy, should be an ERC20Extended address.\n', '     * @param uint _amount Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the _amount.\n', '     * @param uint _minimumRate The minimum amount of tokens to receive for 1 ETH.\n', '     * @param address _depositAddress The address to send the bought tokens to.\n', '     * @param bytes32 _exchangeId The exchangeId to choose. If it&#39;s an empty string, then the exchange will be chosen automatically.\n', '     * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here.\n', '     * @return boolean whether or not the trade succeeded.\n', '     */\n', '    function buyToken\n', '        (\n', '        ERC20Extended _token, uint _amount, uint _minimumRate,\n', '        address _depositAddress, bytes32 _exchangeId, address _partnerId\n', '        ) external payable returns(bool success);\n', '\n', '    /*\n', '     * @dev Sell a single token for ETH. Make sure the token is approved beforehand.\n', '     * @param ERC20Extended _token The token to sell, should be an ERC20Extended address.\n', '     * @param uint _amount Amount of tokens to sell.\n', '     * @param uint _minimumRate The minimum amount of ETH to receive for 1 ERC20Extended token.\n', '     * @param address _depositAddress The address to send the bought tokens to.\n', '     * @param bytes32 _exchangeId The exchangeId to choose. If it&#39;s an empty string, then the exchange will be chosen automatically.\n', '     * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here\n', '     * @return boolean boolean whether or not the trade succeeded.\n', '     */\n', '    function sellToken\n', '        (\n', '        ERC20Extended _token, uint _amount, uint _minimumRate,\n', '        address _depositAddress, bytes32 _exchangeId, address _partnerId\n', '        ) external returns(bool success);\n', '}\n', '\n', 'contract KyberNetworkInterface {\n', '\n', '    function getExpectedRate(ERC20Extended src, ERC20Extended dest, uint srcQty)\n', '        external view returns (uint expectedRate, uint slippageRate);\n', '\n', '    function trade(\n', '        ERC20Extended source,\n', '        uint srcAmount,\n', '        ERC20Extended dest,\n', '        address destAddress,\n', '        uint maxDestAmount,\n', '        uint minConversionRate,\n', '        address walletId)\n', '        external payable returns(uint);\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract OlympusExchangeAdapterInterface is Ownable {\n', '\n', '    function supportsTradingPair(address _srcAddress, address _destAddress)\n', '        external view returns(bool supported);\n', '\n', '    function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount)\n', '        external view returns(uint expectedRate, uint slippageRate);\n', '\n', '    function sellToken\n', '        (\n', '        ERC20Extended _token, uint _amount, uint _minimumRate,\n', '        address _depositAddress\n', '        ) external returns(bool success);\n', '\n', '    function buyToken\n', '        (\n', '        ERC20Extended _token, uint _amount, uint _minimumRate,\n', '        address _depositAddress\n', '        ) external payable returns(bool success);\n', '\n', '    function enable() external returns(bool);\n', '    function disable() external returns(bool);\n', '    function isEnabled() external view returns (bool success);\n', '\n', '    function setExchangeDetails(bytes32 _id, bytes32 _name) external returns(bool success);\n', '    function getExchangeDetails() external view returns(bytes32 _name, bool _enabled);\n', '\n', '}\n', '\n', 'contract ERC20NoReturn {\n', '    uint256 public decimals;\n', '    string public name;\n', '    string public symbol;\n', '    function totalSupply() public view returns (uint);\n', '    function balanceOf(address tokenOwner) public view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '    function transfer(address to, uint tokens) public;\n', '    function approve(address spender, uint tokens) public;\n', '    function transferFrom(address from, address to, uint tokens) public;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract KyberNetworkAdapter is OlympusExchangeAdapterInterface{\n', '    using SafeMath for uint256;\n', '\n', '    KyberNetworkInterface public kyber;\n', '    address public exchangeAdapterManager;\n', '    bytes32 public exchangeId;\n', '    bytes32 public name;\n', '    ERC20Extended public constant ETH_TOKEN_ADDRESS = ERC20Extended(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);\n', '    address public walletId = 0x09227deaeE08a5Ba9D6Eb057F922aDfAd191c36c;\n', '\n', '    bool public adapterEnabled;\n', '\n', '    modifier onlyExchangeAdapterManager() {\n', '        require(msg.sender == address(exchangeAdapterManager));\n', '        _;\n', '    }\n', '\n', '    constructor (KyberNetworkInterface _kyber, address _exchangeAdapterManager) public {\n', '        require(address(_kyber) != 0x0);\n', '        kyber = _kyber;\n', '        exchangeAdapterManager = _exchangeAdapterManager;\n', '        adapterEnabled = true;\n', '    }\n', '\n', '    function setExchangeAdapterManager(address _exchangeAdapterManager) external onlyOwner{\n', '        exchangeAdapterManager = _exchangeAdapterManager;\n', '    }\n', '\n', '    function setExchangeDetails(bytes32 _id, bytes32 _name)\n', '    external onlyExchangeAdapterManager returns(bool)\n', '    {\n', '        exchangeId = _id;\n', '        name = _name;\n', '        return true;\n', '    }\n', '\n', '    function getExchangeDetails()\n', '    external view returns(bytes32 _name, bool _enabled)\n', '    {\n', '        return (name, adapterEnabled);\n', '    }\n', '\n', '    function getExpectAmount(uint eth, uint destDecimals, uint rate) internal pure returns(uint){\n', '        return Utils.calcDstQty(eth, 18, destDecimals, rate);\n', '    }\n', '\n', '    function configAdapter(KyberNetworkInterface _kyber, address _walletId) external onlyOwner returns(bool success) {\n', '        if(address(_kyber) != 0x0){\n', '            kyber = _kyber;\n', '        }\n', '        if(_walletId != 0x0){\n', '            walletId = _walletId;\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function supportsTradingPair(address _srcAddress, address _destAddress) external view returns(bool supported){\n', '        // Get price for selling one\n', '        uint amount = ERC20Extended(_srcAddress) == ETH_TOKEN_ADDRESS ? 10**18 : 10**ERC20Extended(_srcAddress).decimals();\n', '        uint price;\n', '        (price,) = this.getPrice(ERC20Extended(_srcAddress), ERC20Extended(_destAddress), amount);\n', '        return price > 0;\n', '    }\n', '\n', '    function enable() external onlyOwner returns(bool){\n', '        adapterEnabled = true;\n', '        return true;\n', '    }\n', '\n', '    function disable() external onlyOwner returns(bool){\n', '        adapterEnabled = false;\n', '        return true;\n', '    }\n', '\n', '    function isEnabled() external view returns (bool success) {\n', '        return adapterEnabled;\n', '    }\n', '\n', '    function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount) external view returns(uint, uint){\n', '        return kyber.getExpectedRate(_sourceAddress, _destAddress, _amount);\n', '    }\n', '\n', '    function buyToken(ERC20Extended _token, uint _amount, uint _minimumRate, address _depositAddress)\n', '    external payable returns(bool) {\n', '        if (address(this).balance < _amount) {\n', '            return false;\n', '        }\n', '        require(msg.value == _amount);\n', '        uint slippageRate;\n', '\n', '        (, slippageRate) = kyber.getExpectedRate(ETH_TOKEN_ADDRESS, _token, _amount);\n', '        if(slippageRate < _minimumRate){\n', '            return false;\n', '        }\n', '\n', '        uint beforeTokenBalance = _token.balanceOf(_depositAddress);\n', '        slippageRate = _minimumRate;\n', '        kyber.trade.value(msg.value)(\n', '            ETH_TOKEN_ADDRESS,\n', '            _amount,\n', '            _token,\n', '            _depositAddress,\n', '            2**256 - 1,\n', '            slippageRate,\n', '            walletId);\n', '\n', '        require(_token.balanceOf(_depositAddress) > beforeTokenBalance);\n', '\n', '        return true;\n', '    }\n', '    function sellToken(ERC20Extended _token, uint _amount, uint _minimumRate, address _depositAddress)\n', '    external returns(bool success)\n', '    {\n', '        ERC20NoReturn(_token).approve(address(kyber), 0);\n', '        ERC20NoReturn(_token).approve(address(kyber), _amount);\n', '        uint slippageRate;\n', '        (,slippageRate) = kyber.getExpectedRate(_token, ETH_TOKEN_ADDRESS, _amount);\n', '\n', '        if(slippageRate < _minimumRate){\n', '            return false;\n', '        }\n', '        slippageRate = _minimumRate;\n', '\n', '        // uint beforeTokenBalance = _token.balanceOf(this);\n', '        kyber.trade(\n', '            _token,\n', '            _amount,\n', '            ETH_TOKEN_ADDRESS,\n', '            _depositAddress,\n', '            2**256 - 1,\n', '            slippageRate,\n', '            walletId);\n', '\n', '        // require(_token.balanceOf(this) < beforeTokenBalance);\n', '        // require((beforeTokenBalance - _token.balanceOf(this)) == _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function withdraw(uint amount) external onlyOwner {\n', '\n', '        require(amount <= address(this).balance);\n', '\n', '        uint sendAmount = amount;\n', '        if (amount == 0){\n', '            sendAmount = address(this).balance;\n', '        }\n', '        msg.sender.transfer(sendAmount);\n', '    }\n', '\n', '}']