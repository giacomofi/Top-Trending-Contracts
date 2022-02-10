['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-29\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    /**\n', '     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with\n', '     * `errorMessage` as a fallback revert reason when `target` reverts.\n', '     *\n', '     * _Available since v3.1._\n', '     */\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev A token holder contract that will allow a beneficiary to extract the\n', ' * tokens at predefined intervals. Tokens not claimed at payment epochs accumulate\n', " * Modified version of Openzeppelin's TokenTimeLock\n", ' */\n', 'contract Lock is Ownable {\n', '    using SafeMath for uint;\n', '    enum period {\n', '        second,\n', '        minute,\n', '        hour,\n', '        day,\n', '        week,\n', '        month, //inaccurate, assumes 30 day month, subject to drift\n', '        year,\n', '        quarter,//13 weeks\n', '        biannual//26 weeks\n', '    }\n', '    \n', '    //The length in seconds for each epoch between payments\n', '    uint epochLength;\n', '    // ERC20 basic token contract being held\n', '    IERC20 private _token;\n', '\n', '    // beneficiary of tokens after they are released\n', '    address private _beneficiary;\n', '\n', '    uint periods;\n', '\n', '    //the size of periodic payments\n', '    uint paymentSize;\n', '    uint paymentsRemaining =0;\n', '    uint startTime =0;\n', '    uint beneficiaryBalance = 0;\n', '\n', '    function initialize(address tokenAddress, address beneficiary, uint duration,uint durationMultiple,uint p)  public onlyOwner{\n', '        release();\n', "        require(paymentsRemaining == 0, 'cannot initialize during active vesting schedule');\n", "        require(duration>0 && p>0, 'epoch parameters must be positive');\n", '        _token = IERC20(tokenAddress);\n', '        _beneficiary = beneficiary;\n', '        if(duration<=uint(period.biannual)){\n', '         \n', '            if(duration == uint(period.second)){\n', '                epochLength = durationMultiple * 1 seconds;\n', '            }else if(duration == uint(period.minute)){\n', '                epochLength = durationMultiple * 1 minutes;\n', '            }\n', '            else if(duration == uint(period.hour)){\n', '                epochLength =  durationMultiple *1 hours;\n', '            }else if(duration == uint(period.day)){\n', '                epochLength =  durationMultiple *1 days;\n', '            }\n', '            else if(duration == uint(period.week)){\n', '                epochLength =  durationMultiple *1 weeks;\n', '            }else if(duration == uint(period.month)){\n', '                epochLength =  durationMultiple *30 days;\n', '            }else if(duration == uint(period.year)){\n', '                epochLength =  durationMultiple *52 weeks;\n', '            }else if(duration == uint(period.quarter)){\n', '                epochLength =  durationMultiple *13 weeks;\n', '            }\n', '            else if(duration == uint(period.biannual)){\n', '                epochLength = 26 weeks;\n', '            }\n', '        }\n', '        else{\n', '                epochLength = duration; //custom value\n', '            }\n', '            periods = p;\n', '\n', '        emit Initialized(tokenAddress,beneficiary,epochLength,p);\n', '    }\n', '\n', '    function deposit (uint amount) public { //remember to ERC20.approve\n', "         require (_token.transferFrom(msg.sender,address(this),amount),'transfer failed');\n", '         uint balance = _token.balanceOf(address(this));\n', '         if(paymentsRemaining==0)\n', '         {\n', '             paymentsRemaining = periods;\n', '             startTime = block.timestamp;\n', '         }\n', '         paymentSize = balance/paymentsRemaining;\n', '         emit PaymentsUpdatedOnDeposit(paymentSize,startTime,paymentsRemaining);\n', '    }\n', '\n', '    function getElapsedReward() public view returns (uint,uint,uint){\n', '         if(epochLength == 0)\n', '            return (0, startTime,paymentsRemaining);\n', '        uint elapsedEpochs = (block.timestamp - startTime)/epochLength;\n', '        if(elapsedEpochs==0)\n', '            return (0, startTime,paymentsRemaining);\n', '        elapsedEpochs = elapsedEpochs>paymentsRemaining?paymentsRemaining:elapsedEpochs;\n', '        uint newStartTime = block.timestamp;\n', '        uint newPaymentsRemaining = paymentsRemaining.sub(elapsedEpochs);\n', '        uint balance  =_token.balanceOf(address(this));\n', '        uint accumulatedFunds = paymentSize.mul(elapsedEpochs);\n', '         return (beneficiaryBalance.add(accumulatedFunds>balance?balance:accumulatedFunds),newStartTime,newPaymentsRemaining);\n', '    } \n', '\n', '    function updateBeneficiaryBalance() private {\n', '        (beneficiaryBalance,startTime, paymentsRemaining) = getElapsedReward();\n', '    }\n', '\n', '    function changeBeneficiary (address beneficiary) public onlyOwner{\n', "        require (paymentsRemaining == 0, 'TokenTimelock: cannot change beneficiary while token balance positive');\n", '        _beneficiary = beneficiary;\n', '    }\n', '    /**\n', '     * @return the beneficiary of the tokens.\n', '     */\n', '    function beneficiary() public view returns (address) {\n', '        return _beneficiary;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to beneficiary.\n', '     */\n', '    function release() public {\n', '        // solhint-disable-next-line not-rely-on-time\n', '        require(block.timestamp >= startTime, "TokenTimelock: current time is before release time");\n', '        updateBeneficiaryBalance();\n', '        uint amountToSend = beneficiaryBalance;\n', '        beneficiaryBalance = 0;\n', '        if(amountToSend>0)\n', "            require(_token.transfer(_beneficiary,amountToSend),'release funds failed');\n", '        emit FundsReleasedToBeneficiary(_beneficiary,amountToSend,block.timestamp);\n', '    }\n', '\n', '    event PaymentsUpdatedOnDeposit(uint paymentSize,uint startTime, uint paymentsRemaining);\n', '    event Initialized (address tokenAddress, address beneficiary, uint duration,uint periods);\n', '    event FundsReleasedToBeneficiary(address beneficiary, uint value, uint timeStamp);\n', '}']