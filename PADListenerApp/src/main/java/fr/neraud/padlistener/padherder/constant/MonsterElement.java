package fr.neraud.padlistener.padherder.constant;

/**
 * Enum of monster elements
 *
 * @author Neraud
 */
public enum MonsterElement {

	FIRE(0),
	WATER(1),
	WOOD(2),
	LIGHT(3),
	DARK(4);

	// elementId in ParHerder API
	private final int elementId;

	private MonsterElement(int elementId) {
		this.elementId = elementId;
	}

	public static MonsterElement findById(int id) {
		for (final MonsterElement element : values()) {
			if (element.elementId == id) {
				return element;
			}
		}
		return null;
	}

	public int getElementId() {
		return elementId;
	}

}
