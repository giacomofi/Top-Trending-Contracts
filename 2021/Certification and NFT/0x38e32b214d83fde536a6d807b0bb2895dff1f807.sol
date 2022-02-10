['/**\n', ' * \n', ' * \n', '  _______      ___       __          ___       ______ .___________. _______ .______       __   __    __  .___  ___. \n', ' /  _____|    /   \\     |  |        /   \\     /      ||           ||   ____||   _  \\     |  | |  |  |  | |   \\/   | \n', "|  |  __     /  ^  \\    |  |       /  ^  \\   |  ,----'`---|  |----`|  |__   |  |_)  |    |  | |  |  |  | |  \\  /  | \n", '|  | |_ |   /  /_\\  \\   |  |      /  /_\\  \\  |  |         |  |     |   __|  |      /     |  | |  |  |  | |  |\\/|  | \n', "|  |__| |  /  _____  \\  |  `----./  _____  \\ |  `----.    |  |     |  |____ |  |\\  \\----.|  | |  `--'  | |  |  |  | \n", ' \\______| /__/     \\__\\ |_______/__/     \\__\\ \\______|    |__|     |_______|| _| `._____||__|  \\______/  |__|  |__|                                                                                                                \n', '\n', '____ _  _ ____ ___  _ ____ _  _ ____    ____ ____    ___ _  _ ____    ____ ____ _    ____ ____ ___ ____ ____ _ _  _ _  _ \n', '| __ |  | |__| |  \\ | |__| |\\ | [__     |  | |___     |  |__| |___    | __ |__| |    |__| |     |  |___ |__/ | |  | |\\/| \n', '|__] |__| |  | |__/ | |  | | \\| ___]    |__| |        |  |  | |___    |__] |  | |___ |  | |___  |  |___ |  \\ | |__| |  | \n', '                                                                                                                         \n', '____ ____ ___ ____ ___     ____ _  _ ___     ____ ___ ____ ____ _  _ ____ _  _                                           \n', '[__  |___  |  |___ |__]    |__| |\\ | |  \\    [__   |  |__| |__/ |\\/| |__| |\\ |                                           \n', '___] |___  |  |___ |       |  | | \\| |__/    ___]  |  |  | |  \\ |  | |  | | \\|   \n', '\n', 'Reality Benders\n', '\n', '(3)(6)(9)\n', 'MarsOne\n', 'Rocket Labs\n', 'Elon Musk\n', 'Richard Brandson\n', 'Space Force\n', 'International Space Station\n', 'Beyond\n', ' * \n', ' *\n', ' * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt\n', ' */\n', '\n', '\n', 'pragma solidity ^0.4.8;\n', '\n', 'import "./IncreasingPriceCrowdsale.sol";\n', 'import "./GalacticCrowdsale.sol";\n', 'import "./Ownable.sol";\n', 'import "./ERC20.sol";\n', '\n', 'contract GalacticSale is IncreasingPriceCrowdsale, Ownable {\n', '  uint256 public defaultCap;\n', '  mapping(address => uint256) public contributions;\n', '  mapping(address => uint256) public caps;\n', '\n', '  address  private ownerwallet;\n', '  constructor (\n', '    uint256 _openingTime,\n', '    uint256 _closingTime,\n', '    address  _wallet,\n', '    address _token,\n', '    uint256 _initialRate,\n', '    uint256 _finalRate,\n', '    uint256 _walletCap\n', '  )\n', '    public\n', '    GalacticCrowdsale(_initialRate, _wallet, _token)\n', '    TimedCrowdsale(_openingTime, _closingTime)\n', '    IncreasingPriceCrowdsale(_initialRate, _finalRate)\n', '  {\n', '      ownerwallet=_wallet;\n', '      defaultCap = _walletCap;\n', '  }\n', '  \n', '  function closeSale() onlyOwner public{\n', '      if(!hasClosed()) revert();\n', '      uint256 contractTokenBalance = tokensRemaining();\n', '     \n', '      if(contractTokenBalance>0){\n', '        ERC20(token).transfer(ownerwallet,contractTokenBalance);  \n', '        emit Transfer(address(0),address(ownerwallet),contractTokenBalance);\n', '      }\n', '  }\n', '\n', '/**\n', "   * @dev Sets default user's maximum contribution.\n", '   * @param _cap Wei limit for individual contribution\n', '   */\n', '  function setDefaultCap( uint256 _cap) external onlyOwner {\n', '      defaultCap = _cap;\n', '  }\n', '/**\n', "   * @dev Sets a specific user's maximum contribution.\n", '   * @param _beneficiary Address to be capped\n', '   * @param _cap Wei limit for individual contribution\n', '   */\n', '  function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {\n', '    caps[_beneficiary] = _cap;\n', '  }\n', '/**\n', '   * Called from invest() to confirm if the curret investment does not break our cap rule.\n', '   */\n', '  function isBreakingCap(uint tokenAmount) public view  returns (bool limitBroken) {\n', '    if(tokenAmount > getTokensLeft()) {\n', '      return true;\n', '    } else {\n', '      return false;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * We are sold out when our approve pool becomes empty.\n', '   */\n', '  function isCrowdsaleFull() public view returns (bool) {\n', '    return getTokensLeft() == 0;\n', '  }\n', '\n', '  /**\n', '   * Get the amount of unsold tokens allocated to this contract;\n', '   */\n', '  function getTokensLeft() public view returns (uint) {\n', '    return token.allowance(owner, address(this));\n', '  }\n', '\n', '  /**\n', '   * Transfer tokens from approve() pool to the buyer.\n', '   *\n', '   * Use approve() given to this crowdsale to distribute the tokens.\n', '   */\n', '  function assignTokens(address receiver, uint tokenAmount) onlyOwner {\n', '    if(!token.transferFrom(address(0), receiver, tokenAmount)) revert();\n', '  }\n', '  /**\n', "   * @dev Sets a group of users' maximum contribution.\n", '   * @param _beneficiaries List of addresses to be capped\n', '   * @param _cap Wei limit for individual contribution\n', '   */\n', '  function setGroupCap(\n', '    address[]  _beneficiaries,\n', '    uint256 _cap\n', '  )\n', '    external\n', '    onlyOwner\n', '  {\n', '    for (uint256 i = 0; i < _beneficiaries.length; i++) {\n', '      caps[_beneficiaries[i]] = _cap;\n', '    }\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the cap of a specific user.\n', '   * @param _beneficiary Address whose cap is to be checked\n', '   * @return Current cap for individual user\n', '   */\n', '  function getUserCap(address _beneficiary) public view returns (uint256) {\n', '    return caps[_beneficiary];\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the amount contributed so far by a sepecific user.\n', '   * @param _beneficiary Address of contributor\n', '   * @return User contribution so far\n', '   */\n', '  function getUserContribution(address _beneficiary)\n', '    public view returns (uint256)\n', '  {\n', '    return contributions[_beneficiary];\n', '  }\n', '\n', '  /**\n', "   * @dev Extend parent behavior requiring purchase to respect the user's funding cap.\n", '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _preValidatePurchase(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    super._preValidatePurchase(_beneficiary, _weiAmount);\n', '    if(caps[_beneficiary]==0){\n', '      caps[_beneficiary] = defaultCap;\n', '    }\n', '    require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);\n', '  }\n', '\n', '  /**\n', '   * @dev Extend parent behavior to update user contributions\n', '   * @param _beneficiary Token purchaser\n', '   * @param _weiAmount Amount of wei contributed\n', '   */\n', '  function _updatePurchasingState(\n', '    address _beneficiary,\n', '    uint256 _weiAmount\n', '  )\n', '    internal\n', '  {\n', '    super._updatePurchasingState(_beneficiary, _weiAmount);\n', '    contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);\n', '  }\n', '\n', '}']