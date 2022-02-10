['/**\n', ' * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.\n', ' * Licensed under the Apache License, Version 2.0.\n', ' */\n', ' \n', 'pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract BZxOwnable is Ownable {\n', '\n', '    address public bZxContractAddress;\n', '\n', '    event BZxOwnershipTransferred(address indexed previousBZxContract, address indexed newBZxContract);\n', '\n', '    // modifier reverts if bZxContractAddress isn&#39;t set\n', '    modifier onlyBZx() {\n', '        require(msg.sender == bZxContractAddress, "only bZx contracts can call this function");\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer the bZx contract owner to a new contract address\n', '    * @param newBZxContractAddress The bZx contract address to transfer ownership to.\n', '    */\n', '    function transferBZxOwnership(address newBZxContractAddress) public onlyOwner {\n', '        require(newBZxContractAddress != address(0) && newBZxContractAddress != owner, "transferBZxOwnership::unauthorized");\n', '        emit BZxOwnershipTransferred(bZxContractAddress, newBZxContractAddress);\n', '        bZxContractAddress = newBZxContractAddress;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    * This overrides transferOwnership in Ownable to prevent setting the new owner the same as the bZxContract\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0) && newOwner != bZxContractAddress, "transferOwnership::unauthorized");\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface NonCompliantEIP20 {\n', '    function transfer(address _to, uint _value) external;\n', '    function transferFrom(address _from, address _to, uint _value) external;\n', '    function approve(address _spender, uint _value) external;\n', '}\n', '\n', 'contract EIP20Wrapper {\n', '\n', '    function eip20Transfer(\n', '        address token,\n', '        address to,\n', '        uint256 value)\n', '        internal\n', '        returns (bool result) {\n', '\n', '        NonCompliantEIP20(token).transfer(to, value);\n', '\n', '        assembly {\n', '            switch returndatasize()   \n', '            case 0 {                        // non compliant ERC20\n', '                result := not(0)            // result is true\n', '            }\n', '            case 32 {                       // compliant ERC20\n', '                returndatacopy(0, 0, 32) \n', '                result := mload(0)          // result == returndata of external call\n', '            }\n', '            default {                       // not an not an ERC20 token\n', '                revert(0, 0) \n', '            }\n', '        }\n', '\n', '        require(result, "eip20Transfer failed");\n', '    }\n', '\n', '    function eip20TransferFrom(\n', '        address token,\n', '        address from,\n', '        address to,\n', '        uint256 value)\n', '        internal\n', '        returns (bool result) {\n', '\n', '        NonCompliantEIP20(token).transferFrom(from, to, value);\n', '\n', '        assembly {\n', '            switch returndatasize()   \n', '            case 0 {                        // non compliant ERC20\n', '                result := not(0)            // result is true\n', '            }\n', '            case 32 {                       // compliant ERC20\n', '                returndatacopy(0, 0, 32) \n', '                result := mload(0)          // result == returndata of external call\n', '            }\n', '            default {                       // not an not an ERC20 token\n', '                revert(0, 0) \n', '            }\n', '        }\n', '\n', '        require(result, "eip20TransferFrom failed");\n', '    }\n', '\n', '    function eip20Approve(\n', '        address token,\n', '        address spender,\n', '        uint256 value)\n', '        internal\n', '        returns (bool result) {\n', '\n', '        NonCompliantEIP20(token).approve(spender, value);\n', '\n', '        assembly {\n', '            switch returndatasize()   \n', '            case 0 {                        // non compliant ERC20\n', '                result := not(0)            // result is true\n', '            }\n', '            case 32 {                       // compliant ERC20\n', '                returndatacopy(0, 0, 32) \n', '                result := mload(0)          // result == returndata of external call\n', '            }\n', '            default {                       // not an not an ERC20 token\n', '                revert(0, 0) \n', '            }\n', '        }\n', '\n', '        require(result, "eip20Approve failed");\n', '    }\n', '}\n', '\n', 'contract BZxVault is EIP20Wrapper, BZxOwnable {\n', '\n', '    // Only the bZx contract can directly deposit ether\n', '    function() public payable onlyBZx {}\n', '\n', '    function withdrawEther(\n', '        address to,\n', '        uint value)\n', '        public\n', '        onlyBZx\n', '        returns (bool)\n', '    {\n', '        uint amount = value;\n', '        if (amount > address(this).balance) {\n', '            amount = address(this).balance;\n', '        }\n', '\n', '        return (to.send(amount)); // solhint-disable-line check-send-result, multiple-sends\n', '    }\n', '\n', '    function depositToken(\n', '        address token,\n', '        address from,\n', '        uint tokenAmount)\n', '        public\n', '        onlyBZx\n', '        returns (bool)\n', '    {\n', '        if (tokenAmount == 0) {\n', '            return false;\n', '        }\n', '\n', '        eip20TransferFrom(\n', '            token,\n', '            from,\n', '            this,\n', '            tokenAmount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function withdrawToken(\n', '        address token,\n', '        address to,\n', '        uint tokenAmount)\n', '        public\n', '        onlyBZx\n', '        returns (bool)\n', '    {\n', '        if (tokenAmount == 0) {\n', '            return false;\n', '        }\n', '\n', '        eip20Transfer(\n', '            token,\n', '            to,\n', '            tokenAmount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferTokenFrom(\n', '        address token,\n', '        address from,\n', '        address to,\n', '        uint tokenAmount)\n', '        public\n', '        onlyBZx\n', '        returns (bool)\n', '    {\n', '        if (tokenAmount == 0) {\n', '            return false;\n', '        }\n', '\n', '        eip20TransferFrom(\n', '            token,\n', '            from,\n', '            to,\n', '            tokenAmount);\n', '\n', '        return true;\n', '    }\n', '}']