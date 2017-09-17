package stack;

public class FilledStackTop extends StackTop {
	private StackTop previous;
	
	private Object content;
	
	public FilledStackTop(StackTop previous, Object content) {
		this.previous = previous;
		this.content = content;
	}

	@Override
	public boolean isEmpty() {
		return false;
	}

	@Override
	public Integer size() {
		return 1 + previous.size();
	}

	@Override
	public Object content() throws Exception {
		return content;
	}

	@Override
	public StackTop previous() throws Exception {
		return previous;
	}

}
