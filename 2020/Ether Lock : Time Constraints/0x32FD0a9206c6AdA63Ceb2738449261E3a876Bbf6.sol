['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'interface TownInterface {\n', '    function checkProposal(address proposal) external returns (bool);\n', '    function voteOn(address externalToken, uint256 amount) external returns (bool);\n', '    \n', '}\n', '\n', 'interface Token {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through `transferFrom`. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when `approve` or `transferFrom` are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * > Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an `Approval` event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a `Transfer` event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to `approve`. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    \n', '    function getHoldersCount() external view returns (uint256);\n', '\n', '    function getHolderByIndex(uint256 index) external view returns (address);\n', '}\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Town is TownInterface {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 private _distributionPeriod;\n', '    uint256 private _distributionPeriodsNumber;\n', '    uint256 private _startRate;\n', '    uint256 private _minTokenGetAmount;\n', '    uint256 private _durationOfMinTokenGetAmount;\n', '    uint256 private _maxTokenGetAmount;\n', '    uint256 private _minExternalTokensAmount;\n', '    uint256 private _minSignAmount;\n', '    uint256 private _lastDistributionsDate;\n', '\n', '    uint256 private _transactionsCount;\n', '\n', '   \n', '    struct ExternalTokenDistributionsInfo {\n', '        address _official;\n', '        uint256 _distributionAmount;\n', '        uint256 _distributionsCount;\n', '    }\n', '\n', '    struct ExternalToken {\n', '        ExternalTokenDistributionsInfo[] _entities;\n', '        uint256 _weight;\n', '    }\n', '\n', '    struct TransactionsInfo {\n', '        uint256 _rate;\n', '        uint256 _amount;\n', '    }\n', '\n', '    struct TownTokenRequest {\n', '        address _address;\n', '        TransactionsInfo _info;\n', '    }\n', '\n', '    struct RemunerationsInfo {\n', '        address payable _address;\n', '        uint256 _priority;\n', '        uint256 _amount;\n', '    }\n', '\n', '    struct RemunerationsOfficialsInfo {\n', '        uint256 _amount;\n', '        uint256 _decayTimestamp;\n', '    }\n', '\n', '    Token private _token;\n', '\n', '    mapping (address => TransactionsInfo[]) private _historyTransactions;\n', '\n', '    TownTokenRequest[] private _queueTownTokenRequests;\n', '\n', '    RemunerationsInfo[] private _remunerationsQueue;\n', '\n', '    mapping (address => ExternalToken) private _externalTokens;\n', '    address[] private _externalTokensAddresses;\n', '\n', '    mapping (address => mapping (address => uint256)) private _townHoldersLedger;\n', '    mapping (address => address[]) private _ledgerExternalTokensAddresses;\n', '\n', '    mapping (address => RemunerationsOfficialsInfo) private _officialsLedger;\n', '\n', '    address[] private _externalTokensWithWight;\n', '\n', '    event Proposal(uint256 value, address indexed _official, uint256 _distributionAmount, uint256 _distributionsCount, address indexed externalToken);\n', '    event Vote(address indexed externalToken, uint256 value);\n', '    event Init(uint256 _distributionPeriod,uint256 _distributionPeriodsNumber,uint256 _startRate,address indexed tokenAddress,uint256 _transactionsCount, uint256 _minTokenGetAmount,uint256 _durationOfMinTokenGetAmount,uint256 _maxTokenGetAmount,uint256 _minExternalTokensAmount,uint256 _lastDistributionsDate, uint256 _minSignAmount);\n', '\n', '    modifier onlyTownTokenSmartContract {\n', '        require(msg.sender == address(_token), "only town token smart contract can call this function");\n', '        _;\n', '    }\n', '\n', '    constructor (\n', '        uint256 distributionPeriod,\n', '        uint256 distributionPeriodsNumber,\n', '        uint256 startRate,\n', '        uint256 minTokenGetAmount,\n', '        uint256 durationOfMinTokenGetAmount,\n', '        uint256 maxTokenGetAmount,\n', '        uint256 minExternalTokensAmount,\n', '        address tokenAddress) {\n', '        require(distributionPeriod > 0, "distributionPeriod wrong");\n', '        require(distributionPeriodsNumber > 0, "distributionPeriodsNumber wrong");\n', '        require(minTokenGetAmount > 0, "minTokenGetAmount wrong");\n', '        require(durationOfMinTokenGetAmount > 0, "durationOfMinTokenGetAmount wrong");\n', '        require(maxTokenGetAmount > 0, "maxTokenGetAmount wrong");\n', '        require(minExternalTokensAmount > 0, "minExternalTokensAmount wrong");\n', '\n', '        _distributionPeriod = distributionPeriod * 1 days;\n', '        _distributionPeriodsNumber = distributionPeriodsNumber;\n', '        _startRate = startRate;\n', '\n', '        _token = Token(tokenAddress);\n', '\n', '        _transactionsCount = 0;\n', '        _minTokenGetAmount = minTokenGetAmount;\n', '        _durationOfMinTokenGetAmount = durationOfMinTokenGetAmount;\n', '        _maxTokenGetAmount = maxTokenGetAmount;\n', '        _minExternalTokensAmount = minExternalTokensAmount;\n', '        _lastDistributionsDate = (block.timestamp.div(86400).add(1)).mul(86400);\n', '        _minSignAmount = 10000000000000;\n', '        emit Init(_distributionPeriod,_distributionPeriodsNumber,_startRate,tokenAddress,_transactionsCount,_minTokenGetAmount,_durationOfMinTokenGetAmount,_maxTokenGetAmount,_minExternalTokensAmount,_lastDistributionsDate,_minSignAmount);\n', '    }\n', '\n', '    receive () external payable {\n', '        if (msg.value <= _minSignAmount) {\n', '            if (_officialsLedger[msg.sender]._amount > 0) {\n', '                claimFunds(msg.sender);\n', '            }\n', '            if (_ledgerExternalTokensAddresses[msg.sender].length > 0) {\n', '                claimExternalTokens(msg.sender);\n', '            }\n', '            return;\n', '        }\n', '        uint256 tokenAmount = IWantTakeTokensToAmount(msg.value);\n', '        require(_transactionsCount > _durationOfMinTokenGetAmount || tokenAmount > _minTokenGetAmount, "insufficient amount");\n', '\n', '        getTownTokens(msg.sender);\n', '    }\n', '\n', '    function token() external view returns (Token) {\n', '        return _token;\n', '    }\n', '\n', '    function distributionPeriod() external view returns (uint256) {\n', '        return _distributionPeriod;\n', '    }\n', '\n', '    function distributionPeriodsNumber() external view returns (uint256) {\n', '        return _distributionPeriodsNumber;\n', '    }\n', '\n', '    function startRate() external view returns (uint256) {\n', '        return _startRate;\n', '    }\n', '\n', '    function minTokenGetAmount() external view returns (uint256) {\n', '        return _minTokenGetAmount;\n', '    }\n', '\n', '    function durationOfMinTokenGetAmount() external view returns (uint256) {\n', '        return _durationOfMinTokenGetAmount;\n', '    }\n', '\n', '    function maxTokenGetAmount() external view returns (uint256) {\n', '        return _maxTokenGetAmount;\n', '    }\n', '\n', '    function minExternalTokensAmount() external view returns (uint256) {\n', '        return _minExternalTokensAmount;\n', '    }\n', '\n', '    function lastDistributionsDate() external view returns (uint256) {\n', '        return _lastDistributionsDate;\n', '    }\n', '\n', '    function transactionsCount() external view returns (uint256) {\n', '        return _transactionsCount;\n', '    }\n', '\n', '    function getCurrentRate() external view returns (uint256) {\n', '        return currentRate();\n', '    }\n', '\n', '    function getLengthRemunerationQueue() external view returns (uint256) {\n', '        return _remunerationsQueue.length;\n', '    }\n', '\n', '    function getMinSignAmount() external view returns (uint256) {\n', '        return _minSignAmount;\n', '    }\n', '\n', '    function getRemunerationQueue(uint256 index) external view returns (address, uint256, uint256) {\n', '        return (_remunerationsQueue[index]._address, _remunerationsQueue[index]._priority, _remunerationsQueue[index]._amount);\n', '    }\n', '\n', '    function getLengthQueueTownTokenRequests() external view returns (uint256) {\n', '        return _queueTownTokenRequests.length;\n', '    }\n', '\n', '    function getQueueTownTokenRequests(uint256 index) external  view returns (address, uint256, uint256) {\n', '        TownTokenRequest memory tokenRequest = _queueTownTokenRequests[index];\n', '        return (tokenRequest._address, tokenRequest._info._rate, tokenRequest._info._amount);\n', '    }\n', '\n', '    function getMyTownTokens() external view returns (uint256, uint256) {\n', '        uint256 amount = 0;\n', '        uint256 tokenAmount = 0;\n', '        for (uint256 i = 0; i < _historyTransactions[msg.sender].length; ++i) {\n', '            amount = amount.add(_historyTransactions[msg.sender][i]._amount.mul(_historyTransactions[msg.sender][i]._rate).div(10 ** 18));\n', '            tokenAmount = tokenAmount.add(_historyTransactions[msg.sender][i]._amount);\n', '        }\n', '        return (amount, tokenAmount);\n', '    }\n', '\n', '    function checkProposal(address proposal) external override view returns (bool) {\n', '        if (_externalTokens[proposal]._entities.length > 0) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function getProposals(address externalToken) external view returns (uint256) {\n', '        return _externalTokens[externalToken]._entities.length;\n', '    }\n', '\n', '    function sendExternalTokens(address official, address externalToken) external returns (bool) {\n', '        Token tokenERC20 = Token(externalToken);\n', '        uint256 balance = tokenERC20.allowance(official, address(this));\n', '        require(tokenERC20.balanceOf(official) >= balance, "Official should have external tokens for approved");\n', '        require(balance > 0, "External tokens must be approved for town smart contract");\n', '        tokenERC20.transferFrom(official, address(this), balance);\n', '\n', '        ExternalTokenDistributionsInfo memory tokenInfo;\n', '        tokenInfo._official = official;\n', '        tokenInfo._distributionsCount = _distributionPeriodsNumber;\n', '        tokenInfo._distributionAmount = balance.div(_distributionPeriodsNumber);\n', '\n', '        ExternalToken storage tokenObj = _externalTokens[externalToken];\n', '\n', '        if (tokenObj._entities.length == 0) {\n', '            _externalTokensAddresses.push(externalToken);\n', '        }\n', '\n', '        tokenObj._entities.push(tokenInfo);\n', '        emit Proposal(balance, tokenInfo._official, tokenInfo._distributionsCount, tokenInfo._distributionAmount, externalToken);\n', '\n', '        return true;\n', '    }\n', '\n', '    function remuneration(uint256 tokensAmount) external returns (bool) {\n', '        require(_token.balanceOf(msg.sender) >= tokensAmount, "Town tokens not found");\n', '        require(_token.allowance(msg.sender, address(this)) >= tokensAmount, "Town tokens must be approved for town smart contract");\n', '\n', '        uint256 debt = 0;\n', '        uint256 restOfTokens = tokensAmount;\n', '        uint256 executedRequestCount = 0;\n', '        for (uint256 i = 0; i < _queueTownTokenRequests.length; ++i) {\n', '            address user = _queueTownTokenRequests[i]._address;\n', '            uint256 rate = _queueTownTokenRequests[i]._info._rate;\n', '            uint256 amount = _queueTownTokenRequests[i]._info._amount;\n', '            if (restOfTokens > amount) {\n', '                _token.transferFrom(msg.sender, user, amount);\n', '                restOfTokens = restOfTokens.sub(amount);\n', '                debt = debt.add(amount.mul(rate).div(10 ** 18));\n', '                executedRequestCount++;\n', '            } else {\n', '                break;\n', '            }\n', '        }\n', '\n', '        if (restOfTokens > 0) {\n', '            _token.transferFrom(msg.sender, address(this), restOfTokens);\n', '        }\n', '\n', '        if (executedRequestCount > 0) {\n', '            for (uint256 i = executedRequestCount; i < _queueTownTokenRequests.length; ++i) {\n', '                _queueTownTokenRequests[i - executedRequestCount] = _queueTownTokenRequests[i];\n', '            }\n', '\n', '            for (uint256 i = 0; i < executedRequestCount; ++i) {\n', '                //delete _queueTownTokenRequests[_queueTownTokenRequests.length - 1];\n', '                _queueTownTokenRequests.pop();\n', '            }\n', '        }\n', '\n', '        if (_historyTransactions[msg.sender].length > 0) {\n', '            for (uint256 i = _historyTransactions[msg.sender].length - 1; ; --i) {\n', '                uint256 rate = _historyTransactions[msg.sender][i]._rate;\n', '                uint256 amount = _historyTransactions[msg.sender][i]._amount;\n', '                //delete _historyTransactions[msg.sender][i];\n', '                _historyTransactions[msg.sender].pop();\n', '\n', '                if (restOfTokens < amount) {\n', '                    TransactionsInfo memory info = TransactionsInfo(rate, amount.sub(restOfTokens));\n', '                    _historyTransactions[msg.sender].push(info);\n', '\n', '                    debt = debt.add(restOfTokens.mul(rate).div(10 ** 18));\n', '                    break;\n', '                }\n', '\n', '                debt = debt.add(amount.mul(rate).div(10 ** 18));\n', '                restOfTokens = restOfTokens.sub(amount);\n', '\n', '                if (i == 0) break;\n', '            }\n', '        }\n', '\n', '        if (debt > address(this).balance) {\n', '            msg.sender.transfer(address(this).balance);\n', '\n', '            RemunerationsInfo memory info = RemunerationsInfo(msg.sender, 2, debt.sub(address(this).balance));\n', '            _remunerationsQueue.push(info);\n', '        } else {\n', '            msg.sender.transfer(debt);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function distributionSnapshot() external returns (bool) {\n', '        require(block.timestamp > (_lastDistributionsDate + _distributionPeriod), "distribution time has not yet arrived");\n', '\n', '        uint256 sumWeight = 0;\n', '        address[] memory tempArray;\n', '        _externalTokensWithWight = tempArray;\n', '        for (uint256 i = 0; i < _externalTokensAddresses.length; ++i) {\n', '            ExternalToken memory externalToken = _externalTokens[_externalTokensAddresses[i]];\n', '            if (externalToken._weight > 0) {\n', '                uint256 sumExternalTokens = 0;\n', '                for (uint256 j = 0; j < externalToken._entities.length; ++j) {\n', '                    if (externalToken._entities[j]._distributionsCount > 0) {\n', '                        ExternalTokenDistributionsInfo memory info = externalToken._entities[j];\n', '                        sumExternalTokens = sumExternalTokens.add(info._distributionAmount.mul(info._distributionsCount));\n', '                    }\n', '                }\n', '                if (sumExternalTokens > _minExternalTokensAmount) {\n', '                    sumWeight = sumWeight.add(externalToken._weight);\n', '                    _externalTokensWithWight.push(_externalTokensAddresses[i]);\n', '                } else {\n', '                    externalToken._weight = 0;\n', '                }\n', '            }\n', '        }\n', '\n', '        uint256 fullBalance = address(this).balance;\n', '        for (uint256 i = 0; i < _externalTokensWithWight.length; ++i) {\n', '            ExternalToken memory externalToken = _externalTokens[_externalTokensWithWight[i]];\n', '            uint256 sumExternalTokens = 0;\n', '            for (uint256 j = 0; j < externalToken._entities.length; ++j) {\n', '                sumExternalTokens = sumExternalTokens.add(externalToken._entities[j]._distributionAmount);\n', '            }\n', '            uint256 externalTokenCost = fullBalance.mul(externalToken._weight).div(sumWeight);\n', '            for (uint256 j = 0; j < externalToken._entities.length; ++j) {\n', '                address official = externalToken._entities[j]._official;\n', '                uint256 tokensAmount = externalToken._entities[j]._distributionAmount;\n', '                uint256 amount = externalTokenCost.mul(tokensAmount).div(sumExternalTokens);\n', '                uint256 decayTimestamp = (block.timestamp - _lastDistributionsDate).div(_distributionPeriod).mul(_distributionPeriod).add(_lastDistributionsDate).add(_distributionPeriod);\n', '                _officialsLedger[official] = RemunerationsOfficialsInfo(amount, decayTimestamp);\n', '            }\n', '        }\n', '\n', '        uint256 sumHoldersTokens = _token.totalSupply().sub(_token.balanceOf(address(this)));\n', '\n', '        if (sumHoldersTokens != 0) {\n', '            for (uint256 i = 0; i < _token.getHoldersCount(); ++i) {\n', '                address holder = _token.getHolderByIndex(i);\n', '                uint256 balance = _token.balanceOf(holder);\n', '                for (uint256 j = 0; j < _externalTokensAddresses.length; ++j) {\n', '                    address externalTokenAddress = _externalTokensAddresses[j];\n', '                    ExternalToken memory externalToken = _externalTokens[externalTokenAddress];\n', '                    for (uint256 k = 0; k < externalToken._entities.length; ++k) {\n', '                        if (holder != address(this) && externalToken._entities[k]._distributionsCount > 0) {\n', '                            uint256 percent = balance.mul(externalToken._entities[k]._distributionAmount).div(sumHoldersTokens);\n', '                            if (percent > (10 ** 4)) {\n', '                                address[] memory externalTokensForHolder = _ledgerExternalTokensAddresses[holder];\n', '                                bool found = false;\n', '                                for (uint256 h = 0; h < externalTokensForHolder.length; ++h) {\n', '                                    if (externalTokensForHolder[h] == externalTokenAddress) {\n', '                                        found = true;\n', '                                        break;\n', '                                    }\n', '                                }\n', '                                if (found == false) {\n', '                                    _ledgerExternalTokensAddresses[holder].push(externalTokenAddress);\n', '                                }\n', '\n', '                                _townHoldersLedger[holder][externalTokenAddress] = _townHoldersLedger[holder][externalTokenAddress].add(percent);\n', '                            }\n', '                        }\n', '                    }\n', '                }\n', '            }\n', '\n', '            for (uint256 j = 0; j < _externalTokensAddresses.length; ++j) {\n', '                ExternalTokenDistributionsInfo[] memory tempEntities = _externalTokens[_externalTokensAddresses[j]]._entities;\n', '\n', '                //for (uint256 k = 0; k < tempEntities.length; ++k) {\n', '                //    delete _externalTokens[_externalTokensAddresses[j]]._entities[k];\n', '                //}\n', '                delete _externalTokens[_externalTokensAddresses[j]]._entities;\n', '\n', '                for (uint256 k = 0; k < tempEntities.length; ++k) {\n', '                    tempEntities[k]._distributionsCount--;\n', '                    if (tempEntities[k]._distributionsCount > 0) {\n', '                        _externalTokens[_externalTokensAddresses[j]]._entities.push(tempEntities[k]);\n', '                    }\n', '                }\n', '            }\n', '        }\n', '\n', '        for (uint256 i = 0; i < _externalTokensAddresses.length; ++i) {\n', '            if (_externalTokens[_externalTokensAddresses[i]]._weight > 0) {\n', '                _externalTokens[_externalTokensAddresses[i]]._weight = 0;\n', '            }\n', '        }\n', '\n', '        _lastDistributionsDate = _lastDistributionsDate.add(_distributionPeriod);\n', '        return true;\n', '    }\n', '\n', '    function voteOn(address externalToken, uint256 amount) external override onlyTownTokenSmartContract returns (bool) {\n', '        require(_externalTokens[externalToken]._entities.length > 0, "external token address not found");\n', '        require(block.timestamp < (_lastDistributionsDate + _distributionPeriod), "need call distributionSnapshot function");\n', '\n', '        _externalTokens[externalToken]._weight = _externalTokens[externalToken]._weight.add(amount);\n', '        emit Vote(externalToken, amount);\n', '        return true;\n', '    }\n', '\n', '    function getVotes() external view returns (uint256) {\n', '        return _externalTokensWithWight.length;\n', '    }\n', '\n', '    function claimExternalTokens(address holder) public returns (bool) {\n', '        address[] memory externalTokensForHolder = _ledgerExternalTokensAddresses[holder];\n', '        if (externalTokensForHolder.length > 0) {\n', '            for (uint256 i = externalTokensForHolder.length - 1; ; --i) {\n', '                Token(externalTokensForHolder[i]).transfer(holder, _townHoldersLedger[holder][externalTokensForHolder[i]]);\n', '                delete _townHoldersLedger[holder][externalTokensForHolder[i]];\n', '                //delete _ledgerExternalTokensAddresses[holder][i];\n', '                _ledgerExternalTokensAddresses[holder].pop();\n', '\n', '                if (i == 0) break;\n', '            }\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function claimFunds(address payable official) public returns (bool) {\n', '        require(_officialsLedger[official]._amount != 0, "official address not found in ledger");\n', '\n', '        if (block.timestamp >= _officialsLedger[official]._decayTimestamp) {\n', '            RemunerationsOfficialsInfo memory info = RemunerationsOfficialsInfo(0, 0);\n', '            _officialsLedger[official] = info;\n', '            return false;\n', '        }\n', '\n', '        uint256 amount = _officialsLedger[official]._amount;\n', '        if (address(this).balance >= amount) {\n', '            official.transfer(amount);\n', '        } else {\n', '            RemunerationsInfo memory info = RemunerationsInfo(official, 1, amount);\n', '            _remunerationsQueue.push(info);\n', '        }\n', '        RemunerationsOfficialsInfo memory info = RemunerationsOfficialsInfo(0, 0);\n', '        _officialsLedger[official] = info;\n', '\n', '        return true;\n', '    }\n', '\n', '    function IWantTakeTokensToAmount(uint256 amount) public view returns (uint256) {\n', '        return amount.mul(10 ** 18).div(currentRate());\n', '    }\n', '\n', '    function getTownTokens(address holder) public payable returns (bool) {\n', '        require(holder != address(0), "holder address cannot be null");\n', '\n', '        uint256 amount = msg.value;\n', '        uint256 tokenAmount = IWantTakeTokensToAmount(amount);\n', '        uint256 rate = currentRate();\n', '        if (_transactionsCount < _durationOfMinTokenGetAmount && tokenAmount < _minTokenGetAmount) {\n', '            return false;\n', '        }\n', '        if (tokenAmount >= _maxTokenGetAmount) {\n', '            tokenAmount = _maxTokenGetAmount;\n', '            uint256 change = amount.sub(_maxTokenGetAmount.mul(rate).div(10 ** 18));\n', '            msg.sender.transfer(change);\n', '            amount = amount.sub(change);\n', '        }\n', '\n', '        if (_token.balanceOf(address(this)) >= tokenAmount) {\n', '            TransactionsInfo memory transactionsHistory = TransactionsInfo(rate, tokenAmount);\n', '            _token.transfer(holder, tokenAmount);\n', '            _historyTransactions[holder].push(transactionsHistory);\n', '            _transactionsCount = _transactionsCount.add(1);\n', '        } else {\n', '            if (_token.balanceOf(address(this)) > 0) {\n', '                uint256 tokenBalance = _token.balanceOf(address(this));\n', '                _token.transfer(holder, tokenBalance);\n', '                TransactionsInfo memory transactionsHistory = TransactionsInfo(rate, tokenBalance);\n', '                _historyTransactions[holder].push(transactionsHistory);\n', '                tokenAmount = tokenAmount.sub(tokenBalance);\n', '            }\n', '\n', '            TransactionsInfo memory transactionsInfo = TransactionsInfo(rate, tokenAmount);\n', '            TownTokenRequest memory tokenRequest = TownTokenRequest(holder, transactionsInfo);\n', '            _queueTownTokenRequests.push(tokenRequest);\n', '        }\n', '\n', '        for (uint256 i = 0; i < _remunerationsQueue.length; ++i) {\n', '            if (_remunerationsQueue[i]._priority == 1) {\n', '                if (_remunerationsQueue[i]._amount > amount) {\n', '                    _remunerationsQueue[i]._address.transfer(_remunerationsQueue[i]._amount);\n', '                    amount = amount.sub(_remunerationsQueue[i]._amount);\n', '\n', '                    //delete _remunerationsQueue[i];\n', '                    for (uint j = i + 1; j < _remunerationsQueue.length; ++j) {\n', '                        _remunerationsQueue[j - 1] = _remunerationsQueue[j];\n', '                    }\n', '                    _remunerationsQueue.pop();\n', '                } else {\n', '                    _remunerationsQueue[i]._address.transfer(amount);\n', '                    _remunerationsQueue[i]._amount = _remunerationsQueue[i]._amount.sub(amount);\n', '                    break;\n', '                }\n', '            }\n', '        }\n', '\n', '        for (uint256 i = 0; i < _remunerationsQueue.length; ++i) {\n', '            if (_remunerationsQueue[i]._amount > amount) {\n', '                _remunerationsQueue[i]._address.transfer(_remunerationsQueue[i]._amount);\n', '                amount = amount.sub(_remunerationsQueue[i]._amount);\n', '\n', '                //delete _remunerationsQueue[i];\n', '                for (uint j = i + 1; j < _remunerationsQueue.length; ++j) {\n', '                    _remunerationsQueue[j - 1] = _remunerationsQueue[j];\n', '                }\n', '                _remunerationsQueue.pop();\n', '            } else {\n', '                _remunerationsQueue[i]._address.transfer(amount);\n', '                _remunerationsQueue[i]._amount = _remunerationsQueue[i]._amount.sub(amount);\n', '                break;\n', '            }\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function currentRate() internal view returns (uint256) {\n', '        return _startRate;\n', '    }\n', '}']