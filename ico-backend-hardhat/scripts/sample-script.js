const { ethers } = require("hardhat");
const { CryptoDevNFTAddress } = require("../constants/index");

async function main() {
	const [owner] = await ethers.getSigners();
	const CryptoDevToeknFactory = await ethers.getContractFactory(
		"CryptoDevToken"
	);
	const CryptoDevToeknContract = await CryptoDevToeknFactory.deploy(
		CryptoDevNFTAddress
	);

	await CryptoDevToeknContract.deployed();
	console.log("CrytoDev Token deployed to :", CryptoDevToeknContract.address);

	let txn = await CryptoDevToeknContract.mint(10, {
		value: ethers.utils.parseEther((0.001 * 10).toString()),
	});
	await txn.wait();

	// txn = await CryptoDevToeknContract.claim();

	txn = await CryptoDevToeknContract.withdraw();
	await txn.wait();

	// console.log(
	// 	"Money transfered Paisa hi paisa",
	// 	ethers.utils.formatEther(await owner.getBalance())
	// );
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.error(error);
		process.exit(1);
	});
