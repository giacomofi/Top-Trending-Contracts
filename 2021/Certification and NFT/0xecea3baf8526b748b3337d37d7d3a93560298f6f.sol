['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-24\n', '*/\n', '\n', '/*\n', 'B.PROTOCOL TERMS OF USE\n', '=======================\n', '\n', 'THE TERMS OF USE CONTAINED HEREIN (THESE “TERMS”) GOVERN YOUR USE OF B.PROTOCOL, WHICH IS A DECENTRALIZED PROTOCOL ON THE ETHEREUM BLOCKCHAIN (the “PROTOCOL”) THAT enables a backstop liquidity mechanism FOR DECENTRALIZED LENDING PLATFORMS\xa0(“DLPs”).  \n', 'PLEASE READ THESE TERMS CAREFULLY AT https://github.com/backstop-protocol/Terms-and-Conditions, INCLUDING ALL DISCLAIMERS AND RISK FACTORS, BEFORE USING THE PROTOCOL. BY USING THE PROTOCOL, YOU ARE IRREVOCABLY CONSENTING TO BE BOUND BY THESE TERMS. \n', 'IF YOU DO NOT AGREE TO ALL OF THESE TERMS, DO NOT USE THE PROTOCOL. YOUR RIGHT TO USE THE PROTOCOL IS SUBJECT AND DEPENDENT BY YOUR AGREEMENT TO ALL TERMS AND CONDITIONS SET FORTH HEREIN, WHICH AGREEMENT SHALL BE EVIDENCED BY YOUR USE OF THE PROTOCOL.\n', 'Minors Prohibited: The Protocol is not directed to individuals under the age of eighteen (18) or the age of majority in your jurisdiction if the age of majority is greater. If you are under the age of eighteen or the age of majority (if greater), you are not authorized to access or use the Protocol. By using the Protocol, you represent and warrant that you are above such age.\n', '\n', 'License; No Warranties; Limitation of Liability;\n', '(a) The software underlying the Protocol is licensed for use in accordance with the 3-clause BSD License, which can be accessed here: https://opensource.org/licenses/BSD-3-Clause.\n', '(b) THE PROTOCOL IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS", “WITH ALL FAULTS” and “AS AVAILABLE” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. \n', '(c) IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. \n', '*/\n', '\n', '// File: @openzeppelin/contracts/GSN/Context.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '    // solhint-disable-previous-line no-empty-blocks\n', '\n', '    function _msgSender() internal view returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// File: @openzeppelin/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return _msgSender() == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/minter.sol\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '//import "./BPRO.sol";\n', '\n', '\n', 'contract BPROLike {\n', '    function mint(address to, uint qty) external;\n', '    function setMinter(address newMinter) external;\n', '}\n', '\n', '// initially deployer owns it, and then it moves it to the DAO\n', 'contract BPROMinter is Ownable {\n', '    address public reservoir;\n', '    address public devPool;\n', '    address public userPool;\n', '    address public backstopPool;\n', '    address public genesisPool;\n', '\n', '    uint public deploymentBlock;\n', '    uint public deploymentTime;\n', '    mapping(bytes32 => uint) lastDripBlock;\n', '\n', '    BPROLike public bpro;\n', '\n', '    uint constant BLOCKS_PER_YEAR = 4 * 60 * 24 * 365;\n', '    uint constant BLOCKS_PER_MONTH = (BLOCKS_PER_YEAR / 12);\n', '\n', '    uint constant YEAR = 365 days;\n', '\n', '    event MinterSet(address newMinter);\n', '    event DevPoolSet(address newPool);\n', '    event BackstopPoolSet(address newPool);\n', '    event UserPoolSet(address newPool);\n', '    event ReservoirSet(address newPool);\n', '\n', '    constructor(BPROLike _bpro, address _reservoir, address _devPool, address _userPool, address _backstopPool) public {\n', '        reservoir = _reservoir;\n', '        devPool = _devPool;\n', '\n', '        userPool = _userPool;\n', '        backstopPool = _backstopPool;\n', '\n', '        deploymentBlock = getBlockNumber();\n', '        deploymentTime = now;\n', '\n', '        bpro = _bpro;\n', '\n', '        // this will be pre minted before ownership transfer\n', '        //bpro.mint(_genesisMakerPool, 500_000e18);\n', '        //bpro.mint(_genesisCompoundPool, 500_000e18);        \n', '    }\n', '\n', '    function dripReservoir() external {\n', '        drip(reservoir, "reservoir", 1_325_000e18 / BLOCKS_PER_YEAR, uint(-1));\n', '    }\n', '\n', '    function dripDev() external {\n', '        drip(devPool, "devPool", 825_000e18 / BLOCKS_PER_YEAR, uint(-1));\n', '    }\n', '\n', '    function dripUser() external {\n', '        uint dripPerMonth = 250_000e18 / uint(3);\n', '\n', '        drip(userPool, "dripUser", dripPerMonth / BLOCKS_PER_MONTH, deploymentBlock + BLOCKS_PER_MONTH * 3);\n', '    }\n', '\n', '    function dripBackstop() external {\n', '        drip(backstopPool, "dripBackstop", 150_000e18 / BLOCKS_PER_YEAR, deploymentBlock + BLOCKS_PER_YEAR);\n', '    }\n', '\n', '    function setMinter(address newMinter) external onlyOwner {\n', '        require(now > deploymentTime + 4 * YEAR, "setMinter: wait-4-years");\n', '        bpro.setMinter(newMinter);\n', '\n', '        emit MinterSet(newMinter);\n', '    }\n', '\n', '    function setDevPool(address newPool) external onlyOwner {\n', '        require(now > deploymentTime + YEAR, "setDevPool: wait-1-years");\n', '        devPool = newPool;\n', '\n', '        emit DevPoolSet(newPool);\n', '    }\n', '\n', '    function setBackstopPool(address newPool) external onlyOwner {\n', '        backstopPool = newPool;\n', '\n', '        emit BackstopPoolSet(newPool);\n', '    }\n', '\n', '    function setUserPool(address newPool) external onlyOwner {\n', '        userPool = newPool;\n', '\n', '        emit UserPoolSet(newPool);\n', '    }\n', '\n', '    function setReservoir(address newPool) external onlyOwner {\n', '        reservoir = newPool;\n', '\n', '        emit ReservoirSet(newPool);\n', '    }\n', '\n', '    function drip(address target, bytes32 targetName, uint dripRate, uint finalDripBlock) internal {\n', '        uint prevDripBlock = lastDripBlock[targetName];\n', '        if(prevDripBlock == 0) prevDripBlock = deploymentBlock;\n', '\n', '        uint currBlock = getBlockNumber();\n', '        if(currBlock > finalDripBlock) currBlock = finalDripBlock;\n', '\n', '        require(currBlock > prevDripBlock, "drip: bad-block");\n', '\n', '        uint deltaBlock = currBlock - prevDripBlock;\n', '        lastDripBlock[targetName] = currBlock;\n', '\n', '        uint mintAmount = deltaBlock * dripRate;\n', '        bpro.mint(target, mintAmount);\n', '    }\n', '\n', '    function getBlockNumber() public view returns(uint) {\n', '        return block.number;\n', '    }\n', '}\n', '\n', 'contract MockMiner is BPROMinter {\n', '    uint blockNumber;\n', '\n', '    constructor(BPROLike _bpro, address _reservoir, address _devPool, address _userPool, address _backstopPool) public \n', '        BPROMinter(_bpro,_reservoir,_devPool,_userPool,_backstopPool)\n', '    {\n', '        blockNumber = block.number;\n', '    }\n', '\n', '    function fwdBlockNumber(uint delta) public {\n', '        blockNumber += delta;\n', '    }\n', '\n', '    function getBlockNumber() public view returns(uint) {\n', '        if(blockNumber == 0) return block.number;\n', '\n', '        return blockNumber;\n', '    }\n', '}']