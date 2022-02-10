['pragma solidity ^0.4.23;\n', '\n', 'import "./MintableToken.sol";\n', 'import "./BurnableToken.sol";\n', 'import "./Blacklisted.sol";\n', '\n', '/**\n', ' * @title Token\n', ' * ERC20 Token.\n', ' * Genesis Token\n', ' */\n', 'contract B34R is MintableToken, BurnableToken, Blacklisted {\n', '\n', '  string public constant name = "B34R"; // solium-disable-line uppercase\n', '  string public constant symbol = "B34R"; // solium-disable-line uppercase\n', '  uint8 public constant decimals = 18; // solium-disable-line uppercase\n', '\n', '  uint256 public constant INITIAL_SUPPLY = 1000 * 1000 * (1000 ** uint256(decimals)); // initial supply B34R token\n', '\n', '  bool public isUnlocked = false;\n', '\n', '  /**\n', '   * Constructor that gives msg.sender all of existing tokens.\n', '   */\n', '  constructor(address _wallet) public {\n', '    totalSupply_ = INITIAL_SUPPLY;\n', '    balances[_wallet] = INITIAL_SUPPLY;\n', '    emit Transfer(address(0), _wallet, INITIAL_SUPPLY);\n', '  }\n', '\n', '  modifier onlyTransferable() {\n', '    require(isUnlocked || owners[msg.sender] != 0);\n', '    _;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {\n', '      return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {\n', '      return super.transfer(_to, _value);\n', '  }\n', '\n', '  function unlockTransfer() public onlyOwner {\n', '      isUnlocked = true;\n', '  }\n', '\n', '  function lockTransfer() public onlyOwner {\n', '      isUnlocked = false;\n', '  }\n', '\n', '}']