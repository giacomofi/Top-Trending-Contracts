['pragma solidity ^0.6.0;  interface ERC20 {\n', '    function totalSupply() external view returns (uint256 supply);\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        external\n', '        returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining);\n', '\n', '    function decimals() external view returns (uint256 digits);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}  library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}  library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}  library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(ERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     */\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function _callOptionalReturn(ERC20 token, bytes memory data) private {\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}  interface IFlashLoanReceiver {\n', '    function executeOperation(address _reserve, uint256 _amount, uint256 _fee, bytes calldata _params) external;\n', '}\n', '\n', 'abstract contract ILendingPoolAddressesProvider {\n', '\n', '    function getLendingPool() public view virtual returns (address);\n', '    function setLendingPoolImpl(address _pool) public virtual;\n', '\n', '    function getLendingPoolCore() public virtual view returns (address payable);\n', '    function setLendingPoolCoreImpl(address _lendingPoolCore) public virtual;\n', '\n', '    function getLendingPoolConfigurator() public virtual view returns (address);\n', '    function setLendingPoolConfiguratorImpl(address _configurator) public virtual;\n', '\n', '    function getLendingPoolDataProvider() public virtual view returns (address);\n', '    function setLendingPoolDataProviderImpl(address _provider) public virtual;\n', '\n', '    function getLendingPoolParametersProvider() public virtual view returns (address);\n', '    function setLendingPoolParametersProviderImpl(address _parametersProvider) public virtual;\n', '\n', '    function getTokenDistributor() public virtual view returns (address);\n', '    function setTokenDistributor(address _tokenDistributor) public virtual;\n', '\n', '\n', '    function getFeeProvider() public virtual view returns (address);\n', '    function setFeeProviderImpl(address _feeProvider) public virtual;\n', '\n', '    function getLendingPoolLiquidationManager() public virtual view returns (address);\n', '    function setLendingPoolLiquidationManager(address _manager) public virtual;\n', '\n', '    function getLendingPoolManager() public virtual view returns (address);\n', '    function setLendingPoolManager(address _lendingPoolManager) public virtual;\n', '\n', '    function getPriceOracle() public virtual view returns (address);\n', '    function setPriceOracle(address _priceOracle) public virtual;\n', '\n', '    function getLendingRateOracle() public view virtual returns (address);\n', '    function setLendingRateOracle(address _lendingRateOracle) public virtual;\n', '}\n', '\n', 'library EthAddressLib {\n', '\n', '    function ethAddress() internal pure returns(address) {\n', '        return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '    }\n', '}\n', '\n', 'abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {\n', '\n', '    using SafeERC20 for ERC20;\n', '    using SafeMath for uint256;\n', '\n', '    ILendingPoolAddressesProvider public addressesProvider;\n', '\n', '    constructor(ILendingPoolAddressesProvider _provider) public {\n', '        addressesProvider = _provider;\n', '    }\n', '\n', '    receive () external virtual payable {}\n', '\n', '    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount) internal {\n', '\n', '        address payable core = addressesProvider.getLendingPoolCore();\n', '\n', '        transferInternal(core,_reserve, _amount);\n', '    }\n', '\n', '    function transferInternal(address payable _destination, address _reserve, uint256  _amount) internal {\n', '        if(_reserve == EthAddressLib.ethAddress()) {\n', '            //solium-disable-next-line\n', '            _destination.call{value: _amount}("");\n', '            return;\n', '        }\n', '\n', '        ERC20(_reserve).safeTransfer(_destination, _amount);\n', '\n', '\n', '    }\n', '\n', '    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {\n', '        if(_reserve == EthAddressLib.ethAddress()) {\n', '\n', '            return _target.balance;\n', '        }\n', '\n', '        return ERC20(_reserve).balanceOf(_target);\n', '\n', '    }\n', '}  abstract contract DSProxyInterface {\n', '\n', "    /// Truffle wont compile if this isn't commented\n", '    // function execute(bytes memory _code, bytes memory _data)\n', '    //     public virtual\n', '    //     payable\n', '    //     returns (address, bytes32);\n', '\n', '    function execute(address _target, bytes memory _data) public virtual payable returns (bytes32);\n', '\n', '    function setCache(address _cacheAddr) public virtual payable returns (bool);\n', '\n', '    function owner() public virtual returns (address);\n', '}  abstract contract ProxyRegistryInterface {\n', '    function proxies(address _owner) public virtual view returns (address);\n', '    function build(address) public virtual returns (address);\n', '}  abstract contract CTokenInterface is ERC20 {\n', '    function mint(uint256 mintAmount) external virtual returns (uint256);\n', '\n', '    // function mint() external virtual payable;\n', '\n', '    function accrueInterest() public virtual returns (uint);\n', '\n', '    function redeem(uint256 redeemTokens) external virtual returns (uint256);\n', '\n', '    function redeemUnderlying(uint256 redeemAmount) external virtual returns (uint256);\n', '\n', '    function borrow(uint256 borrowAmount) external virtual returns (uint256);\n', '    function borrowIndex() public view virtual returns (uint);\n', '    function borrowBalanceStored(address) public view virtual returns(uint);\n', '\n', '    function repayBorrow(uint256 repayAmount) external virtual returns (uint256);\n', '\n', '    function repayBorrow() external virtual payable;\n', '\n', '    function repayBorrowBehalf(address borrower, uint256 repayAmount) external virtual returns (uint256);\n', '\n', '    function repayBorrowBehalf(address borrower) external virtual payable;\n', '\n', '    function liquidateBorrow(address borrower, uint256 repayAmount, address cTokenCollateral)\n', '        external virtual\n', '        returns (uint256);\n', '\n', '    function liquidateBorrow(address borrower, address cTokenCollateral) external virtual payable;\n', '\n', '    function exchangeRateCurrent() external virtual returns (uint256);\n', '\n', '    function supplyRatePerBlock() external virtual returns (uint256);\n', '\n', '    function borrowRatePerBlock() external virtual returns (uint256);\n', '\n', '    function totalReserves() external virtual returns (uint256);\n', '\n', '    function reserveFactorMantissa() external virtual returns (uint256);\n', '\n', '    function borrowBalanceCurrent(address account) external virtual returns (uint256);\n', '\n', '    function totalBorrowsCurrent() external virtual returns (uint256);\n', '\n', '    function getCash() external virtual returns (uint256);\n', '\n', '    function balanceOfUnderlying(address owner) external virtual returns (uint256);\n', '\n', '    function underlying() external virtual returns (address);\n', '\n', '    function getAccountSnapshot(address account) external virtual view returns (uint, uint, uint, uint);\n', '}  /// @title Receives FL from Aave and imports the position to DSProxy\n', 'contract CompoundImportFlashLoan is FlashLoanReceiverBase {\n', '\n', '    using SafeERC20 for ERC20;\n', '\n', '    ILendingPoolAddressesProvider public LENDING_POOL_ADDRESS_PROVIDER = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);\n', '\n', '    address public constant COMPOUND_BORROW_PROXY = 0xb7EDC39bE76107e2Cc645f0f6a3D164f5e173Ee2;\n', '\n', '    address public owner;\n', '\n', '    constructor()\n', '        FlashLoanReceiverBase(LENDING_POOL_ADDRESS_PROVIDER)\n', '        public {\n', '            owner = msg.sender;\n', '    }\n', '\n', '    /// @notice Called by Aave when sending back the FL amount\n', '    /// @param _reserve The address of the borrowed token\n', '    /// @param _amount Amount of FL tokens received\n', '    /// @param _fee FL Aave fee\n', '    /// @param _params The params that are sent from the original FL caller contract\n', '    function executeOperation(\n', '        address _reserve,\n', '        uint256 _amount,\n', '        uint256 _fee,\n', '        bytes calldata _params)\n', '    external override {\n', '\n', '        (\n', '            address cCollateralToken,\n', '            address cBorrowToken,\n', '            address user,\n', '            address proxy\n', '        )\n', '        = abi.decode(_params, (address,address,address,address));\n', '\n', '        // approve FL tokens so we can repay them\n', '        ERC20(_reserve).safeApprove(cBorrowToken, 0);\n', '        ERC20(_reserve).safeApprove(cBorrowToken, uint(-1));\n', '\n', '        // repay compound debt\n', '        require(CTokenInterface(cBorrowToken).repayBorrowBehalf(user, uint(-1)) == 0, "Repay borrow behalf fail");\n', '\n', '        // transfer cTokens to proxy\n', '        uint cTokenBalance = CTokenInterface(cCollateralToken).balanceOf(user);\n', '        require(CTokenInterface(cCollateralToken).transferFrom(user, proxy, cTokenBalance));\n', '\n', '        // borrow\n', '        bytes memory proxyData = getProxyData(cCollateralToken, cBorrowToken, _reserve, (_amount + _fee));\n', '        DSProxyInterface(proxy).execute(COMPOUND_BORROW_PROXY, proxyData);\n', '\n', '        // Repay the loan with the money DSProxy sent back\n', '        transferFundsBackToPoolInternal(_reserve, _amount.add(_fee));\n', '    }\n', '\n', '    /// @notice Formats function data call so we can call it through DSProxy\n', '    /// @param _cCollToken CToken address of collateral\n', '    /// @param _cBorrowToken CToken address we will borrow\n', '    /// @param _borrowToken Token address we will borrow\n', '    /// @param _amount Amount that will be borrowed\n', '    /// @return proxyData Formated function call data\n', '    function getProxyData(address _cCollToken, address _cBorrowToken, address _borrowToken, uint _amount) internal pure returns (bytes memory proxyData) {\n', '        proxyData = abi.encodeWithSignature(\n', '            "borrow(address,address,address,uint256)",\n', '            _cCollToken, _cBorrowToken, _borrowToken, _amount);\n', '    }\n', '\n', '    function withdrawStuckFunds(address _tokenAddr, uint _amount) public {\n', '        require(owner == msg.sender, "Must be owner");\n', '\n', '        if (_tokenAddr == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {\n', '            msg.sender.transfer(_amount);\n', '        } else {\n', '            ERC20(_tokenAddr).safeTransfer(owner, _amount);\n', '        }\n', '    }\n', '}']