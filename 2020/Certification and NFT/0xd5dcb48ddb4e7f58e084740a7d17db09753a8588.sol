['pragma solidity ^0.6.0; interface ERC20 {\n', '    function totalSupply() external view returns (uint256 supply);\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        external\n', '        returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining);\n', '\n', '    function decimals() external view returns (uint256 digits);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '} library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(ERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     */\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function _callOptionalReturn(ERC20 token, bytes memory data) private {\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '} abstract contract KyberNetworkProxyInterface {\n', '    function maxGasPrice() external virtual view returns (uint256);\n', '\n', '    function getUserCapInWei(address user) external virtual view returns (uint256);\n', '\n', '    function getUserCapInTokenWei(address user, ERC20 token) external virtual view returns (uint256);\n', '\n', '    function enabled() external virtual view returns (bool);\n', '\n', '    function info(bytes32 id) external virtual view returns (uint256);\n', '\n', '    function getExpectedRate(ERC20 src, ERC20 dest, uint256 srcQty)\n', '        public virtual\n', '        view\n', '        returns (uint256 expectedRate, uint256 slippageRate);\n', '\n', '    function tradeWithHint(\n', '        ERC20 src,\n', '        uint256 srcAmount,\n', '        ERC20 dest,\n', '        address destAddress,\n', '        uint256 maxDestAmount,\n', '        uint256 minConversionRate,\n', '        address walletId,\n', '        bytes memory hint\n', '    ) public virtual payable returns (uint256);\n', '\n', '    function trade(\n', '        ERC20 src,\n', '        uint256 srcAmount,\n', '        ERC20 dest,\n', '        address destAddress,\n', '        uint256 maxDestAmount,\n', '        uint256 minConversionRate,\n', '        address walletId\n', '    ) public virtual payable returns (uint256);\n', '\n', '    function swapEtherToToken(ERC20 token, uint256 minConversionRate)\n', '        external virtual\n', '        payable\n', '        returns (uint256);\n', '\n', '    function swapTokenToEther(ERC20 token, uint256 tokenQty, uint256 minRate)\n', '        external virtual\n', '        payable\n', '        returns (uint256);\n', '\n', '    function swapTokenToToken(ERC20 src, uint256 srcAmount, ERC20 dest, uint256 minConversionRate)\n', '        public virtual\n', '        returns (uint256);\n', '} interface ExchangeInterfaceV2 {\n', '    function sell(address _srcAddr, address _destAddr, uint _srcAmount) external payable returns (uint);\n', '\n', '    function buy(address _srcAddr, address _destAddr, uint _destAmount) external payable returns(uint);\n', '\n', '    function getSellRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);\n', '\n', '    function getBuyRate(address _srcAddr, address _destAddr, uint _srcAmount) external view returns (uint);\n', '} contract DSMath {\n', '    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '\n', '    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '\n', '    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '\n', '    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        return x / y;\n', '    }\n', '\n', '\n', '    uint256 constant WAD = 10**18;\n', '    uint256 constant RAY = 10**27;\n', '\n', '    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '\n', '    function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '\n', '    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '\n', '    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', ' \n', '} contract AdminAuth {\n', '\n', '    using SafeERC20 for ERC20;\n', '\n', '    address public owner;\n', '    address public admin;\n', '\n', '    modifier onlyOwner() {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /// @notice Admin is set by owner first time, after that admin is super role and has permission to change owner\n', '    /// @param _admin Address of multisig that becomes admin\n', '    function setAdminByOwner(address _admin) public {\n', '        require(msg.sender == owner);\n', '        require(admin == address(0));\n', '\n', '        admin = _admin;\n', '    }\n', '\n', '    /// @notice Admin is able to set new admin\n', '    /// @param _admin Address of multisig that becomes new admin\n', '    function setAdminByAdmin(address _admin) public {\n', '        require(msg.sender == admin);\n', '\n', '        admin = _admin;\n', '    }\n', '\n', '    /// @notice Admin is able to change owner\n', '    /// @param _owner Address of new owner\n', '    function setOwnerByAdmin(address _owner) public {\n', '        require(msg.sender == admin);\n', '\n', '        owner = _owner;\n', '    }\n', '\n', '    /// @notice Destroy the contract\n', '    function kill() public onlyOwner {\n', '        selfdestruct(payable(owner));\n', '    }\n', '\n', '    /// @notice  withdraw stuck funds\n', '    function withdrawStuckFunds(address _token, uint _amount) public onlyOwner {\n', '        if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {\n', '            payable(owner).transfer(_amount);\n', '        } else {\n', '            ERC20(_token).safeTransfer(owner, _amount);\n', '        }\n', '    }\n', '} contract KyberWrapper is DSMath, ExchangeInterfaceV2, AdminAuth {\n', '\n', '    address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '    address public constant KYBER_INTERFACE = 0x9AAb3f75489902f3a48495025729a0AF77d4b11e;\n', '    address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;\n', '\n', '    using SafeERC20 for ERC20;\n', '\n', '    /// @notice Sells a _srcAmount of tokens at Kyber\n', '    /// @param _srcAddr From token\n', '    /// @param _destAddr To token\n', '    /// @param _srcAmount From amount\n', '    /// @return uint Destination amount\n', '    function sell(address _srcAddr, address _destAddr, uint _srcAmount) external override payable returns (uint) {\n', '        ERC20 srcToken = ERC20(_srcAddr);\n', '        ERC20 destToken = ERC20(_destAddr);\n', '\n', '        KyberNetworkProxyInterface kyberNetworkProxy = KyberNetworkProxyInterface(KYBER_INTERFACE);\n', '\n', '        if (_srcAddr != KYBER_ETH_ADDRESS) {\n', '            srcToken.safeApprove(address(kyberNetworkProxy), _srcAmount);\n', '        }\n', '\n', '        uint destAmount = kyberNetworkProxy.trade{value: msg.value}(\n', '            srcToken,\n', '            _srcAmount,\n', '            destToken,\n', '            msg.sender,\n', '            uint(-1),\n', '            0,\n', '            WALLET_ID\n', '        );\n', '\n', '        return destAmount;\n', '    }\n', '\n', '    /// @notice Buys a _destAmount of tokens at Kyber\n', '    /// @param _srcAddr From token\n', '    /// @param _destAddr To token\n', '    /// @param _destAmount To amount\n', '    /// @return uint srcAmount\n', '    function buy(address _srcAddr, address _destAddr, uint _destAmount) external override payable returns(uint) {\n', '        ERC20 srcToken = ERC20(_srcAddr);\n', '        ERC20 destToken = ERC20(_destAddr);\n', '\n', '        uint srcAmount = 0;\n', '        if (_srcAddr != KYBER_ETH_ADDRESS) {\n', '            srcAmount = srcToken.balanceOf(address(this));\n', '        } else {\n', '            srcAmount = msg.value;\n', '        }\n', '\n', '        KyberNetworkProxyInterface kyberNetworkProxy = KyberNetworkProxyInterface(KYBER_INTERFACE);\n', '\n', '        if (_srcAddr != KYBER_ETH_ADDRESS) {\n', '            srcToken.safeApprove(address(kyberNetworkProxy), srcAmount);\n', '        }\n', '\n', '        uint destAmount = kyberNetworkProxy.trade{value: msg.value}(\n', '            srcToken,\n', '            srcAmount,\n', '            destToken,\n', '            msg.sender,\n', '            _destAmount,\n', '            0,\n', '            WALLET_ID\n', '        );\n', '\n', '        require(destAmount == _destAmount, "Wrong dest amount");\n', '\n', '        uint srcAmountAfter = 0;\n', '\n', '        if (_srcAddr != KYBER_ETH_ADDRESS) {\n', '            srcAmountAfter = srcToken.balanceOf(address(this));\n', '        } else {\n', '            srcAmountAfter = address(this).balance;\n', '        }\n', '\n', '        // Send the leftover from the source token back\n', '        sendLeftOver(_srcAddr);\n', '\n', '        return (srcAmount - srcAmountAfter);\n', '    }\n', '\n', '    /// @notice Return a rate for which we can sell an amount of tokens\n', '    /// @param _srcAddr From token\n', '    /// @param _destAddr To token\n', '    /// @param _srcAmount From amount\n', '    /// @return rate Rate\n', '    function getSellRate(address _srcAddr, address _destAddr, uint _srcAmount) public override view returns (uint rate) {\n', '        (rate, ) = KyberNetworkProxyInterface(KYBER_INTERFACE)\n', '            .getExpectedRate(ERC20(_srcAddr), ERC20(_destAddr), _srcAmount);\n', '\n', '        // multiply with decimal difference in src token\n', '        rate = rate * (10**(18 - getDecimals(_srcAddr)));\n', '        // divide with decimal difference in dest token\n', '        rate = rate / (10**(18 - getDecimals(_destAddr)));\n', '    }\n', '\n', '    /// @notice Return a rate for which we can buy an amount of tokens\n', '    /// @param _srcAddr From token\n', '    /// @param _destAddr To token\n', '    /// @param _destAmount To amount\n', '    /// @return rate Rate\n', '    function getBuyRate(address _srcAddr, address _destAddr, uint _destAmount) public override view returns (uint rate) {\n', '        uint256 srcRate = getSellRate(_srcAddr, _destAddr, _destAmount);\n', '        uint256 srcAmount = wmul(_destAmount, srcRate);\n', '\n', '        rate = getSellRate(_destAddr, _srcAddr, srcAmount);\n', '\n', '        // increase rate by 3% too account for inaccuracy between sell/buy conversion\n', '        rate = rate + (rate / 30);\n', '    }\n', '\n', '    /// @notice Send any leftover tokens, we use to clear out srcTokens after buy\n', '    /// @param _srcAddr Source token address\n', '    function sendLeftOver(address _srcAddr) internal {\n', '        msg.sender.transfer(address(this).balance);\n', '\n', '        if (_srcAddr != KYBER_ETH_ADDRESS) {\n', '            ERC20(_srcAddr).safeTransfer(msg.sender, ERC20(_srcAddr).balanceOf(address(this)));\n', '        }\n', '    }\n', '\n', '    receive() payable external {}\n', '\n', '    function getDecimals(address _token) internal view returns (uint256) {\n', '        if (_token == KYBER_ETH_ADDRESS) return 18;\n', '\n', '        return ERC20(_token).decimals();\n', '    }\n', '}']