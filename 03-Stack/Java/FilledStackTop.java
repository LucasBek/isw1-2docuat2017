package stack;

public class FilledStackTop implements StackTop {
	private StackTop previous;
	
	private Object content;
	
	public FilledStackTop(StackTop previous, Object content) {
		this.previous = previous;
		this.content = content;
	}

	public boolean isEmpty() {
		return false;
	}

	public Integer size() {
		return 1 + previous.size();
	}

	public Object content() {
		return content;
	}

	public StackTop previous() {
		return previous;
	}

}
