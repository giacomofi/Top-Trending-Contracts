['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-25\n', '*/\n', '\n', '/*\n', 'B.PROTOCOL TERMS OF USE\n', '=======================\n', '\n', 'THE TERMS OF USE CONTAINED HEREIN (THESE “TERMS”) GOVERN YOUR USE OF B.PROTOCOL, WHICH IS A DECENTRALIZED PROTOCOL ON THE ETHEREUM BLOCKCHAIN (the “PROTOCOL”) THAT enables a backstop liquidity mechanism FOR DECENTRALIZED LENDING PLATFORMS\xa0(“DLPs”).  \n', 'PLEASE READ THESE TERMS CAREFULLY AT https://github.com/backstop-protocol/Terms-and-Conditions, INCLUDING ALL DISCLAIMERS AND RISK FACTORS, BEFORE USING THE PROTOCOL. BY USING THE PROTOCOL, YOU ARE IRREVOCABLY CONSENTING TO BE BOUND BY THESE TERMS. \n', 'IF YOU DO NOT AGREE TO ALL OF THESE TERMS, DO NOT USE THE PROTOCOL. YOUR RIGHT TO USE THE PROTOCOL IS SUBJECT AND DEPENDENT BY YOUR AGREEMENT TO ALL TERMS AND CONDITIONS SET FORTH HEREIN, WHICH AGREEMENT SHALL BE EVIDENCED BY YOUR USE OF THE PROTOCOL.\n', 'Minors Prohibited: The Protocol is not directed to individuals under the age of eighteen (18) or the age of majority in your jurisdiction if the age of majority is greater. If you are under the age of eighteen or the age of majority (if greater), you are not authorized to access or use the Protocol. By using the Protocol, you represent and warrant that you are above such age.\n', '\n', 'License; No Warranties; Limitation of Liability;\n', '(a) The software underlying the Protocol is licensed for use in accordance with the 3-clause BSD License, which can be accessed here: https://opensource.org/licenses/BSD-3-Clause.\n', '(b) THE PROTOCOL IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS", “WITH ALL FAULTS” and “AS AVAILABLE” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. \n', '(c) IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. \n', '*/\n', '\n', '\n', 'pragma solidity =0.6.11;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @dev These functions deal with verification of Merkle trees (hash trees),\n', ' */\n', 'library MerkleProof {\n', '    /**\n', '     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree\n', '     * defined by `root`. For this, a `proof` must be provided, containing\n', '     * sibling hashes on the branch from the leaf to the root of the tree. Each\n', '     * pair of leaves and each pair of pre-images are assumed to be sorted.\n', '     */\n', '    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {\n', '        bytes32 computedHash = leaf;\n', '\n', '        for (uint256 i = 0; i < proof.length; i++) {\n', '            bytes32 proofElement = proof[i];\n', '\n', '            if (computedHash <= proofElement) {\n', '                // Hash(current computed hash + current element of the proof)\n', '                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));\n', '            } else {\n', '                // Hash(current element of the proof + current computed hash)\n', '                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));\n', '            }\n', '        }\n', '\n', '        // Check if the computed hash (root) is equal to the provided root\n', '        return computedHash == root;\n', '    }\n', '}\n', '\n', '// Allows anyone to claim a token if they exist in a merkle root.\n', 'interface IMerkleDistributor {\n', '    // Returns the address of the token distributed by this contract.\n', '    function token() external view returns (address);\n', '    // Returns the merkle root of the merkle tree containing account balances available to claim.\n', '    function merkleRoot() external view returns (bytes32);\n', '    // Returns true if the index has been marked claimed.\n', '    function isClaimed(uint256 index) external view returns (bool);\n', '    // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.\n', '    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;\n', '\n', '    // This event is triggered whenever a call to #claim succeeds.\n', '    event Claimed(uint256 index, address account, uint256 amount);\n', '}\n', '\n', 'contract MerkleDistributor is IMerkleDistributor {\n', '    address public immutable override token;\n', '    bytes32 public immutable override merkleRoot;\n', '\n', '    // This is a packed array of booleans.\n', '    mapping(uint256 => uint256) private claimedBitMap;\n', '\n', '    constructor(address token_, bytes32 merkleRoot_) public {\n', '        token = token_;\n', '        merkleRoot = merkleRoot_;\n', '    }\n', '\n', '    function isClaimed(uint256 index) public view override returns (bool) {\n', '        uint256 claimedWordIndex = index / 256;\n', '        uint256 claimedBitIndex = index % 256;\n', '        uint256 claimedWord = claimedBitMap[claimedWordIndex];\n', '        uint256 mask = (1 << claimedBitIndex);\n', '        return claimedWord & mask == mask;\n', '    }\n', '\n', '    function _setClaimed(uint256 index) private {\n', '        uint256 claimedWordIndex = index / 256;\n', '        uint256 claimedBitIndex = index % 256;\n', '        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);\n', '    }\n', '\n', '    function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {\n', "        require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');\n", '\n', '        // Verify the merkle proof.\n', '        bytes32 node = keccak256(abi.encodePacked(index, account, amount));\n', "        require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');\n", '\n', '        // Mark it claimed and send the token.\n', '        _setClaimed(index);\n', "        require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');\n", '\n', '        emit Claimed(index, account, amount);\n', '    }\n', '}']