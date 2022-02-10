['pragma solidity ^0.6.0; interface ERC20 {\n', '    function totalSupply() external view returns (uint256 supply);\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        external\n', '        returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining);\n', '\n', '    function decimals() external view returns (uint256 digits);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '} abstract contract GasTokenInterface is ERC20 {\n', '    function free(uint256 value) public virtual returns (bool success);\n', '\n', '    function freeUpTo(uint256 value) public virtual returns (uint256 freed);\n', '\n', '    function freeFrom(address from, uint256 value) public virtual returns (bool success);\n', '\n', '    function freeFromUpTo(address from, uint256 value) public virtual returns (uint256 freed);\n', '} contract GasBurner {\n', '    // solhint-disable-next-line const-name-snakecase\n', '    GasTokenInterface public constant gasToken = GasTokenInterface(0x0000000000b3F879cb30FE243b4Dfee438691c04);\n', '\n', '    modifier burnGas(uint _amount) {\n', '        if (gasToken.balanceOf(address(this)) >= _amount) {\n', '            gasToken.free(_amount);\n', '        }\n', '\n', '        _;\n', '    }\n', '} library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '} library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '} library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(ERC20 token, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));\n', '    }\n', '\n', '    /**\n', '     * @dev Deprecated. This function has issues similar to the ones found in\n', '     * {IERC20-approve}, and its usage is discouraged.\n', '     */\n', '    function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));\n', '    }\n', '\n', '    function _callOptionalReturn(ERC20 token, bytes memory data) private {\n', '\n', '        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");\n', '        if (returndata.length > 0) { // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '} abstract contract CTokenInterface is ERC20 {\n', '    function mint(uint256 mintAmount) external virtual returns (uint256);\n', '\n', '    // function mint() external virtual payable;\n', '\n', '    function accrueInterest() public virtual returns (uint);\n', '\n', '    function redeem(uint256 redeemTokens) external virtual returns (uint256);\n', '\n', '    function redeemUnderlying(uint256 redeemAmount) external virtual returns (uint256);\n', '\n', '    function borrow(uint256 borrowAmount) external virtual returns (uint256);\n', '\n', '    function repayBorrow(uint256 repayAmount) external virtual returns (uint256);\n', '\n', '    function repayBorrow() external virtual payable;\n', '\n', '    function repayBorrowBehalf(address borrower, uint256 repayAmount) external virtual returns (uint256);\n', '\n', '    function repayBorrowBehalf(address borrower) external virtual payable;\n', '\n', '    function liquidateBorrow(address borrower, uint256 repayAmount, address cTokenCollateral)\n', '        external virtual\n', '        returns (uint256);\n', '\n', '    function liquidateBorrow(address borrower, address cTokenCollateral) external virtual payable;\n', '\n', '    function exchangeRateCurrent() external virtual returns (uint256);\n', '\n', '    function supplyRatePerBlock() external virtual returns (uint256);\n', '\n', '    function borrowRatePerBlock() external virtual returns (uint256);\n', '\n', '    function totalReserves() external virtual returns (uint256);\n', '\n', '    function reserveFactorMantissa() external virtual returns (uint256);\n', '\n', '    function borrowBalanceCurrent(address account) external virtual returns (uint256);\n', '\n', '    function totalBorrowsCurrent() external virtual returns (uint256);\n', '\n', '    function getCash() external virtual returns (uint256);\n', '\n', '    function balanceOfUnderlying(address owner) external virtual returns (uint256);\n', '\n', '    function underlying() external virtual returns (address);\n', '\n', '    function getAccountSnapshot(address account) external virtual view returns (uint, uint, uint, uint);\n', '} abstract contract CEtherInterface {\n', '    function mint() external virtual payable;\n', '    function repayBorrow() external virtual payable;\n', '} abstract contract ComptrollerInterface {\n', '    function enterMarkets(address[] calldata cTokens) external virtual returns (uint256[] memory);\n', '\n', '    function exitMarket(address cToken) external virtual returns (uint256);\n', '\n', '    function getAssetsIn(address account) external virtual view returns (address[] memory);\n', '\n', '    function markets(address account) public virtual view returns (bool, uint256);\n', '\n', '    function getAccountLiquidity(address account) external virtual view returns (uint256, uint256, uint256);\n', '\n', '    function claimComp(address holder) virtual public;\n', '\n', '    function oracle() public virtual view returns (address);\n', '} /// @title Basic cream interactions through the DSProxy\n', 'contract CreamBasicProxy is GasBurner {\n', '\n', '    address public constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '    address public constant COMPTROLLER_ADDR = 0x3d5BC3c8d13dcB8bF317092d84783c2697AE9258;\n', '\n', '    using SafeERC20 for ERC20;\n', '\n', '    /// @notice User deposits tokens to the cream protocol\n', '    /// @dev User needs to approve the DSProxy to pull the _tokenAddr tokens\n', '    /// @param _tokenAddr The address of the token to be deposited\n', '    /// @param _cTokenAddr CTokens to be deposited\n', '    /// @param _amount Amount of tokens to be deposited\n', '    /// @param _inMarket True if the token is already in market for that address\n', '    function deposit(address _tokenAddr, address _cTokenAddr, uint _amount, bool _inMarket) public burnGas(5) payable {\n', '        if (_tokenAddr != ETH_ADDR) {\n', '            ERC20(_tokenAddr).safeTransferFrom(msg.sender, address(this), _amount);\n', '        }\n', '\n', '        approveToken(_tokenAddr, _cTokenAddr);\n', '\n', '        if (!_inMarket) {\n', '            enterMarket(_cTokenAddr);\n', '        }\n', '\n', '        if (_tokenAddr != ETH_ADDR) {\n', '            require(CTokenInterface(_cTokenAddr).mint(_amount) == 0);\n', '        } else {\n', '            CEtherInterface(_cTokenAddr).mint{value: msg.value}(); // reverts on fail\n', '        }\n', '    }\n', '\n', '    /// @notice User withdraws tokens to the cream protocol\n', '    /// @param _tokenAddr The address of the token to be withdrawn\n', '    /// @param _cTokenAddr CTokens to be withdrawn\n', '    /// @param _amount Amount of tokens to be withdrawn\n', '    /// @param _isCAmount If true _amount is cTokens if falls _amount is underlying tokens\n', '    function withdraw(address _tokenAddr, address _cTokenAddr, uint _amount, bool _isCAmount) public burnGas(5) {\n', '\n', '        if (_isCAmount) {\n', '            require(CTokenInterface(_cTokenAddr).redeem(_amount) == 0);\n', '        } else {\n', '            require(CTokenInterface(_cTokenAddr).redeemUnderlying(_amount) == 0);\n', '        }\n', '\n', '        // withdraw funds to msg.sender\n', '        if (_tokenAddr != ETH_ADDR) {\n', '            ERC20(_tokenAddr).safeTransfer(msg.sender, ERC20(_tokenAddr).balanceOf(address(this)));\n', '        } else {\n', '            msg.sender.transfer(address(this).balance);\n', '        }\n', '\n', '    }\n', '\n', '    /// @notice User borrows tokens to the cream protocol\n', '    /// @param _tokenAddr The address of the token to be borrowed\n', '    /// @param _cTokenAddr CTokens to be borrowed\n', '    /// @param _amount Amount of tokens to be borrowed\n', '    /// @param _inMarket True if the token is already in market for that address\n', '    function borrow(address _tokenAddr, address _cTokenAddr, uint _amount, bool _inMarket) public burnGas(8) {\n', '        if (!_inMarket) {\n', '            enterMarket(_cTokenAddr);\n', '        }\n', '\n', '        require(CTokenInterface(_cTokenAddr).borrow(_amount) == 0);\n', '\n', '        // withdraw funds to msg.sender\n', '        if (_tokenAddr != ETH_ADDR) {\n', '            ERC20(_tokenAddr).safeTransfer(msg.sender, ERC20(_tokenAddr).balanceOf(address(this)));\n', '        } else {\n', '            msg.sender.transfer(address(this).balance);\n', '        }\n', '    }\n', '\n', '    /// @dev User needs to approve the DSProxy to pull the _tokenAddr tokens\n', '    /// @notice User paybacks tokens to the cream protocol\n', '    /// @param _tokenAddr The address of the token to be paybacked\n', '    /// @param _cTokenAddr CTokens to be paybacked\n', '    /// @param _amount Amount of tokens to be payedback\n', '    /// @param _wholeDebt If true the _amount will be set to the whole amount of the debt\n', '    function payback(address _tokenAddr, address _cTokenAddr, uint _amount, bool _wholeDebt) public burnGas(5) payable {\n', '        approveToken(_tokenAddr, _cTokenAddr);\n', '\n', '        if (_wholeDebt) {\n', '            _amount = CTokenInterface(_cTokenAddr).borrowBalanceCurrent(address(this));\n', '        }\n', '\n', '        if (_tokenAddr != ETH_ADDR) {\n', '            ERC20(_tokenAddr).safeTransferFrom(msg.sender, address(this), _amount);\n', '\n', '            require(CTokenInterface(_cTokenAddr).repayBorrow(_amount) == 0);\n', '        } else {\n', '            CEtherInterface(_cTokenAddr).repayBorrow{value: msg.value}();\n', '            msg.sender.transfer(address(this).balance); // send back the extra eth\n', '        }\n', '    }\n', '\n', '    /// @notice Helper method to withdraw tokens from the DSProxy\n', '    /// @param _tokenAddr Address of the token to be withdrawn\n', '    function withdrawTokens(address _tokenAddr) public {\n', '        if (_tokenAddr != ETH_ADDR) {\n', '            ERC20(_tokenAddr).safeTransfer(msg.sender, ERC20(_tokenAddr).balanceOf(address(this)));\n', '        } else {\n', '            msg.sender.transfer(address(this).balance);\n', '        }\n', '    }\n', '\n', '    /// @notice Enters the cream market so it can be deposited/borrowed\n', '    /// @param _cTokenAddr CToken address of the token\n', '    function enterMarket(address _cTokenAddr) public {\n', '        address[] memory markets = new address[](1);\n', '        markets[0] = _cTokenAddr;\n', '\n', '        ComptrollerInterface(COMPTROLLER_ADDR).enterMarkets(markets);\n', '    }\n', '\n', "    /// @notice Exits the cream market so it can't be deposited/borrowed\n", '    /// @param _cTokenAddr CToken address of the token\n', '    function exitMarket(address _cTokenAddr) public {\n', '        ComptrollerInterface(COMPTROLLER_ADDR).exitMarket(_cTokenAddr);\n', '    }\n', '\n', '    /// @notice Approves CToken contract to pull underlying tokens from the DSProxy\n', '    /// @param _tokenAddr Token we are trying to approve\n', '    /// @param _cTokenAddr Address which will gain the approval\n', '    function approveToken(address _tokenAddr, address _cTokenAddr) internal {\n', '        if (_tokenAddr != ETH_ADDR) {\n', '            ERC20(_tokenAddr).safeApprove(_cTokenAddr, 0);\n', '            ERC20(_tokenAddr).safeApprove(_cTokenAddr, uint(-1));\n', '        }\n', '    }\n', '}']