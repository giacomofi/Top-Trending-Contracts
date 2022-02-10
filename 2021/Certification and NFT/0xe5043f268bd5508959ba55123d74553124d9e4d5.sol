['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-18\n', '*/\n', '\n', 'pragma solidity =0.7.6;  \n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256 supply);\n', '\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '    ) external returns (bool success);\n', '\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining);\n', '\n', '    function decimals() external view returns (uint256 digits);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}  \n', '\n', '\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly {\n', '            codehash := extcodehash(account)\n', '        }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{value: amount}("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(\n', '        address target,\n', '        bytes memory data,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value\n', '    ) internal returns (bytes memory) {\n', '        return\n', '            functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 value,\n', '        string memory errorMessage\n', '    ) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(\n', '        address target,\n', '        bytes memory data,\n', '        uint256 weiValue,\n', '        string memory errorMessage\n', '    ) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}  \n', '\n', '\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}  \n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)\n', '        );\n', '    }\n', '\n', '    /// @dev Edited so it always first approves 0 and then the value, because of non standard tokens\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));\n', '        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.approve.selector, spender, newAllowance)\n', '        );\n', '    }\n', '\n', '    function safeDecreaseAllowance(\n', '        IERC20 token,\n', '        address spender,\n', '        uint256 value\n', '    ) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(\n', '            value,\n', '            "SafeERC20: decreased allowance below zero"\n', '        );\n', '        _callOptionalReturn(\n', '            token,\n', '            abi.encodeWithSelector(token.approve.selector, spender, newAllowance)\n', '        );\n', '    }\n', '\n', '    function _callOptionalReturn(IERC20 token, bytes memory data) private {\n', '        bytes memory returndata = address(token).functionCall(\n', '            data,\n', '            "SafeERC20: low-level call failed"\n', '        );\n', '        if (returndata.length > 0) {\n', '            // Return data is optional\n', '            // solhint-disable-next-line max-line-length\n', '            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");\n', '        }\n', '    }\n', '}  \n', '\n', '\n', '\n', 'contract DSMath {\n', '    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require((z = x + y) >= x, "");\n', '    }\n', '\n', '    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require((z = x - y) <= x, "");\n', '    }\n', '\n', '    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        require(y == 0 || (z = x * y) / y == x, "");\n', '    }\n', '\n', '    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        return x / y;\n', '    }\n', '\n', '    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        return x <= y ? x : y;\n', '    }\n', '\n', '    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    function imin(int256 x, int256 y) internal pure returns (int256 z) {\n', '        return x <= y ? x : y;\n', '    }\n', '\n', '    function imax(int256 x, int256 y) internal pure returns (int256 z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint256 constant WAD = 10**18;\n', '    uint256 constant RAY = 10**27;\n', '\n', '    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '\n', '    function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '\n', '    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '\n', '    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}  \n', '\n', '\n', '\n', 'abstract contract IDFSRegistry {\n', ' \n', '    function getAddr(bytes32 _id) public view virtual returns (address);\n', '\n', '    function addNewContract(\n', '        bytes32 _id,\n', '        address _contractAddr,\n', '        uint256 _waitPeriod\n', '    ) public virtual;\n', '\n', '    function startContractChange(bytes32 _id, address _newContractAddr) public virtual;\n', '\n', '    function approveContractChange(bytes32 _id) public virtual;\n', '\n', '    function cancelContractChange(bytes32 _id) public virtual;\n', '\n', '    function changeWaitPeriod(bytes32 _id, uint256 _newWaitPeriod) public virtual;\n', '}  \n', '\n', '\n', '\n', '/// @title A stateful contract that holds and can change owner/admin\n', 'contract AdminVault {\n', '    address public owner;\n', '    address public admin;\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '        admin = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9;\n', '    }\n', '\n', '    /// @notice Admin is able to change owner\n', '    /// @param _owner Address of new owner\n', '    function changeOwner(address _owner) public {\n', '        require(admin == msg.sender, "msg.sender not admin");\n', '        owner = _owner;\n', '    }\n', '\n', '    /// @notice Admin is able to set new admin\n', '    /// @param _admin Address of multisig that becomes new admin\n', '    function changeAdmin(address _admin) public {\n', '        require(admin == msg.sender, "msg.sender not admin");\n', '        admin = _admin;\n', '    }\n', '\n', '}  \n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/// @title AdminAuth Handles owner/admin privileges over smart contracts\n', 'contract AdminAuth {\n', '    using SafeERC20 for IERC20;\n', '\n', '    address public constant ADMIN_VAULT_ADDR = 0xCCf3d848e08b94478Ed8f46fFead3008faF581fD;\n', '\n', '    AdminVault public constant adminVault = AdminVault(ADMIN_VAULT_ADDR);\n', '\n', '    modifier onlyOwner() {\n', '        require(adminVault.owner() == msg.sender, "msg.sender not owner");\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(adminVault.admin() == msg.sender, "msg.sender not admin");\n', '        _;\n', '    }\n', '\n', '    /// @notice withdraw stuck funds\n', '    function withdrawStuckFunds(address _token, address _receiver, uint256 _amount) public onlyOwner {\n', '        if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {\n', '            payable(_receiver).transfer(_amount);\n', '        } else {\n', '            IERC20(_token).safeTransfer(_receiver, _amount);\n', '        }\n', '    }\n', '\n', '    /// @notice Destroy the contract\n', '    function kill() public onlyAdmin {\n', '        selfdestruct(payable(msg.sender));\n', '    }\n', '}  \n', '\n', '\n', '\n', '\n', '\n', 'abstract contract IWETH {\n', '    function allowance(address, address) public virtual returns (uint256);\n', '\n', '    function balanceOf(address) public virtual returns (uint256);\n', '\n', '    function approve(address, uint256) public virtual;\n', '\n', '    function transfer(address, uint256) public virtual returns (bool);\n', '\n', '    function transferFrom(\n', '        address,\n', '        address,\n', '        uint256\n', '    ) public virtual returns (bool);\n', '\n', '    function deposit() public payable virtual;\n', '\n', '    function withdraw(uint256) public virtual;\n', '}  \n', '\n', '\n', '\n', '\n', '\n', '\n', 'library TokenUtils {\n', '    using SafeERC20 for IERC20;\n', '\n', '    address public constant WETH_ADDR = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    address public constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '    function approveToken(\n', '        address _tokenAddr,\n', '        address _to,\n', '        uint256 _amount\n', '    ) internal {\n', '        if (_tokenAddr == ETH_ADDR) return;\n', '\n', '        if (IERC20(_tokenAddr).allowance(address(this), _to) < _amount) {\n', '            IERC20(_tokenAddr).safeApprove(_to, _amount);\n', '        }\n', '    }\n', '\n', '    function pullTokensIfNeeded(\n', '        address _token,\n', '        address _from,\n', '        uint256 _amount\n', '    ) internal returns (uint256) {\n', '        // handle max uint amount\n', '        if (_amount == type(uint256).max) {\n', '            uint256 userAllowance = IERC20(_token).allowance(_from, address(this));\n', '            uint256 balance = getBalance(_token, _from);\n', '\n', '            // pull max allowance amount if balance is bigger than allowance\n', '            _amount = (balance > userAllowance) ? userAllowance : balance;\n', '        }\n', '\n', '        if (_from != address(0) && _from != address(this) && _token != ETH_ADDR && _amount != 0) {\n', '            IERC20(_token).safeTransferFrom(_from, address(this), _amount);\n', '        }\n', '\n', '        return _amount;\n', '    }\n', '\n', '    function withdrawTokens(\n', '        address _token,\n', '        address _to,\n', '        uint256 _amount\n', '    ) internal returns (uint256) {\n', '        if (_amount == type(uint256).max) {\n', '            _amount = getBalance(_token, address(this));\n', '        }\n', '\n', '        if (_to != address(0) && _to != address(this) && _amount != 0) {\n', '            if (_token != ETH_ADDR) {\n', '                IERC20(_token).safeTransfer(_to, _amount);\n', '            } else {\n', '                payable(_to).transfer(_amount);\n', '            }\n', '        }\n', '\n', '        return _amount;\n', '    }\n', '\n', '    function depositWeth(uint256 _amount) internal {\n', '        IWETH(WETH_ADDR).deposit{value: _amount}();\n', '    }\n', '\n', '    function withdrawWeth(uint256 _amount) internal {\n', '        IWETH(WETH_ADDR).withdraw(_amount);\n', '    }\n', '\n', '    function getBalance(address _tokenAddr, address _acc) internal view returns (uint256) {\n', '        if (_tokenAddr == ETH_ADDR) {\n', '            return _acc.balance;\n', '        } else {\n', '            return IERC20(_tokenAddr).balanceOf(_acc);\n', '        }\n', '    }\n', '\n', '    function getTokenDecimals(address _token) internal view returns (uint256) {\n', '        if (_token == ETH_ADDR) return 18;\n', '\n', '        return IERC20(_token).decimals();\n', '    }\n', '}  \n', '\n', '\n', '\n', 'contract Discount {\n', '    address public owner;\n', '    mapping(address => CustomServiceFee) public serviceFees;\n', '\n', '    uint256 constant MAX_SERVICE_FEE = 400;\n', '\n', '    struct CustomServiceFee {\n', '        bool active;\n', '        uint256 amount;\n', '    }\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function isCustomFeeSet(address _user) public view returns (bool) {\n', '        return serviceFees[_user].active;\n', '    }\n', '\n', '    function getCustomServiceFee(address _user) public view returns (uint256) {\n', '        return serviceFees[_user].amount;\n', '    }\n', '\n', '    function setServiceFee(address _user, uint256 _fee) public {\n', '        require(msg.sender == owner, "Only owner");\n', '        require(_fee >= MAX_SERVICE_FEE || _fee == 0, "Wrong fee value");\n', '\n', '        serviceFees[_user] = CustomServiceFee({active: true, amount: _fee});\n', '    }\n', '\n', '    function disableServiceFee(address _user) public {\n', '        require(msg.sender == owner, "Only owner");\n', '\n', '        serviceFees[_user] = CustomServiceFee({active: false, amount: 0});\n', '    }\n', '}  \n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract DFSExchangeHelper {\n', '    \n', '    using TokenUtils for address;\n', '    \n', '    string public constant ERR_OFFCHAIN_DATA_INVALID = "Offchain data invalid";\n', '\n', '    using SafeERC20 for IERC20;\n', '\n', '    function sendLeftover(\n', '        address _srcAddr,\n', '        address _destAddr,\n', '        address payable _to\n', '    ) internal {\n', '        // clean out any eth leftover\n', '        TokenUtils.ETH_ADDR.withdrawTokens(_to, type(uint256).max);\n', '\n', '        _srcAddr.withdrawTokens(_to, type(uint256).max);\n', '        _destAddr.withdrawTokens(_to, type(uint256).max);\n', '    }\n', '\n', '    function sliceUint(bytes memory bs, uint256 start) internal pure returns (uint256) {\n', '        require(bs.length >= start + 32, "slicing out of range");\n', '\n', '        uint256 x;\n', '        assembly {\n', '            x := mload(add(bs, add(0x20, start)))\n', '        }\n', '\n', '        return x;\n', '    }\n', '\n', '    function writeUint256(\n', '        bytes memory _b,\n', '        uint256 _index,\n', '        uint256 _input\n', '    ) internal pure {\n', '        if (_b.length < _index + 32) {\n', '            revert(ERR_OFFCHAIN_DATA_INVALID);\n', '        }\n', '\n', '        bytes32 input = bytes32(_input);\n', '\n', '        _index += 32;\n', '\n', '        // Read the bytes32 from array memory\n', '        assembly {\n', '            mstore(add(_b, _index), input)\n', '        }\n', '    }\n', '}  \n', '\n', '\n', '\n', 'contract DFSExchangeData {\n', '\n', '    // first is empty to keep the legacy order in place\n', '    enum ExchangeType { _, OASIS, KYBER, UNISWAP, ZEROX }\n', '\n', '    enum ExchangeActionType { SELL, BUY }\n', '\n', '    struct OffchainData {\n', '        address wrapper;\n', '        address exchangeAddr;\n', '        address allowanceTarget;\n', '        uint256 price;\n', '        uint256 protocolFee;\n', '        bytes callData;\n', '    }\n', '\n', '    struct ExchangeData {\n', '        address srcAddr;\n', '        address destAddr;\n', '        uint256 srcAmount;\n', '        uint256 destAmount;\n', '        uint256 minPrice;\n', '        uint256 dfsFeeDivider; // service fee divider\n', '        address user; // user to check special fee\n', '        address wrapper;\n', '        bytes wrapperData;\n', '        OffchainData offchainData;\n', '    }\n', '\n', '    function packExchangeData(ExchangeData memory _exData) public pure returns(bytes memory) {\n', '        return abi.encode(_exData);\n', '    }\n', '\n', '    function unpackExchangeData(bytes memory _data) public pure returns(ExchangeData memory _exData) {\n', '        _exData = abi.decode(_data, (ExchangeData));\n', '    }\n', '}  \n', '\n', '\n', '\n', '\n', '\n', '\n', 'abstract contract IOffchainWrapper is DFSExchangeData {\n', '    function takeOrder(\n', '        ExchangeData memory _exData,\n', '        ExchangeActionType _type\n', '    ) virtual public payable returns (bool success, uint256);\n', '}  \n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract ScpWrapper is IOffchainWrapper, DFSExchangeHelper, AdminAuth, DSMath {\n', '\n', '    using TokenUtils for address;\n', '\n', '    string public constant ERR_SRC_AMOUNT = "Not enough funds";\n', '    string public constant ERR_PROTOCOL_FEE = "Not enough eth for protocol fee";\n', '    string public constant ERR_TOKENS_SWAPPED_ZERO = "Order success but amount 0";\n', '\n', '    using SafeERC20 for IERC20;\n', '\n', '    /// @notice Takes order from Scp and returns bool indicating if it is successful\n', '    /// @param _exData Exchange data\n', '    /// @param _type Action type (buy or sell)\n', '    function takeOrder(\n', '        ExchangeData memory _exData,\n', '        ExchangeActionType _type\n', '    ) override public payable returns (bool success, uint256) {\n', '        // check that contract have enough balance for exchange and protocol fee\n', '        require(_exData.srcAddr.getBalance(address(this)) >= _exData.srcAmount, ERR_SRC_AMOUNT);\n', '        require(TokenUtils.ETH_ADDR.getBalance(address(this)) >= _exData.offchainData.protocolFee, ERR_PROTOCOL_FEE);\n', '\n', '        IERC20(_exData.srcAddr).safeApprove(_exData.offchainData.allowanceTarget, _exData.srcAmount);\n', '\n', '        // write in the exact amount we are selling/buying in an order\n', '        if (_type == ExchangeActionType.SELL) {\n', '            writeUint256(_exData.offchainData.callData, 36, _exData.srcAmount);\n', '        } else {\n', '            uint srcAmount = wdiv(_exData.destAmount, _exData.offchainData.price) + 1; // + 1 so we round up\n', '            writeUint256(_exData.offchainData.callData, 36, srcAmount);\n', '        }\n', '\n', '        uint256 tokensBefore = _exData.destAddr.getBalance(address(this));\n', '        (success, ) = _exData.offchainData.exchangeAddr.call{value: _exData.offchainData.protocolFee}(_exData.offchainData.callData);\n', '        uint256 tokensSwapped = 0;\n', '\n', '        if (success) {\n', '            // get the current balance of the swapped tokens\n', '            tokensSwapped = sub(_exData.destAddr.getBalance(address(this)), tokensBefore);\n', '            require(tokensSwapped > 0, ERR_TOKENS_SWAPPED_ZERO);\n', '        }\n', '\n', '        // returns all funds from src addr, dest addr and eth funds (protocol fee leftovers)\n', '        sendLeftover(_exData.srcAddr, _exData.destAddr, msg.sender);\n', '\n', '        return (success, tokensSwapped);\n', '    }\n', '\n', '    // solhint-disable-next-line no-empty-blocks\n', '    receive() external virtual payable {}\n', '}']