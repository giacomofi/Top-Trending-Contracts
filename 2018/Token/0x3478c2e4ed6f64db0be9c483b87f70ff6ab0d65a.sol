['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: contracts/interface/IBasicMultiToken.sol\n', '\n', 'contract IBasicMultiToken is ERC20 {\n', '    event Bundle(address indexed who, address indexed beneficiary, uint256 value);\n', '    event Unbundle(address indexed who, address indexed beneficiary, uint256 value);\n', '\n', '    function tokensCount() public view returns(uint256);\n', '    function tokens(uint256 _index) public view returns(ERC20);\n', '    function allTokens() public view returns(ERC20[]);\n', '    function allDecimals() public view returns(uint8[]);\n', '    function allBalances() public view returns(uint256[]);\n', '    function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);\n', '\n', '    function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;\n', '    function bundle(address _beneficiary, uint256 _amount) public;\n', '\n', '    function unbundle(address _beneficiary, uint256 _value) public;\n', '    function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;\n', '\n', '    function denyBundling() public;\n', '    function allowBundling() public;\n', '}\n', '\n', '// File: contracts/interface/IMultiToken.sol\n', '\n', 'contract IMultiToken is IBasicMultiToken {\n', '    event Update();\n', '    event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);\n', '\n', '    function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);\n', '    function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);\n', '\n', '    function allWeights() public view returns(uint256[] _weights);\n', '    function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);\n', '\n', '    function denyChanges() public;\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: contracts/registry/IDeployer.sol\n', '\n', 'contract IDeployer is Ownable {\n', '    function deploy(bytes data) external returns(address mtkn);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: contracts/registry/MultiTokenNetwork.sol\n', '\n', 'contract MultiTokenNetwork is Pausable {\n', '\n', '    event NewMultitoken(address indexed mtkn);\n', '    event NewDeployer(uint256 indexed index, address indexed oldDeployer, address indexed newDeployer);\n', '\n', '    address[] public multitokens;\n', '    mapping(uint256 => IDeployer) public deployers;\n', '\n', '    function multitokensCount() public view returns(uint256) {\n', '        return multitokens.length;\n', '    }\n', '\n', '    function allMultitokens() public view returns(address[]) {\n', '        return multitokens;\n', '    }\n', '\n', '    function allWalletBalances(address wallet) public view returns(uint256[]) {\n', '        uint256[] memory balances = new uint256[](multitokens.length);\n', '        for (uint i = 0; i < multitokens.length; i++) {\n', '            balances[i] = ERC20(multitokens[i]).balanceOf(wallet);\n', '        }\n', '        return balances;\n', '    }\n', '\n', '    function deleteMultitoken(uint index) public onlyOwner {\n', '        require(index < multitokens.length, "deleteMultitoken: index out of range");\n', '        if (index != multitokens.length - 1) {\n', '            multitokens[index] = multitokens[multitokens.length - 1];\n', '        }\n', '        multitokens.length -= 1;\n', '    }\n', '\n', '    function denyBundlingMultitoken(uint index) public onlyOwner {\n', '        IBasicMultiToken(multitokens[index]).denyBundling();\n', '    }\n', '\n', '    function allowBundlingMultitoken(uint index) public onlyOwner {\n', '        IBasicMultiToken(multitokens[index]).allowBundling();\n', '    }\n', '\n', '    function denyChangesMultitoken(uint index) public onlyOwner {\n', '        IMultiToken(multitokens[index]).denyChanges();\n', '    }\n', '\n', '    function setDeployer(uint256 index, IDeployer deployer) public onlyOwner whenNotPaused {\n', '        require(deployer.owner() == address(this), "setDeployer: first set MultiTokenNetwork as owner");\n', '        emit NewDeployer(index, deployers[index], deployer);\n', '        deployers[index] = deployer;\n', '    }\n', '\n', '    function deploy(uint256 index, bytes data) public whenNotPaused {\n', '        address mtkn = deployers[index].deploy(data);\n', '        multitokens.push(mtkn);\n', '        emit NewMultitoken(mtkn);\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: contracts/interface/IBasicMultiToken.sol\n', '\n', 'contract IBasicMultiToken is ERC20 {\n', '    event Bundle(address indexed who, address indexed beneficiary, uint256 value);\n', '    event Unbundle(address indexed who, address indexed beneficiary, uint256 value);\n', '\n', '    function tokensCount() public view returns(uint256);\n', '    function tokens(uint256 _index) public view returns(ERC20);\n', '    function allTokens() public view returns(ERC20[]);\n', '    function allDecimals() public view returns(uint8[]);\n', '    function allBalances() public view returns(uint256[]);\n', '    function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);\n', '\n', '    function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;\n', '    function bundle(address _beneficiary, uint256 _amount) public;\n', '\n', '    function unbundle(address _beneficiary, uint256 _value) public;\n', '    function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;\n', '\n', '    function denyBundling() public;\n', '    function allowBundling() public;\n', '}\n', '\n', '// File: contracts/interface/IMultiToken.sol\n', '\n', 'contract IMultiToken is IBasicMultiToken {\n', '    event Update();\n', '    event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);\n', '\n', '    function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);\n', '    function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);\n', '\n', '    function allWeights() public view returns(uint256[] _weights);\n', '    function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);\n', '\n', '    function denyChanges() public;\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '// File: contracts/registry/IDeployer.sol\n', '\n', 'contract IDeployer is Ownable {\n', '    function deploy(bytes data) external returns(address mtkn);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '// File: contracts/registry/MultiTokenNetwork.sol\n', '\n', 'contract MultiTokenNetwork is Pausable {\n', '\n', '    event NewMultitoken(address indexed mtkn);\n', '    event NewDeployer(uint256 indexed index, address indexed oldDeployer, address indexed newDeployer);\n', '\n', '    address[] public multitokens;\n', '    mapping(uint256 => IDeployer) public deployers;\n', '\n', '    function multitokensCount() public view returns(uint256) {\n', '        return multitokens.length;\n', '    }\n', '\n', '    function allMultitokens() public view returns(address[]) {\n', '        return multitokens;\n', '    }\n', '\n', '    function allWalletBalances(address wallet) public view returns(uint256[]) {\n', '        uint256[] memory balances = new uint256[](multitokens.length);\n', '        for (uint i = 0; i < multitokens.length; i++) {\n', '            balances[i] = ERC20(multitokens[i]).balanceOf(wallet);\n', '        }\n', '        return balances;\n', '    }\n', '\n', '    function deleteMultitoken(uint index) public onlyOwner {\n', '        require(index < multitokens.length, "deleteMultitoken: index out of range");\n', '        if (index != multitokens.length - 1) {\n', '            multitokens[index] = multitokens[multitokens.length - 1];\n', '        }\n', '        multitokens.length -= 1;\n', '    }\n', '\n', '    function denyBundlingMultitoken(uint index) public onlyOwner {\n', '        IBasicMultiToken(multitokens[index]).denyBundling();\n', '    }\n', '\n', '    function allowBundlingMultitoken(uint index) public onlyOwner {\n', '        IBasicMultiToken(multitokens[index]).allowBundling();\n', '    }\n', '\n', '    function denyChangesMultitoken(uint index) public onlyOwner {\n', '        IMultiToken(multitokens[index]).denyChanges();\n', '    }\n', '\n', '    function setDeployer(uint256 index, IDeployer deployer) public onlyOwner whenNotPaused {\n', '        require(deployer.owner() == address(this), "setDeployer: first set MultiTokenNetwork as owner");\n', '        emit NewDeployer(index, deployers[index], deployer);\n', '        deployers[index] = deployer;\n', '    }\n', '\n', '    function deploy(uint256 index, bytes data) public whenNotPaused {\n', '        address mtkn = deployers[index].deploy(data);\n', '        multitokens.push(mtkn);\n', '        emit NewMultitoken(mtkn);\n', '    }\n', '}']
