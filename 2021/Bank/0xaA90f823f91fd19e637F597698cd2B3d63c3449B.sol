['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-15\n', '*/\n', '\n', '// Sources flattened with hardhat v2.3.3 https://hardhat.org\n', '\n', '// File contracts/interfaces/IOracle.sol\n', '\n', 'pragma solidity 0.8.4;\n', '\n', 'interface IOracle {\n', '    function getTokensOwed(uint256 ethOwed, address pToken, address uTokenLink) external view returns (uint256);\n', '    function getEthOwed(uint256 tokensOwed, address pToken, address uTokenLink) external view returns (uint256);\n', '}\n', '\n', '\n', '// File contracts/interfaces/ICovBase.sol\n', '\n', 'pragma solidity 0.8.4;\n', '\n', 'interface ICovBase {\n', '    function editShield(address shield, bool active) external;\n', '    function updateShield(uint256 ethValue) external payable;\n', '    function checkCoverage(uint256 pAmount) external view returns (bool);\n', '    function getShieldOwed(address shield) external view returns (uint256);\n', '}\n', '\n', '\n', '// File contracts/interfaces/IController.sol\n', '\n', 'pragma solidity 0.8.4;\n', '\n', 'interface IController {\n', '    function bonus() external view returns (uint256);\n', '    function refFee() external view returns (uint256);\n', '    function governor() external view returns (address);\n', '    function depositAmt() external view returns (uint256);\n', '    function beneficiary() external view returns (address payable);\n', '}\n', '\n', '\n', '// File contracts/interfaces/IArmorToken.sol\n', '\n', 'pragma solidity 0.8.4;\n', '\n', 'interface IArmorToken {\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    \n', '    function mint(address to, uint256 amount) external returns (bool);\n', '    function burn(uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '    \n', '    // Putting in for now to replicate the compound-like token function where I can find balance at a certain block.\n', '    function balanceOfAt(address account, uint256 blockNo) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '\n', '// File @openzeppelin/contracts/token/ERC20/[email\xa0protected]\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// File contracts/core/arShield.sol\n', '\n', '// SPDX-License-Identifier: (c) Armor.Fi, 2021\n', '\n', 'pragma solidity 0.8.4;\n', '\n', '/**\n', ' * @title Armor Shield\n', ' * @dev arShield base provides the base functionality of arShield contracts.\n', ' * @author Armor.fi -- Robert M.C. Forster\n', '**/\n', 'contract arShield {\n', '\n', '    /**\n', '     * @dev Universal requirements:\n', '     *      - notLocked functions must never be able to be accessed if locked.\n', '     *      - onlyGov functions must only ever be able to be accessed by governance.\n', '     *      - Total of refBals must always equal refTotal.\n', '     *      - depositor should always be address(0) if contract is not locked.\n', '     *      - totalTokens must always equal pToken.balanceOf( address(this) ) - (refTotal + sum(feesToLiq) ).\n', '    **/\n', '\n', '    // Denominator for % fractions.\n', '    uint256 constant DENOMINATOR = 10000;\n', '    \n', '    // Whether or not the pool has capped coverage.\n', '    bool public capped;\n', '    // Whether or not the contract is locked.\n', '    bool public locked;\n', '    // Limit of tokens (in Wei) that can be entered into the shield.\n', '    uint256 public limit;\n', '    // Address that will receive default referral fees and excess eth/tokens.\n', '    address payable public beneficiary;\n', '    // User who deposited to notify of a hack.\n', '    address public depositor;\n', '    // Amount to payout in Ether per token for the most recent hack.\n', '    uint256 public payoutAmt;\n', '    // Block at which users must be holding tokens to receive a payout.\n', '    uint256 public payoutBlock;\n', '    // Total amount to be paid to referrers.\n', '    uint256 public refTotal;\n', '    // 0.25% paid for minting in order to pay for the first week of coverage--can be immediately liquidated.\n', '    uint256[] public feesToLiq;\n', '    // Different amounts to charge as a fee for each protocol.\n', '    uint256[] public feePerBase;\n', '    // Total tokens to protect in the vault (tokens - fees).\n', '    uint256 public totalTokens;\n', '\n', '    // Balance of referrers.\n', '    mapping (address => uint256) public refBals;\n', '   // Whether user has been paid for a specific payout block.\n', '    mapping (uint256 => mapping (address => uint256)) public paid;\n', '\n', '    // Chainlink address for the underlying token.\n', '    address public uTokenLink;\n', "    // Protocol token that we're providing protection for.\n", '    IERC20 public pToken;\n', '    // Oracle to find uToken price.\n', '    IOracle public oracle;\n', '    // The armorToken that this shield issues.\n', '    IArmorToken public arToken;\n', '    // Coverage bases that we need to be paying.\n', '    ICovBase[] public covBases;\n', '    // Used for universal variables (all shields) such as bonus for liquidation.\n', '    IController public controller;\n', '\n', '    event Unlocked(uint256 timestamp);\n', '    event Locked(address reporter, uint256 timestamp);\n', '    event HackConfirmed(uint256 payoutBlock, uint256 timestamp);\n', '    event Mint(address indexed user, uint256 amount, uint256 timestamp);\n', '    event Redemption(address indexed user, uint256 amount, uint256 timestamp);\n', '\n', '    modifier onlyGov \n', '    {\n', '        require(msg.sender == controller.governor(), "Only governance may call this function.");\n', '        _;\n', '    }\n', '\n', '    modifier isLocked \n', '    {\n', '        require(locked, "You may not do this while the contract is unlocked.");\n', '        _;\n', '    }\n', '\n', '    // Only allow minting when there are no claims processing (people withdrawing to receive Ether).\n', '    modifier notLocked \n', '    {\n', '        require(!locked, "You may not do this while the contract is locked.");\n', '        _;\n', '    }\n', '\n', '    // Used for initial soft launch to limit the amount of funds in the shield. 0 if unlimited.\n', '    modifier withinLimits\n', '    {\n', '        _;\n', '        uint256 _limit = limit;\n', '        require(_limit == 0 || pToken.balanceOf( address(this) ) <= _limit, "Too much value in the shield.");\n', '    }\n', '    \n', '    receive() external payable {}\n', '    \n', '    /**\n', '     * @notice Controller immediately initializes contract with this.\n', '     * @dev - Must set all included variables properly.\n', '     *      - Must set covBases and fees in correct order.\n', '     *      - Must not allow improper lengths.\n', '     * @param _oracle Address of our oracle for this family of tokens.\n', "     * @param _pToken The protocol token we're protecting.\n", '     * @param _arToken The Armor token that the vault controls.\n', '     * @param _uTokenLink ChainLink contract for the underlying token.\n', '     * @param _fees Mint/redeem fees for each coverage base.\n', '     * @param _covBases Addresses of the coverage bases to pay for coverage.\n', '    **/\n', '    function initialize(\n', '        address _oracle,\n', '        address _pToken,\n', '        address _arToken,\n', '        address _uTokenLink, \n', '        uint256[] calldata _fees,\n', '        address[] calldata _covBases\n', '    )\n', '      external\n', '    {\n', '        require(address(arToken) == address(0), "Contract already initialized.");\n', '\n', '        uTokenLink = _uTokenLink;\n', '        pToken = IERC20(_pToken);\n', '        oracle = IOracle(_oracle);\n', '        arToken = IArmorToken(_arToken);\n', '        controller = IController(msg.sender);\n', '        beneficiary = controller.beneficiary();\n', '\n', '        // CovBases and fees must always be the same length.\n', '        require(_covBases.length == _fees.length, "Improper length array.");\n', '        for(uint256 i = 0; i < _covBases.length; i++) {\n', '            covBases.push( ICovBase(_covBases[i]) );\n', '            feePerBase.push(_fees[i]);\n', '            feesToLiq.push(0);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice User deposits pToken, is returned arToken. Amount returned is judged based off amount in contract.\n', '     *         Amount returned will likely be more than deposited because pTokens will be removed to pay for cover.\n', '     * @dev - Must increase referrer bal 0.25% (in tests) if there is a referrer, beneficiary bal if not.\n', '     *      - Important: must mint correct value of tokens in all scenarios. Conversion from pToken to arToken - (referral fee - feePerBase amounts - liquidator bonus).\n', '     *      - Must take exactly _pAmount from user and deposit to this address.\n', '     *      - Important: must save all fees correctly.\n', '     * @param _pAmount Amount of pTokens to deposit to the contract.\n', '     * @param _referrer The address that referred the user to arShield.\n', '    **/\n', '    function mint(\n', '        uint256 _pAmount,\n', '        address _referrer\n', '    )\n', '      external\n', '      notLocked\n', '      withinLimits\n', '    {\n', '        address user = msg.sender;\n', '\n', '        // fee is total including refFee\n', '        (\n', '         uint256 fee, \n', '         uint256 refFee, \n', '         uint256 totalFees,\n', '         uint256[] memory newFees\n', '        ) = _findFees(_pAmount);\n', '\n', '        uint256 arAmount = arValue(_pAmount - fee);\n', '        pToken.transferFrom(user, address(this), _pAmount);\n', '        _saveFees(newFees, _referrer, refFee);\n', '\n', '        // If this vault is capped in its coverage, we check whether the mint should be allowed, and update.\n', '        if (capped) {\n', '            uint256 ethValue = getEthValue(pToken.balanceOf( address(this) ) - totalFees);\n', '            require(checkCapped(ethValue), "Not enough coverage available.");\n', '\n', "            // If we don't update here, two shields could get big deposits at the same time and allow both when it shouldn't.\n", '            // This update runs the risk of making CoverageBase need to pay more than it has upfront, but in that case we liquidate.\n', '            for (uint256 i = 0; i < covBases.length; i++) covBases[i].updateShield(ethValue);\n', '        }\n', '\n', '        arToken.mint(user, arAmount);\n', '        emit Mint(user, arAmount, block.timestamp);\n', '    }\n', '\n', '    /**\n', '     * @notice Redeem arTokens for underlying pTokens.\n', '     * @dev - Must increase referrer bal 0.25% (in tests) if there is a referrer, beneficiary bal if not.\n', '     *      - Important: must return correct value of tokens in all scenarios. Conversion from arToken to pToken - (referral fee - feePerBase amounts - liquidator bonus).\n', '     *      - Must take exactly _arAmount from user and deposit to this address.\n', '     *      - Important: must save all fees correctly.\n', '     * @param _arAmount Amount of arTokens to redeem.\n', '     * @param _referrer The address that referred the user to arShield.\n', '    **/\n', '    function redeem(\n', '        uint256 _arAmount,\n', '        address _referrer\n', '    )\n', '      external\n', '    {\n', '        address user = msg.sender;\n', '        uint256 pAmount = pValue(_arAmount);\n', '        arToken.transferFrom(user, address(this), _arAmount);\n', '        arToken.burn(_arAmount);\n', '        \n', '        (\n', '         uint256 fee, \n', '         uint256 refFee,\n', '         uint256 totalFees,\n', '         uint256[] memory newFees\n', '        ) = _findFees(pAmount);\n', '\n', '        pToken.transfer(user, pAmount - fee);\n', '        _saveFees(newFees, _referrer, refFee);\n', '\n', "        // If we don't update this here, users will get stuck paying for coverage that they are not using.\n", '        uint256 ethValue = getEthValue(pToken.balanceOf( address(this) ) - totalFees);\n', '        for (uint256 i = 0; i < covBases.length; i++) covBases[i].updateShield(ethValue);\n', '\n', '        emit Redemption(user, _arAmount, block.timestamp);\n', '    }\n', '\n', '    /**\n', '     * @notice Liquidate for payment for coverage by selling to people at oracle price.\n', '     * @dev - Must give correct amount of tokens.\n', '     *      - Must take correct amount of Ether back.\n', '     *      - Must adjust fees correctly afterwards.\n', "     *      - Must not allow any extra to be sold than what's needed.\n", '     * @param _covId covBase ID that we are liquidating.\n', '    **/\n', '    function liquidate(\n', '        uint256 _covId\n', '    )\n', '      external\n', '      payable\n', '    {\n', '        // Get full amounts for liquidation here.\n', '        (\n', '         uint256 ethOwed, \n', '         uint256 tokensOwed,\n', '         uint256 tokenFees\n', '        ) = liqAmts(_covId);\n', '        require(msg.value <= ethOwed, "Too much Ether paid.");\n', '\n', '        // Determine eth value and amount of tokens to pay?\n', '        (\n', '         uint256 tokensOut,\n', '         uint256 feesPaid,\n', '         uint256 ethValue\n', '        ) = payAmts(\n', '            msg.value,\n', '            ethOwed,\n', '            tokensOwed,\n', '            tokenFees\n', '        );\n', '\n', '        covBases[_covId].updateShield{value:msg.value}(ethValue);\n', '        feesToLiq[_covId] -= feesPaid;\n', '        pToken.transfer(msg.sender, tokensOut);\n', '    }\n', '\n', '    /**\n', '     * @notice Claim funds if you were holding tokens on the payout block.\n', '     * @dev - Must return correct amount of funds to user according to their balance at the time.\n', '     *      - Must subtract if paid mapping has value.\n', '     *      - Must correctly set paid.\n', '     *      - Must only ever work for users who held tokens at exactly payout block.\n', '    **/\n', '    function claim()\n', '      external\n', '      isLocked\n', '    {\n', '        // Find balance at the payout block, multiply by the amount per token to pay, subtract anything paid.\n', '        uint256 balance = arToken.balanceOfAt(msg.sender, payoutBlock);\n', '        uint256 owedBal = balance - paid[payoutBlock][msg.sender];\n', '        uint256 amount = payoutAmt\n', '                         * owedBal\n', '                         / 1 ether;\n', '\n', '        require(balance > 0 && amount > 0, "Sender did not have funds on payout block.");\n', '        paid[payoutBlock][msg.sender] += owedBal;\n', '        payable(msg.sender).transfer(amount);\n', '    }\n', '\n', '    /**\n', '     * @notice Used by referrers to withdraw their owed balance.\n', '     * @dev - Must allow user to withdraw correct referral balance from the contract.\n', '     *      - Must allow no extra than referral balance to be withdrawn.\n', '    **/\n', '    function withdraw(\n', '        address _user\n', '    )\n', '      external\n', '    {\n', '        uint256 balance = refBals[_user];\n', '        refBals[_user] = 0;\n', '        pToken.transfer(_user, balance);\n', '    }\n', '\n', '    /**\n', '     * @notice Inverse of arValue (find yToken value of arToken amount).\n', '     * @dev - Must convert correctly in any scenario.\n', '     * @param _arAmount Amount of arTokens to find yToken value of.\n', '     * @return pAmount Amount of pTokens the input arTokens are worth.\n', '    **/\n', '    function pValue(\n', '        uint256 _arAmount\n', '    )\n', '      public\n', '      view\n', '    returns (\n', '        uint256 pAmount\n', '    )\n', '    {\n', '        uint256 totalSupply = arToken.totalSupply();\n', '        if (totalSupply == 0) return _arAmount;\n', '\n', '        pAmount = ( pToken.balanceOf( address(this) ) - totalFeeAmts() )\n', '                  * _arAmount \n', '                  / totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @notice Find the arToken value of a pToken amount.\n', '     * @dev - Must convert correctly in any scenario.\n', '     * @param _pAmount Amount of yTokens to find arToken value of.\n', '     * @return arAmount Amount of arToken the input pTokens are worth.\n', '    **/\n', '    function arValue(\n', '        uint256 _pAmount\n', '    )\n', '      public\n', '      view\n', '    returns (\n', '        uint256 arAmount\n', '    )\n', '    {\n', '        uint256 balance = pToken.balanceOf( address(this) );\n', '        if (balance == 0) return _pAmount;\n', '\n', '        arAmount = arToken.totalSupply()\n', '                   * _pAmount \n', '                   / ( balance - totalFeeAmts() );\n', '    }\n', '\n', '    /**\n', '     * @notice Amounts owed to be liquidated.\n', '     * @dev - Must always return correct amounts that can currently be liquidated.\n', '     * @param _covId Coverage Base ID lol\n', '     * @return ethOwed Amount of Ether owed to coverage base.\n', '     * @return tokensOwed Amount of tokens owed to liquidator for that Ether.\n', '     * @return tokenFees Amount of tokens owed to liquidator for that Ether.\n', '    **/\n', '    function liqAmts(\n', '        uint256 _covId\n', '    )\n', '      public\n', '      view\n', '    returns(\n', '        uint256 ethOwed,\n', '        uint256 tokensOwed,\n', '        uint256 tokenFees\n', '    )\n', '    {\n', '        // Find amount owed in Ether, find amount owed in protocol tokens.\n', "        // If nothing is owed to coverage base, don't use getTokensOwed.\n", '        ethOwed = covBases[_covId].getShieldOwed( address(this) );\n', '        if (ethOwed > 0) tokensOwed = oracle.getTokensOwed(ethOwed, address(pToken), uTokenLink);\n', '\n', '        tokenFees = feesToLiq[_covId];\n', '        require(tokensOwed + tokenFees > 0, "No fees are owed.");\n', '\n', '        // Find the Ether value of the mint fees we have.\n', '        uint256 ethFees = ethOwed > 0 ?\n', '                            ethOwed\n', '                            * tokenFees\n', '                            / tokensOwed\n', '                          : getEthValue(tokenFees);\n', '        ethOwed += ethFees;\n', '        tokensOwed += tokenFees;\n', '\n', '        // Add a bonus for liquidators (0% to start).\n', '        // As it stands, this will lead to a small loss of arToken:pToken conversion immediately so in bigger\n', '        // amounts it could be taken advantage of, but we do not think real damage can happen given the small amounts.\n', '        uint256 liqBonus = tokensOwed \n', '                           * controller.bonus()\n', '                           / DENOMINATOR;\n', '        tokensOwed += liqBonus;\n', '    }\n', '\n', '    /**\n', '     * @notice Find amount to pay a liquidator--needed because a liquidator may not pay all Ether.\n', '     * @dev - Must always return correct amounts to be paid according to liqAmts and Ether in.\n', '    **/\n', '    function payAmts(\n', '        uint256 _ethIn,\n', '        uint256 _ethOwed,\n', '        uint256 _tokensOwed,\n', '        uint256 _tokenFees\n', '    )\n', '      public\n', '      view\n', '    returns(\n', '        uint256 tokensOut,\n', '        uint256 feesPaid,\n', '        uint256 ethValue\n', '    )\n', '    {\n', "        // Actual amount we're liquidating (liquidator may not pay full Ether owed).\n", '        tokensOut = _ethIn\n', '                    * _tokensOwed\n', '                    / _ethOwed;\n', '\n', '        // Amount of fees for this protocol being paid.\n', '        feesPaid = _ethIn\n', '                   * _tokenFees\n', '                   / _ethOwed;\n', '\n', "        // Ether value of all of the contract minus what we're liquidating.\n", '        ethValue = (pToken.balanceOf( address(this) ) \n', '                    - totalFeeAmts())\n', '                   * _ethOwed\n', '                   / _tokensOwed;\n', '    }\n', '\n', '    /**\n', '     * @notice Find total amount of tokens that are not to be covered (ref fees, tokens to liq, liquidator bonus).\n', '     * @dev - Must always return correct total fees owed.\n', '     * @return totalOwed Total amount of tokens owed in fees.\n', '    **/\n', '    function totalFeeAmts()\n', '      public\n', '      view\n', '    returns(\n', '        uint256 totalOwed\n', '    )\n', '    {\n', '        for (uint256 i = 0; i < covBases.length; i++) {\n', '            uint256 ethOwed = covBases[i].getShieldOwed( address(this) );\n', '            if (ethOwed > 0) totalOwed += oracle.getTokensOwed(ethOwed, address(pToken), uTokenLink);\n', '            totalOwed += feesToLiq[i];\n', '        }\n', '\n', '        // Add a bonus for liquidators (0.5% to start). Removed for now.\n', '        /**uint256 liqBonus = totalOwed \n', '                           * controller.bonus()\n', '                           / DENOMINATOR;\n', '\n', '        totalOwed += liqBonus;**/\n', '        totalOwed += refTotal;\n', '    }\n', '\n', '    /**\n', '     * @notice If the shield requires full coverage, check coverage base to see if it is available.\n', '     * @dev - Must return false if any of the covBases do not have coverage available.\n', '     * @param _ethValue Ether value of the new tokens.\n', '     * @return allowed True if the deposit is allowed.\n', '    **/\n', '    function checkCapped(\n', '        uint256 _ethValue\n', '    )\n', '      public\n', '      view\n', '    returns(\n', '        bool allowed\n', '    )\n', '    {\n', '        if (capped) {\n', '            for(uint256 i = 0; i < covBases.length; i++) {\n', '                if( !covBases[i].checkCoverage(_ethValue) ) return false;\n', '            }\n', '        }\n', '        allowed = true;\n', '    }\n', '\n', '    /**\n', '     * @notice Find the Ether value of a certain amount of pTokens.\n', '     * @dev - Must return correct Ether value for _pAmount.\n', '     * @param _pAmount The amount of pTokens to find Ether value for.\n', '     * @return ethValue Ether value of the pTokens (in Wei).\n', '    **/\n', '    function getEthValue(\n', '        uint256 _pAmount\n', '    )\n', '      public\n', '      view\n', '    returns(\n', '        uint256 ethValue\n', '    )\n', '    {\n', '        ethValue = oracle.getEthOwed(_pAmount, address(pToken), uTokenLink);\n', '    }\n', '\n', '    /**\n', '     * @notice Allows frontend to find the percents that are taken from mint/redeem. 10 == 0.1%.\n', '    **/\n', '    function findFeePct()\n', '      external\n', '      view\n', '    returns(\n', '        uint256 percent\n', '    )\n', '    {\n', '        // Find protocol fees for each coverage base.\n', '        uint256 end = feePerBase.length;\n', '        for (uint256 i = 0; i < end; i++) percent += feePerBase[i];\n', '        percent += controller.refFee() \n', '                   * percent\n', '                   / DENOMINATOR;\n', '    }\n', '\n', '    /**\n', '     * @notice Find the fee for deposit and withdrawal.\n', '     * @param _pAmount The amount of pTokens to find the fee of.\n', '     * @return userFee coverage + mint fees + liquidator bonus + referral fee.\n', '     * @return refFee Referral fee.\n', '     * @return totalFees Total fees owed from the contract including referrals (used to calculate amount to cover).\n', '     * @return newFees New fees to save in feesToLiq.\n', '    **/\n', '    function _findFees(\n', '        uint256 _pAmount\n', '    )\n', '      internal\n', '      view\n', '    returns(\n', '        uint256 userFee,\n', '        uint256 refFee,\n', '        uint256 totalFees,\n', '        uint256[] memory newFees\n', '    )\n', '    {\n', '        // Find protocol fees for each coverage base.\n', '        newFees = feesToLiq;\n', '        for (uint256 i = 0; i < newFees.length; i++) {\n', '            totalFees += newFees[i];\n', '            uint256 fee = _pAmount\n', '                          * feePerBase[i]\n', '                          / DENOMINATOR;\n', '            newFees[i] += fee;\n', '            userFee += fee;\n', '        }\n', '\n', '        // Add referral fee.\n', '        refFee = userFee \n', '                 * controller.refFee() \n', '                 / DENOMINATOR;\n', '        userFee += refFee;\n', '\n', '        // Add liquidator bonus.\n', '        /**uint256 liqBonus = (userFee - refFee) \n', '                           * controller.bonus()\n', '                           / DENOMINATOR;**/\n', '\n', '        // userFee += liqBonus; <-- user not being charged liqBonus fee\n', '        totalFees += userFee + refTotal/* + liqBonus*/;\n', '    }\n', '\n', '    /**\n', '     * @notice Save new coverage fees and referral fees.\n', '     * @param liqFees Fees associated with depositing to a coverage base.\n', '     * @param _refFee Fee given to the address that referred this user.\n', '    **/\n', '    function _saveFees(\n', '        uint256[] memory liqFees,\n', '        address _referrer,\n', '        uint256 _refFee\n', '    )\n', '      internal\n', '    {\n', '        refTotal += _refFee;\n', '        if ( _referrer != address(0) ) refBals[_referrer] += _refFee;\n', '        else refBals[beneficiary] += _refFee;\n', '        for (uint256 i = 0; i < liqFees.length; i++) feesToLiq[i] = liqFees[i];\n', '    }\n', '    \n', '    /**\n', '     * @notice Anyone may call this to pause contract deposits for a couple days.\n', '     * @notice They will get refunded + more when hack is confirmed.\n', '     * @dev - Must allow any user to lock contract when a deposit is sent.\n', '     *      - Must set variables correctly.\n', '    **/\n', '    function notifyHack()\n', '      external\n', '      payable\n', '      notLocked\n', '    {\n', '        require(msg.value == controller.depositAmt(), "You must pay the deposit amount to notify a hack.");\n', '        depositor = msg.sender;\n', '        locked = true;\n', '        emit Locked(msg.sender, block.timestamp);\n', '    }\n', '    \n', '    /**\n', '     * @notice Used by governor to confirm that a hack happened, which then locks the contract in anticipation of claims.\n', '     * @dev - On success, depositor paid exactly correct deposit amount (10 Ether in tests.).\n', '     *      - depositor == address(0).\n', '     *      - payoutBlock and payoutAmt set correctly.\n', '     * @param _payoutBlock Block that user must have had tokens at. Will not be the same as when the hack occurred\n', '     *                     because we will need to give time for users to withdraw from dexes and such if needed.\n', '     * @param _payoutAmt The amount of Ether PER TOKEN that users will be given for this claim.\n', '    **/\n', '    function confirmHack(\n', '        uint256 _payoutBlock,\n', '        uint256 _payoutAmt\n', '    )\n', '      external\n', '      isLocked\n', '      onlyGov\n', '    {\n', '        // low-level call to avoid push problems\n', '        payable(depositor).call{value: controller.depositAmt()}("");\n', '        delete depositor;\n', '        payoutBlock = _payoutBlock;\n', '        payoutAmt = _payoutAmt;\n', '        emit HackConfirmed(_payoutBlock, block.timestamp);\n', '    }\n', '    \n', '    /**\n', '     * @notice Used by controller to confirm that a hack happened, which then locks the contract in anticipation of claims.\n', '     * @dev - On success, locked == false, payoutBlock == 0, payoutAmt == 0.\n', '    **/\n', '    function unlock()\n', '      external\n', '      isLocked\n', '      onlyGov\n', '    {\n', '        locked = false;\n', '        delete payoutBlock;\n', '        delete payoutAmt;\n', '        emit Unlocked(block.timestamp);\n', '    }\n', '\n', '    /**\n', '     * @notice Funds may be withdrawn to beneficiary if any are leftover after a hack.\n', '     * @dev - On success, full token/Ether balance should be withdrawn to beneficiary.\n', '     *      - Tokens/Ether should never be withdrawn anywhere other than beneficiary.\n', '     * @param _token Address of the token to withdraw excess for. Cannot be protocol token.\n', '    **/\n', '    function withdrawExcess(address _token)\n', '      external\n', '      notLocked\n', '    {\n', '        if ( _token == address(0) ) beneficiary.transfer( address(this).balance );\n', '        else if ( _token != address(pToken) ) {\n', '            IERC20(_token).transfer( beneficiary, IERC20(_token).balanceOf( address(this) ) );\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice Block a payout if an address minted tokens after a hack occurred.\n', '     *      There are ways people can mess with this to make it annoying to ban people,\n', '     *      but ideally the presence of this function alone will stop malicious minting.\n', '     * \n', "     *      Although it's not a likely scenario, the reason we put amounts in here\n", '     *      is to avoid a bad actor sending a bit to a legitimate holder and having their\n', '     *      full balance banned from receiving a payout.\n', '     * @dev - On success, paid[_payoutBlock][_users] for every user[i] should be incremented by _amount[i].\n', '     * @param _payoutBlock The block at which the hack occurred.\n', '     * @param _users List of users to ban from receiving payout.\n', '     * @param _amounts Bad amounts (in arToken wei) that the user should not be paid.\n', '    **/\n', '    function banPayouts(\n', '        uint256 _payoutBlock,\n', '        address[] calldata _users,\n', '        uint256[] calldata _amounts\n', '    )\n', '      external\n', '      onlyGov\n', '    {\n', '        for (uint256 i = 0; i < _users.length; i++) paid[_payoutBlock][_users[i]] += _amounts[i];\n', '    }\n', '\n', '    /**\n', '     * @notice Change the fees taken for minting and redeeming.\n', '     * @dev - On success, feePerBase == _newFees.\n', '     *      - No success on inequal lengths.\n', '     * @param _newFees Array for each of the new fees. 10 == 0.1% fee.\n', '    **/\n', '    function changeFees(\n', '        uint256[] calldata _newFees\n', '    )\n', '      external\n', '      onlyGov\n', '    {\n', '        require(_newFees.length == feePerBase.length, "Improper fees length.");\n', '        for (uint256 i = 0; i < _newFees.length; i++) feePerBase[i] = _newFees[i];\n', '    }\n', '\n', '    /**\n', '     * @notice Change the main beneficiary of the shield.\n', '     * @dev - On success, contract variable beneficiary == _beneficiary.\n', '     * @param _beneficiary New address to withdraw excess funds and get default referral fees.\n', '    **/\n', '    function changeBeneficiary(\n', '        address payable _beneficiary\n', '    )\n', '      external\n', '      onlyGov\n', '    {\n', '        beneficiary = _beneficiary;\n', '    }\n', '\n', '    /**\n', '     * @notice Change whether this arShield has a cap on tokens submitted or not.\n', '     * @dev - On success, contract variable capped == _capped.\n', '     * @param _capped True if there should now be a cap on the vault.\n', '    **/\n', '    function changeCapped(\n', '        bool _capped\n', '    )\n', '      external\n', '      onlyGov\n', '    {\n', '        capped = _capped;\n', '    }\n', '\n', '    /**\n', '     * @notice Change whether this arShield has a limit to tokens in the shield.\n', '     * @dev - On success, contract variable limit == _limit.\n', '     * @param _limit Limit of funds in the contract, 0 if unlimited.\n', '    **/\n', '    function changeLimit(\n', '        uint256 _limit\n', '    )\n', '      external\n', '      onlyGov\n', '    {\n', '        limit = _limit;\n', '    }\n', '\n', '}']