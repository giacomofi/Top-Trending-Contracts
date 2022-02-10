['pragma solidity ^0.4.21;\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Claimable.sol\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/Withdrawals.sol\n', '\n', 'contract Withdrawals is Claimable {\n', '    \n', '    /**\n', '    * @dev responsible for calling withdraw function\n', '    */\n', '    address public withdrawCreator;\n', '\n', '    /**\n', '    * @dev if it&#39;s token transfer the tokenAddress will be 0x0000... \n', '    * @param _destination receiver of token or eth\n', '    * @param _amount amount of ETH or Tokens\n', '    * @param _tokenAddress actual token address or 0x000.. in case of eth transfer\n', '    */\n', '    event AmountWithdrawEvent(\n', '    address _destination, \n', '    uint _amount, \n', '    address _tokenAddress \n', '    );\n', '\n', '    /**\n', '    * @dev fallback function only to enable ETH transfer\n', '    */\n', '    function() payable public {\n', '\n', '    }\n', '\n', '    /**\n', '    * @dev setter for the withdraw creator (responsible for calling withdraw function)\n', '    */\n', '    function setWithdrawCreator(address _withdrawCreator) public onlyOwner {\n', '        withdrawCreator = _withdrawCreator;\n', '    }\n', '\n', '    /**\n', '    * @dev withdraw function to send token addresses or eth amounts to a list of receivers\n', '    * @param _destinations batch list of token or eth receivers\n', '    * @param _amounts batch list of values of eth or tokens\n', '    * @param _tokenAddresses what token to be transfered in case of eth just leave the 0x address\n', '    */\n', '    function withdraw(address[] _destinations, uint[] _amounts, address[] _tokenAddresses) public onlyOwnerOrWithdrawCreator {\n', '        require(_destinations.length == _amounts.length && _amounts.length == _tokenAddresses.length);\n', '        // itterate in receivers\n', '        for (uint i = 0; i < _destinations.length; i++) {\n', '            address tokenAddress = _tokenAddresses[i];\n', '            uint amount = _amounts[i];\n', '            address destination = _destinations[i];\n', '            // eth transfer\n', '            if (tokenAddress == address(0)) {\n', '                if (this.balance < amount) {\n', '                    continue;\n', '                }\n', '                if (!destination.call.gas(70000).value(amount)()) {\n', '                    continue;\n', '                }\n', '                \n', '            }else {\n', '            // erc 20 transfer\n', '                if (ERC20(tokenAddress).balanceOf(this) < amount) {\n', '                    continue;\n', '                }\n', '                ERC20(tokenAddress).transfer(destination, amount);\n', '            }\n', '            // emit event in both cases\n', '            emit AmountWithdrawEvent(destination, amount, tokenAddress);                \n', '        }\n', '\n', '    }\n', '\n', '    modifier onlyOwnerOrWithdrawCreator() {\n', '        require(msg.sender == withdrawCreator || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.21;\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Claimable.sol\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '  address public pendingOwner;\n', '\n', '  /**\n', '   * @dev Modifier throws if called by any account other than the pendingOwner.\n', '   */\n', '  modifier onlyPendingOwner() {\n', '    require(msg.sender == pendingOwner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to set the pendingOwner address.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    pendingOwner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the pendingOwner address to finalize the transfer.\n', '   */\n', '  function claimOwnership() onlyPendingOwner public {\n', '    OwnershipTransferred(owner, pendingOwner);\n', '    owner = pendingOwner;\n', '    pendingOwner = address(0);\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/Withdrawals.sol\n', '\n', 'contract Withdrawals is Claimable {\n', '    \n', '    /**\n', '    * @dev responsible for calling withdraw function\n', '    */\n', '    address public withdrawCreator;\n', '\n', '    /**\n', "    * @dev if it's token transfer the tokenAddress will be 0x0000... \n", '    * @param _destination receiver of token or eth\n', '    * @param _amount amount of ETH or Tokens\n', '    * @param _tokenAddress actual token address or 0x000.. in case of eth transfer\n', '    */\n', '    event AmountWithdrawEvent(\n', '    address _destination, \n', '    uint _amount, \n', '    address _tokenAddress \n', '    );\n', '\n', '    /**\n', '    * @dev fallback function only to enable ETH transfer\n', '    */\n', '    function() payable public {\n', '\n', '    }\n', '\n', '    /**\n', '    * @dev setter for the withdraw creator (responsible for calling withdraw function)\n', '    */\n', '    function setWithdrawCreator(address _withdrawCreator) public onlyOwner {\n', '        withdrawCreator = _withdrawCreator;\n', '    }\n', '\n', '    /**\n', '    * @dev withdraw function to send token addresses or eth amounts to a list of receivers\n', '    * @param _destinations batch list of token or eth receivers\n', '    * @param _amounts batch list of values of eth or tokens\n', '    * @param _tokenAddresses what token to be transfered in case of eth just leave the 0x address\n', '    */\n', '    function withdraw(address[] _destinations, uint[] _amounts, address[] _tokenAddresses) public onlyOwnerOrWithdrawCreator {\n', '        require(_destinations.length == _amounts.length && _amounts.length == _tokenAddresses.length);\n', '        // itterate in receivers\n', '        for (uint i = 0; i < _destinations.length; i++) {\n', '            address tokenAddress = _tokenAddresses[i];\n', '            uint amount = _amounts[i];\n', '            address destination = _destinations[i];\n', '            // eth transfer\n', '            if (tokenAddress == address(0)) {\n', '                if (this.balance < amount) {\n', '                    continue;\n', '                }\n', '                if (!destination.call.gas(70000).value(amount)()) {\n', '                    continue;\n', '                }\n', '                \n', '            }else {\n', '            // erc 20 transfer\n', '                if (ERC20(tokenAddress).balanceOf(this) < amount) {\n', '                    continue;\n', '                }\n', '                ERC20(tokenAddress).transfer(destination, amount);\n', '            }\n', '            // emit event in both cases\n', '            emit AmountWithdrawEvent(destination, amount, tokenAddress);                \n', '        }\n', '\n', '    }\n', '\n', '    modifier onlyOwnerOrWithdrawCreator() {\n', '        require(msg.sender == withdrawCreator || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '}']
