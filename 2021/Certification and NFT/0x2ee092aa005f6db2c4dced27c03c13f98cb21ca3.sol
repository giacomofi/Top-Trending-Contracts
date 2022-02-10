['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-13\n', '*/\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes calldata) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/sale_v2.sol\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', '//@R\n', '\n', '//+---------------------------------------------------------------------------------------+\n', '// Imports\n', '//+---------------------------------------------------------------------------------------+\n', '\n', '\n', '\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '//+---------------------------------------------------------------------------------------+\n', '// Contracts\n', '//+---------------------------------------------------------------------------------------+\n', '\n', '/** This contract is designed for coordinating the sale of wLiti tokens to purchasers\n', '  *     and includes a referral system where referrers earn bonus tokens on each wLiti\n', '  *     sale.\n', '  **/\n', 'contract wLitiSale is Context, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    //+---------------------------------------------------------------------------------------+\n', '    // Structures\n', '    //+---------------------------------------------------------------------------------------+\n', '\n', '    //Type for tracking referral memebers and their bonus percentages\n', '    struct Referrer {\n', '\n', '        bool isReferrer;  //If true, referer is allowed to receive referral bonuses\n', '        uint256 bonusPercent; //Percentage bonus amount\n', '\n', '    }\n', '\n', '    //+---------------------------------------------------------------------------------------+\n', '    // Contract Data Members\n', '    //+---------------------------------------------------------------------------------------+\n', '\n', '    //Referral info\n', '    address private _masterReferrerWallet; //Wallet of the master referrer (this person ALWAYS recieves a bonus)\n', '    uint256 private _maxBonusPercent; //Max bonus that can be given to referrers\n', '    mapping(address => Referrer) _referrers; //Track referrer info\n', '\n', '    //Sale info\n', '    IERC20 private _token; //Token to be sold\n', '    address private _ETHWallet; //Wallet ETH is sent to\n', '    uint256 private _saleCount; //Counts the number of sales\n', '    uint256 private _tokenPrice; //ETH price per token\n', '    uint256 private _saleSupplyLeft; //Supply left in sale\n', '    uint256 private _saleSupplyTotal; //Total supply of sale\n', '    uint256 private _saleStartTime; //Sale start epoch timestamp\n', '    uint256 private _saleEndTime; //Sale end epoch timestamp\n', '    mapping(uint256 => uint256) _weiRaised; //Track wei raised from each sale\n', '\n', '    //+---------------------------------------------------------------------------------------+\n', '    // Constructors\n', '    //+---------------------------------------------------------------------------------------+\n', '\n', '    /** Constructor to build the contract\n', '      *\n', '      * @param token - the contract address of the token that is being sold\n', '      * @param ETHWallet - the wallet that ETH will be sent to after every purchase\n', '      * @param masterReferrerWallet - the wallet of the master referrer\n', '      *\n', '      **/\n', '    constructor(address token, address ETHWallet, address masterReferrerWallet) {\n', '\n', '        _token = IERC20(token);\n', '        _ETHWallet = ETHWallet;\n', '        _masterReferrerWallet = masterReferrerWallet;\n', '\n', '    }\n', '\n', '    //+---------------------------------------------------------------------------------------+\n', '    // Getters\n', '    //+---------------------------------------------------------------------------------------+\n', '\n', '    function getMasterReferrerWallet() public view returns (address) { return _masterReferrerWallet; }\n', '\n', '    function getReferrerBonusPercent(address referrer) public view returns (uint256) { return _referrers[referrer].bonusPercent; }\n', '\n', '    function getMaxBonusPercent() public view returns (uint256) { return _maxBonusPercent; }\n', '\n', '    function getTokenPrice() public view returns (uint256) { return _tokenPrice; }\n', '\n', '    function getSaleSupplyLeft() public view returns (uint256) { return _saleSupplyLeft; }\n', '\n', '    function getSaleSupplyTotal() public view returns (uint256) { return _saleSupplyTotal; }\n', '\n', '    function getSaleStartTime() public view returns (uint256) { return _saleStartTime; }\n', '\n', '    function getSaleEndTime() public view returns (uint256) { return _saleEndTime; }\n', '\n', '    function getSaleCount() public view returns (uint256) { return _saleCount; }\n', '\n', '    function getWeiRaised(uint256 sale) public view returns (uint256) { return _weiRaised[sale]; }\n', '\n', '    function getETHWallet() public view returns (address) { return _ETHWallet; }\n', '\n', '    function isSaleActive() public view returns (bool) {\n', '\n', '        return (block.timestamp > _saleStartTime &&\n', '                block.timestamp < _saleEndTime);\n', '\n', '    }\n', '\n', '    function isReferrer(address referrer) public view returns (bool) { return _referrers[referrer].isReferrer; }\n', '\n', '    //+---------------------------------------------------------------------------------------+\n', '    // Private Functions\n', '    //+---------------------------------------------------------------------------------------+\n', '\n', '    function transferReferralTokens(address referrer, uint256 bonusPercent, uint purchaseAmountBig) private {\n', '\n', '        uint256 referralAmountBig = purchaseAmountBig.mul(bonusPercent).div(10**2);\n', '        _token.transfer(referrer, (referralAmountBig));\n', '\n', '    }\n', '\n', '    //+---------------------------------------------------------------------------------------+\n', '    // Public/User Functions\n', '    //+---------------------------------------------------------------------------------------+\n', '\n', '    /** Purchase tokens from contract and distribute token bonuses to referrers. Master referrer will ALWAYS recieve at least\n', '      *     a 1% token bonus. A second referrer address is required to be provided when purchasing and they will recieve at least 1%.\n', '      *     A third referrer is optional, but not required. If the optional referrer is an autherized Referrer by the contract owner, then\n', '      *     the optional referrer will receive a minimum of a 1% token bonus.\n', '      *\n', '      *  @param purchaseAmount - the amount of tokens that the purchaser wants to buy\n', '      *  @param referrer - second referrer that is required\n', '      *  @param optionalReferrer - third referrer that is optional\n', '      **/\n', '    function purchaseTokens(uint256 purchaseAmount, address referrer, address optionalReferrer) public payable {\n', '\n', '        require(_msgSender() != address(0), "AddressZero cannot purchase tokens");\n', '        require(isSaleActive(), "Sale is not active");\n', '        require(getTokenPrice() != 0, "Token price is not set");\n', '        require(getMaxBonusPercent() != 0, "Referral bonus percent is not set");\n', '        require(isReferrer(referrer), "Referrer is not authorized");\n', '\n', '        //Calculate big number amounts\n', '        uint256 purchaseAmountBig = purchaseAmount * 1 ether; //Amount of tokens user is purchasing\n', '        uint256 totalRAmountBig = purchaseAmountBig.mul(_maxBonusPercent).div(10**2); //Amount of tokens referrers will earn\n', '        uint256 totalAmountBig = purchaseAmountBig.add(totalRAmountBig); //Total amount of tokens being distributed\n', '        uint256 masterBonusPercent = _maxBonusPercent; //Bonus percent for the master referrer\n', '\n', '        require(totalAmountBig <= _saleSupplyLeft, "Purchase amount is bigger than the remaining sale supply");\n', '\n', '        uint256 totalPrice = purchaseAmount * _tokenPrice; //Total ETH price for tokens\n', '        require(msg.value >= totalPrice, "Payment amount too low");\n', '\n', '        //If the optionalReferrer is an authorized referrer, then distribute referral bonus tokens\n', '        if(isReferrer(optionalReferrer)) {\n', '\n', '            require(_referrers[referrer].bonusPercent + _referrers[optionalReferrer].bonusPercent < _maxBonusPercent,\n', '                "Referrers bonus percent must be less than max bonus");\n', '\n', "            //Subtract the master's bonus by the referrers' bonus AND transfer tokens to the optional referrer\n", '            masterBonusPercent = masterBonusPercent.sub(_referrers[referrer].bonusPercent).sub(_referrers[optionalReferrer].bonusPercent);\n', '            transferReferralTokens(optionalReferrer, _referrers[optionalReferrer].bonusPercent, purchaseAmountBig);\n', '\n', '        }\n', '        //There is only one referrer, ignore the optional referrer\n', '        else {\n', '\n', '            require(_referrers[referrer].bonusPercent < _maxBonusPercent, "Referrer bonus percent must be less than max bonus");\n', '\n', "            //Subtract the master's bonus by the referrer's bonus\n", '            masterBonusPercent = masterBonusPercent.sub(_referrers[referrer].bonusPercent);\n', '\n', '        }\n', '\n', '        //Transfer tokens to referrer, master referrer, and purchaser\n', '        transferReferralTokens(referrer, _referrers[referrer].bonusPercent, purchaseAmountBig);\n', '        transferReferralTokens(_masterReferrerWallet, masterBonusPercent, purchaseAmountBig);\n', '        _token.transfer(msg.sender, (purchaseAmountBig));\n', '\n', '        //Modify sale information\n', '        _weiRaised[_saleCount] = _weiRaised[_saleCount] + totalPrice;\n', '        _saleSupplyLeft = _saleSupplyLeft - (totalAmountBig);\n', '\n', '        //Transfer ETH back to presale wallet\n', '        address payable walletPayable = payable(_ETHWallet);\n', '        walletPayable.transfer(totalPrice);\n', '\n', '        //Transfer extra ETH back to buyer\n', '        address payable client = payable(msg.sender);\n', '        client.transfer(msg.value - totalPrice);\n', '\n', '    }\n', '\n', '    //+---------------------------------------------------------------------------------------+\n', '    // Setters (Owner Only)\n', '    //+---------------------------------------------------------------------------------------+\n', '\n', '    //Set the max bonue that referrers can earn\n', '    function setMaxBonusPercent(uint256 percent) public onlyOwner { _maxBonusPercent = percent; }\n', '\n', '    //Set the ETH price of the tokens\n', '    function setTokenPrice(uint256 price) public onlyOwner { _tokenPrice = price; }\n', '\n', '    //Set the wallet to receive ETH\n', '    function setETHWallet(address ETHWallet) public onlyOwner { _ETHWallet = ETHWallet; }\n', '\n', '    //Set the master referrer wallet\n', '    function setMasterReferrerWallet(address masterReferrerWallet) public onlyOwner { _masterReferrerWallet = masterReferrerWallet; }\n', '\n', '    //Set referrer bonus percent\n', '    function setReferrerBonusPercent(address referrer, uint256 bonusPercent) public onlyOwner {\n', '\n', '        _referrers[referrer].bonusPercent = bonusPercent;\n', '\n', '    }\n', '\n', '    //+---------------------------------------------------------------------------------------+\n', '    // Controls (Owner Only)\n', '    //+---------------------------------------------------------------------------------------+\n', '\n', '    //Add a referrer\n', '    function addReferrer(address referrer, uint256 bonusPercent) public onlyOwner {\n', '\n', '        require(!isReferrer(referrer), "Address is already a referrer");\n', '        require(bonusPercent < _maxBonusPercent, "Referrer bonus cannot be equal to or greater than max bonus");\n', '        require(bonusPercent > 0, "Bonus percent must be greater than 0");\n', '\n', '        _referrers[referrer].isReferrer = true;\n', '        _referrers[referrer].bonusPercent = bonusPercent;\n', '\n', '    }\n', '\n', '    //Remove a referrer\n', '    function removeReferrer(address referrer) public onlyOwner {\n', '\n', '        require(isReferrer(referrer), "Address already is not a referrer");\n', '\n', '        delete _referrers[referrer];\n', '\n', '    }\n', '\n', '    //Withdraw a number of tokens from contract to the contract owner\n', '    function withdrawToken(uint256 amount) public onlyOwner {\n', '        _token.transfer(owner(), amount);\n', '    }\n', '\n', '    //Withdraw ALL tokens from contract to the contract owner\n', '    function withdrawAllTokens() public onlyOwner {\n', '        _token.transfer(owner(), _token.balanceOf(address(this)));\n', '    }\n', '\n', '    //Create a sale\n', '    function createSale(uint256 supply, uint256 timeStart, uint256 timeEnd) public onlyOwner {\n', '\n', '        require(supply <= _token.balanceOf(address(this)), "Supply too high, not enough tokens in contract");\n', '        require(timeStart >= block.timestamp, "Sale start time cannot be in the past");\n', '        require(timeEnd > timeStart, "Sale start time cannot be before the end time");\n', '\n', '        //Store sale info\n', '        _saleSupplyTotal = supply;\n', '        _saleSupplyLeft = supply;\n', '        _saleStartTime = timeStart;\n', '        _saleEndTime = timeEnd;\n', '        _saleCount += 1;\n', '\n', '    }\n', '\n', '}']